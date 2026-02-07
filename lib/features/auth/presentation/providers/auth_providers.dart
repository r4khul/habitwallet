import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository_provider.dart';
import '../../domain/auth_session.dart';

part 'auth_providers.g.dart';

/// Application State: Manages the global authentication session.
/// Responsibility: Exposes the current session and handles session transitions.
/// Lifecycle: App-wide (keepAlive: true).
@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  FutureOr<AuthSession?> build() {
    final repository = ref.watch(authRepositoryProvider);
    return repository.getSession();
  }

  /// Transitions the app to an unauthenticated state.
  Future<void> logout() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).clearSession();
      return null;
    });
  }
}
