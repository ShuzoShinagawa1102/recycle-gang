package com.recyclegang.backend.shared;

public class BusinessException extends RuntimeException {
  public final String code;
  public final int status;

  public BusinessException(String code, String message, int status) {
    super(message);
    this.code = code;
    this.status = status;
  }

  public static BusinessException conflict(String message) {
    return new BusinessException("INVALID_STATE", message, 409);
  }

  public static BusinessException invalid(String message) {
    return new BusinessException("INVALID_INPUT", message, 400);
  }

  public static BusinessException missing() {
    return new BusinessException("NOT_FOUND", "対象が見つかりません。", 404);
  }
}
