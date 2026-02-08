import '../domain/category_entity.dart';

abstract class CategoryRemoteDataSource {
  Future<List<CategoryEntity>> fetchAll();
  Future<void> push(CategoryEntity category);
}
