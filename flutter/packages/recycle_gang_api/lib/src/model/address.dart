//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Address {
  /// Returns a new [Address] instance.
  Address({
    required this.id,

    required this.label,

    required this.postalCode,

    required this.prefecture,

    required this.addressLine,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'label', required: true, includeIfNull: false)
  final String label;

  @JsonKey(name: r'postalCode', required: true, includeIfNull: false)
  final String postalCode;

  @JsonKey(name: r'prefecture', required: true, includeIfNull: false)
  final String prefecture;

  @JsonKey(name: r'addressLine', required: true, includeIfNull: false)
  final String addressLine;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Address &&
          other.id == id &&
          other.label == label &&
          other.postalCode == postalCode &&
          other.prefecture == prefecture &&
          other.addressLine == addressLine;

  @override
  int get hashCode =>
      id.hashCode +
      label.hashCode +
      postalCode.hashCode +
      prefecture.hashCode +
      addressLine.hashCode;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);

  Map<String, dynamic> toJson() => _$AddressToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
