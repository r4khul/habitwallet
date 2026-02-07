import 'transaction_entity.dart';

/// Transactions Feature Domain: Interface for transaction data management.
/// Boundary Rules: Pure Dart only, protects domain invariants.
abstract class TransactionRepository {
  /// Retrieves all transactions.
  Future<List<TransactionEntity>> getAll();

  /// Retrieves a specific transaction by its unique [id].
  Future<TransactionEntity?> getById(String id);

  /// Creates or updates a transaction while maintaining its identity.
  Future<void> upsert(TransactionEntity transaction);

  /// Deletes a transaction by its [id].
  Future<void> delete(String id);
}
