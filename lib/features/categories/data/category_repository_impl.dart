import '../../../core/database/daos/category_dao.dart';
import '../../../core/database/database.dart';
import '../domain/category_entity.dart';
import '../domain/category_repository.dart';

/// Categories Feature Data: Implementation of category management with mapping.
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._categoryDao);

  final CategoryDao _categoryDao;

  @override
  Future<void> init() async {
    // Initialization logic for categories if needed.
  }

  @override
  Future<List<CategoryEntity>> getAll() async {
    final rows = await _categoryDao.getAll();
    return rows.map(_toEntity).toList();
  }

  /// Maps Database Row to Domain Entity.
  CategoryEntity _toEntity(Category row) {
    return CategoryEntity(name: row.name);
  }
}
