// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_type.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ItemTypeCWProxy {
  ItemType id(String id);

  ItemType name(String name);

  ItemType unit(String unit);

  ItemType priceYen(int priceYen);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemType(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemType call({String id, String name, String unit, int priceYen});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfItemType.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfItemType.copyWith.fieldName(...)`
class _$ItemTypeCWProxyImpl implements _$ItemTypeCWProxy {
  const _$ItemTypeCWProxyImpl(this._value);

  final ItemType _value;

  @override
  ItemType id(String id) => this(id: id);

  @override
  ItemType name(String name) => this(name: name);

  @override
  ItemType unit(String unit) => this(unit: unit);

  @override
  ItemType priceYen(int priceYen) => this(priceYen: priceYen);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemType(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemType(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemType call({
    Object? id = const $CopyWithPlaceholder(),
    Object? name = const $CopyWithPlaceholder(),
    Object? unit = const $CopyWithPlaceholder(),
    Object? priceYen = const $CopyWithPlaceholder(),
  }) {
    return ItemType(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      name: name == const $CopyWithPlaceholder()
          ? _value.name
          // ignore: cast_nullable_to_non_nullable
          : name as String,
      unit: unit == const $CopyWithPlaceholder()
          ? _value.unit
          // ignore: cast_nullable_to_non_nullable
          : unit as String,
      priceYen: priceYen == const $CopyWithPlaceholder()
          ? _value.priceYen
          // ignore: cast_nullable_to_non_nullable
          : priceYen as int,
    );
  }
}

extension $ItemTypeCopyWith on ItemType {
  /// Returns a callable class that can be used as follows: `instanceOfItemType.copyWith(...)` or like so:`instanceOfItemType.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ItemTypeCWProxy get copyWith => _$ItemTypeCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemType _$ItemTypeFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ItemType', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['id', 'name', 'unit', 'priceYen']);
      final val = ItemType(
        id: $checkedConvert('id', (v) => v as String),
        name: $checkedConvert('name', (v) => v as String),
        unit: $checkedConvert('unit', (v) => v as String),
        priceYen: $checkedConvert('priceYen', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$ItemTypeToJson(ItemType instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'unit': instance.unit,
  'priceYen': instance.priceYen,
};
