import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/transaction_repository_provider.dart';
import '../../domain/transaction_entity.dart';

part 'transaction_providers.g.dart';

/// State Provider for the list of all transactions.
/// Responsibility: Observes the TransactionRepository and exposes the current transaction state.
@riverpod
Future<List<TransactionEntity>> transactions(Ref ref) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getAll();
}

/// State Provider for a specific transaction by its ID.
@riverpod
Future<TransactionEntity?> transactionById(Ref ref, String id) {
  final repository = ref.watch(transactionRepositoryProvider);
  return repository.getById(id);
}
