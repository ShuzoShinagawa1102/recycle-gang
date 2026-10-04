package com.recyclegang.backend.catalog.presentation;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.recyclegang.backend.catalog.application.CatalogService;
import com.recyclegang.backend.generated.api.CatalogApi;
import com.recyclegang.backend.generated.model.Catalog;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class CatalogController implements CatalogApi {
  private final CatalogService service;
  private final ObjectMapper json;

  public CatalogController(CatalogService service, ObjectMapper json) {
    this.service = service;
    this.json = json;
  }

  public ResponseEntity<Catalog> getCatalog() {
    return ResponseEntity.ok(json.convertValue(service.get(), Catalog.class));
  }
}
