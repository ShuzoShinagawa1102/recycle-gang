package com.recyclegang.backend.catalog.infrastructure;

import static com.recyclegang.backend.generated.jooq.Tables.*;

import com.recyclegang.backend.catalog.application.*;
import java.util.List;
import org.jooq.DSLContext;
import org.springframework.stereotype.Repository;

@Repository
public class JooqCatalogRepository implements CatalogRepository {
  private final DSLContext db;

  public JooqCatalogRepository(DSLContext db) {
    this.db = db;
  }

  public List<Catalog.Facility> facilities() {
    return db.selectFrom(FACILITY)
        .orderBy(FACILITY.ID)
        .fetch(
            r ->
                new Catalog.Facility(
                    r.getId(),
                    r.getName(),
                    r.getAddress(),
                    r.getLatitude(),
                    r.getLongitude(),
                    r.getInstructions()));
  }

  public List<Catalog.ItemType> itemTypes() {
    return db.selectFrom(ITEM_TYPE)
        .orderBy(ITEM_TYPE.PRICE_YEN, ITEM_TYPE.ID)
        .fetch(r -> new Catalog.ItemType(r.getId(), r.getName(), r.getUnit(), r.getPriceYen()));
  }
}
