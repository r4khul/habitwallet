import '../domain/transaction_entity.dart';
import 'transaction_remote_data_source.dart';

/// Transaction Feature Data: Mock Remote Data Source.
/// Simulated API replication target for development and sync testing.
class FakeTransactionRemoteDataSource implements TransactionRemoteDataSource {
  final Map<String, TransactionEntity> _remoteDb = {};

  @override
  Future<List<TransactionEntity>> fetchAll() async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 500));
    return _remoteDb.values.toList();
  }

  @override
  Future<void> push(TransactionEntity transaction) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _remoteDb[transaction.id] = transaction;
  }
}
