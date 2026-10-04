//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:recycle_gang_api/src/model/facility.dart';
import 'package:recycle_gang_api/src/model/item_type.dart';
import 'package:recycle_gang_api/src/model/slot.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'catalog.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Catalog {
  /// Returns a new [Catalog] instance.
  Catalog({
    required this.facilities,

    required this.itemTypes,

    required this.slots,
  });

  @JsonKey(name: r'facilities', required: true, includeIfNull: false)
  final List<Facility> facilities;

  @JsonKey(name: r'itemTypes', required: true, includeIfNull: false)
  final List<ItemType> itemTypes;

  @JsonKey(name: r'slots', required: true, includeIfNull: false)
  final List<Slot> slots;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Catalog &&
          other.facilities == facilities &&
          other.itemTypes == itemTypes &&
          other.slots == slots;

  @override
  int get hashCode => facilities.hashCode + itemTypes.hashCode + slots.hashCode;

  factory Catalog.fromJson(Map<String, dynamic> json) =>
      _$CatalogFromJson(json);

  Map<String, dynamic> toJson() => _$CatalogToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
