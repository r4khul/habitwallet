import '../domain/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAll();
  Future<CategoryEntity?> getById(String id);
  Future<void> upsert(CategoryEntity category);
  Future<void> delete(String id);
  Future<bool> isCategoryUsed(String id);
}
