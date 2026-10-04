package com.recyclegang.backend.customer.application;

import java.util.List;

public record CustomerProfile(
    String displayName, String email, String phone, List<Address> addresses) {
  public record Address(
      String id, String label, String postalCode, String prefecture, String addressLine) {}
}
