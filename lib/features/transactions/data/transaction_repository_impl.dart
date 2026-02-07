import '../domain/transaction_entity.dart';
import '../domain/transaction_repository.dart';

/// Transactions Feature Data: Implementation of TransactionRepository.
/// Orchestrates data flow between local and remote sources.
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl();

  @override
  Future<List<TransactionEntity>> getAll() async => [];

  @override
  Future<TransactionEntity?> getById(String id) async => null;

  @override
  Future<void> upsert(TransactionEntity transaction) async {}

  @override
  Future<void> delete(String id) async {}
}
