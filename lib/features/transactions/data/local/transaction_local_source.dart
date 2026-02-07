/// Transactions Feature Data: Local data source for offline persistence.
abstract class TransactionLocalSource {
  Future<void> init();
  Future<void> cacheTransactions();
}
