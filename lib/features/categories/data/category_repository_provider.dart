import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/database_providers.dart';
import '../domain/category_repository.dart';
import 'category_repository_impl.dart';

part 'category_repository_provider.g.dart';

/// Provider for the CategoryRepository interface.
/// Dependency: Injects CategoryDao into the implementation.
@riverpod
CategoryRepository categoryRepository(Ref ref) {
  final catDao = ref.watch(categoryDaoProvider);
  final txDao = ref.watch(transactionDaoProvider);
  final db = ref.watch(appDatabaseProvider);
  return CategoryRepositoryImpl(catDao, txDao, db);
}
