//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_type.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ItemType {
  /// Returns a new [ItemType] instance.
  ItemType({
    required this.id,

    required this.name,

    required this.unit,

    required this.priceYen,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'unit', required: true, includeIfNull: false)
  final String unit;

  // minimum: 0
  @JsonKey(name: r'priceYen', required: true, includeIfNull: false)
  final int priceYen;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemType &&
          other.id == id &&
          other.name == name &&
          other.unit == unit &&
          other.priceYen == priceYen;

  @override
  int get hashCode =>
      id.hashCode + name.hashCode + unit.hashCode + priceYen.hashCode;

  factory ItemType.fromJson(Map<String, dynamic> json) =>
      _$ItemTypeFromJson(json);

  Map<String, dynamic> toJson() => _$ItemTypeToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
