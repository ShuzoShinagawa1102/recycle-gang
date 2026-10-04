package com.recyclegang.backend.reservation.application;

import com.recyclegang.backend.reservation.domain.Booking;
import java.time.OffsetDateTime;
import java.util.List;

public interface BookingRepository {
  List<Booking> list(String customerId);

  Booking get(String id, String customerId, boolean lock);

  Booking byRequest(String customerId, String clientRequestId);

  void save(Booking booking, TicketData ticket);

  TicketData ticket(String reservationId);

  Booking byTicketHash(String hash);

  void enter(Booking booking, String managerId, OffsetDateTime now);

  void cancel(String id);

  void complete(String id, OffsetDateTime now);

  void addPhoto(String reservationId, Booking.Photo photo, byte[] content, OffsetDateTime now);

  PhotoContent photo(String reservationId, String photoId);

  record TicketData(String tokenHash, String encryptedToken, OffsetDateTime expiresAt) {}

  record PhotoContent(Booking.Photo meta, byte[] content) {}
}
