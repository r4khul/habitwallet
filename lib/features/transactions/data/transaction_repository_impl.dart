import '../domain/transaction_entity.dart';
import '../domain/transaction_repository.dart';

/// Transactions Feature Data: Implementation of TransactionRepository.
/// Orchestrates data flow between local and remote sources.
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl();

  @override
  Future<List<TransactionEntity>> getTransactions() async => [];

  @override
  Future<void> addTransaction(TransactionEntity transaction) async {}
}
