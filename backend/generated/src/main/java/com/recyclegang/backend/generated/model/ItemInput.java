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
 * ItemInput
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.15.0")
public class ItemInput {

  private String itemTypeId;

  private Integer quantity;

  public ItemInput() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public ItemInput(String itemTypeId, Integer quantity) {
    this.itemTypeId = itemTypeId;
    this.quantity = quantity;
  }

  public ItemInput itemTypeId(String itemTypeId) {
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

  public ItemInput quantity(Integer quantity) {
    this.quantity = quantity;
    return this;
  }

  /**
   * Get quantity
   * minimum: 1
   * maximum: 20
   * @return quantity
   */
  @NotNull @Min(1) @Max(20)
  @JsonProperty("quantity")
  public Integer getQuantity() {
    return quantity;
  }

  public void setQuantity(Integer quantity) {
    this.quantity = quantity;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    ItemInput itemInput = (ItemInput) o;
    return Objects.equals(this.itemTypeId, itemInput.itemTypeId) &&
        Objects.equals(this.quantity, itemInput.quantity);
  }

  @Override
  public int hashCode() {
    return Objects.hash(itemTypeId, quantity);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class ItemInput {\n");
    sb.append("    itemTypeId: ").append(toIndentedString(itemTypeId)).append("\n");
    sb.append("    quantity: ").append(toIndentedString(quantity)).append("\n");
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
