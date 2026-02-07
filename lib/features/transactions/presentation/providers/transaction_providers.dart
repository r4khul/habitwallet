import 'package:riverpod_annotation/riverpod_annotation.dart';
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

  /// Adds or updates a transaction and refreshes the state.
  Future<void> upsertTransaction(TransactionEntity transaction) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(transactionRepositoryProvider).upsert(transaction);
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
