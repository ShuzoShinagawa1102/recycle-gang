package com.recyclegang.backend.generated.model;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import com.recyclegang.backend.generated.model.ItemInput;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.UUID;
import org.springframework.lang.Nullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * ReservationInput
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.15.0")
public class ReservationInput {

  private UUID clientRequestId;

  /**
   * Gets or Sets mode
   */
  public enum ModeEnum {
    PICKUP("PICKUP"),

    DROPOFF("DROPOFF");

    private final String value;

    ModeEnum(String value) {
      this.value = value;
    }

    @JsonValue
    public String getValue() {
      return value;
    }

    @Override
    public String toString() {
      return String.valueOf(value);
    }

    @JsonCreator
    public static ModeEnum fromValue(String value) {
      for (ModeEnum b : ModeEnum.values()) {
        if (b.value.equals(value)) {
          return b;
        }
      }
      throw new IllegalArgumentException("Unexpected value '" + value + "'");
    }
  }

  private ModeEnum mode;

  private @Nullable String facilityId;

  private @Nullable String addressId;

  private String slotId;

  @Valid
  private List<@Valid ItemInput> items = new ArrayList<>();

  private @Nullable String note;

  public ReservationInput() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public ReservationInput(UUID clientRequestId, ModeEnum mode, String slotId, List<@Valid ItemInput> items) {
    this.clientRequestId = clientRequestId;
    this.mode = mode;
    this.slotId = slotId;
    this.items = items;
  }

  public ReservationInput clientRequestId(UUID clientRequestId) {
    this.clientRequestId = clientRequestId;
    return this;
  }

  /**
   * Get clientRequestId
   * @return clientRequestId
   */
  @NotNull @Valid
  @JsonProperty("clientRequestId")
  public UUID getClientRequestId() {
    return clientRequestId;
  }

  public void setClientRequestId(UUID clientRequestId) {
    this.clientRequestId = clientRequestId;
  }

  public ReservationInput mode(ModeEnum mode) {
    this.mode = mode;
    return this;
  }

  /**
   * Get mode
   * @return mode
   */
  @NotNull
  @JsonProperty("mode")
  public ModeEnum getMode() {
    return mode;
  }

  public void setMode(ModeEnum mode) {
    this.mode = mode;
  }

  public ReservationInput facilityId(@Nullable String facilityId) {
    this.facilityId = facilityId;
    return this;
  }

  /**
   * Get facilityId
   * @return facilityId
   */

  @JsonProperty("facilityId")
  public @Nullable String getFacilityId() {
    return facilityId;
  }

  public void setFacilityId(@Nullable String facilityId) {
    this.facilityId = facilityId;
  }

  public ReservationInput addressId(@Nullable String addressId) {
    this.addressId = addressId;
    return this;
  }

  /**
   * Get addressId
   * @return addressId
   */

  @JsonProperty("addressId")
  public @Nullable String getAddressId() {
    return addressId;
  }

  public void setAddressId(@Nullable String addressId) {
    this.addressId = addressId;
  }

  public ReservationInput slotId(String slotId) {
    this.slotId = slotId;
    return this;
  }

  /**
   * Get slotId
   * @return slotId
   */
  @NotNull
  @JsonProperty("slotId")
  public String getSlotId() {
    return slotId;
  }

  public void setSlotId(String slotId) {
    this.slotId = slotId;
  }

  public ReservationInput items(List<@Valid ItemInput> items) {
    this.items = items;
    return this;
  }

  public ReservationInput addItemsItem(ItemInput itemsItem) {
    if (this.items == null) {
      this.items = new ArrayList<>();
    }
    this.items.add(itemsItem);
    return this;
  }

  /**
   * Get items
   * @return items
   */
  @NotNull @Valid @Size(min = 1, max = 10)
  @JsonProperty("items")
  public List<@Valid ItemInput> getItems() {
    return items;
  }

  public void setItems(List<@Valid ItemInput> items) {
    this.items = items;
  }

  public ReservationInput note(@Nullable String note) {
    this.note = note;
    return this;
  }

  /**
   * Get note
   * @return note
   */
  @Size(max = 500)
  @JsonProperty("note")
  public @Nullable String getNote() {
    return note;
  }

  public void setNote(@Nullable String note) {
    this.note = note;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ReservationInput reservationInput = (ReservationInput) o;
    return Objects.equals(this.clientRequestId, reservationInput.clientRequestId) &&
        Objects.equals(this.mode, reservationInput.mode) &&
        Objects.equals(this.facilityId, reservationInput.facilityId) &&
        Objects.equals(this.addressId, reservationInput.addressId) &&
        Objects.equals(this.slotId, reservationInput.slotId) &&
        Objects.equals(this.items, reservationInput.items) &&
        Objects.equals(this.note, reservationInput.note);
  }

  @Override
  public int hashCode() {
    return Objects.hash(clientRequestId, mode, facilityId, addressId, slotId, items, note);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ReservationInput {\n");
    sb.append("    clientRequestId: ").append(toIndentedString(clientRequestId)).append("\n");
    sb.append("    mode: ").append(toIndentedString(mode)).append("\n");
    sb.append("    facilityId: ").append(toIndentedString(facilityId)).append("\n");
    sb.append("    addressId: ").append(toIndentedString(addressId)).append("\n");
    sb.append("    slotId: ").append(toIndentedString(slotId)).append("\n");
    sb.append("    items: ").append(toIndentedString(items)).append("\n");
    sb.append("    note: ").append(toIndentedString(note)).append("\n");
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
