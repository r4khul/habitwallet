import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/transaction_repository_provider.dart';
import '../../domain/transaction_entity.dart';

part 'transaction_providers.g.dart';

/// Feature State: Manages the collection of transactions.
/// Responsibility: Provides an observable list of transactions and handles mutative actions.
/// Ownership: Owns the transaction logic; calls repository only.
@riverpod
class TransactionController extends _$TransactionController {
  @override
  FutureOr<List<TransactionEntity>> build() {
    final repository = ref.watch(transactionRepositoryProvider);
    return repository.getAll();
  }

  /// Retries loading transactions.
  void refresh() {
    ref.invalidateSelf();
  }

  /// Adds or updates a transaction and refreshes the state.
  Future<void> upsertTransaction(
    TransactionEntity transaction, {
    required bool isIncome,
  }) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      var tx = transaction;

      // Handle ID generation if new
      if (tx.id.isEmpty) {
        tx = tx.copyWith(id: const Uuid().v4());
      }

      // Handle amount sign based on business rules
      final absAmount = tx.amount.abs();
      tx = tx.copyWith(amount: isIncome ? absAmount : -absAmount);

      await ref.read(transactionRepositoryProvider).upsert(tx);
      // Refresh the list after modification
      return ref.read(transactionRepositoryProvider).getAll();
    });
  }

  /// Deletes a transaction by ID and refreshes the state.
  Future<void> deleteTransaction(String id) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(transactionRepositoryProvider).delete(id);
      return ref.read(transactionRepositoryProvider).getAll();
    });
  }
}

/// Feature State: Exposes a single transaction by its ID.
@riverpod
Future<TransactionEntity?> transactionById(Ref ref, String id) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getById(id);
}
