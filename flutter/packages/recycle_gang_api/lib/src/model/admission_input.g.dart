// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'admission_input.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$AdmissionInputCWProxy {
  AdmissionInput token(String token);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdmissionInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdmissionInput(...).copyWith(id: 12, name: "My name")
  /// ````
  AdmissionInput call({String token});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfAdmissionInput.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfAdmissionInput.copyWith.fieldName(...)`
class _$AdmissionInputCWProxyImpl implements _$AdmissionInputCWProxy {
  const _$AdmissionInputCWProxyImpl(this._value);

  final AdmissionInput _value;

  @override
  AdmissionInput token(String token) => this(token: token);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `AdmissionInput(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// AdmissionInput(...).copyWith(id: 12, name: "My name")
  /// ````
  AdmissionInput call({Object? token = const $CopyWithPlaceholder()}) {
    return AdmissionInput(
      token: token == const $CopyWithPlaceholder()
          ? _value.token
          // ignore: cast_nullable_to_non_nullable
          : token as String,
    );
  }
}

extension $AdmissionInputCopyWith on AdmissionInput {
  /// Returns a callable class that can be used as follows: `instanceOfAdmissionInput.copyWith(...)` or like so:`instanceOfAdmissionInput.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$AdmissionInputCWProxy get copyWith => _$AdmissionInputCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AdmissionInput _$AdmissionInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('AdmissionInput', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['token']);
      final val = AdmissionInput(
        token: $checkedConvert('token', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AdmissionInputToJson(AdmissionInput instance) =>
    <String, dynamic>{'token': instance.token};
