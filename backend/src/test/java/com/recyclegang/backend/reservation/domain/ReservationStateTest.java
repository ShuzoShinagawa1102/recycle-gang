package com.recyclegang.backend.reservation.domain;

import static org.junit.jupiter.api.Assertions.*;

import com.recyclegang.backend.shared.BusinessException;
import java.time.OffsetDateTime;
import org.junit.jupiter.api.Test;

class ReservationStateTest {
  final OffsetDateTime start = OffsetDateTime.parse("2026-10-04T00:00:00+09:00");
  final OffsetDateTime end = start.plusDays(1);

  ReservationState state(String mode, String status) {
    return new ReservationState(mode, status, start, end);
  }

  @Test
  void admissionRequiresCorrectModeStateAndWindow() {
    assertDoesNotThrow(() -> state("DROPOFF", "RESERVED").requireAdmission(start));
    assertThrows(BusinessException.class, () -> state("DROPOFF", "RESERVED").requireAdmission(end));
    assertThrows(
        BusinessException.class,
        () -> state("DROPOFF", "RESERVED").requireAdmission(start.minusSeconds(1)));
    for (var status : new String[] {"CANCELLED", "ENTERED", "COMPLETED"})
      assertThrows(BusinessException.class, () -> state("DROPOFF", status).requireAdmission(start));
    assertThrows(
        BusinessException.class, () -> state("PICKUP", "RESERVED").requireAdmission(start));
  }

  @Test
  void completionNeedsAdmissionAndEvidence() {
    assertDoesNotThrow(() -> state("DROPOFF", "ENTERED").requireCompletion(1));
    assertThrows(BusinessException.class, () -> state("DROPOFF", "ENTERED").requireCompletion(0));
    assertThrows(BusinessException.class, () -> state("DROPOFF", "RESERVED").requireCompletion(1));
    assertThrows(BusinessException.class, () -> state("PICKUP", "ENTERED").requireCompletion(1));
  }

  @Test
  void cannotCancelAfterEntry() {
    assertDoesNotThrow(() -> state("DROPOFF", "RESERVED").requireCancellation());
    assertThrows(BusinessException.class, () -> state("DROPOFF", "ENTERED").requireCancellation());
  }
}
