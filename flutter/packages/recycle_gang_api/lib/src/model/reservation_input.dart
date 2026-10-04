//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:recycle_gang_api/src/model/item_input.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation_input.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class ReservationInput {
  /// Returns a new [ReservationInput] instance.
  ReservationInput({
    required this.clientRequestId,

    required this.mode,

    this.facilityId,

    this.addressId,

    required this.slotId,

    required this.items,

    this.note,
  });

  @JsonKey(name: r'clientRequestId', required: true, includeIfNull: false)
  final String clientRequestId;

  @JsonKey(name: r'mode', required: true, includeIfNull: false)
  final ReservationInputModeEnum mode;

  @JsonKey(name: r'facilityId', required: false, includeIfNull: false)
  final String? facilityId;

  @JsonKey(name: r'addressId', required: false, includeIfNull: false)
  final String? addressId;

  @JsonKey(name: r'slotId', required: true, includeIfNull: false)
  final String slotId;

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<ItemInput> items;

  @JsonKey(name: r'note', required: false, includeIfNull: false)
  final String? note;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReservationInput &&
          other.clientRequestId == clientRequestId &&
          other.mode == mode &&
          other.facilityId == facilityId &&
          other.addressId == addressId &&
          other.slotId == slotId &&
          other.items == items &&
          other.note == note;

  @override
  int get hashCode =>
      clientRequestId.hashCode +
      mode.hashCode +
      facilityId.hashCode +
      addressId.hashCode +
      slotId.hashCode +
      items.hashCode +
      note.hashCode;

  factory ReservationInput.fromJson(Map<String, dynamic> json) =>
      _$ReservationInputFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationInputToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}

enum ReservationInputModeEnum {
  @JsonValue(r'PICKUP')
  PICKUP(r'PICKUP'),
  @JsonValue(r'DROPOFF')
  DROPOFF(r'DROPOFF');

  const ReservationInputModeEnum(this.value);

  final String value;

  @override
  String toString() => value;
}
