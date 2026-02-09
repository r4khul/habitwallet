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
    return data
        .map((item) => CategoryEntity.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> push(CategoryEntity category) async {
    await _dio.post<void>('/categories', data: category.toJson());
  }
}
