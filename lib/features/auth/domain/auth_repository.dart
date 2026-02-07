import 'auth_session.dart';

/// Auth Feature Domain: Interface for authentication operations.
/// Boundary Rules: Pure Dart only.
abstract class AuthRepository {
  /// Retrieves the current active session, if any.
  Future<AuthSession?> getSession();

  /// Persists a new or updated [session].
  Future<void> saveSession(AuthSession session);

  /// Removes the current active session.
  Future<void> clearSession();
}
