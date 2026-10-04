package com.recyclegang.backend.reservation.application;

public interface TicketCodec {
  String newToken();

  String hash(String token);

  String encrypt(String reservationId, String token);

  String decrypt(String reservationId, String encryptedToken);
}
