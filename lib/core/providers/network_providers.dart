import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'shared_preferences_provider.dart';

part 'network_providers.g.dart';

@riverpod
class BaseUrlController extends _$BaseUrlController {
  static const _key = 'base_url';
  static const _defaultUrl =
      'https://unprohibitive-emelia-tactilely.ngrok-free.dev';

  @override
  String build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    return prefs.getString(_key) ?? _defaultUrl;
  }

  Future<void> setUrl(String url) async {
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_key, url);
    state = url;
  }
}

@riverpod
Dio dio(Ref ref) {
  final baseUrl = ref.watch(baseUrlControllerProvider);
  final dio = Dio(BaseOptions(baseUrl: baseUrl));

  dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true));

  return dio;
}
