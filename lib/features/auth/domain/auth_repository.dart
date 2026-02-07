import 'auth_session.dart';

/// Auth Feature Domain: Interface for authentication operations.
/// Boundary Rules: Pure Dart only.
abstract class AuthRepository {
  /// Retrieves the current active session, if any.
  Future<AuthSession?> getSession();

  /// Persists a new or updated [session].
  Future<void> saveSession(AuthSession session);

  /// Authenticates a user with [email] and [pin].
  Future<AuthSession> login({
    required String email,
    required String pin,
    required bool rememberMe,
  });

  /// Removes the current active session.
  Future<void> clearSession();
}
