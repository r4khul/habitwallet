import 'package:dio/dio.dart';
import '../domain/category_entity.dart';
import 'category_remote_data_source.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CategoryEntity>> fetchAll() async {
    try {
      final response = await _dio.get<dynamic>('/categories');
      final data = response.data;

      // Handle null or non-list responses
      if (data == null || data is! List) return [];

      // Handle empty array
      if (data.isEmpty) return [];

      return data.expand<CategoryEntity>((item) {
        // Skip null items
        if (item == null) return [];

        // Handle String format (e.g., ["Food", "Travel", "Bills"])
        if (item is String) {
          // Skip empty strings
          if (item.trim().isEmpty) return [];

          // Use the original string as ID to match transaction references
          // This ensures "Food" in categories matches "Food" in transactions
          return [
            CategoryEntity(
              id: item.trim(),
              name: item.trim(),
              icon: _mapCategoryToIcon(item),
              color:
                  _fallbackColors[item.hashCode.abs() % _fallbackColors.length],
            ),
          ];
        }

        // Handle Object format (e.g., {id, name, icon, color})
        if (item is Map) {
          try {
            final json = Map<String, dynamic>.from(item);

            // Validate required fields exist
            if (!json.containsKey('id') || json['id'] == null) {
              return [];
            }

            return [CategoryEntity.fromJson(json)];
          } on Object catch (_) {
            // Silently skip malformed objects
            return [];
          }
        }

        // Skip unknown types
        return [];
      }).toList();
    } on Object catch (_) {
      // Return empty list on any network or parsing error
      return [];
    }
  }

  /// Maps common category names to appropriate Material Icons.
  String _mapCategoryToIcon(String categoryName) {
    final normalized = categoryName.toLowerCase().trim();

    // Common category mappings
    const iconMap = {
      'food': 'restaurant',
      'dining': 'restaurant',
      'groceries': 'shopping_cart',
      'transport': 'directions_car',
      'transportation': 'directions_car',
      'travel': 'flight',
      'bills': 'receipt',
      'utilities': 'receipt',
      'shopping': 'shopping_bag',
      'salary': 'payments',
      'income': 'payments',
      'entertainment': 'movie',
      'health': 'local_hospital',
      'medical': 'local_hospital',
      'education': 'school',
      'other': 'category',
      'others': 'category',
    };

    return iconMap[normalized] ?? 'category';
  }

  static const _fallbackColors = [
    0xFF6366F1, // Indigo
    0xFF8B5CF6, // Violet
    0xFFEC4899, // Pink
    0xFFEF4444, // Red
    0xFFF59E0B, // Amber
    0xFF10B981, // Emerald
    0xFF06B6D4, // Cyan
    0xFF3B82F6, // Blue
    0xFF64748B, // Slate
  ];

  @override
  Future<void> push(CategoryEntity category) async {
    await _dio.post<void>('/categories', data: category.toJson());
  }
}
