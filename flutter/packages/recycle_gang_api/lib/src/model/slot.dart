//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'slot.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Slot {
  /// Returns a new [Slot] instance.
  Slot({
    required this.id,

    required this.label,

    required this.startsAt,

    required this.endsAt,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'label', required: true, includeIfNull: false)
  final String label;

  @JsonKey(name: r'startsAt', required: true, includeIfNull: false)
  final DateTime startsAt;

  @JsonKey(name: r'endsAt', required: true, includeIfNull: false)
  final DateTime endsAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Slot &&
          other.id == id &&
          other.label == label &&
          other.startsAt == startsAt &&
          other.endsAt == endsAt;

  @override
  int get hashCode =>
      id.hashCode + label.hashCode + startsAt.hashCode + endsAt.hashCode;

  factory Slot.fromJson(Map<String, dynamic> json) => _$SlotFromJson(json);

  Map<String, dynamic> toJson() => _$SlotToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
