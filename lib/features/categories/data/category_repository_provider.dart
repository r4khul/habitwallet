import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_providers.dart';
import '../../../core/providers/network_providers.dart';
import '../domain/category_repository.dart';
import 'category_remote_data_source.dart';
import 'category_remote_data_source_impl.dart';
import 'category_repository_impl.dart';

part 'category_repository_provider.g.dart';

@riverpod
CategoryRemoteDataSource categoryRemoteDataSource(Ref ref) {
  final dio = ref.watch(dioProvider);
  return CategoryRemoteDataSourceImpl(dio);
}

/// Provider for the CategoryRepository interface.
/// Dependency: Injects CategoryDao into the implementation.
@riverpod
CategoryRepository categoryRepository(Ref ref) {
  final catDao = ref.watch(categoryDaoProvider);
  final txDao = ref.watch(transactionDaoProvider);
  final db = ref.watch(appDatabaseProvider);
  final remote = ref.watch(categoryRemoteDataSourceProvider);

  final repository = CategoryRepositoryImpl(catDao, txDao, db, remote);
  ref.onDispose(repository.dispose);
  return repository;
}
