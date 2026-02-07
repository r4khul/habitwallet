import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'daos/category_dao.dart';
import 'daos/transaction_dao.dart';
import 'database.dart';

part 'database_providers.g.dart';

/// Provider for the central database instance.
/// Responsibility: Singleton access to the Drift database.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  // Logic for opening the database (e.g., using sqlite3 on mobile/desktop)
  // should ideally be handled here or in a dedicated opener.
  // For now, we assume the construction is handled via an override or a simple instance.
  throw UnimplementedError(
    'Database connection logic not yet implemented. Use ProviderScope overrides for testing.',
  );
}

/// Provider for [TransactionDao].
@riverpod
TransactionDao transactionDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return TransactionDao(db);
}

/// Provider for [CategoryDao].
@riverpod
CategoryDao categoryDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return CategoryDao(db);
}
