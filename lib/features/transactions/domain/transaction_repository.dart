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

  /// Synchronizes local transactions with the remote source.
  /// Implement Push-then-Pull model with deterministic conflict resolution.
  /// Guarantee: Local data is never lost on failure.
  Future<void> syncWithRemote();

  /// Exposes the current synchronization status.
  /// Use this to update the UI state (e.g., show a spinner or error icon).
  Stream<SyncStatus> get syncStatus;

  /// Cleans up resources (e.g., closes streams).
  void dispose();
}

/// Represents the current state of data synchronization.
enum SyncStatus {
  /// No synchronization is currently in progress.
  idle,

  /// Synchronization is active (pushing or pulling data).
  syncing,

  /// The last synchronization attempt failed.
  failed,
}
