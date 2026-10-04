// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$TicketCWProxy {
  Ticket token(String token);

  Ticket expiresAt(DateTime expiresAt);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ticket(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ticket(...).copyWith(id: 12, name: "My name")
  /// ````
  Ticket call({String token, DateTime expiresAt});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfTicket.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfTicket.copyWith.fieldName(...)`
class _$TicketCWProxyImpl implements _$TicketCWProxy {
  const _$TicketCWProxyImpl(this._value);

  final Ticket _value;

  @override
  Ticket token(String token) => this(token: token);

  @override
  Ticket expiresAt(DateTime expiresAt) => this(expiresAt: expiresAt);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Ticket(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Ticket(...).copyWith(id: 12, name: "My name")
  /// ````
  Ticket call({
    Object? token = const $CopyWithPlaceholder(),
    Object? expiresAt = const $CopyWithPlaceholder(),
  }) {
    return Ticket(
      token: token == const $CopyWithPlaceholder()
          ? _value.token
          // ignore: cast_nullable_to_non_nullable
          : token as String,
      expiresAt: expiresAt == const $CopyWithPlaceholder()
          ? _value.expiresAt
          // ignore: cast_nullable_to_non_nullable
          : expiresAt as DateTime,
    );
  }
}

extension $TicketCopyWith on Ticket {
  /// Returns a callable class that can be used as follows: `instanceOfTicket.copyWith(...)` or like so:`instanceOfTicket.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$TicketCWProxy get copyWith => _$TicketCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Ticket', json, ($checkedConvert) {
      $checkKeys(json, requiredKeys: const ['token', 'expiresAt']);
      final val = Ticket(
        token: $checkedConvert('token', (v) => v as String),
        expiresAt: $checkedConvert(
          'expiresAt',
          (v) => DateTime.parse(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'token': instance.token,
  'expiresAt': instance.expiresAt.toIso8601String(),
};
