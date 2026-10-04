import 'package:recycle_gang_api/src/model/address.dart';
import 'package:recycle_gang_api/src/model/admission.dart';
import 'package:recycle_gang_api/src/model/admission_input.dart';
import 'package:recycle_gang_api/src/model/catalog.dart';
import 'package:recycle_gang_api/src/model/error.dart';
import 'package:recycle_gang_api/src/model/facility.dart';
import 'package:recycle_gang_api/src/model/item_input.dart';
import 'package:recycle_gang_api/src/model/item_type.dart';
import 'package:recycle_gang_api/src/model/photo.dart';
import 'package:recycle_gang_api/src/model/profile.dart';
import 'package:recycle_gang_api/src/model/reservation.dart';
import 'package:recycle_gang_api/src/model/reservation_input.dart';
import 'package:recycle_gang_api/src/model/reservation_item.dart';
import 'package:recycle_gang_api/src/model/slot.dart';
import 'package:recycle_gang_api/src/model/ticket.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

ReturnType deserialize<ReturnType, BaseType>(
  dynamic value,
  String targetType, {
  bool growable = true,
}) {
  switch (targetType) {
    case 'String':
      return '$value' as ReturnType;
    case 'int':
      return (value is int ? value : int.parse('$value')) as ReturnType;
    case 'bool':
      if (value is bool) {
        return value as ReturnType;
      }
      final valueString = '$value'.toLowerCase();
      return (valueString == 'true' || valueString == '1') as ReturnType;
    case 'double':
      return (value is double ? value : double.parse('$value')) as ReturnType;
    case 'Address':
      return Address.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Admission':
      return Admission.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'AdmissionInput':
      return AdmissionInput.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'Catalog':
      return Catalog.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Error':
      return Error.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Facility':
      return Facility.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ItemInput':
      return ItemInput.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ItemType':
      return ItemType.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Photo':
      return Photo.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Profile':
      return Profile.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Reservation':
      return Reservation.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ReservationInput':
      return ReservationInput.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'ReservationItem':
      return ReservationItem.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'Slot':
      return Slot.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Ticket':
      return Ticket.fromJson(value as Map<String, dynamic>) as ReturnType;
    default:
      RegExpMatch? match;

      if (value is List && (match = _regList.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
                .map<BaseType>(
                  (dynamic v) => deserialize<BaseType, BaseType>(
                    v,
                    targetType,
                    growable: growable,
                  ),
                )
                .toList(growable: growable)
            as ReturnType;
      }
      if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
                .map<BaseType>(
                  (dynamic v) => deserialize<BaseType, BaseType>(
                    v,
                    targetType,
                    growable: growable,
                  ),
                )
                .toSet()
            as ReturnType;
      }
      if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
        targetType = match![1]!.trim(); // ignore: parameter_assignments
        return Map<String, BaseType>.fromIterables(
          value.keys as Iterable<String>,
          value.values.map(
            (dynamic v) => deserialize<BaseType, BaseType>(
              v,
              targetType,
              growable: growable,
            ),
          ),
        ) as ReturnType;
      }
      break;
  }
  throw Exception('Cannot deserialize');
}
