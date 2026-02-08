import 'package:drift/drift.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'daos/attachment_dao.dart';
import 'tables.dart';

part 'database.g.dart';

/// Central database service using Drift.
/// Orchestrates the schema and prepares the app for offline-first data management.
@DriftDatabase(
  tables: [Transactions, Categories, Attachments],
  daos: [TransactionDao, CategoryDao, AttachmentDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 3;
}
