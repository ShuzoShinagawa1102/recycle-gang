// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reservation.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$ReservationCWProxy {
  Reservation id(String id);

  Reservation mode(String mode);

  Reservation status(String status);

  Reservation locationName(String locationName);

  Reservation address(String address);

  Reservation slotStart(DateTime slotStart);

  Reservation slotEnd(DateTime slotEnd);

  Reservation items(List<ReservationItem> items);

  Reservation amountYen(int amountYen);

  Reservation paymentStatus(String paymentStatus);

  Reservation note(String note);

  Reservation photos(List<Photo> photos);

  Reservation createdAt(DateTime createdAt);

  Reservation admittedAt(DateTime? admittedAt);

  Reservation completedAt(DateTime? completedAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Reservation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Reservation(...).copyWith(id: 12, name: "My name")
  /// ````
  Reservation call({
    String id,
    String mode,
    String status,
    String locationName,
    String address,
    DateTime slotStart,
    DateTime slotEnd,
    List<ReservationItem> items,
    int amountYen,
    String paymentStatus,
    String note,
    List<Photo> photos,
    DateTime createdAt,
    DateTime? admittedAt,
    DateTime? completedAt,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfReservation.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfReservation.copyWith.fieldName(...)`
class _$ReservationCWProxyImpl implements _$ReservationCWProxy {
  const _$ReservationCWProxyImpl(this._value);

  final Reservation _value;

  @override
  Reservation id(String id) => this(id: id);

  @override
  Reservation mode(String mode) => this(mode: mode);

  @override
  Reservation status(String status) => this(status: status);

  @override
  Reservation locationName(String locationName) =>
      this(locationName: locationName);

  @override
  Reservation address(String address) => this(address: address);

  @override
  Reservation slotStart(DateTime slotStart) => this(slotStart: slotStart);

  @override
  Reservation slotEnd(DateTime slotEnd) => this(slotEnd: slotEnd);

  @override
  Reservation items(List<ReservationItem> items) => this(items: items);

  @override
  Reservation amountYen(int amountYen) => this(amountYen: amountYen);

  @override
  Reservation paymentStatus(String paymentStatus) =>
      this(paymentStatus: paymentStatus);

  @override
  Reservation note(String note) => this(note: note);

  @override
  Reservation photos(List<Photo> photos) => this(photos: photos);

  @override
  Reservation createdAt(DateTime createdAt) => this(createdAt: createdAt);

  @override
  Reservation admittedAt(DateTime? admittedAt) => this(admittedAt: admittedAt);

  @override
  Reservation completedAt(DateTime? completedAt) =>
      this(completedAt: completedAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Reservation(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Reservation(...).copyWith(id: 12, name: "My name")
  /// ````
  Reservation call({
    Object? id = const $CopyWithPlaceholder(),
    Object? mode = const $CopyWithPlaceholder(),
    Object? status = const $CopyWithPlaceholder(),
    Object? locationName = const $CopyWithPlaceholder(),
    Object? address = const $CopyWithPlaceholder(),
    Object? slotStart = const $CopyWithPlaceholder(),
    Object? slotEnd = const $CopyWithPlaceholder(),
    Object? items = const $CopyWithPlaceholder(),
    Object? amountYen = const $CopyWithPlaceholder(),
    Object? paymentStatus = const $CopyWithPlaceholder(),
    Object? note = const $CopyWithPlaceholder(),
    Object? photos = const $CopyWithPlaceholder(),
    Object? createdAt = const $CopyWithPlaceholder(),
    Object? admittedAt = const $CopyWithPlaceholder(),
    Object? completedAt = const $CopyWithPlaceholder(),
  }) {
    return Reservation(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      mode: mode == const $CopyWithPlaceholder()
          ? _value.mode
          // ignore: cast_nullable_to_non_nullable
          : mode as String,
      status: status == const $CopyWithPlaceholder()
          ? _value.status
          // ignore: cast_nullable_to_non_nullable
          : status as String,
      locationName: locationName == const $CopyWithPlaceholder()
          ? _value.locationName
          // ignore: cast_nullable_to_non_nullable
          : locationName as String,
      address: address == const $CopyWithPlaceholder()
          ? _value.address
          // ignore: cast_nullable_to_non_nullable
          : address as String,
      slotStart: slotStart == const $CopyWithPlaceholder()
          ? _value.slotStart
          // ignore: cast_nullable_to_non_nullable
          : slotStart as DateTime,
      slotEnd: slotEnd == const $CopyWithPlaceholder()
          ? _value.slotEnd
          // ignore: cast_nullable_to_non_nullable
          : slotEnd as DateTime,
      items: items == const $CopyWithPlaceholder()
          ? _value.items
          // ignore: cast_nullable_to_non_nullable
          : items as List<ReservationItem>,
      amountYen: amountYen == const $CopyWithPlaceholder()
          ? _value.amountYen
          // ignore: cast_nullable_to_non_nullable
          : amountYen as int,
      paymentStatus: paymentStatus == const $CopyWithPlaceholder()
          ? _value.paymentStatus
          // ignore: cast_nullable_to_non_nullable
          : paymentStatus as String,
      note: note == const $CopyWithPlaceholder()
          ? _value.note
          // ignore: cast_nullable_to_non_nullable
          : note as String,
      photos: photos == const $CopyWithPlaceholder()
          ? _value.photos
          // ignore: cast_nullable_to_non_nullable
          : photos as List<Photo>,
      createdAt: createdAt == const $CopyWithPlaceholder()
          ? _value.createdAt
          // ignore: cast_nullable_to_non_nullable
          : createdAt as DateTime,
      admittedAt: admittedAt == const $CopyWithPlaceholder()
          ? _value.admittedAt
          // ignore: cast_nullable_to_non_nullable
          : admittedAt as DateTime?,
      completedAt: completedAt == const $CopyWithPlaceholder()
          ? _value.completedAt
          // ignore: cast_nullable_to_non_nullable
          : completedAt as DateTime?,
    );
  }
}

extension $ReservationCopyWith on Reservation {
  /// Returns a callable class that can be used as follows: `instanceOfReservation.copyWith(...)` or like so:`instanceOfReservation.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$ReservationCWProxy get copyWith => _$ReservationCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Reservation _$ReservationFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('Reservation', json, ($checkedConvert) {
  $checkKeys(
    json,
    requiredKeys: const [
      'id',
      'mode',
      'status',
      'locationName',
      'address',
      'slotStart',
      'slotEnd',
      'items',
      'amountYen',
      'paymentStatus',
      'note',
      'photos',
      'createdAt',
    ],
  );
  final val = Reservation(
    id: $checkedConvert('id', (v) => v as String),
    mode: $checkedConvert('mode', (v) => v as String),
    status: $checkedConvert('status', (v) => v as String),
    locationName: $checkedConvert('locationName', (v) => v as String),
    address: $checkedConvert('address', (v) => v as String),
    slotStart: $checkedConvert('slotStart', (v) => DateTime.parse(v as String)),
    slotEnd: $checkedConvert('slotEnd', (v) => DateTime.parse(v as String)),
    items: $checkedConvert(
      'items',
      (v) => (v as List<dynamic>)
          .map((e) => ReservationItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    amountYen: $checkedConvert('amountYen', (v) => (v as num).toInt()),
    paymentStatus: $checkedConvert('paymentStatus', (v) => v as String),
    note: $checkedConvert('note', (v) => v as String),
    photos: $checkedConvert(
      'photos',
      (v) => (v as List<dynamic>)
          .map((e) => Photo.fromJson(e as Map<String, dynamic>))
          .toList(),
    ),
    createdAt: $checkedConvert('createdAt', (v) => DateTime.parse(v as String)),
    admittedAt: $checkedConvert(
      'admittedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    completedAt: $checkedConvert(
      'completedAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
  );
  return val;
});

Map<String, dynamic> _$ReservationToJson(Reservation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'mode': instance.mode,
      'status': instance.status,
      'locationName': instance.locationName,
      'address': instance.address,
      'slotStart': instance.slotStart.toIso8601String(),
      'slotEnd': instance.slotEnd.toIso8601String(),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'amountYen': instance.amountYen,
      'paymentStatus': instance.paymentStatus,
      'note': instance.note,
      'photos': instance.photos.map((e) => e.toJson()).toList(),
      'createdAt': instance.createdAt.toIso8601String(),
      'admittedAt': ?instance.admittedAt?.toIso8601String(),
      'completedAt': ?instance.completedAt?.toIso8601String(),
    };
