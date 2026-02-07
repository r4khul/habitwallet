import 'category_entity.dart';

/// Categories Feature Domain: Interface for category data management.
/// Boundary Rules: Pure Dart only.
abstract class CategoryRepository {
  /// Initializes the repository with default categories if needed.
  Future<void> init();

  /// Retrieves all user-defined and default categories.
  Future<List<CategoryEntity>> getAll();
}
