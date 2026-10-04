//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'facility.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Facility {
  /// Returns a new [Facility] instance.
  Facility({
    required this.id,

    required this.name,

    required this.address,

    required this.latitude,

    required this.longitude,

    required this.instructions,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'name', required: true, includeIfNull: false)
  final String name;

  @JsonKey(name: r'address', required: true, includeIfNull: false)
  final String address;

  @JsonKey(name: r'latitude', required: true, includeIfNull: false)
  final double latitude;

  @JsonKey(name: r'longitude', required: true, includeIfNull: false)
  final double longitude;

  @JsonKey(name: r'instructions', required: true, includeIfNull: false)
  final String instructions;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Facility &&
          other.id == id &&
          other.name == name &&
          other.address == address &&
          other.latitude == latitude &&
          other.longitude == longitude &&
          other.instructions == instructions;

  @override
  int get hashCode =>
      id.hashCode +
      name.hashCode +
      address.hashCode +
      latitude.hashCode +
      longitude.hashCode +
      instructions.hashCode;

  factory Facility.fromJson(Map<String, dynamic> json) =>
      _$FacilityFromJson(json);

  Map<String, dynamic> toJson() => _$FacilityToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
