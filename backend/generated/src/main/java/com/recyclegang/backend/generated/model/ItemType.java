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
 * ItemType
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.15.0")
public class ItemType {

  private String id;

  private String name;

  private String unit;

  private Integer priceYen;

  public ItemType() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public ItemType(String id, String name, String unit, Integer priceYen) {
    this.id = id;
    this.name = name;
    this.unit = unit;
    this.priceYen = priceYen;
  }

  public ItemType id(String id) {
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

  public ItemType name(String name) {
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

  public ItemType unit(String unit) {
    this.unit = unit;
    return this;
  }

  /**
   * Get unit
   * @return unit
   */
  @NotNull
  @JsonProperty("unit")
  public String getUnit() {
    return unit;
  }

  public void setUnit(String unit) {
    this.unit = unit;
  }

  public ItemType priceYen(Integer priceYen) {
    this.priceYen = priceYen;
    return this;
  }

  /**
   * Get priceYen
   * minimum: 0
   * @return priceYen
   */
  @NotNull @Min(0)
  @JsonProperty("priceYen")
  public Integer getPriceYen() {
    return priceYen;
  }

  public void setPriceYen(Integer priceYen) {
    this.priceYen = priceYen;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ItemType itemType = (ItemType) o;
    return Objects.equals(this.id, itemType.id) &&
        Objects.equals(this.name, itemType.name) &&
        Objects.equals(this.unit, itemType.unit) &&
        Objects.equals(this.priceYen, itemType.priceYen);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, name, unit, priceYen);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ItemType {\n");
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    name: ").append(toIndentedString(name)).append("\n");
    sb.append("    unit: ").append(toIndentedString(unit)).append("\n");
    sb.append("    priceYen: ").append(toIndentedString(priceYen)).append("\n");
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
