package com.recyclegang.backend.reservation.presentation;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.recyclegang.backend.generated.api.AdmissionsApi;
import com.recyclegang.backend.generated.model.*;
import com.recyclegang.backend.reservation.application.BookingService;
import com.recyclegang.backend.shared.LocalIdentity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class AdmissionController implements AdmissionsApi {
  private final BookingService service;
  private final ObjectMapper json;

  public AdmissionController(BookingService service, ObjectMapper json) {
    this.service = service;
    this.json = json;
  }

  public ResponseEntity<Admission> admitReservation(AdmissionInput input) {
    var manager = LocalIdentity.current();
    return ResponseEntity.ok(
        json.convertValue(
            service.admit(manager.id(), manager.facilityId(), input.getToken()), Admission.class));
  }
}
