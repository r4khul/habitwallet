import '../../../core/database/daos/category_dao.dart';
import '../../../core/database/daos/transaction_dao.dart';
import '../../../core/database/database.dart';
import '../../../core/error/failures.dart';
import '../domain/category_entity.dart';
import '../domain/category_repository.dart';

/// Categories Feature Data: Implementation with explicit error handling.
class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._categoryDao, this._transactionDao, this._db);

  final CategoryDao _categoryDao;
  final TransactionDao _transactionDao;
  final AppDatabase _db;

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

  @override
  Future<CategoryEntity?> getById(String id) async {
    try {
      final row = await _categoryDao.getById(id);
      return row != null ? _toEntity(row) : null;
    } on Object catch (_) {
      throw const DatabaseFailure('Failed to retrieve category details.');
    }
  }

  @override
  Future<void> upsert(CategoryEntity category) async {
    try {
      await _categoryDao.upsert(_toRow(category));
    } on Object catch (_) {
      throw const DatabaseFailure('Failed to save category.');
    }
  }

  @override
  Future<void> delete(String id) async {
    try {
      // Logic for strict deletion: check usage first (handled at service/controller level usually,
      // but let's implement the base delete here).
      await _categoryDao.deleteById(id);
    } on Object catch (_) {
      throw const DatabaseFailure('Failed to remove category.');
    }
  }

  @override
  Future<bool> isCategoryUsed(String id) async {
    try {
      return await _categoryDao.isUsed(id);
    } on Object catch (_) {
      return true; // Conservative approach on error
    }
  }

  @override
  Future<void> deleteWithTransactions(String id) async {
    try {
      // Use transaction for atomicity
      await _db.transaction(() async {
        await _transactionDao.deleteByCategoryId(id);
        await _categoryDao.deleteById(id);
      });
    } on Object catch (_) {
      throw const DatabaseFailure(
        'Failed to remove category and its transactions.',
      );
    }
  }

  @override
  Future<void> reassignAndAndDelete(String oldId, String newId) async {
    try {
      await _db.transaction(() async {
        await _transactionDao.reassignCategoryId(oldId, newId);
        await _categoryDao.deleteById(oldId);
      });
    } on Object catch (_) {
      throw const DatabaseFailure(
        'Failed to reassign transactions and remove category.',
      );
    }
  }

  /// Maps Database Row to Domain Entity.
  CategoryEntity _toEntity(Category row) {
    return CategoryEntity(
      id: row.id,
      name: row.name,
      icon: row.icon,
      color: row.color,
    );
  }

  /// Maps Domain Entity to Database Row.
  Category _toRow(CategoryEntity entity) {
    return Category(
      id: entity.id,
      name: entity.name,
      icon: entity.icon,
      color: entity.color,
    );
  }
}
