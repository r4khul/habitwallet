import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import '../../data/category_repository_provider.dart';
import '../../domain/category_entity.dart';

part 'category_providers.g.dart';

@riverpod
class CategoryController extends _$CategoryController {
  @override
  FutureOr<List<CategoryEntity>> build() async {
    final repository = ref.watch(categoryRepositoryProvider);
    final categories = await repository.getAll();

    if (categories.isEmpty) {
      // Seed default categories
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
      return repository.getAll();
    }

    return categories;
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () => ref.read(categoryRepositoryProvider).getAll(),
    );
  }

  Future<void> upsertCategory(CategoryEntity category) async {
    final categoryToSave = category.id.isEmpty
        ? category.copyWith(id: const Uuid().v4())
        : category;
    await ref.read(categoryRepositoryProvider).upsert(categoryToSave);
    await refresh();
  }

  Future<void> deleteCategory(String id) async {
    final isUsed = await ref
        .read(categoryRepositoryProvider)
        .isCategoryUsed(id);
    if (isUsed) {
      throw Exception('This category is in use and cannot be deleted.');
    }
    await ref.read(categoryRepositoryProvider).delete(id);
    await refresh();
  }
}

@riverpod
Future<CategoryEntity?> categoryById(Ref ref, String id) {
  return ref.watch(categoryRepositoryProvider).getById(id);
}
