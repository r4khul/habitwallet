import 'transaction.dart';

/// Transactions Feature Domain: Interface for transaction data management.
abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();
  Future<void> addTransaction(Transaction transaction);
}
