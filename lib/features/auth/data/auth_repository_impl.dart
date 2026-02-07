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
    // Auth Lifecycle: Write Flow
    // 1. Validate credentials (stub)
    // 2. Clear stale session records
    // 3. Persist new session if requested
    if (pin == '1234') {
      final session = AuthSession(email: email, rememberMe: rememberMe);

      if (rememberMe) {
        await saveSession(session);
      } else {
        // If not rememberMe, ensure storage is clean of previous sessions
        await clearSession();
      }

      return session;
    } else {
      throw const AuthFailure('Invalid PIN. Please try again.');
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
