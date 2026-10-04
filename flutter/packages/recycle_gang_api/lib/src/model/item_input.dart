//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'item_input.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ItemInput {
  /// Returns a new [ItemInput] instance.
  ItemInput({required this.itemTypeId, required this.quantity});

  @JsonKey(name: r'itemTypeId', required: true, includeIfNull: false)
  final String itemTypeId;

  // minimum: 1
  // maximum: 20
  @JsonKey(name: r'quantity', required: true, includeIfNull: false)
  final int quantity;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemInput &&
          other.itemTypeId == itemTypeId &&
          other.quantity == quantity;

  @override
  int get hashCode => itemTypeId.hashCode + quantity.hashCode;

  factory ItemInput.fromJson(Map<String, dynamic> json) =>
      _$ItemInputFromJson(json);

  Map<String, dynamic> toJson() => _$ItemInputToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
