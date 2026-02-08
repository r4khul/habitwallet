import 'package:dio/dio.dart';
import '../domain/transaction_entity.dart';
import 'transaction_remote_data_source.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  TransactionRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TransactionEntity>> fetchAll() async {
    final response = await _dio.get<List<dynamic>>('/transactions');
    final data = response.data ?? [];
    return data
        .map((json) => TransactionEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> push(TransactionEntity transaction) async {
    await _dio.post<void>('/transactions', data: transaction.toJson());
  }
}
