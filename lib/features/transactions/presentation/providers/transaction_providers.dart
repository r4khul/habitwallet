import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/transaction_repository_provider.dart';
import '../../domain/transaction_entity.dart';
import 'date_filter_provider.dart';

part 'transaction_providers.g.dart';

/// Feature State: Manages the collection of transactions.
/// Responsibility: Provides an observable list of transactions and handles mutative actions.
/// Ownership: Owns the transaction logic; calls repository only.
@riverpod
class TransactionController extends _$TransactionController {
  @override
  Stream<List<TransactionEntity>> build() {
    return ref.watch(transactionRepositoryProvider).watchAll();
  }

  /// Retries loading transactions.
  void refresh() {
    ref.invalidateSelf();
  }

  Future<void> upsertTransaction(
    TransactionEntity transaction, {
    required bool isIncome,
  }) async {
    final repository = ref.read(transactionRepositoryProvider);
    var tx = transaction;

    // Handle ID generation if new
    if (tx.id.isEmpty) {
      tx = tx.copyWith(id: const Uuid().v4());
    }

    // Handle amount sign based on business rules
    final absAmount = tx.amount.abs();
    tx = tx.copyWith(amount: isIncome ? absAmount : -absAmount);

    await repository.upsert(tx);
  }

  /// Deletes a transaction by ID.
  Future<void> deleteTransaction(String id) async {
    await ref.read(transactionRepositoryProvider).delete(id);
  }
}

/// Feature State: Exposes a single transaction by its ID.
@riverpod
Stream<TransactionEntity?> transactionById(Ref ref, String id) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.watchById(id);
}

@riverpod
Stream<List<TransactionEntity>> filteredTransactions(Ref ref) async* {
  final transactionsAsync = ref.watch(transactionControllerProvider);
  final filter = ref.watch(dateFilterControllerProvider);

  if (transactionsAsync.hasValue) {
    final transactions = transactionsAsync.value!;
    yield transactions.where((tx) {
      return tx.timestamp.isAfter(
            filter.start.subtract(const Duration(seconds: 1)),
          ) &&
          tx.timestamp.isBefore(filter.end.add(const Duration(seconds: 1)));
    }).toList()..sort((a, b) => b.timestamp.compareTo(a.timestamp));
  }
}
