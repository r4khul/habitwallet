import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/providers/network_providers.dart';
import '../domain/transaction_repository.dart';
import 'transaction_remote_data_source.dart';
import 'transaction_remote_data_source_impl.dart';
import 'transaction_repository_impl.dart';

part 'transaction_repository_provider.g.dart';

@riverpod
TransactionRemoteDataSource transactionRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return TransactionRemoteDataSourceImpl(dio);
}

/// Provider for the TransactionRepository interface.
/// Dependency: Injects TransactionDao and RemoteDataSource into the implementation.
@riverpod
TransactionRepository transactionRepository(Ref ref) {
  final dao = ref.watch(transactionDaoProvider);
  final attachmentDao = ref.watch(attachmentDaoProvider);
  final remote = ref.watch(transactionRemoteDataSourceProvider);

  final repository = TransactionRepositoryImpl(dao, attachmentDao, remote);
  ref.onDispose(repository.dispose);

  return repository;
}
