import '../domain/category_entity.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getAll();
  Stream<List<CategoryEntity>> watchAll();
  Future<CategoryEntity?> getById(String id);
  Stream<CategoryEntity?> watchById(String id);
  Future<void> upsert(CategoryEntity category);
  Future<void> delete(String id);
  Future<bool> isCategoryUsed(String id);
  Future<void> deleteWithTransactions(String id);
  Future<void> reassignAndAndDelete(String oldId, String newId);
}
