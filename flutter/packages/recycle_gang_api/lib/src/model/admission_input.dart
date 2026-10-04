//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'admission_input.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class AdmissionInput {
  /// Returns a new [AdmissionInput] instance.
  AdmissionInput({required this.token});

  @JsonKey(name: r'token', required: true, includeIfNull: false)
  final String token;

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is AdmissionInput && other.token == token;

  @override
  int get hashCode => token.hashCode;

  factory AdmissionInput.fromJson(Map<String, dynamic> json) =>
      _$AdmissionInputFromJson(json);

  Map<String, dynamic> toJson() => _$AdmissionInputToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
