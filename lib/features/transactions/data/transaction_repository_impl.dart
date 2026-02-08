import '../../../core/database/daos/transaction_dao.dart';
import '../../../core/database/database.dart';
import '../../../core/error/failures.dart';
import '../domain/transaction_entity.dart';
import '../domain/transaction_repository.dart';

/// Transactions Feature Data: Implementation of TransactionRepository.
/// Orchestrates data flow with explicit error handling for local persistence.
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl(this._transactionDao);

  final TransactionDao _transactionDao;

  @override
  Future<List<TransactionEntity>> getAll() async {
    try {
      final rows = await _transactionDao.getAll();
      return rows.map(_toEntity).toList();
    } on Object catch (_) {
      throw const DatabaseFailure(
        'Failed to fetch transactions from local storage.',
      );
    }
  }

  @override
  Future<TransactionEntity?> getById(String id) async {
    try {
      final row = await _transactionDao.getById(id);
      return row != null ? _toEntity(row) : null;
    } on Object catch (_) {
      throw const DatabaseFailure('Failed to retrieve transaction details.');
    }
  }

  @override
  Future<void> upsert(TransactionEntity transaction) async {
    try {
      await _transactionDao.upsert(_toRow(transaction));
    } on Object catch (_) {
      throw const DatabaseFailure('Failed to save transaction locally.');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      await _transactionDao.deleteById(id);
    } on Object catch (_) {
      throw const DatabaseFailure('Failed to remove transaction.');
    }
  }

  /// Maps Database Row to Domain Entity.
  /// Ignores infra-only fields (createdAt, updatedAt).
  TransactionEntity _toEntity(Transaction row) {
    return TransactionEntity(
      id: row.id,
      amount: row.amount,
      categoryId: row.categoryId,
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
      categoryId: entity.categoryId,
      timestamp: entity.timestamp.millisecondsSinceEpoch,
      note: entity.note,
      editedLocally: true, // Mark as edited locally on save/update
      createdAt: now, // Initial metadata, actual logic may vary in real apps
      updatedAt: now,
    );
  }
}
