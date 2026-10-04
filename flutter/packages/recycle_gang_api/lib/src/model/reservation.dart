//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:recycle_gang_api/src/model/photo.dart';
import 'package:recycle_gang_api/src/model/reservation_item.dart';
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'reservation.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Reservation {
  /// Returns a new [Reservation] instance.
  Reservation({
    required this.id,

    required this.mode,

    required this.status,

    required this.locationName,

    required this.address,

    required this.slotStart,

    required this.slotEnd,

    required this.items,

    required this.amountYen,

    required this.paymentStatus,

    required this.note,

    required this.photos,

    required this.createdAt,

    this.admittedAt,

    this.completedAt,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'mode', required: true, includeIfNull: false)
  final String mode;

  @JsonKey(name: r'status', required: true, includeIfNull: false)
  final String status;

  @JsonKey(name: r'locationName', required: true, includeIfNull: false)
  final String locationName;

  @JsonKey(name: r'address', required: true, includeIfNull: false)
  final String address;

  @JsonKey(name: r'slotStart', required: true, includeIfNull: false)
  final DateTime slotStart;

  @JsonKey(name: r'slotEnd', required: true, includeIfNull: false)
  final DateTime slotEnd;

  @JsonKey(name: r'items', required: true, includeIfNull: false)
  final List<ReservationItem> items;

  @JsonKey(name: r'amountYen', required: true, includeIfNull: false)
  final int amountYen;

  @JsonKey(name: r'paymentStatus', required: true, includeIfNull: false)
  final String paymentStatus;

  @JsonKey(name: r'note', required: true, includeIfNull: false)
  final String note;

  @JsonKey(name: r'photos', required: true, includeIfNull: false)
  final List<Photo> photos;

  @JsonKey(name: r'createdAt', required: true, includeIfNull: false)
  final DateTime createdAt;

  @JsonKey(name: r'admittedAt', required: false, includeIfNull: false)
  final DateTime? admittedAt;

  @JsonKey(name: r'completedAt', required: false, includeIfNull: false)
  final DateTime? completedAt;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Reservation &&
          other.id == id &&
          other.mode == mode &&
          other.status == status &&
          other.locationName == locationName &&
          other.address == address &&
          other.slotStart == slotStart &&
          other.slotEnd == slotEnd &&
          other.items == items &&
          other.amountYen == amountYen &&
          other.paymentStatus == paymentStatus &&
          other.note == note &&
          other.photos == photos &&
          other.createdAt == createdAt &&
          other.admittedAt == admittedAt &&
          other.completedAt == completedAt;

  @override
  int get hashCode =>
      id.hashCode +
      mode.hashCode +
      status.hashCode +
      locationName.hashCode +
      address.hashCode +
      slotStart.hashCode +
      slotEnd.hashCode +
      items.hashCode +
      amountYen.hashCode +
      paymentStatus.hashCode +
      note.hashCode +
      photos.hashCode +
      createdAt.hashCode +
      admittedAt.hashCode +
      completedAt.hashCode;

  factory Reservation.fromJson(Map<String, dynamic> json) =>
      _$ReservationFromJson(json);

  Map<String, dynamic> toJson() => _$ReservationToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
