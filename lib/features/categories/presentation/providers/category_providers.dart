import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/category_repository_provider.dart';
import '../../domain/category_entity.dart';
import '../../domain/category_repository.dart';

part 'category_providers.g.dart';

@riverpod
class CategoryController extends _$CategoryController {
  @override
  Stream<List<CategoryEntity>> build() async* {
    final repository = ref.watch(categoryRepositoryProvider);

    // Initial check for seeding
    final categories = await repository.getAll();
    if (categories.isEmpty) {
      await _seed(repository);
    }

    yield* repository.watchAll();
  }

  Future<void> _seed(CategoryRepository repository) async {
    final defaults = [
      CategoryEntity(
        id: 'food',
        name: 'Food',
        icon: 'food',
        color: 0xFFF44336,
      ), // Red
      CategoryEntity(
        id: 'transport',
        name: 'Transport',
        icon: 'transport',
        color: 0xFF2196F3,
      ), // Blue
      CategoryEntity(
        id: 'shopping',
        name: 'Shopping',
        icon: 'shopping',
        color: 0xFF9C27B0,
      ), // Purple
      CategoryEntity(
        id: 'entertainment',
        name: 'Entertainment',
        icon: 'entertainment',
        color: 0xFFFF9800,
      ), // Orange
      CategoryEntity(
        id: 'health',
        name: 'Health',
        icon: 'health',
        color: 0xFF4CAF50,
      ), // Green
      CategoryEntity(
        id: 'salary',
        name: 'Salary',
        icon: 'salary',
        color: 0xFF00BCD4,
      ), // Cyan
    ];

    for (final cat in defaults) {
      await repository.upsert(cat);
    }
  }

  void refresh() {
    ref.invalidateSelf();
  }

  Future<void> upsertCategory(CategoryEntity category) async {
    final categoryToSave = category.id.isEmpty
        ? category.copyWith(id: const Uuid().v4())
        : category;
    await ref.read(categoryRepositoryProvider).upsert(categoryToSave);
  }

  Future<void> deleteCategory(String id) async {
    final isUsed = await ref
        .read(categoryRepositoryProvider)
        .isCategoryUsed(id);
    if (isUsed) {
      throw Exception('This category is in use and cannot be deleted.');
    }
    await ref.read(categoryRepositoryProvider).delete(id);
  }

  Future<void> deleteCategoryWithTransactions(String id) async {
    await ref.read(categoryRepositoryProvider).deleteWithTransactions(id);
  }

  Future<void> reassignAndDeleteCategory(String oldId, String newId) async {
    await ref
        .read(categoryRepositoryProvider)
        .reassignAndAndDelete(oldId, newId);
  }
}

@riverpod
Stream<CategoryEntity?> categoryById(Ref ref, String id) {
  return ref.watch(categoryRepositoryProvider).watchById(id);
}
