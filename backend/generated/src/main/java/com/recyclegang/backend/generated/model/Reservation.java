package com.recyclegang.backend.generated.model;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.recyclegang.backend.generated.model.Photo;
import com.recyclegang.backend.generated.model.ReservationItem;
import java.time.OffsetDateTime;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.lang.Nullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * Reservation
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.15.0")
public class Reservation {

  private String id;

  private String mode;

  private String status;

  private String locationName;

  private String address;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
  private OffsetDateTime slotStart;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
  private OffsetDateTime slotEnd;

  @Valid
  private List<@Valid ReservationItem> items = new ArrayList<>();

  private Integer amountYen;

  private String paymentStatus;

  private String note;

  @Valid
  private List<@Valid Photo> photos = new ArrayList<>();

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
  private OffsetDateTime createdAt;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
  private @Nullable OffsetDateTime admittedAt;

  @DateTimeFormat(iso = DateTimeFormat.ISO.DATE_TIME)
  private @Nullable OffsetDateTime completedAt;

  public Reservation() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public Reservation(String id, String mode, String status, String locationName, String address, OffsetDateTime slotStart, OffsetDateTime slotEnd, List<@Valid ReservationItem> items, Integer amountYen, String paymentStatus, String note, List<@Valid Photo> photos, OffsetDateTime createdAt) {
    this.id = id;
    this.mode = mode;
    this.status = status;
    this.locationName = locationName;
    this.address = address;
    this.slotStart = slotStart;
    this.slotEnd = slotEnd;
    this.items = items;
    this.amountYen = amountYen;
    this.paymentStatus = paymentStatus;
    this.note = note;
    this.photos = photos;
    this.createdAt = createdAt;
  }

  public Reservation id(String id) {
    this.id = id;
    return this;
  }

  /**
   * Get id
   * @return id
   */
  @NotNull
  @JsonProperty("id")
  public String getId() {
    return id;
  }

  public void setId(String id) {
    this.id = id;
  }

  public Reservation mode(String mode) {
    this.mode = mode;
    return this;
  }

  /**
   * Get mode
   * @return mode
   */
  @NotNull
  @JsonProperty("mode")
  public String getMode() {
    return mode;
  }

  public void setMode(String mode) {
    this.mode = mode;
  }

  public Reservation status(String status) {
    this.status = status;
    return this;
  }

  /**
   * Get status
   * @return status
   */
  @NotNull
  @JsonProperty("status")
  public String getStatus() {
    return status;
  }

  public void setStatus(String status) {
    this.status = status;
  }

  public Reservation locationName(String locationName) {
    this.locationName = locationName;
    return this;
  }

  /**
   * Get locationName
   * @return locationName
   */
  @NotNull
  @JsonProperty("locationName")
  public String getLocationName() {
    return locationName;
  }

  public void setLocationName(String locationName) {
    this.locationName = locationName;
  }

  public Reservation address(String address) {
    this.address = address;
    return this;
  }

  /**
   * Get address
   * @return address
   */
  @NotNull
  @JsonProperty("address")
  public String getAddress() {
    return address;
  }

  public void setAddress(String address) {
    this.address = address;
  }

  public Reservation slotStart(OffsetDateTime slotStart) {
    this.slotStart = slotStart;
    return this;
  }

  /**
   * Get slotStart
   * @return slotStart
   */
  @NotNull @Valid
  @JsonProperty("slotStart")
  public OffsetDateTime getSlotStart() {
    return slotStart;
  }

  public void setSlotStart(OffsetDateTime slotStart) {
    this.slotStart = slotStart;
  }

  public Reservation slotEnd(OffsetDateTime slotEnd) {
    this.slotEnd = slotEnd;
    return this;
  }

  /**
   * Get slotEnd
   * @return slotEnd
   */
  @NotNull @Valid
  @JsonProperty("slotEnd")
  public OffsetDateTime getSlotEnd() {
    return slotEnd;
  }

  public void setSlotEnd(OffsetDateTime slotEnd) {
    this.slotEnd = slotEnd;
  }

  public Reservation items(List<@Valid ReservationItem> items) {
    this.items = items;
    return this;
  }

  public Reservation addItemsItem(ReservationItem itemsItem) {
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
  @NotNull @Valid
  @JsonProperty("items")
  public List<@Valid ReservationItem> getItems() {
    return items;
  }

  public void setItems(List<@Valid ReservationItem> items) {
    this.items = items;
  }

  public Reservation amountYen(Integer amountYen) {
    this.amountYen = amountYen;
    return this;
  }

  /**
   * Get amountYen
   * @return amountYen
   */
  @NotNull
  @JsonProperty("amountYen")
  public Integer getAmountYen() {
    return amountYen;
  }

  public void setAmountYen(Integer amountYen) {
    this.amountYen = amountYen;
  }

  public Reservation paymentStatus(String paymentStatus) {
    this.paymentStatus = paymentStatus;
    return this;
  }

  /**
   * Get paymentStatus
   * @return paymentStatus
   */
  @NotNull
  @JsonProperty("paymentStatus")
  public String getPaymentStatus() {
    return paymentStatus;
  }

  public void setPaymentStatus(String paymentStatus) {
    this.paymentStatus = paymentStatus;
  }

  public Reservation note(String note) {
    this.note = note;
    return this;
  }

  /**
   * Get note
   * @return note
   */
  @NotNull
  @JsonProperty("note")
  public String getNote() {
    return note;
  }

  public void setNote(String note) {
    this.note = note;
  }

  public Reservation photos(List<@Valid Photo> photos) {
    this.photos = photos;
    return this;
  }

  public Reservation addPhotosItem(Photo photosItem) {
    if (this.photos == null) {
      this.photos = new ArrayList<>();
    }
    this.photos.add(photosItem);
    return this;
  }

  /**
   * Get photos
   * @return photos
   */
  @NotNull @Valid
  @JsonProperty("photos")
  public List<@Valid Photo> getPhotos() {
    return photos;
  }

  public void setPhotos(List<@Valid Photo> photos) {
    this.photos = photos;
  }

  public Reservation createdAt(OffsetDateTime createdAt) {
    this.createdAt = createdAt;
    return this;
  }

  /**
   * Get createdAt
   * @return createdAt
   */
  @NotNull @Valid
  @JsonProperty("createdAt")
  public OffsetDateTime getCreatedAt() {
    return createdAt;
  }

  public void setCreatedAt(OffsetDateTime createdAt) {
    this.createdAt = createdAt;
  }

  public Reservation admittedAt(@Nullable OffsetDateTime admittedAt) {
    this.admittedAt = admittedAt;
    return this;
  }

  /**
   * Get admittedAt
   * @return admittedAt
   */
  @Valid
  @JsonProperty("admittedAt")
  public @Nullable OffsetDateTime getAdmittedAt() {
    return admittedAt;
  }

  public void setAdmittedAt(@Nullable OffsetDateTime admittedAt) {
    this.admittedAt = admittedAt;
  }

  public Reservation completedAt(@Nullable OffsetDateTime completedAt) {
    this.completedAt = completedAt;
    return this;
  }

  /**
   * Get completedAt
   * @return completedAt
   */
  @Valid
  @JsonProperty("completedAt")
  public @Nullable OffsetDateTime getCompletedAt() {
    return completedAt;
  }

  public void setCompletedAt(@Nullable OffsetDateTime completedAt) {
    this.completedAt = completedAt;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Reservation reservation = (Reservation) o;
    return Objects.equals(this.id, reservation.id) &&
        Objects.equals(this.mode, reservation.mode) &&
        Objects.equals(this.status, reservation.status) &&
        Objects.equals(this.locationName, reservation.locationName) &&
        Objects.equals(this.address, reservation.address) &&
        Objects.equals(this.slotStart, reservation.slotStart) &&
        Objects.equals(this.slotEnd, reservation.slotEnd) &&
        Objects.equals(this.items, reservation.items) &&
        Objects.equals(this.amountYen, reservation.amountYen) &&
        Objects.equals(this.paymentStatus, reservation.paymentStatus) &&
        Objects.equals(this.note, reservation.note) &&
        Objects.equals(this.photos, reservation.photos) &&
        Objects.equals(this.createdAt, reservation.createdAt) &&
        Objects.equals(this.admittedAt, reservation.admittedAt) &&
        Objects.equals(this.completedAt, reservation.completedAt);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, mode, status, locationName, address, slotStart, slotEnd, items, amountYen, paymentStatus, note, photos, createdAt, admittedAt, completedAt);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class Reservation {\n");
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    mode: ").append(toIndentedString(mode)).append("\n");
    sb.append("    status: ").append(toIndentedString(status)).append("\n");
    sb.append("    locationName: ").append(toIndentedString(locationName)).append("\n");
    sb.append("    address: ").append(toIndentedString(address)).append("\n");
    sb.append("    slotStart: ").append(toIndentedString(slotStart)).append("\n");
    sb.append("    slotEnd: ").append(toIndentedString(slotEnd)).append("\n");
    sb.append("    items: ").append(toIndentedString(items)).append("\n");
    sb.append("    amountYen: ").append(toIndentedString(amountYen)).append("\n");
    sb.append("    paymentStatus: ").append(toIndentedString(paymentStatus)).append("\n");
    sb.append("    note: ").append(toIndentedString(note)).append("\n");
    sb.append("    photos: ").append(toIndentedString(photos)).append("\n");
    sb.append("    createdAt: ").append(toIndentedString(createdAt)).append("\n");
    sb.append("    admittedAt: ").append(toIndentedString(admittedAt)).append("\n");
    sb.append("    completedAt: ").append(toIndentedString(completedAt)).append("\n");
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
