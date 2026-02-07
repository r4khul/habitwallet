/// Transactions Feature Data: Remote data source for API communication.
abstract class TransactionRemoteSource {
  Future<void> init();
  Future<void> fetchTransactions();
}
