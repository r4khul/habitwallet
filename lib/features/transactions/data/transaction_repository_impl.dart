import '../../../core/database/daos/transaction_dao.dart';
import '../../../core/database/database.dart';
import '../domain/transaction_entity.dart';
import '../domain/transaction_repository.dart';

/// Transactions Feature Data: Implementation of TransactionRepository.
/// Orchestrates data flow between local and remote sources with explicit mapping.
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._transactionDao);

  final TransactionDao _transactionDao;

  @override
  Future<List<TransactionEntity>> getAll() async {
    final rows = await _transactionDao.getAll();
    return rows.map(_toEntity).toList();
  }

  @override
  Future<TransactionEntity?> getById(String id) async {
    final row = await _transactionDao.getById(id);
    return row != null ? _toEntity(row) : null;
  }

  @override
  Future<void> upsert(TransactionEntity transaction) async {
    await _transactionDao.upsert(_toRow(transaction));
  }

  @override
  Future<void> delete(String id) async {
    await _transactionDao.deleteById(id);
  }

  /// Maps Database Row to Domain Entity.
  /// Ignores infra-only fields (createdAt, updatedAt).
  TransactionEntity _toEntity(Transaction row) {
    return TransactionEntity(
      id: row.id,
      amount: row.amount,
      category: row.category,
      timestamp: DateTime.fromMillisecondsSinceEpoch(row.timestamp),
      note: row.note,
      editedLocally: row.editedLocally,
    );
  }

  /// Maps Domain Entity to Database Row.
  /// Sets editedLocally = true for local lifecycle management.
  Transaction _toRow(TransactionEntity entity) {
    final now = DateTime.now().millisecondsSinceEpoch;
    return Transaction(
      id: entity.id,
      amount: entity.amount,
      category: entity.category,
      timestamp: entity.timestamp.millisecondsSinceEpoch,
      note: entity.note,
      editedLocally: true, // Mark as edited locally on save/update
      createdAt: now, // Initial metadata, actual logic may vary in real apps
      updatedAt: now,
    );
  }
}
