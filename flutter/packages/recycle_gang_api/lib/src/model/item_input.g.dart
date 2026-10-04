// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ItemInputCWProxy {
  ItemInput itemTypeId(String itemTypeId);

  ItemInput quantity(int quantity);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemInput(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemInput call({String itemTypeId, int quantity});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfItemInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfItemInput.copyWith.fieldName(...)`
class _$ItemInputCWProxyImpl implements _$ItemInputCWProxy {
  const _$ItemInputCWProxyImpl(this._value);

  final ItemInput _value;

  @override
  ItemInput itemTypeId(String itemTypeId) => this(itemTypeId: itemTypeId);

  @override
  ItemInput quantity(int quantity) => this(quantity: quantity);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ItemInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ItemInput(...).copyWith(id: 12, name: "My name")
  /// ````
  ItemInput call({
    Object? itemTypeId = const $CopyWithPlaceholder(),
    Object? quantity = const $CopyWithPlaceholder(),
  }) {
    return ItemInput(
      itemTypeId: itemTypeId == const $CopyWithPlaceholder()
          ? _value.itemTypeId
          // ignore: cast_nullable_to_non_nullable
          : itemTypeId as String,
      quantity: quantity == const $CopyWithPlaceholder()
          ? _value.quantity
          // ignore: cast_nullable_to_non_nullable
          : quantity as int,
    );
  }
}

extension $ItemInputCopyWith on ItemInput {
  /// Returns a callable class that can be used as follows: `instanceOfItemInput.copyWith(...)` or like so:`instanceOfItemInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ItemInputCWProxy get copyWith => _$ItemInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ItemInput _$ItemInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ItemInput', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['itemTypeId', 'quantity']);
      final val = ItemInput(
        itemTypeId: $checkedConvert('itemTypeId', (v) => v as String),
        quantity: $checkedConvert('quantity', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$ItemInputToJson(ItemInput instance) => <String, dynamic>{
  'itemTypeId': instance.itemTypeId,
  'quantity': instance.quantity,
};
