// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admission.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdmissionCWProxy {
  Admission reservationId(String reservationId);

  Admission admittedAt(DateTime admittedAt);

  Admission alreadyAdmitted(bool alreadyAdmitted);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Admission(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Admission(...).copyWith(id: 12, name: "My name")
  /// ````
  Admission call({
    String reservationId,
    DateTime admittedAt,
    bool alreadyAdmitted,
  });
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdmission.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdmission.copyWith.fieldName(...)`
class _$AdmissionCWProxyImpl implements _$AdmissionCWProxy {
  const _$AdmissionCWProxyImpl(this._value);

  final Admission _value;

  @override
  Admission reservationId(String reservationId) =>
      this(reservationId: reservationId);

  @override
  Admission admittedAt(DateTime admittedAt) => this(admittedAt: admittedAt);

  @override
  Admission alreadyAdmitted(bool alreadyAdmitted) =>
      this(alreadyAdmitted: alreadyAdmitted);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Admission(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Admission(...).copyWith(id: 12, name: "My name")
  /// ````
  Admission call({
    Object? reservationId = const $CopyWithPlaceholder(),
    Object? admittedAt = const $CopyWithPlaceholder(),
    Object? alreadyAdmitted = const $CopyWithPlaceholder(),
  }) {
    return Admission(
      reservationId: reservationId == const $CopyWithPlaceholder()
          ? _value.reservationId
          // ignore: cast_nullable_to_non_nullable
          : reservationId as String,
      admittedAt: admittedAt == const $CopyWithPlaceholder()
          ? _value.admittedAt
          // ignore: cast_nullable_to_non_nullable
          : admittedAt as DateTime,
      alreadyAdmitted: alreadyAdmitted == const $CopyWithPlaceholder()
          ? _value.alreadyAdmitted
          // ignore: cast_nullable_to_non_nullable
          : alreadyAdmitted as bool,
    );
  }
}

extension $AdmissionCopyWith on Admission {
  /// Returns a callable class that can be used as follows: `instanceOfAdmission.copyWith(...)` or like so:`instanceOfAdmission.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdmissionCWProxy get copyWith => _$AdmissionCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Admission _$AdmissionFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Admission', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['reservationId', 'admittedAt', 'alreadyAdmitted'],
      );
      final val = Admission(
        reservationId: $checkedConvert('reservationId', (v) => v as String),
        admittedAt: $checkedConvert(
          'admittedAt',
          (v) => DateTime.parse(v as String),
        ),
        alreadyAdmitted: $checkedConvert('alreadyAdmitted', (v) => v as bool),
      );
      return val;
    });

Map<String, dynamic> _$AdmissionToJson(Admission instance) => <String, dynamic>{
  'reservationId': instance.reservationId,
  'admittedAt': instance.admittedAt.toIso8601String(),
  'alreadyAdmitted': instance.alreadyAdmitted,
};
