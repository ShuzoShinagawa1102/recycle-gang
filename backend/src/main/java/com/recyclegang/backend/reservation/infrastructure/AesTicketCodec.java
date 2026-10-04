package com.recyclegang.backend.reservation.infrastructure;

import com.recyclegang.backend.reservation.application.TicketCodec;
import java.nio.charset.StandardCharsets;
import java.security.*;
import java.util.*;
import javax.crypto.Cipher;
import javax.crypto.spec.*;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class AesTicketCodec implements TicketCodec {
  private final byte[] key;
  private final SecureRandom random = new SecureRandom();

  public AesTicketCodec(@Value("${app.ticket-key}") String key) {
    this.key = Base64.getDecoder().decode(key);
    if (this.key.length != 32)
      throw new IllegalArgumentException(
          "TICKET_KEY must be a base64-encoded 32-byte key. For local development activate the"
              + " local profile.");
  }

  public String newToken() {
    byte[] bytes = new byte[32];
    random.nextBytes(bytes);
    return "rg:entry:v1:" + Base64.getUrlEncoder().withoutPadding().encodeToString(bytes);
  }

  public String hash(String token) {
    try {
      return HexFormat.of()
          .formatHex(
              MessageDigest.getInstance("SHA-256").digest(token.getBytes(StandardCharsets.UTF_8)));
    } catch (GeneralSecurityException e) {
      throw new IllegalStateException(e);
    }
  }

  public String encrypt(String id, String token) {
    try {
      var nonce = new byte[12];
      random.nextBytes(nonce);
      var cipher = cipher(Cipher.ENCRYPT_MODE, id, nonce);
      var encrypted = cipher.doFinal(token.getBytes(StandardCharsets.UTF_8));
      var all = Arrays.copyOf(nonce, nonce.length + encrypted.length);
      System.arraycopy(encrypted, 0, all, nonce.length, encrypted.length);
      return Base64.getEncoder().encodeToString(all);
    } catch (GeneralSecurityException e) {
      throw new IllegalStateException(e);
    }
  }

  public String decrypt(String id, String encrypted) {
    try {
      var all = Base64.getDecoder().decode(encrypted);
      return new String(
          cipher(Cipher.DECRYPT_MODE, id, Arrays.copyOf(all, 12))
              .doFinal(Arrays.copyOfRange(all, 12, all.length)),
          StandardCharsets.UTF_8);
    } catch (GeneralSecurityException e) {
      throw new IllegalStateException(e);
    }
  }

  private Cipher cipher(int mode, String id, byte[] nonce) throws GeneralSecurityException {
    var c = Cipher.getInstance("AES/GCM/NoPadding");
    c.init(mode, new SecretKeySpec(key, "AES"), new GCMParameterSpec(128, nonce));
    c.updateAAD(id.getBytes(StandardCharsets.UTF_8));
    return c;
  }
}
