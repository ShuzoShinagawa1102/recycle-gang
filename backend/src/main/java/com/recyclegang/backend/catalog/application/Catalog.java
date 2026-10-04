package com.recyclegang.backend.catalog.application;

import java.time.OffsetDateTime;
import java.util.List;

public record Catalog(List<Facility> facilities, List<ItemType> itemTypes, List<Slot> slots) {
  public record Facility(
      String id,
      String name,
      String address,
      double latitude,
      double longitude,
      String instructions) {}

  public record ItemType(String id, String name, String unit, int priceYen) {}

  public record Slot(String id, String label, OffsetDateTime startsAt, OffsetDateTime endsAt) {}
}
