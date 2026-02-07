import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'transaction_dao.g.dart';

/// DAO for [Transactions] table.
/// Responsibility: Direct low-level database operations for transactions using data rows.
@DriftAccessor(tables: [Transactions])
class TransactionDao extends DatabaseAccessor<AppDatabase>
    with _$TransactionDaoMixin {
  TransactionDao(super.db);

  /// Retrieves all transaction rows ordered by timestamp descending.
  Future<List<Transaction>> getAll() {
    return (select(
      transactions,
    )..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).get();
  }

  /// Reactive stream of all transaction rows ordered by timestamp descending.
  Stream<List<Transaction>> watchAll() {
    return (select(
      transactions,
    )..orderBy([(t) => OrderingTerm.desc(t.timestamp)])).watch();
  }

  /// Fetches a specific transaction row by its [id].
  Future<Transaction?> getById(String id) {
    return (select(
      transactions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Upserts a transaction row (inserts or replaces on conflict).
  Future<void> upsert(Transaction row) {
    return into(transactions).insertOnConflictUpdate(row);
  }

  /// Deletes a transaction row by its [id].
  Future<int> deleteById(String id) {
    return (delete(transactions)..where((t) => t.id.equals(id))).go();
  }
}
