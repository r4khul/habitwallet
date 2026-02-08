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

  /// Reactive stream of all category rows.
  Stream<List<Category>> watchAll() {
    return select(categories).watch();
  }

  /// Fetches a specific category row by its [id].
  Future<Category?> getById(String id) {
    return (select(
      categories,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Reactive stream of a single category row.
  Stream<Category?> watchById(String id) {
    return (select(
      categories,
    )..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Upserts a category row.
  Future<void> upsert(Category row) {
    return into(categories).insertOnConflictUpdate(row);
  }

  /// Deletes a category row by its [id].
  Future<int> deleteById(String id) {
    return (delete(categories)..where((t) => t.id.equals(id))).go();
  }

  /// Checks if a category is used in any transactions.
  Future<bool> isUsed(String id) async {
    final query = select(db.transactions)
      ..where((t) => t.categoryId.equals(id))
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result != null;
  }
}
