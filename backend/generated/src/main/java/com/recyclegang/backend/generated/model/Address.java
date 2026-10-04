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
 * Address
 */

@Generated(value = "org.openapitools.codegen.languages.SpringCodegen", comments = "Generator version: 7.15.0")
public class Address {

  private String id;

  private String label;

  private String postalCode;

  private String prefecture;

  private String addressLine;

  public Address() {
    super();
  }

  /**
   * Constructor with only required parameters
   */
  public Address(String id, String label, String postalCode, String prefecture, String addressLine) {
    this.id = id;
    this.label = label;
    this.postalCode = postalCode;
    this.prefecture = prefecture;
    this.addressLine = addressLine;
  }

  public Address id(String id) {
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

  public Address label(String label) {
    this.label = label;
    return this;
  }

  /**
   * Get label
   * @return label
   */
  @NotNull @Size(max = 40)
  @JsonProperty("label")
  public String getLabel() {
    return label;
  }

  public void setLabel(String label) {
    this.label = label;
  }

  public Address postalCode(String postalCode) {
    this.postalCode = postalCode;
    return this;
  }

  /**
   * Get postalCode
   * @return postalCode
   */
  @NotNull @Size(max = 10)
  @JsonProperty("postalCode")
  public String getPostalCode() {
    return postalCode;
  }

  public void setPostalCode(String postalCode) {
    this.postalCode = postalCode;
  }

  public Address prefecture(String prefecture) {
    this.prefecture = prefecture;
    return this;
  }

  /**
   * Get prefecture
   * @return prefecture
   */
  @NotNull @Size(max = 10)
  @JsonProperty("prefecture")
  public String getPrefecture() {
    return prefecture;
  }

  public void setPrefecture(String prefecture) {
    this.prefecture = prefecture;
  }

  public Address addressLine(String addressLine) {
    this.addressLine = addressLine;
    return this;
  }

  /**
   * Get addressLine
   * @return addressLine
   */
  @NotNull @Size(max = 200)
  @JsonProperty("addressLine")
  public String getAddressLine() {
    return addressLine;
  }

  public void setAddressLine(String addressLine) {
    this.addressLine = addressLine;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Address address = (Address) o;
    return Objects.equals(this.id, address.id) &&
        Objects.equals(this.label, address.label) &&
        Objects.equals(this.postalCode, address.postalCode) &&
        Objects.equals(this.prefecture, address.prefecture) &&
        Objects.equals(this.addressLine, address.addressLine);
  }

  @Override
  public int hashCode() {
    return Objects.hash(id, label, postalCode, prefecture, addressLine);
  }

  @Override
  public String toString() {
    StringBuilder sb = new StringBuilder();
    sb.append("class Address {\n");
    sb.append("    id: ").append(toIndentedString(id)).append("\n");
    sb.append("    label: ").append(toIndentedString(label)).append("\n");
    sb.append("    postalCode: ").append(toIndentedString(postalCode)).append("\n");
    sb.append("    prefecture: ").append(toIndentedString(prefecture)).append("\n");
    sb.append("    addressLine: ").append(toIndentedString(addressLine)).append("\n");
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
