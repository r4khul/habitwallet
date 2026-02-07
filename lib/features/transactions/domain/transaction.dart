/// Transactions Feature Domain: Represents a financial transaction.
class Transaction {
  const Transaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
  });

  final String id;
  final double amount;
  final String description;
  final DateTime date;
}
