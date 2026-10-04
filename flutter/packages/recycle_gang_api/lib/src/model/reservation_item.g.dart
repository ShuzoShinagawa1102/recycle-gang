// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_item.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReservationItemCWProxy {
  ReservationItem itemTypeId(String itemTypeId);

  ReservationItem name(String name);

  ReservationItem quantity(int quantity);

  ReservationItem unitPriceYen(int unitPriceYen);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReservationItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReservationItem(...).copyWith(id: 12, name: "My name")
  /// ````
  ReservationItem call({
    String itemTypeId,
    String name,
    int quantity,
    int unitPriceYen,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReservationItem.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReservationItem.copyWith.fieldName(...)`
class _$ReservationItemCWProxyImpl implements _$ReservationItemCWProxy {
  const _$ReservationItemCWProxyImpl(this._value);

  final ReservationItem _value;

  @override
  ReservationItem itemTypeId(String itemTypeId) => this(itemTypeId: itemTypeId);

  @override
  ReservationItem name(String name) => this(name: name);

  @override
  ReservationItem quantity(int quantity) => this(quantity: quantity);

  @override
  ReservationItem unitPriceYen(int unitPriceYen) =>
      this(unitPriceYen: unitPriceYen);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReservationItem(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReservationItem(...).copyWith(id: 12, name: "My name")
  /// ````
  ReservationItem call({
    Object? itemTypeId = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
    Object? unitPriceYen = const $CopyWithPlaceholder(),
  }) {
    return ReservationItem(
      itemTypeId: itemTypeId == const $CopyWithPlaceholder()
          ? _value.itemTypeId
          // ignore: cast_nullable_to_non_nullable
          : itemTypeId as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as int,
      unitPriceYen: unitPriceYen == const $CopyWithPlaceholder()
          ? _value.unitPriceYen
          // ignore: cast_nullable_to_non_nullable
          : unitPriceYen as int,
    );
  }
}

extension $ReservationItemCopyWith on ReservationItem {
  /// Returns a callable class that can be used as follows: `instanceOfReservationItem.copyWith(...)` or like so:`instanceOfReservationItem.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReservationItemCWProxy get copyWith => _$ReservationItemCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationItem _$ReservationItemFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReservationItem', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['itemTypeId', 'name', 'quantity', 'unitPriceYen'],
      );
      final val = ReservationItem(
        itemTypeId: $checkedConvert('itemTypeId', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        quantity: $checkedConvert('quantity', (v) => (v as num).toInt()),
        unitPriceYen: $checkedConvert(
          'unitPriceYen',
          (v) => (v as num).toInt(),
        ),
      );
      return val;
    });

Map<String, dynamic> _$ReservationItemToJson(ReservationItem instance) =>
    <String, dynamic>{
      'itemTypeId': instance.itemTypeId,
      'name': instance.name,
      'quantity': instance.quantity,
      'unitPriceYen': instance.unitPriceYen,
    };
