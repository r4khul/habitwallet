import 'package:dio/dio.dart';
import '../domain/transaction_entity.dart';
import 'transaction_remote_data_source.dart';

class TransactionRemoteDataSourceImpl implements TransactionRemoteDataSource {
  TransactionRemoteDataSourceImpl(this._dio);

  final Dio _dio;

  @override
  Future<List<TransactionEntity>> fetchAll() async {
    try {
      final response = await _dio.get<dynamic>('/transactions');
      final data = response.data;

      // Handle null or non-list responses
      if (data == null || data is! List) return [];

      // Handle empty array
      if (data.isEmpty) return [];

      return data.expand<TransactionEntity>((json) {
        // Skip null items
        if (json == null) return [];

        if (json is Map) {
          try {
            final jsonMap = Map<String, dynamic>.from(json);

            // Validate required fields exist and are not null
            if (!jsonMap.containsKey('id') || jsonMap['id'] == null) {
              return [];
            }
            if (!jsonMap.containsKey('amount') || jsonMap['amount'] == null) {
              return [];
            }
            if (!jsonMap.containsKey('category') ||
                jsonMap['category'] == null) {
              return [];
            }
            if (!jsonMap.containsKey('ts') || jsonMap['ts'] == null) {
              return [];
            }

            return [TransactionEntity.fromJson(jsonMap)];
          } on Object catch (_) {
            // Silently skip malformed transactions
            return [];
          }
        }

        // Skip non-map items
        return [];
      }).toList();
    } on Object catch (_) {
      // Return empty list on any network or parsing error
      return [];
    }
  }

  @override
  Future<void> push(TransactionEntity transaction) async {
    await _dio.post<void>('/transactions', data: transaction.toJson());
  }
}
