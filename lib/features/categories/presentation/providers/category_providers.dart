import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/category_repository_provider.dart';
import '../../domain/category_entity.dart';

part 'category_providers.g.dart';

/// State Provider for the list of categories.
@riverpod
Future<List<CategoryEntity>> categories(Ref ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getAll();
}
