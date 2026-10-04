package com.recyclegang.backend.generated.model;

import java.net.URI;
import java.util.Objects;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonCreator;
import com.recyclegang.backend.generated.model.Facility;
import com.recyclegang.backend.generated.model.ItemType;
import com.recyclegang.backend.generated.model.Slot;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.springframework.lang.Nullable;
import java.time.OffsetDateTime;
import jakarta.validation.Valid;
import jakarta.validation.constraints.*;


import java.util.*;
import jakarta.annotation.Generated;

/**
 * Catalog
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.15.0")
public class Catalog {

  @Valid
  private List<@Valid Facility> facilities = new ArrayList<>();

  @Valid
  private List<@Valid ItemType> itemTypes = new ArrayList<>();

  @Valid
  private List<@Valid Slot> slots = new ArrayList<>();

  public Catalog() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public Catalog(List<@Valid Facility> facilities, List<@Valid ItemType> itemTypes, List<@Valid Slot> slots) {
    this.facilities = facilities;
    this.itemTypes = itemTypes;
    this.slots = slots;
  }

  public Catalog facilities(List<@Valid Facility> facilities) {
    this.facilities = facilities;
    return this;
  }

  public Catalog addFacilitiesItem(Facility facilitiesItem) {
    if (this.facilities == null) {
      this.facilities = new ArrayList<>();
    }
    this.facilities.add(facilitiesItem);
    return this;
  }

  /**
   * Get facilities
   * @return facilities
   */
  @NotNull @Valid
  @JsonProperty("facilities")
  public List<@Valid Facility> getFacilities() {
    return facilities;
  }

  public void setFacilities(List<@Valid Facility> facilities) {
    this.facilities = facilities;
  }

  public Catalog itemTypes(List<@Valid ItemType> itemTypes) {
    this.itemTypes = itemTypes;
    return this;
  }

  public Catalog addItemTypesItem(ItemType itemTypesItem) {
    if (this.itemTypes == null) {
      this.itemTypes = new ArrayList<>();
    }
    this.itemTypes.add(itemTypesItem);
    return this;
  }

  /**
   * Get itemTypes
   * @return itemTypes
   */
  @NotNull @Valid
  @JsonProperty("itemTypes")
  public List<@Valid ItemType> getItemTypes() {
    return itemTypes;
  }

  public void setItemTypes(List<@Valid ItemType> itemTypes) {
    this.itemTypes = itemTypes;
  }

  public Catalog slots(List<@Valid Slot> slots) {
    this.slots = slots;
    return this;
  }

  public Catalog addSlotsItem(Slot slotsItem) {
    if (this.slots == null) {
      this.slots = new ArrayList<>();
    }
    this.slots.add(slotsItem);
    return this;
  }

  /**
   * Get slots
   * @return slots
   */
  @NotNull @Valid
  @JsonProperty("slots")
  public List<@Valid Slot> getSlots() {
    return slots;
  }

  public void setSlots(List<@Valid Slot> slots) {
    this.slots = slots;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Catalog catalog = (Catalog) o;
    return Objects.equals(this.facilities, catalog.facilities) &&
        Objects.equals(this.itemTypes, catalog.itemTypes) &&
        Objects.equals(this.slots, catalog.slots);
  }

  @Override
  public int hashCode() {
    return Objects.hash(facilities, itemTypes, slots);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class Catalog {\n");
    sb.append("    facilities: ").append(toIndentedString(facilities)).append("\n");
    sb.append("    itemTypes: ").append(toIndentedString(itemTypes)).append("\n");
    sb.append("    slots: ").append(toIndentedString(slots)).append("\n");
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
