package com.recyclegang.backend.reservation.domain;

import java.time.OffsetDateTime;
import java.util.List;

public record Booking(
    String id,
    String customerId,
    String clientRequestId,
    String requestHash,
    String mode,
    String status,
    String facilityId,
    String locationName,
    String address,
    OffsetDateTime slotStart,
    OffsetDateTime slotEnd,
    List<Item> items,
    int amountYen,
    String paymentStatus,
    String note,
    List<Photo> photos,
    OffsetDateTime createdAt,
    OffsetDateTime admittedAt,
    OffsetDateTime completedAt) {
  public record Item(String itemTypeId, String name, int quantity, int unitPriceYen) {}

  public record Photo(String id, String fileName, String contentType, long size) {}

  public ReservationState state() {
    return new ReservationState(mode, status, slotStart, slotEnd);
  }
}
