package com.recyclegang.backend.customer.presentation;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.recyclegang.backend.customer.application.*;
import com.recyclegang.backend.generated.api.ProfileApi;
import com.recyclegang.backend.generated.model.Profile;
import com.recyclegang.backend.shared.LocalIdentity;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ProfileController implements ProfileApi {
  private final CustomerService service;
  private final ObjectMapper json;

  public ProfileController(CustomerService service, ObjectMapper json) {
    this.service = service;
    this.json = json;
  }

  public ResponseEntity<Profile> getProfile() {
    return ResponseEntity.ok(
        json.convertValue(service.get(LocalIdentity.current().id()), Profile.class));
  }

  public ResponseEntity<Profile> updateProfile(Profile p) {
    return ResponseEntity.ok(
        json.convertValue(
            service.save(LocalIdentity.current().id(), json.convertValue(p, CustomerProfile.class)),
            Profile.class));
  }
}
