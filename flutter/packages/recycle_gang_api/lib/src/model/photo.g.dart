// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'photo.dart';

// **************************************************************************
// CopyWithGenerator
// **************************************************************************

abstract class _$PhotoCWProxy {
  Photo id(String id);

  Photo fileName(String fileName);

  Photo contentType(String contentType);

  Photo size(int size);

  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Photo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Photo(...).copyWith(id: 12, name: "My name")
  /// ````
  Photo call({String id, String fileName, String contentType, int size});
}

/// Proxy class for `copyWith` functionality. This is a callable class and can be used as follows: `instanceOfPhoto.copyWith(...)`. Additionally contains functions for specific fields e.g. `instanceOfPhoto.copyWith.fieldName(...)`
class _$PhotoCWProxyImpl implements _$PhotoCWProxy {
  const _$PhotoCWProxyImpl(this._value);

  final Photo _value;

  @override
  Photo id(String id) => this(id: id);

  @override
  Photo fileName(String fileName) => this(fileName: fileName);

  @override
  Photo contentType(String contentType) => this(contentType: contentType);

  @override
  Photo size(int size) => this(size: size);

  @override
  /// This function **does support** nullification of nullable fields. All `null` values passed to `non-nullable` fields will be ignored. You can also use `Photo(...).copyWith.fieldName(...)` to override fields one at a time with nullification support.
  ///
  /// Usage
  /// ```dart
  /// Photo(...).copyWith(id: 12, name: "My name")
  /// ````
  Photo call({
    Object? id = const $CopyWithPlaceholder(),
    Object? fileName = const $CopyWithPlaceholder(),
    Object? contentType = const $CopyWithPlaceholder(),
    Object? size = const $CopyWithPlaceholder(),
  }) {
    return Photo(
      id: id == const $CopyWithPlaceholder()
          ? _value.id
          // ignore: cast_nullable_to_non_nullable
          : id as String,
      fileName: fileName == const $CopyWithPlaceholder()
          ? _value.fileName
          // ignore: cast_nullable_to_non_nullable
          : fileName as String,
      contentType: contentType == const $CopyWithPlaceholder()
          ? _value.contentType
          // ignore: cast_nullable_to_non_nullable
          : contentType as String,
      size: size == const $CopyWithPlaceholder()
          ? _value.size
          // ignore: cast_nullable_to_non_nullable
          : size as int,
    );
  }
}

extension $PhotoCopyWith on Photo {
  /// Returns a callable class that can be used as follows: `instanceOfPhoto.copyWith(...)` or like so:`instanceOfPhoto.copyWith.fieldName(...)`.
  // ignore: library_private_types_in_public_api
  _$PhotoCWProxy get copyWith => _$PhotoCWProxyImpl(this);
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Photo _$PhotoFromJson(Map<String, dynamic> json) =>
    $checkedCreate('Photo', json, ($checkedConvert) {
      $checkKeys(
        json,
        requiredKeys: const ['id', 'fileName', 'contentType', 'size'],
      );
      final val = Photo(
        id: $checkedConvert('id', (v) => v as String),
        fileName: $checkedConvert('fileName', (v) => v as String),
        contentType: $checkedConvert('contentType', (v) => v as String),
        size: $checkedConvert('size', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$PhotoToJson(Photo instance) => <String, dynamic>{
  'id': instance.id,
  'fileName': instance.fileName,
  'contentType': instance.contentType,
  'size': instance.size,
};
