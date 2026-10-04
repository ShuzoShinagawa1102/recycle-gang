// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'slot.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$SlotCWProxy {
  Slot id(String id);

  Slot label(String label);

  Slot startsAt(DateTime startsAt);

  Slot endsAt(DateTime endsAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Slot(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Slot(...).copyWith(id: 12, name: "My name")
  /// ````
  Slot call({String id, String label, DateTime startsAt, DateTime endsAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfSlot.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfSlot.copyWith.fieldName(...)`
class _$SlotCWProxyImpl implements _$SlotCWProxy {
  const _$SlotCWProxyImpl(this._value);

  final Slot _value;

  @override
  Slot id(String id) => this(id: id);

  @override
  Slot label(String label) => this(label: label);

  @override
  Slot startsAt(DateTime startsAt) => this(startsAt: startsAt);

  @override
  Slot endsAt(DateTime endsAt) => this(endsAt: endsAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Slot(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Slot(...).copyWith(id: 12, name: "My name")
  /// ````
  Slot call({
    Object? id = const $CopyWithPlaceholder(),
    Object? label = const $CopyWithPlaceholder(),
    Object? startsAt = const $CopyWithPlaceholder(),
    Object? endsAt = const $CopyWithPlaceholder(),
  }) {
    return Slot(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      label: label == const $CopyWithPlaceholder()
          ? _value.label
          // ignore: cast_nullable_to_non_nullable
          : label as String,
      startsAt: startsAt == const $CopyWithPlaceholder()
          ? _value.startsAt
          // ignore: cast_nullable_to_non_nullable
          : startsAt as DateTime,
      endsAt: endsAt == const $CopyWithPlaceholder()
          ? _value.endsAt
          // ignore: cast_nullable_to_non_nullable
          : endsAt as DateTime,
    );
  }
}

extension $SlotCopyWith on Slot {
  /// Returns a callable class that can be used as follows: `instanceOfSlot.copyWith(...)` or like so:`instanceOfSlot.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$SlotCWProxy get copyWith => _$SlotCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Slot _$SlotFromJson(Map<String, dynamic> json) => $checkedCreate('Slot', json, (
  $checkedConvert,
) {
  $checkKeys(json, requiredKeys: const ['id', 'label', 'startsAt', 'endsAt']);
  final val = Slot(
    id: $checkedConvert('id', (v) => v as String),
    label: $checkedConvert('label', (v) => v as String),
    startsAt: $checkedConvert('startsAt', (v) => DateTime.parse(v as String)),
    endsAt: $checkedConvert('endsAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$SlotToJson(Slot instance) => <String, dynamic>{
  'id': instance.id,
  'label': instance.label,
  'startsAt': instance.startsAt.toIso8601String(),
  'endsAt': instance.endsAt.toIso8601String(),
};
