// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReservationInputCWProxy {
  ReservationInput clientRequestId(String clientRequestId);

  ReservationInput mode(ReservationInputModeEnum mode);

  ReservationInput facilityId(String? facilityId);

  ReservationInput addressId(String? addressId);

  ReservationInput slotId(String slotId);

  ReservationInput items(List<ItemInput> items);

  ReservationInput note(String? note);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReservationInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReservationInput(...).copyWith(id: 12, name: "My name")
  /// ````
  ReservationInput call({
    String clientRequestId,
    ReservationInputModeEnum mode,
    String? facilityId,
    String? addressId,
    String slotId,
    List<ItemInput> items,
    String? note,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReservationInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReservationInput.copyWith.fieldName(...)`
class _$ReservationInputCWProxyImpl implements _$ReservationInputCWProxy {
  const _$ReservationInputCWProxyImpl(this._value);

  final ReservationInput _value;

  @override
  ReservationInput clientRequestId(String clientRequestId) =>
      this(clientRequestId: clientRequestId);

  @override
  ReservationInput mode(ReservationInputModeEnum mode) => this(mode: mode);

  @override
  ReservationInput facilityId(String? facilityId) =>
      this(facilityId: facilityId);

  @override
  ReservationInput addressId(String? addressId) => this(addressId: addressId);

  @override
  ReservationInput slotId(String slotId) => this(slotId: slotId);

  @override
  ReservationInput items(List<ItemInput> items) => this(items: items);

  @override
  ReservationInput note(String? note) => this(note: note);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `ReservationInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// ReservationInput(...).copyWith(id: 12, name: "My name")
  /// ````
  ReservationInput call({
    Object? clientRequestId = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? facilityId = const $CopyWithPlaceholder(),
    Object? addressId = const $CopyWithPlaceholder(),
    Object? slotId = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
  }) {
    return ReservationInput(
      clientRequestId: clientRequestId == const $CopyWithPlaceholder()
          ? _value.clientRequestId
          // ignore: cast_nullable_to_non_nullable
          : clientRequestId as String,
      mode: mode == const $CopyWithPlaceholder()
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as ReservationInputModeEnum,
      facilityId: facilityId == const $CopyWithPlaceholder()
          ? _value.facilityId
          // ignore: cast_nullable_to_non_nullable
          : facilityId as String?,
      addressId: addressId == const $CopyWithPlaceholder()
          ? _value.addressId
          // ignore: cast_nullable_to_non_nullable
          : addressId as String?,
      slotId: slotId == const $CopyWithPlaceholder()
          ? _value.slotId
          // ignore: cast_nullable_to_non_nullable
          : slotId as String,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ItemInput>,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String?,
    );
  }
}

extension $ReservationInputCopyWith on ReservationInput {
  /// Returns a callable class that can be used as follows: `instanceOfReservationInput.copyWith(...)` or like so:`instanceOfReservationInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReservationInputCWProxy get copyWith => _$ReservationInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReservationInput _$ReservationInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('ReservationInput', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['clientRequestId', 'mode', 'slotId', 'items'],
      );
      final val = ReservationInput(
        clientRequestId: $checkedConvert('clientRequestId', (v) => v as String),
        mode: $checkedConvert(
          'mode',
          (v) => $enumDecode(_$ReservationInputModeEnumEnumMap, v),
        ),
        facilityId: $checkedConvert('facilityId', (v) => v as String?),
        addressId: $checkedConvert('addressId', (v) => v as String?),
        slotId: $checkedConvert('slotId', (v) => v as String),
        items: $checkedConvert(
          'items',
          (v) => (v as List<dynamic>)
              .map((e) => ItemInput.fromJson(e as Map<String, dynamic>))
              .toList(),
        ),
        note: $checkedConvert('note', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$ReservationInputToJson(ReservationInput instance) =>
    <String, dynamic>{
      'clientRequestId': instance.clientRequestId,
      'mode': _$ReservationInputModeEnumEnumMap[instance.mode]!,
      'facilityId': ?instance.facilityId,
      'addressId': ?instance.addressId,
      'slotId': instance.slotId,
      'items': instance.items.map((e) => e.toJson()).toList(),
      'note': ?instance.note,
    };

const _$ReservationInputModeEnumEnumMap = {
  ReservationInputModeEnum.PICKUP: 'PICKUP',
  ReservationInputModeEnum.DROPOFF: 'DROPOFF',
};
