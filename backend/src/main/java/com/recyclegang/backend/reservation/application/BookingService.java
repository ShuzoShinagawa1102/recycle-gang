package com.recyclegang.backend.reservation.application;

import com.recyclegang.backend.catalog.application.CatalogService;
import com.recyclegang.backend.customer.application.CustomerService;
import com.recyclegang.backend.reservation.domain.Booking;
import com.recyclegang.backend.shared.BusinessException;
import java.time.*;
import java.util.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class BookingService {
  public record ItemInput(String itemTypeId, int quantity) {}

  public record Create(
      String clientRequestId,
      String mode,
      String facilityId,
      String addressId,
      String slotId,
      List<ItemInput> items,
      String note) {}

  public record Ticket(String token, OffsetDateTime expiresAt) {}

  public record Admission(
      String reservationId, OffsetDateTime admittedAt, boolean alreadyAdmitted) {}

  private final BookingRepository repository;
  private final CustomerService customers;
  private final CatalogService catalogs;
  private final TicketCodec tickets;
  private final Clock clock;

  public BookingService(
      BookingRepository repository,
      CustomerService customers,
      CatalogService catalogs,
      TicketCodec tickets,
      Clock clock) {
    this.repository = repository;
    this.customers = customers;
    this.catalogs = catalogs;
    this.tickets = tickets;
    this.clock = clock;
  }

  public List<Booking> list(String user) {
    return repository.list(user);
  }

  public Booking get(String user, String id) {
    return repository.get(id, user, false);
  }

  @Transactional
  public Booking create(String user, Create c) {
    // Serializes concurrent retries for this customer; the database also enforces uniqueness.
    var customer = customers.lockForBooking(user);
    var hash = tickets.hash(c.toString());
    var existing = repository.byRequest(user, c.clientRequestId());
    if (existing != null) {
      if (!existing.requestHash().equals(hash))
        throw BusinessException.conflict("同じ送信IDで予約内容が変更されています。新しい予約として送信してください。");
      return existing;
    }
    var catalog = catalogs.get();
    var slot =
        catalog.slots().stream()
            .filter(s -> s.id().equals(c.slotId()))
            .findFirst()
            .orElseThrow(() -> BusinessException.invalid("受付日を選び直してください。"));
    var ids = new HashSet<String>();
    var items = new ArrayList<Booking.Item>();
    if (c.items().isEmpty() || c.items().size() > 10)
      throw BusinessException.invalid("回収品を1種類以上登録してください。");
    for (var input : c.items()) {
      if (!ids.add(input.itemTypeId()) || input.quantity() < 1 || input.quantity() > 20)
        throw BusinessException.invalid("品目と数量を確認してください。");
      var type =
          catalog.itemTypes().stream()
              .filter(i -> i.id().equals(input.itemTypeId()))
              .findFirst()
              .orElseThrow(() -> BusinessException.invalid("対象外の回収品です。"));
      items.add(new Booking.Item(type.id(), type.name(), input.quantity(), type.priceYen()));
    }
    String location, address, facilityId = null;
    if ("DROPOFF".equals(c.mode())) {
      var facility =
          catalog.facilities().stream()
              .filter(f -> f.id().equals(c.facilityId()))
              .findFirst()
              .orElseThrow(() -> BusinessException.invalid("持込場所を選んでください。"));
      facilityId = facility.id();
      location = facility.name();
      address = facility.address();
    } else if ("PICKUP".equals(c.mode())) {
      var a =
          customer.addresses().stream()
              .filter(x -> x.id().equals(c.addressId()))
              .findFirst()
              .orElseThrow(() -> BusinessException.invalid("回収先住所を登録・選択してください。"));
      location = a.label();
      address = a.prefecture() + a.addressLine();
    } else throw BusinessException.invalid("回収方法を選んでください。");
    var now = OffsetDateTime.now(clock);
    var id = UUID.randomUUID().toString();
    var booking =
        new Booking(
            id,
            user,
            c.clientRequestId(),
            hash,
            c.mode(),
            "RESERVED",
            facilityId,
            location,
            address,
            slot.startsAt(),
            slot.endsAt(),
            List.copyOf(items),
            items.stream().mapToInt(i -> i.quantity() * i.unitPriceYen()).sum(),
            "TEST_PAID",
            c.note() == null ? "" : c.note(),
            List.of(),
            now,
            null,
            null);
    BookingRepository.TicketData ticket = null;
    if ("DROPOFF".equals(c.mode())) {
      var token = tickets.newToken();
      ticket =
          new BookingRepository.TicketData(
              tickets.hash(token), tickets.encrypt(id, token), slot.endsAt());
    }
    repository.save(booking, ticket);
    return booking;
  }

  @Transactional
  public Booking cancel(String user, String id) {
    var b = repository.get(id, user, true);
    if (b.status().equals("CANCELLED")) return b;
    b.state().requireCancellation();
    repository.cancel(id);
    return repository.get(id, user, false);
  }

  @Transactional(readOnly = true)
  public Ticket ticket(String user, String id) {
    var b = repository.get(id, user, false);
    b.state().requireTicket(OffsetDateTime.now(clock));
    var t = repository.ticket(id);
    return new Ticket(tickets.decrypt(id, t.encryptedToken()), t.expiresAt());
  }

  @Transactional
  public Admission admit(String manager, String facilityId, String token) {
    if (!token.matches("rg:entry:v1:[A-Za-z0-9_-]{43}"))
      throw BusinessException.invalid("入場用QRコードではありません。");
    var b = repository.byTicketHash(tickets.hash(token));
    if (!Objects.equals(facilityId, b.facilityId()))
      throw new BusinessException("WRONG_FACILITY", "この施設の予約ではありません。", 403);
    if (b.status().equals("ENTERED")) return new Admission(b.id(), b.admittedAt(), true);
    var now = OffsetDateTime.now(clock);
    b.state().requireAdmission(now);
    repository.enter(b, manager, now);
    return new Admission(b.id(), now, false);
  }

  @Transactional
  public Booking.Photo addPhoto(String user, String id, byte[] content, String contentType) {
    var b = repository.get(id, user, true);
    b.state().requirePhoto();
    var photoId =
        UUID.nameUUIDFromBytes(
                (id + Base64.getEncoder().encodeToString(content))
                    .getBytes(java.nio.charset.StandardCharsets.UTF_8))
            .toString();
    var existing = b.photos().stream().filter(p -> p.id().equals(photoId)).findFirst();
    if (existing.isPresent()) return existing.get();
    if (b.photos().size() >= 5) throw BusinessException.conflict("写真は5枚まで登録できます。");
    var p = new Booking.Photo(photoId, photoId + ".jpg", contentType, content.length);
    repository.addPhoto(id, p, content, OffsetDateTime.now(clock));
    return p;
  }

  @Transactional
  public Booking complete(String user, String id) {
    var b = repository.get(id, user, true);
    if (b.mode().equals("DROPOFF") && b.status().equals("COMPLETED")) return b;
    b.state().requireCompletion(b.photos().size());
    repository.complete(id, OffsetDateTime.now(clock));
    return repository.get(id, user, false);
  }

  public BookingRepository.PhotoContent photo(String user, String id, String photoId) {
    repository.get(id, user, false);
    return repository.photo(id, photoId);
  }
}
