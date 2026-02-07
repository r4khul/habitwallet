import '../domain/auth_repository.dart';
import '../domain/user.dart';

/// Auth Feature Data: Implementation of AuthRepository.
/// This layer handles authentication logic and data persistence.
class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<User?> login(String email, String password) async {
    return null; // Stub
  }

  @override
  Future<void> logout() async {
    // Stub
  }
}
