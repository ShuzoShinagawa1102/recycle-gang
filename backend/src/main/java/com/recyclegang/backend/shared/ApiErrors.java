package com.recyclegang.backend.shared;

import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MaxUploadSizeExceededException;

@RestControllerAdvice
public class ApiErrors {
  public record Error(String code, String message) {}

  @ExceptionHandler(BusinessException.class)
  ResponseEntity<Error> business(BusinessException e) {
    return ResponseEntity.status(e.status).body(new Error(e.code, e.getMessage()));
  }

  @ExceptionHandler({
    MethodArgumentNotValidException.class,
    HttpMessageNotReadableException.class,
    jakarta.validation.ConstraintViolationException.class
  })
  ResponseEntity<Error> invalid(Exception e) {
    return ResponseEntity.badRequest().body(new Error("INVALID_INPUT", "入力内容を確認してください。"));
  }

  @ExceptionHandler(MaxUploadSizeExceededException.class)
  ResponseEntity<Error> large(Exception e) {
    return ResponseEntity.status(413).body(new Error("PHOTO_TOO_LARGE", "写真は8MB以下にしてください。"));
  }
}
