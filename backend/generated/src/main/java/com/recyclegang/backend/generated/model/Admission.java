package com.recyclegang.backend.generated.model;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import java.time.OffsetDateTime;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.lang.Nullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * Admission
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.15.0")
public class Admission {

  private String reservationId;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
  private OffsetDateTime admittedAt;

  private Boolean alreadyAdmitted;

  public Admission() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public Admission(String reservationId, OffsetDateTime admittedAt, Boolean alreadyAdmitted) {
    this.reservationId = reservationId;
    this.admittedAt = admittedAt;
    this.alreadyAdmitted = alreadyAdmitted;
  }

  public Admission reservationId(String reservationId) {
    this.reservationId = reservationId;
    return this;
  }

  /**
   * Get reservationId
   * @return reservationId
   */
  @NotNull
  @JsonProperty("reservationId")
  public String getReservationId() {
    return reservationId;
  }

  public void setReservationId(String reservationId) {
    this.reservationId = reservationId;
  }

  public Admission admittedAt(OffsetDateTime admittedAt) {
    this.admittedAt = admittedAt;
    return this;
  }

  /**
   * Get admittedAt
   * @return admittedAt
   */
  @NotNull @Valid
  @JsonProperty("admittedAt")
  public OffsetDateTime getAdmittedAt() {
    return admittedAt;
  }

  public void setAdmittedAt(OffsetDateTime admittedAt) {
    this.admittedAt = admittedAt;
  }

  public Admission alreadyAdmitted(Boolean alreadyAdmitted) {
    this.alreadyAdmitted = alreadyAdmitted;
    return this;
  }

  /**
   * Get alreadyAdmitted
   * @return alreadyAdmitted
   */
  @NotNull
  @JsonProperty("alreadyAdmitted")
  public Boolean getAlreadyAdmitted() {
    return alreadyAdmitted;
  }

  public void setAlreadyAdmitted(Boolean alreadyAdmitted) {
    this.alreadyAdmitted = alreadyAdmitted;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Admission admission = (Admission) o;
    return Objects.equals(this.reservationId, admission.reservationId) &&
        Objects.equals(this.admittedAt, admission.admittedAt) &&
        Objects.equals(this.alreadyAdmitted, admission.alreadyAdmitted);
  }

  @Override
  public int hashCode() {
    return Objects.hash(reservationId, admittedAt, alreadyAdmitted);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class Admission {\n");
    sb.append("    reservationId: ").append(toIndentedString(reservationId)).append("\n");
    sb.append("    admittedAt: ").append(toIndentedString(admittedAt)).append("\n");
    sb.append("    alreadyAdmitted: ").append(toIndentedString(alreadyAdmitted)).append("\n");
    sb.append("}");
    return sb.toString();
  }

  /**
   * Convert the given object to string with each line indented by 4 spaces
   * (except the first line).
   */
  private String toIndentedString(Object o) {
    if (o == null) {
      return "null";
    }
    return o.toString().replace("\n", "\n    ");
  }
}
