import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_providers.dart';
import '../domain/transaction_repository.dart';
import 'fake_transaction_remote_data_source.dart';
import 'transaction_remote_data_source.dart';
import 'transaction_repository_impl.dart';

part 'transaction_repository_provider.g.dart';

@riverpod
TransactionRemoteDataSource transactionRemoteDataSource(Ref ref) {
  // Currently using a fake implementation for sync testing.
  return FakeTransactionRemoteDataSource();
}

/// Provider for the TransactionRepository interface.
/// Dependency: Injects TransactionDao and RemoteDataSource into the implementation.
@riverpod
TransactionRepository transactionRepository(Ref ref) {
  final dao = ref.watch(transactionDaoProvider);
  final remote = ref.watch(transactionRemoteDataSourceProvider);
  return TransactionRepositoryImpl(dao, remote);
}
