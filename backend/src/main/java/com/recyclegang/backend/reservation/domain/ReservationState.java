package com.recyclegang.backend.reservation.domain;

import com.recyclegang.backend.shared.BusinessException;
import java.time.OffsetDateTime;

/** Reservation lifecycle rules. No Spring, HTTP or database dependencies. */
public record ReservationState(
    String mode, String status, OffsetDateTime startsAt, OffsetDateTime endsAt) {
  public void requireTicket(OffsetDateTime now) {
    if (!mode.equals("DROPOFF") || !status.equals("RESERVED"))
      throw BusinessException.conflict("入場QRを表示できる予約ではありません。");
    if (!now.isBefore(endsAt)) throw BusinessException.conflict("予約の有効期限が過ぎています。");
  }

  public void requireAdmission(OffsetDateTime now) {
    requireTicket(now);
    if (now.isBefore(startsAt)) throw BusinessException.conflict("予約時間前です。");
  }

  public void requirePhoto() {
    if (!mode.equals("DROPOFF") || !status.equals("ENTERED"))
      throw BusinessException.conflict("入場受付後に写真を登録してください。");
  }

  public void requireCompletion(int photoCount) {
    requirePhoto();
    if (photoCount < 1) throw BusinessException.conflict("回収品を置いた写真を1枚以上登録してください。");
  }

  public void requireCancellation() {
    if (!status.equals("RESERVED")) throw BusinessException.conflict("入場後・完了後の予約は取り消せません。");
  }
}
