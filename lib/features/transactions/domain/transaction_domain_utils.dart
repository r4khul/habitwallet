import 'transaction_entity.dart';

/// Domain Utility: Derived logic for transactions.
/// Business Rule: Balances are derived, never stored.
abstract class TransactionDomainUtils {
  /// Calculates the net balance from a list of transactions.
  /// Sums all amounts (incomes are positive, expenses are negative).
  static double calculateBalance(List<TransactionEntity> transactions) {
    return transactions.fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculates total income from a list of transactions.
  static double calculateTotalIncome(List<TransactionEntity> transactions) {
    return transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, t) => sum + t.amount);
  }

  /// Calculates total expense from a list of transactions (as a positive number).
  static double calculateTotalExpense(List<TransactionEntity> transactions) {
    return transactions
        .where((t) => t.isExpense)
        .fold(0.0, (sum, t) => sum + t.amount.abs());
  }
}
