import 'package:dio/dio.dart';
import '../domain/category_entity.dart';
import 'category_remote_data_source.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<CategoryEntity>> fetchAll() async {
    final response = await _dio.get<List<dynamic>>('/categories');
    final data = response.data ?? [];
    return data.map((item) {
      if (item is Map<String, dynamic>) {
        return CategoryEntity.fromJson(item);
      }
      // Fallback for old simple list format if still in use by server
      final name = item.toString();
      return CategoryEntity(
        id: name,
        name: name,
        icon: 'category', // Default icon
        color: 0xFF9E9E9E, // Default grey color
        updatedAt: DateTime.now(),
      );
    }).toList();
  }

  @override
  Future<void> push(CategoryEntity category) async {
    await _dio.post<void>('/categories', data: category.toJson());
  }
}
