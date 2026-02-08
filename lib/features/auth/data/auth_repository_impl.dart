import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../core/error/failures.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_session.dart';

/// Auth Feature Data: Implementation of AuthRepository.
/// Uses [FlutterSecureStorage] for persistency.
class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;
  static const _sessionKey = 'auth_session';
  static const _registryKey = 'user_registry';

  @override
  Future<AuthSession?> getSession() async {
    try {
      final jsonString = await _storage.read(key: _sessionKey);
      if (jsonString == null) return null;
      return AuthSession.fromJson(
        jsonDecode(jsonString) as Map<String, dynamic>,
      );
    } on Object catch (_) {
      throw const AuthFailure('Failed to retrieve authentication session.');
    }
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    try {
      final jsonString = jsonEncode(session.toJson());
      await _storage.write(key: _sessionKey, value: jsonString);
    } on Object catch (_) {
      throw const AuthFailure('Failed to persist authentication session.');
    }
  }

  @override
  Future<AuthSession> login({
    required String email,
    required String pin,
    required bool rememberMe,
  }) async {
    try {
      // 1. Get user registry
      final registryJson = await _storage.read(key: _registryKey);
      Map<String, String> registry = {};
      if (registryJson != null) {
        registry = Map<String, String>.from(
          jsonDecode(registryJson) as Map<dynamic, dynamic>,
        );
      }

      // 2. Check if user exists and validate/register
      if (registry.containsKey(email)) {
        if (registry[email] != pin) {
          throw const AuthFailure('Invalid PIN for this email.');
        }
      } else {
        // Register new user
        registry[email] = pin;
        await _storage.write(key: _registryKey, value: jsonEncode(registry));
      }

      // 3. Create and persist session
      final session = AuthSession(email: email, rememberMe: rememberMe);

      if (rememberMe) {
        await saveSession(session);
      } else {
        await clearSession();
      }

      return session;
    } on AuthFailure {
      rethrow;
    } on Object catch (e) {
      throw AuthFailure('Authentication error: ${e.toString()}');
    }
  }

  @override
  Future<void> clearSession() async {
    try {
      await _storage.delete(key: _sessionKey);
    } on Object catch (_) {
      throw const AuthFailure('Failed to clear authentication session.');
    }
  }
}
