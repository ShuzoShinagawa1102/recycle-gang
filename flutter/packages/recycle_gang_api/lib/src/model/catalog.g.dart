// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'catalog.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$CatalogCWProxy {
  Catalog facilities(List<Facility> facilities);

  Catalog itemTypes(List<ItemType> itemTypes);

  Catalog slots(List<Slot> slots);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Catalog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Catalog(...).copyWith(id: 12, name: "My name")
  /// ````
  Catalog call({
    List<Facility> facilities,
    List<ItemType> itemTypes,
    List<Slot> slots,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfCatalog.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfCatalog.copyWith.fieldName(...)`
class _$CatalogCWProxyImpl implements _$CatalogCWProxy {
  const _$CatalogCWProxyImpl(this._value);

  final Catalog _value;

  @override
  Catalog facilities(List<Facility> facilities) => this(facilities: facilities);

  @override
  Catalog itemTypes(List<ItemType> itemTypes) => this(itemTypes: itemTypes);

  @override
  Catalog slots(List<Slot> slots) => this(slots: slots);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Catalog(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Catalog(...).copyWith(id: 12, name: "My name")
  /// ````
  Catalog call({
    Object? facilities = const $CopyWithPlaceholder(),
    Object? itemTypes = const $CopyWithPlaceholder(),
    Object? slots = const $CopyWithPlaceholder(),
  }) {
    return Catalog(
      facilities: facilities == const $CopyWithPlaceholder()
          ? _value.facilities
          // ignore: cast_nullable_to_non_nullable
          : facilities as List<Facility>,
      itemTypes: itemTypes == const $CopyWithPlaceholder()
          ? _value.itemTypes
          // ignore: cast_nullable_to_non_nullable
          : itemTypes as List<ItemType>,
      slots: slots == const $CopyWithPlaceholder()
          ? _value.slots
          // ignore: cast_nullable_to_non_nullable
          : slots as List<Slot>,
    );
  }
}

extension $CatalogCopyWith on Catalog {
  /// Returns a callable class that can be used as follows: `instanceOfCatalog.copyWith(...)` or like so:`instanceOfCatalog.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$CatalogCWProxy get copyWith => _$CatalogCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Catalog _$CatalogFromJson(Map<String, dynamic> json) => $checkedCreate(
  'Catalog',
  json,
  ($checkedConvert) {
    $checkKeys(json, requiredKeys: const ['facilities', 'itemTypes', 'slots']);
    final val = Catalog(
      facilities: $checkedConvert(
        'facilities',
        (v) => (v as List<dynamic>)
            .map((e) => Facility.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      itemTypes: $checkedConvert(
        'itemTypes',
        (v) => (v as List<dynamic>)
            .map((e) => ItemType.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      slots: $checkedConvert(
        'slots',
        (v) => (v as List<dynamic>)
            .map((e) => Slot.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
    );
    return val;
  },
);

Map<String, dynamic> _$CatalogToJson(Catalog instance) => <String, dynamic>{
  'facilities': instance.facilities.map((e) => e.toJson()).toList(),
  'itemTypes': instance.itemTypes.map((e) => e.toJson()).toList(),
  'slots': instance.slots.map((e) => e.toJson()).toList(),
};
