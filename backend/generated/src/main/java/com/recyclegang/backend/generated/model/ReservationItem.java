package com.recyclegang.backend.generated.model;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import org.springframework.lang.Nullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * ReservationItem
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.15.0")
public class ReservationItem {

  private String itemTypeId;

  private String name;

  private Integer quantity;

  private Integer unitPriceYen;

  public ReservationItem() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public ReservationItem(String itemTypeId, String name, Integer quantity, Integer unitPriceYen) {
    this.itemTypeId = itemTypeId;
    this.name = name;
    this.quantity = quantity;
    this.unitPriceYen = unitPriceYen;
  }

  public ReservationItem itemTypeId(String itemTypeId) {
    this.itemTypeId = itemTypeId;
    return this;
  }

  /**
   * Get itemTypeId
   * @return itemTypeId
   */
  @NotNull
  @JsonProperty("itemTypeId")
  public String getItemTypeId() {
    return itemTypeId;
  }

  public void setItemTypeId(String itemTypeId) {
    this.itemTypeId = itemTypeId;
  }

  public ReservationItem name(String name) {
    this.name = name;
    return this;
  }

  /**
   * Get name
   * @return name
   */
  @NotNull
  @JsonProperty("name")
  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  public ReservationItem quantity(Integer quantity) {
    this.quantity = quantity;
    return this;
  }

  /**
   * Get quantity
   * @return quantity
   */
  @NotNull
  @JsonProperty("quantity")
  public Integer getQuantity() {
    return quantity;
  }

  public void setQuantity(Integer quantity) {
    this.quantity = quantity;
  }

  public ReservationItem unitPriceYen(Integer unitPriceYen) {
    this.unitPriceYen = unitPriceYen;
    return this;
  }

  /**
   * Get unitPriceYen
   * @return unitPriceYen
   */
  @NotNull
  @JsonProperty("unitPriceYen")
  public Integer getUnitPriceYen() {
    return unitPriceYen;
  }

  public void setUnitPriceYen(Integer unitPriceYen) {
    this.unitPriceYen = unitPriceYen;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ReservationItem reservationItem = (ReservationItem) o;
    return Objects.equals(this.itemTypeId, reservationItem.itemTypeId) &&
        Objects.equals(this.name, reservationItem.name) &&
        Objects.equals(this.quantity, reservationItem.quantity) &&
        Objects.equals(this.unitPriceYen, reservationItem.unitPriceYen);
  }

  @Override
  public int hashCode() {
    return Objects.hash(itemTypeId, name, quantity, unitPriceYen);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ReservationItem {\n");
    sb.append("    itemTypeId: ").append(toIndentedString(itemTypeId)).append("\n");
    sb.append("    name: ").append(toIndentedString(name)).append("\n");
    sb.append("    quantity: ").append(toIndentedString(quantity)).append("\n");
    sb.append("    unitPriceYen: ").append(toIndentedString(unitPriceYen)).append("\n");
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
