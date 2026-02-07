import '../domain/transaction.dart';
import '../domain/transaction_repository.dart';

/// Transactions Feature Data: Implementation of TransactionRepository.
/// Orchestrates data flow between local and remote sources.
class TransactionRepositoryImpl implements TransactionRepository {
  TransactionRepositoryImpl();

  @override
  Future<List<Transaction>> getTransactions() async => [];

  @override
  Future<void> addTransaction(Transaction transaction) async {}
}
