import 'package:drift/drift.dart';
import 'tables.dart';

part 'database.g.dart';

/// Central database service using Drift.
/// Orchestrates the schema and prepares the app for offline-first data management.
@DriftDatabase(tables: [Transactions, Categories])
class AppDatabase extends _$AppDatabase {
  AppDatabase(super.e);

  @override
  int get schemaVersion => 1;
}
