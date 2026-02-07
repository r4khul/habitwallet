import '../../../core/database/daos/category_dao.dart';
import '../../../core/database/database.dart';
import '../../../core/error/failures.dart';
import '../domain/category_entity.dart';
import '../domain/category_repository.dart';

/// Categories Feature Data: Implementation with explicit error handling.
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._categoryDao);

  final CategoryDao _categoryDao;

  @override
  Future<void> init() async {
    // Initialization logic for categories if needed.
  }

  @override
  Future<List<CategoryEntity>> getAll() async {
    try {
      final rows = await _categoryDao.getAll();
      return rows.map(_toEntity).toList();
    } on Object catch (_) {
      throw const DatabaseFailure(
        'Could not load categories. Ensure database health.',
      );
    }
  }

  /// Maps Database Row to Domain Entity.
  CategoryEntity _toEntity(Category row) {
    return CategoryEntity(name: row.name);
  }
}
