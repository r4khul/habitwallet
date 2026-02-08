import '../domain/transaction_entity.dart';

/// Transaction Feature Data: Remote source interface.
/// Represents the API replication target.
abstract class TransactionRemoteDataSource {
  /// Fetches all transactions from the remote server.
  Future<List<TransactionEntity>> fetchAll();

  /// Pushes a single transaction to the remote server.
  Future<void> push(TransactionEntity transaction);
}
