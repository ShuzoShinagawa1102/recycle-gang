//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:recycle_gang_api/src/model/address.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Profile {
  /// Returns a new [Profile] instance.
  Profile({
    required this.displayName,

    required this.email,

    required this.phone,

    required this.addresses,
  });

  @JsonKey(name: r'displayName', required: true, includeIfNull: false)
  final String displayName;

  @JsonKey(name: r'email', required: true, includeIfNull: false)
  final String email;

  @JsonKey(name: r'phone', required: true, includeIfNull: false)
  final String phone;

  @JsonKey(name: r'addresses', required: true, includeIfNull: false)
  final List<Address> addresses;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Profile &&
          other.displayName == displayName &&
          other.email == email &&
          other.phone == phone &&
          other.addresses == addresses;

  @override
  int get hashCode =>
      displayName.hashCode +
      email.hashCode +
      phone.hashCode +
      addresses.hashCode;

  factory Profile.fromJson(Map<String, dynamic> json) =>
      _$ProfileFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
