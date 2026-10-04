package com.recyclegang.backend.reservation.infrastructure;

import static org.junit.jupiter.api.Assertions.*;

import java.util.Base64;
import java.util.HashSet;
import org.junit.jupiter.api.Test;

class AesTicketCodecTest {
  final AesTicketCodec codec = new AesTicketCodec(Base64.getEncoder().encodeToString(new byte[32]));

  @Test
  void tokenIsOpaqueUniqueAndAuthenticatedToReservation() {
    var tokens = new HashSet<String>();
    for (int i = 0; i < 100; i++) {
      var token = codec.newToken();
      assertTrue(token.matches("rg:entry:v1:[A-Za-z0-9_-]{43}"));
      assertTrue(tokens.add(token));
    }
    var token = codec.newToken();
    var encrypted = codec.encrypt("reservation-a", token);
    assertNotEquals(token, encrypted);
    assertEquals(token, codec.decrypt("reservation-a", encrypted));
    assertThrows(IllegalStateException.class, () -> codec.decrypt("reservation-b", encrypted));
    assertNotEquals(codec.hash(token), codec.hash(token + "x"));
  }
}
