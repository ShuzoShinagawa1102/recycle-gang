//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_item.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReservationItem {
  /// Returns a new [ReservationItem] instance.
  ReservationItem({
    required this.itemTypeId,

    required this.name,

    required this.quantity,

    required this.unitPriceYen,
  });

  @JsonKey(name: r'itemTypeId', required: true, includeIfNull: false)
  final String itemTypeId;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'quantity', required: true, includeIfNull: false)
  final int quantity;

  @JsonKey(name: r'unitPriceYen', required: true, includeIfNull: false)
  final int unitPriceYen;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReservationItem &&
          other.itemTypeId == itemTypeId &&
          other.name == name &&
          other.quantity == quantity &&
          other.unitPriceYen == unitPriceYen;

  @override
  int get hashCode =>
      itemTypeId.hashCode +
      name.hashCode +
      quantity.hashCode +
      unitPriceYen.hashCode;

  factory ReservationItem.fromJson(Map<String, dynamic> json) =>
      _$ReservationItemFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationItemToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
