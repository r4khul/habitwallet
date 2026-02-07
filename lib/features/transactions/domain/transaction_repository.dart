import 'transaction_entity.dart';

/// Transactions Feature Domain: Interface for transaction data management.
abstract class TransactionRepository {
  Future<List<TransactionEntity>> getTransactions();
  Future<void> addTransaction(TransactionEntity transaction);
}
