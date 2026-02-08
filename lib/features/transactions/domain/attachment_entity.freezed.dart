// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'attachment_entity.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AttachmentEntity {

/// Unique identifier for the attachment.
 String get id;/// The ID of the transaction this attachment belongs to.
 String get transactionId;/// The name of the file (e.g., "receipt.pdf").
 String get fileName;/// The absolute path to the file on the local filesystem.
 String get filePath;/// The MIME type of the file (optional).
 String? get mimeType;/// The size of the file in bytes (optional).
 int? get sizeBytes;/// When the attachment was added.
 DateTime get createdAt;
/// Create a copy of AttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AttachmentEntityCopyWith<AttachmentEntity> get copyWith => _$AttachmentEntityCopyWithImpl<AttachmentEntity>(this as AttachmentEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AttachmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,transactionId,fileName,filePath,mimeType,sizeBytes,createdAt);

@override
String toString() {
  return 'AttachmentEntity(id: $id, transactionId: $transactionId, fileName: $fileName, filePath: $filePath, mimeType: $mimeType, sizeBytes: $sizeBytes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $AttachmentEntityCopyWith<$Res>  {
  factory $AttachmentEntityCopyWith(AttachmentEntity value, $Res Function(AttachmentEntity) _then) = _$AttachmentEntityCopyWithImpl;
@useResult
$Res call({
 String id, String transactionId, String fileName, String filePath, String? mimeType, int? sizeBytes, DateTime createdAt
});




}
/// @nodoc
class _$AttachmentEntityCopyWithImpl<$Res>
    implements $AttachmentEntityCopyWith<$Res> {
  _$AttachmentEntityCopyWithImpl(this._self, this._then);

  final AttachmentEntity _self;
  final $Res Function(AttachmentEntity) _then;

/// Create a copy of AttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? transactionId = null,Object? fileName = null,Object? filePath = null,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AttachmentEntity].
extension AttachmentEntityPatterns on AttachmentEntity {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AttachmentEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AttachmentEntity() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AttachmentEntity value)  $default,){
final _that = this;
switch (_that) {
case _AttachmentEntity():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AttachmentEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AttachmentEntity() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String transactionId,  String fileName,  String filePath,  String? mimeType,  int? sizeBytes,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AttachmentEntity() when $default != null:
return $default(_that.id,_that.transactionId,_that.fileName,_that.filePath,_that.mimeType,_that.sizeBytes,_that.createdAt);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String transactionId,  String fileName,  String filePath,  String? mimeType,  int? sizeBytes,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _AttachmentEntity():
return $default(_that.id,_that.transactionId,_that.fileName,_that.filePath,_that.mimeType,_that.sizeBytes,_that.createdAt);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String transactionId,  String fileName,  String filePath,  String? mimeType,  int? sizeBytes,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _AttachmentEntity() when $default != null:
return $default(_that.id,_that.transactionId,_that.fileName,_that.filePath,_that.mimeType,_that.sizeBytes,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _AttachmentEntity implements AttachmentEntity {
  const _AttachmentEntity({required this.id, required this.transactionId, required this.fileName, required this.filePath, this.mimeType, this.sizeBytes, required this.createdAt});
  

/// Unique identifier for the attachment.
@override final  String id;
/// The ID of the transaction this attachment belongs to.
@override final  String transactionId;
/// The name of the file (e.g., "receipt.pdf").
@override final  String fileName;
/// The absolute path to the file on the local filesystem.
@override final  String filePath;
/// The MIME type of the file (optional).
@override final  String? mimeType;
/// The size of the file in bytes (optional).
@override final  int? sizeBytes;
/// When the attachment was added.
@override final  DateTime createdAt;

/// Create a copy of AttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AttachmentEntityCopyWith<_AttachmentEntity> get copyWith => __$AttachmentEntityCopyWithImpl<_AttachmentEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AttachmentEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.transactionId, transactionId) || other.transactionId == transactionId)&&(identical(other.fileName, fileName) || other.fileName == fileName)&&(identical(other.filePath, filePath) || other.filePath == filePath)&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.sizeBytes, sizeBytes) || other.sizeBytes == sizeBytes)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,transactionId,fileName,filePath,mimeType,sizeBytes,createdAt);

@override
String toString() {
  return 'AttachmentEntity(id: $id, transactionId: $transactionId, fileName: $fileName, filePath: $filePath, mimeType: $mimeType, sizeBytes: $sizeBytes, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$AttachmentEntityCopyWith<$Res> implements $AttachmentEntityCopyWith<$Res> {
  factory _$AttachmentEntityCopyWith(_AttachmentEntity value, $Res Function(_AttachmentEntity) _then) = __$AttachmentEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String transactionId, String fileName, String filePath, String? mimeType, int? sizeBytes, DateTime createdAt
});




}
/// @nodoc
class __$AttachmentEntityCopyWithImpl<$Res>
    implements _$AttachmentEntityCopyWith<$Res> {
  __$AttachmentEntityCopyWithImpl(this._self, this._then);

  final _AttachmentEntity _self;
  final $Res Function(_AttachmentEntity) _then;

/// Create a copy of AttachmentEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? transactionId = null,Object? fileName = null,Object? filePath = null,Object? mimeType = freezed,Object? sizeBytes = freezed,Object? createdAt = null,}) {
  return _then(_AttachmentEntity(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,transactionId: null == transactionId ? _self.transactionId : transactionId // ignore: cast_nullable_to_non_nullable
as String,fileName: null == fileName ? _self.fileName : fileName // ignore: cast_nullable_to_non_nullable
as String,filePath: null == filePath ? _self.filePath : filePath // ignore: cast_nullable_to_non_nullable
as String,mimeType: freezed == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String?,sizeBytes: freezed == sizeBytes ? _self.sizeBytes : sizeBytes // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
