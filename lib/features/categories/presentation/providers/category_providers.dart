import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/category_repository_provider.dart';
import '../../domain/category_entity.dart';

part 'category_providers.g.dart';

/// Feature State: Manages the collection of categories.
/// Responsibility: Provides an observable list of categories.
/// Ownership: Feature state; calls repository only.
@riverpod
class CategoryController extends _$CategoryController {
  @override
  FutureOr<List<CategoryEntity>> build() {
    final repository = ref.watch(categoryRepositoryProvider);
    return repository.getAll();
  }

  // Future<void> addCategory(String name) async { ... }
}
