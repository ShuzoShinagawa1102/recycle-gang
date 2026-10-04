package com.recyclegang.backend.catalog.application;

import java.util.List;

public interface CatalogRepository {
  List<Catalog.Facility> facilities();

  List<Catalog.ItemType> itemTypes();
}
