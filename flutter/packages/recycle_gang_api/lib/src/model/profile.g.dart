// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ProfileCWProxy {
  Profile displayName(String displayName);

  Profile email(String email);

  Profile phone(String phone);

  Profile addresses(List<Address> addresses);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Profile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Profile(...).copyWith(id: 12, name: "My name")
  /// ````
  Profile call({
    String displayName,
    String email,
    String phone,
    List<Address> addresses,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfProfile.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfProfile.copyWith.fieldName(...)`
class _$ProfileCWProxyImpl implements _$ProfileCWProxy {
  const _$ProfileCWProxyImpl(this._value);

  final Profile _value;

  @override
  Profile displayName(String displayName) => this(displayName: displayName);

  @override
  Profile email(String email) => this(email: email);

  @override
  Profile phone(String phone) => this(phone: phone);

  @override
  Profile addresses(List<Address> addresses) => this(addresses: addresses);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Profile(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Profile(...).copyWith(id: 12, name: "My name")
  /// ````
  Profile call({
    Object? displayName = const $CopyWithPlaceholder(),
    Object? email = const $CopyWithPlaceholder(),
    Object? phone = const $CopyWithPlaceholder(),
    Object? addresses = const $CopyWithPlaceholder(),
  }) {
    return Profile(
      displayName: displayName == const $CopyWithPlaceholder()
          ? _value.displayName
          // ignore: cast_nullable_to_non_nullable
          : displayName as String,
      email: email == const $CopyWithPlaceholder()
          ? _value.email
          // ignore: cast_nullable_to_non_nullable
          : email as String,
      phone: phone == const $CopyWithPlaceholder()
          ? _value.phone
          // ignore: cast_nullable_to_non_nullable
          : phone as String,
      addresses: addresses == const $CopyWithPlaceholder()
          ? _value.addresses
          // ignore: cast_nullable_to_non_nullable
          : addresses as List<Address>,
    );
  }
}

extension $ProfileCopyWith on Profile {
  /// Returns a callable class that can be used as follows: `instanceOfProfile.copyWith(...)` or like so:`instanceOfProfile.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ProfileCWProxy get copyWith => _$ProfileCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Profile _$ProfileFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Profile', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['displayName', 'email', 'phone', 'addresses'],
      );
      final val = Profile(
        displayName: $checkedConvert('displayName', (v) => v as String),
        email: $checkedConvert('email', (v) => v as String),
        phone: $checkedConvert('phone', (v) => v as String),
        addresses: $checkedConvert(
          'addresses',
          (v) => (v as List<dynamic>)
              .map((e) => Address.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ProfileToJson(Profile instance) => <String, dynamic>{
  'displayName': instance.displayName,
  'email': instance.email,
  'phone': instance.phone,
  'addresses': instance.addresses.map((e) => e.toJson()).toList(),
};
