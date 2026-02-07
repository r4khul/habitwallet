import '../domain/category_entity.dart';
import '../domain/category_repository.dart';

/// Categories Feature Data: Implementation of category management.
class CategoryRepositoryImpl implements CategoryRepository {
  @override
  Future<void> init() async {}

  @override
  Future<List<CategoryEntity>> getAll() async => [];
}
