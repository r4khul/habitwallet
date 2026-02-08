import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'attachment_dao.g.dart';

/// DAO for [Attachments] table.
@DriftAccessor(tables: [Attachments])
class AttachmentDao extends DatabaseAccessor<AppDatabase>
    with _$AttachmentDaoMixin {
  AttachmentDao(super.db);

  /// Get attachments for a transaction.
  Future<List<Attachment>> getByTransactionId(String transactionId) {
    return (select(
      attachments,
    )..where((a) => a.transactionId.equals(transactionId))).get();
  }

  /// Insert a single attachment.
  Future<void> insertAttachment(Attachment attachment) {
    return into(attachments).insert(attachment);
  }

  /// Delete an attachment by ID.
  Future<void> deleteAttachment(String id) {
    return (delete(attachments)..where((a) => a.id.equals(id))).go();
  }
}
