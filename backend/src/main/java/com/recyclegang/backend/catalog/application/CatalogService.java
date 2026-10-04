package com.recyclegang.backend.catalog.application;

import java.time.*;
import java.time.format.DateTimeFormatter;
import java.util.stream.IntStream;
import org.springframework.stereotype.Service;

@Service
public class CatalogService {
  private final CatalogRepository repository;
  private final Clock clock;

  public CatalogService(CatalogRepository repository, Clock clock) {
    this.repository = repository;
    this.clock = clock;
  }

  public Catalog get() {
    var zone = ZoneId.of("Asia/Tokyo");
    var today = LocalDate.now(clock.withZone(zone));
    // Local service calendar: today through 13 days ahead, all-day fixture slots.
    var slots =
        IntStream.range(0, 14)
            .mapToObj(
                i -> {
                  var day = today.plusDays(i);
                  return new Catalog.Slot(
                      day.toString(),
                      day.format(DateTimeFormatter.ofPattern("M月d日")) + " 00:00–24:00（テスト枠）",
                      day.atStartOfDay(zone).toOffsetDateTime(),
                      day.plusDays(1).atStartOfDay(zone).toOffsetDateTime());
                })
            .toList();
    return new Catalog(repository.facilities(), repository.itemTypes(), slots);
  }
}
