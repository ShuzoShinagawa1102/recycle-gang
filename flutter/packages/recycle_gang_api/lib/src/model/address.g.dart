// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AddressCWProxy {
  Address id(String id);

  Address label(String label);

  Address postalCode(String postalCode);

  Address prefecture(String prefecture);

  Address addressLine(String addressLine);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Address(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Address(...).copyWith(id: 12, name: "My name")
  /// ````
  Address call({
    String id,
    String label,
    String postalCode,
    String prefecture,
    String addressLine,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAddress.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAddress.copyWith.fieldName(...)`
class _$AddressCWProxyImpl implements _$AddressCWProxy {
  const _$AddressCWProxyImpl(this._value);

  final Address _value;

  @override
  Address id(String id) => this(id: id);

  @override
  Address label(String label) => this(label: label);

  @override
  Address postalCode(String postalCode) => this(postalCode: postalCode);

  @override
  Address prefecture(String prefecture) => this(prefecture: prefecture);

  @override
  Address addressLine(String addressLine) => this(addressLine: addressLine);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Address(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Address(...).copyWith(id: 12, name: "My name")
  /// ````
  Address call({
    Object? id = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? postalCode = const $CopyWithPlaceholder(),
    Object? prefecture = const $CopyWithPlaceholder(),
    Object? addressLine = const $CopyWithPlaceholder(),
  }) {
    return Address(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      postalCode: postalCode == const $CopyWithPlaceholder()
          ? _value.postalCode
          // ignore: cast_nullable_to_non_nullable
          : postalCode as String,
      prefecture: prefecture == const $CopyWithPlaceholder()
          ? _value.prefecture
          // ignore: cast_nullable_to_non_nullable
          : prefecture as String,
      addressLine: addressLine == const $CopyWithPlaceholder()
          ? _value.addressLine
          // ignore: cast_nullable_to_non_nullable
          : addressLine as String,
    );
  }
}

extension $AddressCopyWith on Address {
  /// Returns a callable class that can be used as follows: `instanceOfAddress.copyWith(...)` or like so:`instanceOfAddress.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AddressCWProxy get copyWith => _$AddressCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Address _$AddressFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Address', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const [
          'id',
          'label',
          'postalCode',
          'prefecture',
          'addressLine',
        ],
      );
      final val = Address(
        id: $checkedConvert('id', (v) => v as String),
        label: $checkedConvert('label', (v) => v as String),
        postalCode: $checkedConvert('postalCode', (v) => v as String),
        prefecture: $checkedConvert('prefecture', (v) => v as String),
        addressLine: $checkedConvert('addressLine', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AddressToJson(Address instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'postalCode': instance.postalCode,
  'prefecture': instance.prefecture,
  'addressLine': instance.addressLine,
};
