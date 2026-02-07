import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../domain/auth_repository.dart';
import 'auth_repository_impl.dart';

part 'auth_repository_provider.g.dart';

/// Provider for the AuthRepository interface.
@riverpod
AuthRepository authRepository(Ref ref) {
  return AuthRepositoryImpl();
}
