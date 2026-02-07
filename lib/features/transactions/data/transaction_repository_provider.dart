import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_providers.dart';
import '../domain/transaction_repository.dart';
import 'transaction_repository_impl.dart';

part 'transaction_repository_provider.g.dart';

/// Provider for the TransactionRepository interface.
/// Dependency: Injects TransactionDao into the implementation.
@riverpod
TransactionRepository transactionRepository(Ref ref) {
  final dao = ref.watch(transactionDaoProvider);
  return TransactionRepositoryImpl(dao);
}
