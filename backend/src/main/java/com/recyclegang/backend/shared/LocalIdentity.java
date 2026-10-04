package com.recyclegang.backend.shared;

import org.springframework.security.core.context.SecurityContextHolder;

public record LocalIdentity(String id, String role, String facilityId) {
  public static LocalIdentity current() {
    return (LocalIdentity) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
  }
}
