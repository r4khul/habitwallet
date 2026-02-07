import '../domain/auth_repository.dart';
import '../domain/auth_session.dart';

/// Auth Feature Data: Implementation of AuthRepository.
/// This layer handles authentication logic and data persistence.
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<AuthSession?> getSession() async {
    return null; // Stub
  }

  @override
  Future<void> saveSession(AuthSession session) async {
    // Stub
  }

  @override
  Future<void> clearSession() async {
    // Stub
  }
}
