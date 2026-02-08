// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttachmentEntity _$AttachmentEntityFromJson(Map<String, dynamic> json) =>
    _AttachmentEntity(
      id: json['id'] as String,
      transactionId: json['transactionId'] as String,
      fileName: json['fileName'] as String,
      filePath: json['filePath'] as String,
      mimeType: json['mimeType'] as String?,
      sizeBytes: (json['sizeBytes'] as num?)?.toInt(),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$AttachmentEntityToJson(_AttachmentEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'transactionId': instance.transactionId,
      'fileName': instance.fileName,
      'filePath': instance.filePath,
      'mimeType': instance.mimeType,
      'sizeBytes': instance.sizeBytes,
      'createdAt': instance.createdAt.toIso8601String(),
    };
