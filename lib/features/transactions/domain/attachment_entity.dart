import 'package:freezed_annotation/freezed_annotation.dart';

part 'attachment_entity.freezed.dart';
part 'attachment_entity.g.dart';

/// Domain Entity: Represents a file attached to a transaction.
///
/// **Business Rules & Invariants:**
/// 1. **Metadata Only**: Stores only file references, not content.
/// 2. **Immutability**: Once created, attachments are generally immutable unless deleted.
/// 3. **Validation**: Must reference a valid local file path (though existence is checked at runtime).
@freezed
abstract class AttachmentEntity with _$AttachmentEntity {
  const factory AttachmentEntity({
    /// Unique identifier for the attachment.
    required String id,

    /// The ID of the transaction this attachment belongs to.
    required String transactionId,

    /// The name of the file (e.g., "receipt.pdf").
    required String fileName,

    /// The absolute path to the file on the local filesystem.
    required String filePath,

    /// The MIME type of the file (optional).
    String? mimeType,

    /// The size of the file in bytes (optional).
    int? sizeBytes,

    /// When the attachment was added.
    required DateTime createdAt,
  }) = _AttachmentEntity;

  factory AttachmentEntity.fromJson(Map<String, dynamic> json) =>
      _$AttachmentEntityFromJson(json);
}
