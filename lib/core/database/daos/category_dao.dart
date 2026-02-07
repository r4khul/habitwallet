import 'package:drift/drift.dart';
import '../database.dart';
import '../tables.dart';

part 'category_dao.g.dart';

/// DAO for [Categories] table.
/// Responsibility: Direct low-level database operations for categories.
@DriftAccessor(tables: [Categories])
class CategoryDao extends DatabaseAccessor<AppDatabase>
    with _$CategoryDaoMixin {
  CategoryDao(super.db);

  /// Retrieves all category rows.
  Future<List<Category>> getAll() {
    return select(categories).get();
  }

  /// Upserts a category row.
  Future<void> upsert(Category row) {
    return into(categories).insertOnConflictUpdate(row);
  }
}
