//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'photo.g.dart';

@CopyWith()
@JsonSerializable(
  checked: true,
  createToJson: true,
  disallowUnrecognizedKeys: false,
  explicitToJson: true,
)
class Photo {
  /// Returns a new [Photo] instance.
  Photo({
    required this.id,

    required this.fileName,

    required this.contentType,

    required this.size,
  });

  @JsonKey(name: r'id', required: true, includeIfNull: false)
  final String id;

  @JsonKey(name: r'fileName', required: true, includeIfNull: false)
  final String fileName;

  @JsonKey(name: r'contentType', required: true, includeIfNull: false)
  final String contentType;

  @JsonKey(name: r'size', required: true, includeIfNull: false)
  final int size;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Photo &&
          other.id == id &&
          other.fileName == fileName &&
          other.contentType == contentType &&
          other.size == size;

  @override
  int get hashCode =>
      id.hashCode + fileName.hashCode + contentType.hashCode + size.hashCode;

  factory Photo.fromJson(Map<String, dynamic> json) => _$PhotoFromJson(json);

  Map<String, dynamic> toJson() => _$PhotoToJson(this);

  @override
  String toString() {
    return toJson().toString();
  }
}
