// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'facility.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$FacilityCWProxy {
  Facility id(String id);

  Facility name(String name);

  Facility address(String address);

  Facility latitude(double latitude);

  Facility longitude(double longitude);

  Facility instructions(String instructions);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Facility(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Facility(...).copyWith(id: 12, name: "My name")
  /// ````
  Facility call({
    String id,
    String name,
    String address,
    double latitude,
    double longitude,
    String instructions,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfFacility.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfFacility.copyWith.fieldName(...)`
class _$FacilityCWProxyImpl implements _$FacilityCWProxy {
  const _$FacilityCWProxyImpl(this._value);

  final Facility _value;

  @override
  Facility id(String id) => this(id: id);

  @override
  Facility name(String name) => this(name: name);

  @override
  Facility address(String address) => this(address: address);

  @override
  Facility latitude(double latitude) => this(latitude: latitude);

  @override
  Facility longitude(double longitude) => this(longitude: longitude);

  @override
  Facility instructions(String instructions) =>
      this(instructions: instructions);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Facility(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Facility(...).copyWith(id: 12, name: "My name")
  /// ````
  Facility call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? latitude = const $CopyWithPlaceholder(),
    Object? longitude = const $CopyWithPlaceholder(),
    Object? instructions = const $CopyWithPlaceholder(),
  }) {
    return Facility(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String,
      latitude: latitude == const $CopyWithPlaceholder()
          ? _value.latitude
          // ignore: cast_nullable_to_non_nullable
          : latitude as double,
      longitude: longitude == const $CopyWithPlaceholder()
          ? _value.longitude
          // ignore: cast_nullable_to_non_nullable
          : longitude as double,
      instructions: instructions == const $CopyWithPlaceholder()
          ? _value.instructions
          // ignore: cast_nullable_to_non_nullable
          : instructions as String,
    );
  }
}

extension $FacilityCopyWith on Facility {
  /// Returns a callable class that can be used as follows: `instanceOfFacility.copyWith(...)` or like so:`instanceOfFacility.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$FacilityCWProxy get copyWith => _$FacilityCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Facility _$FacilityFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Facility', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'name',
          'address',
          'latitude',
          'longitude',
          'instructions',
        ],
      );
      final val = Facility(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        address: $checkedConvert('address', (v) => v as String),
        latitude: $checkedConvert('latitude', (v) => (v as num).toDouble()),
        longitude: $checkedConvert('longitude', (v) => (v as num).toDouble()),
        instructions: $checkedConvert('instructions', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$FacilityToJson(Facility instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'address': instance.address,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
  'instructions': instance.instructions,
};
