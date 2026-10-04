package com.recyclegang.backend.reservation.presentation;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.recyclegang.backend.generated.api.ReservationsApi;
import com.recyclegang.backend.generated.model.*;
import com.recyclegang.backend.reservation.application.BookingService;
import com.recyclegang.backend.reservation.domain.Booking;
import com.recyclegang.backend.shared.LocalIdentity;
import java.util.List;
import org.springframework.core.io.*;
import org.springframework.http.*;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

@RestController
public class ReservationController implements ReservationsApi {
  private final BookingService service;
  private final ObjectMapper json;

  public ReservationController(BookingService service, ObjectMapper json) {
    this.service = service;
    this.json = json;
  }

  private String user() {
    return LocalIdentity.current().id();
  }

  private Reservation dto(Booking b) {
    return json.convertValue(b, Reservation.class);
  }

  public ResponseEntity<List<Reservation>> listReservations() {
    return ResponseEntity.ok(service.list(user()).stream().map(this::dto).toList());
  }

  public ResponseEntity<Reservation> getReservation(String id) {
    return ResponseEntity.ok(dto(service.get(user(), id)));
  }

  public ResponseEntity<Reservation> createReservation(ReservationInput r) {
    var c =
        new BookingService.Create(
            r.getClientRequestId().toString(),
            r.getMode().getValue(),
            r.getFacilityId(),
            r.getAddressId(),
            r.getSlotId(),
            r.getItems().stream()
                .map(i -> new BookingService.ItemInput(i.getItemTypeId(), i.getQuantity()))
                .toList(),
            r.getNote());
    return ResponseEntity.status(201).body(dto(service.create(user(), c)));
  }

  public ResponseEntity<Reservation> cancelReservation(String id) {
    return ResponseEntity.ok(dto(service.cancel(user(), id)));
  }

  public ResponseEntity<Ticket> getTicket(String id) {
    return ResponseEntity.ok()
        .cacheControl(CacheControl.noStore())
        .body(json.convertValue(service.ticket(user(), id), Ticket.class));
  }

  public ResponseEntity<Reservation> completeDropoff(String id) {
    return ResponseEntity.ok(dto(service.complete(user(), id)));
  }

  public ResponseEntity<Photo> uploadPhoto(String id, MultipartFile file) {
    return ResponseEntity.status(201)
        .body(
            json.convertValue(
                service.addPhoto(user(), id, SafePhoto.jpeg(file), "image/jpeg"), Photo.class));
  }

  public ResponseEntity<Resource> downloadPhoto(String id, String photoId) {
    var p = service.photo(user(), id, photoId);
    return ResponseEntity.ok()
        .contentType(MediaType.APPLICATION_OCTET_STREAM)
        .cacheControl(CacheControl.noStore())
        .header("X-Content-Type-Options", "nosniff")
        .body(new ByteArrayResource(p.content()));
  }
}
