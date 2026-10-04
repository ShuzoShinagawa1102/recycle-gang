package com.recyclegang.backend.reservation;

import static org.junit.jupiter.api.Assertions.*;
import static org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors.authentication;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;

import com.fasterxml.jackson.databind.*;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.recyclegang.backend.shared.LocalIdentity;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import java.util.*;
import javax.imageio.ImageIO;
import org.jooq.DSLContext;
import org.jooq.conf.*;
import org.junit.jupiter.api.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.context.TestConfiguration;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Import;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.test.context.*;
import org.springframework.test.web.servlet.*;

@SpringBootTest
@AutoConfigureMockMvc
@ActiveProfiles("local")
@Tag("database")
@TestInstance(TestInstance.Lifecycle.PER_CLASS)
@Import(BookingIntegrationTest.SchemaConfig.class)
class BookingIntegrationTest {
  static final String SCHEMA = "rg_test_" + UUID.randomUUID().toString().replace("-", "");

  @DynamicPropertySource
  static void properties(DynamicPropertyRegistry r) {
    r.add("spring.flyway.default-schema", () -> SCHEMA);
    r.add("spring.datasource.hikari.schema", () -> SCHEMA);
    r.add("spring.datasource.hikari.maximum-pool-size", () -> 4);
    r.add("spring.datasource.hikari.minimum-idle", () -> 0);
  }

  @TestConfiguration
  static class SchemaConfig {
    @Bean
    @org.springframework.context.annotation.Primary
    java.time.Clock fixedClock() {
      return java.time.Clock.fixed(
          java.time.Instant.parse("2026-10-04T03:00:00Z"), java.time.ZoneOffset.UTC);
    }

    @Bean
    Settings settings() {
      return new Settings()
          .withRenderMapping(
              new RenderMapping()
                  .withSchemata(new MappedSchema().withInput("public").withOutput(SCHEMA)));
    }
  }

  @Autowired MockMvc mvc;
  @Autowired ObjectMapper json;
  @Autowired DSLContext db;
  final String user = "Bearer local-user-demo", manager = "Bearer local-manager-demo";
  final String base = "/api/consumer/v1/reservations";

  JsonNode body(MvcResult r) throws Exception {
    return json.readTree(r.getResponse().getContentAsString());
  }

  ObjectNode input(String mode) throws Exception {
    var catalog =
        body(
            mvc.perform(get("/api/consumer/v1/catalog").header("Authorization", user))
                .andExpect(status().isOk())
                .andReturn());
    var input = json.createObjectNode();
    input.put("clientRequestId", UUID.randomUUID().toString());
    input.put("mode", mode);
    input.put("facilityId", "tokyo-east");
    input.put("addressId", "home");
    input.put("slotId", catalog.path("slots").get(0).path("id").asText());
    input.putArray("items").addObject().put("itemTypeId", "metal").put("quantity", 2);
    return input;
  }

  JsonNode create(ObjectNode input) throws Exception {
    return body(
        mvc.perform(
                post(base)
                    .header("Authorization", user)
                    .contentType("application/json")
                    .content(input.toString()))
            .andExpect(status().isCreated())
            .andReturn());
  }

  @Test
  void dropoffCompletesOnlyAfterAdmissionAndPhotoAndRetriesAreIdempotent() throws Exception {
    var input = input("DROPOFF");
    var created = create(input);
    var id = created.path("id").asText();
    assertEquals(600, created.path("amountYen").asInt());
    assertEquals(id, create(input).path("id").asText());
    input.put("note", "changed");
    mvc.perform(
            post(base)
                .header("Authorization", user)
                .contentType("application/json")
                .content(input.toString()))
        .andExpect(status().isConflict());
    mvc.perform(post(base + "/" + id + "/complete").header("Authorization", user))
        .andExpect(status().isConflict());
    var token =
        body(mvc.perform(get(base + "/" + id + "/ticket").header("Authorization", user))
                .andExpect(status().isOk())
                .andReturn())
            .path("token")
            .asText();
    assertTrue(token.matches("rg:entry:v1:[A-Za-z0-9_-]{43}"));
    mvc.perform(
            post("/api/backyard/v1/admissions")
                .header("Authorization", user)
                .contentType("application/json")
                .content(json.createObjectNode().put("token", token).toString()))
        .andExpect(status().isForbidden());
    var admission = json.createObjectNode().put("token", token).toString();
    var wrong =
        new UsernamePasswordAuthenticationToken(
            new LocalIdentity("other-manager", "MANAGER", "tokyo-west"),
            null,
            List.of(new SimpleGrantedAuthority("ROLE_MANAGER")));
    mvc.perform(
            post("/api/backyard/v1/admissions")
                .with(authentication(wrong))
                .contentType("application/json")
                .content(admission))
        .andExpect(status().isForbidden());
    mvc.perform(
            post("/api/backyard/v1/admissions")
                .header("Authorization", manager)
                .contentType("application/json")
                .content(admission))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.alreadyAdmitted").value(false));
    mvc.perform(
            post("/api/backyard/v1/admissions")
                .header("Authorization", manager)
                .contentType("application/json")
                .content(admission))
        .andExpect(status().isOk())
        .andExpect(jsonPath("$.alreadyAdmitted").value(true));
    mvc.perform(post(base + "/" + id + "/cancel").header("Authorization", user))
        .andExpect(status().isConflict());
    mvc.perform(post(base + "/" + id + "/complete").header("Authorization", user))
        .andExpect(status().isConflict());
    var bytes = new ByteArrayOutputStream();
    ImageIO.write(new BufferedImage(16, 16, BufferedImage.TYPE_INT_RGB), "png", bytes);
    var photo =
        body(
            mvc.perform(
                    multipart(base + "/" + id + "/photos")
                        .file(
                            new MockMultipartFile(
                                "file", "photo.png", "image/png", bytes.toByteArray()))
                        .header("Authorization", user))
                .andExpect(status().isCreated())
                .andReturn());
    mvc.perform(
            get(base + "/" + id + "/photos/" + photo.path("id").asText())
                .header("Authorization", user))
        .andExpect(status().isOk());
    for (int i = 0; i < 2; i++)
      mvc.perform(post(base + "/" + id + "/complete").header("Authorization", user))
          .andExpect(status().isOk())
          .andExpect(jsonPath("$.status").value("COMPLETED"));
    mvc.perform(
            post("/api/backyard/v1/admissions")
                .header("Authorization", manager)
                .contentType("application/json")
                .content(admission))
        .andExpect(status().isConflict());
    var other =
        new UsernamePasswordAuthenticationToken(
            new LocalIdentity("other-user", "CONSUMER", null),
            null,
            List.of(new SimpleGrantedAuthority("ROLE_CONSUMER")));
    mvc.perform(get(base + "/" + id).with(authentication(other))).andExpect(status().isNotFound());
    mvc.perform(
            get(base + "/" + id + "/photos/" + photo.path("id").asText())
                .with(authentication(other)))
        .andExpect(status().isNotFound());
  }

  @Test
  void cancelledTicketAndPickupTicketAreRejected() throws Exception {
    var id = create(input("DROPOFF")).path("id").asText();
    var token =
        body(mvc.perform(get(base + "/" + id + "/ticket").header("Authorization", user))
                .andReturn())
            .path("token")
            .asText();
    mvc.perform(post(base + "/" + id + "/cancel").header("Authorization", user))
        .andExpect(status().isOk());
    mvc.perform(
            post("/api/backyard/v1/admissions")
                .header("Authorization", manager)
                .contentType("application/json")
                .content(json.createObjectNode().put("token", token).toString()))
        .andExpect(status().isConflict());
    var pickup = create(input("PICKUP")).path("id").asText();
    mvc.perform(get(base + "/" + pickup + "/ticket").header("Authorization", user))
        .andExpect(status().isConflict());
    mvc.perform(get(base)).andExpect(status().isUnauthorized());
  }

  @AfterAll
  void removeTestSchema() {
    db.dropSchema(org.jooq.impl.DSL.name(SCHEMA)).cascade().execute();
  }

  @Test
  void simultaneousAdmissionCreatesOneRecord() throws Exception {
    var id = create(input("DROPOFF")).path("id").asText();
    var token =
        body(mvc.perform(get(base + "/" + id + "/ticket").header("Authorization", user))
                .andReturn())
            .path("token")
            .asText();
    var payload = json.createObjectNode().put("token", token).toString();
    try (var pool = java.util.concurrent.Executors.newFixedThreadPool(2)) {
      java.util.concurrent.Callable<Boolean> call =
          () ->
              body(mvc.perform(
                          post("/api/backyard/v1/admissions")
                              .header("Authorization", manager)
                              .contentType("application/json")
                              .content(payload))
                      .andExpect(status().isOk())
                      .andReturn())
                  .path("alreadyAdmitted")
                  .asBoolean();
      var first = pool.submit(call);
      var second = pool.submit(call);
      assertNotEquals(
          first.get(10, java.util.concurrent.TimeUnit.SECONDS),
          second.get(10, java.util.concurrent.TimeUnit.SECONDS));
      var table = com.recyclegang.backend.generated.jooq.Tables.ADMISSION;
      assertEquals(1, db.fetchCount(table, table.RESERVATION_ID.eq(id)));
    }
  }

  @Test
  void generatedDatabaseFieldsMatchMigratedSchema() {
    for (var table : com.recyclegang.backend.generated.jooq.Public.PUBLIC.getTables()) {
      // SELECT all generated columns with no rows: missing/renamed columns fail at PostgreSQL.
      db.select(table.fields()).from(table).where(org.jooq.impl.DSL.falseCondition()).fetch();
      var physical =
          db.meta().getTables(table.getName()).stream()
              .filter(t -> t.getSchema().getName().equals(SCHEMA))
              .findFirst()
              .orElseThrow();
      assertEquals(
          Arrays.stream(table.fields())
              .map(org.jooq.Field::getName)
              .collect(java.util.stream.Collectors.toSet()),
          Arrays.stream(physical.fields())
              .map(org.jooq.Field::getName)
              .collect(java.util.stream.Collectors.toSet()));
      for (var field : table.fields()) {
        assertEquals(
            field.getType(),
            physical.field(field.getName()).getType(),
            table.getName() + "." + field.getName());
        assertEquals(
            field.getDataType().nullable(),
            physical.field(field.getName()).getDataType().nullable());
      }
    }
  }
}
