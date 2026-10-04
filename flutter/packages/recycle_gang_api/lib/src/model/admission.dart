//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admission.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Admission {
  /// Returns a new [Admission] instance.
  Admission({
    required this.reservationId,

    required this.admittedAt,

    required this.alreadyAdmitted,
  });

  @JsonKey(name: r'reservationId', required: true, includeIfNull: false)
  final String reservationId;

  @JsonKey(name: r'admittedAt', required: true, includeIfNull: false)
  final DateTime admittedAt;

  @JsonKey(name: r'alreadyAdmitted', required: true, includeIfNull: false)
  final bool alreadyAdmitted;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Admission &&
          other.reservationId == reservationId &&
          other.admittedAt == admittedAt &&
          other.alreadyAdmitted == alreadyAdmitted;

  @override
  int get hashCode =>
      reservationId.hashCode + admittedAt.hashCode + alreadyAdmitted.hashCode;

  factory Admission.fromJson(Map<String, dynamic> json) =>
      _$AdmissionFromJson(json);

  Map<String, dynamic> toJson() => _$AdmissionToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
