package com.recyclegang.backend.reservation.infrastructure;

import static com.recyclegang.backend.generated.jooq.Tables.*;

import com.recyclegang.backend.generated.jooq.tables.records.ReservationRecord;
import com.recyclegang.backend.reservation.application.BookingRepository;
import com.recyclegang.backend.reservation.domain.Booking;
import com.recyclegang.backend.shared.BusinessException;
import java.time.OffsetDateTime;
import java.util.List;
import org.jooq.DSLContext;
import org.springframework.stereotype.Repository;

@Repository
public class JooqBookingRepository implements BookingRepository {
  private final DSLContext db;

  public JooqBookingRepository(DSLContext db) {
    this.db = db;
  }

  public List<Booking> list(String user) {
    return db.selectFrom(RESERVATION)
        .where(RESERVATION.CUSTOMER_ID.eq(user))
        .orderBy(RESERVATION.CREATED_AT.desc())
        .fetch(this::map);
  }

  public Booking get(String id, String user, boolean lock) {
    var query =
        db.selectFrom(RESERVATION)
            .where(RESERVATION.ID.eq(id).and(RESERVATION.CUSTOMER_ID.eq(user)));
    var row = lock ? query.forUpdate().fetchOne() : query.fetchOne();
    if (row == null) throw BusinessException.missing();
    return map(row);
  }

  public Booking byRequest(String user, String requestId) {
    var row =
        db.selectFrom(RESERVATION)
            .where(
                RESERVATION.CUSTOMER_ID.eq(user).and(RESERVATION.CLIENT_REQUEST_ID.eq(requestId)))
            .fetchOne();
    return row == null ? null : map(row);
  }

  public void save(Booking b, TicketData ticket) {
    db.insertInto(RESERVATION)
        .set(RESERVATION.ID, b.id())
        .set(RESERVATION.CUSTOMER_ID, b.customerId())
        .set(RESERVATION.CLIENT_REQUEST_ID, b.clientRequestId())
        .set(RESERVATION.REQUEST_HASH, b.requestHash())
        .set(RESERVATION.MODE, b.mode())
        .set(RESERVATION.STATUS, b.status())
        .set(RESERVATION.FACILITY_ID, b.facilityId())
        .set(RESERVATION.LOCATION_NAME, b.locationName())
        .set(RESERVATION.ADDRESS, b.address())
        .set(RESERVATION.SLOT_START, b.slotStart())
        .set(RESERVATION.SLOT_END, b.slotEnd())
        .set(RESERVATION.AMOUNT_YEN, b.amountYen())
        .set(RESERVATION.PAYMENT_STATUS, b.paymentStatus())
        .set(RESERVATION.NOTE, b.note())
        .set(RESERVATION.CREATED_AT, b.createdAt())
        .execute();
    for (var i : b.items())
      db.insertInto(RESERVATION_ITEM)
          .set(RESERVATION_ITEM.RESERVATION_ID, b.id())
          .set(RESERVATION_ITEM.ITEM_TYPE_ID, i.itemTypeId())
          .set(RESERVATION_ITEM.NAME, i.name())
          .set(RESERVATION_ITEM.QUANTITY, i.quantity())
          .set(RESERVATION_ITEM.UNIT_PRICE_YEN, i.unitPriceYen())
          .execute();
    if (ticket != null)
      db.insertInto(ENTRY_TICKET)
          .set(ENTRY_TICKET.RESERVATION_ID, b.id())
          .set(ENTRY_TICKET.TOKEN_HASH, ticket.tokenHash())
          .set(ENTRY_TICKET.ENCRYPTED_TOKEN, ticket.encryptedToken())
          .set(ENTRY_TICKET.EXPIRES_AT, ticket.expiresAt())
          .execute();
  }

  public TicketData ticket(String id) {
    var t = db.selectFrom(ENTRY_TICKET).where(ENTRY_TICKET.RESERVATION_ID.eq(id)).fetchOne();
    if (t == null) throw BusinessException.missing();
    return new TicketData(t.getTokenHash(), t.getEncryptedToken(), t.getExpiresAt());
  }

  public Booking byTicketHash(String hash) {
    var id =
        db.select(ENTRY_TICKET.RESERVATION_ID)
            .from(ENTRY_TICKET)
            .where(ENTRY_TICKET.TOKEN_HASH.eq(hash))
            .fetchOne(ENTRY_TICKET.RESERVATION_ID);
    if (id == null) throw BusinessException.missing();
    var row = db.selectFrom(RESERVATION).where(RESERVATION.ID.eq(id)).forUpdate().fetchOne();
    if (row == null) throw BusinessException.missing();
    return map(row);
  }

  public void enter(Booking b, String manager, OffsetDateTime now) {
    db.insertInto(ADMISSION)
        .set(ADMISSION.RESERVATION_ID, b.id())
        .set(ADMISSION.FACILITY_ID, b.facilityId())
        .set(ADMISSION.MANAGER_ID, manager)
        .set(ADMISSION.ADMITTED_AT, now)
        .execute();
    db.update(RESERVATION)
        .set(RESERVATION.STATUS, "ENTERED")
        .set(RESERVATION.ADMITTED_AT, now)
        .where(RESERVATION.ID.eq(b.id()))
        .execute();
  }

  public void cancel(String id) {
    db.update(RESERVATION)
        .set(RESERVATION.STATUS, "CANCELLED")
        .set(RESERVATION.PAYMENT_STATUS, "TEST_REFUNDED")
        .where(RESERVATION.ID.eq(id))
        .execute();
  }

  public void complete(String id, OffsetDateTime now) {
    db.update(RESERVATION)
        .set(RESERVATION.STATUS, "COMPLETED")
        .set(RESERVATION.COMPLETED_AT, now)
        .where(RESERVATION.ID.eq(id))
        .execute();
  }

  public void addPhoto(String id, Booking.Photo p, byte[] bytes, OffsetDateTime now) {
    db.insertInto(COMPLETION_PHOTO)
        .set(COMPLETION_PHOTO.ID, p.id())
        .set(COMPLETION_PHOTO.RESERVATION_ID, id)
        .set(COMPLETION_PHOTO.FILE_NAME, p.fileName())
        .set(COMPLETION_PHOTO.CONTENT_TYPE, p.contentType())
        .set(COMPLETION_PHOTO.SIZE, p.size())
        .set(COMPLETION_PHOTO.CONTENT, bytes)
        .set(COMPLETION_PHOTO.CREATED_AT, now)
        .execute();
  }

  public PhotoContent photo(String id, String photoId) {
    var p =
        db.selectFrom(COMPLETION_PHOTO)
            .where(COMPLETION_PHOTO.RESERVATION_ID.eq(id).and(COMPLETION_PHOTO.ID.eq(photoId)))
            .fetchOne();
    if (p == null) throw BusinessException.missing();
    return new PhotoContent(
        new Booking.Photo(p.getId(), p.getFileName(), p.getContentType(), p.getSize()),
        p.getContent());
  }

  private Booking map(ReservationRecord r) {
    var items =
        db.selectFrom(RESERVATION_ITEM)
            .where(RESERVATION_ITEM.RESERVATION_ID.eq(r.getId()))
            .orderBy(RESERVATION_ITEM.ITEM_TYPE_ID)
            .fetch(
                i ->
                    new Booking.Item(
                        i.getItemTypeId(), i.getName(), i.getQuantity(), i.getUnitPriceYen()));
    var photos =
        db.select(
                COMPLETION_PHOTO.ID,
                COMPLETION_PHOTO.FILE_NAME,
                COMPLETION_PHOTO.CONTENT_TYPE,
                COMPLETION_PHOTO.SIZE)
            .from(COMPLETION_PHOTO)
            .where(COMPLETION_PHOTO.RESERVATION_ID.eq(r.getId()))
            .orderBy(COMPLETION_PHOTO.CREATED_AT)
            .fetch(p -> new Booking.Photo(p.value1(), p.value2(), p.value3(), p.value4()));
    return new Booking(
        r.getId(),
        r.getCustomerId(),
        r.getClientRequestId(),
        r.getRequestHash(),
        r.getMode(),
        r.getStatus(),
        r.getFacilityId(),
        r.getLocationName(),
        r.getAddress(),
        r.getSlotStart(),
        r.getSlotEnd(),
        items,
        r.getAmountYen(),
        r.getPaymentStatus(),
        r.getNote(),
        photos,
        r.getCreatedAt(),
        r.getAdmittedAt(),
        r.getCompletedAt());
  }
}
