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
  FutureOr<AuthSession?> build() async {
    // Auth Lifecycle: Read Flow (App Startup)
    // 1. Injects AuthRepository
    // 2. Attempts to recover session from secure storage
    // 3. Emits authenticated (Session) or unauthenticated (null) state
    final repository = ref.watch(authRepositoryProvider);
    return repository.getSession();
  }

  /// Retries loading the session if it failed.
  void retry() {
    ref.invalidateSelf();
  }

  /// Transitions the app to an unauthenticated state.
  Future<void> logout() async {
    // Auth Lifecycle: Clear Flow
    // 1. Removes session from secure storage via repository
    // 2. Resets local state to unauthenticated
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).clearSession();
      return null;
    });
  }

  /// Attempts to authenticate the user and updates the app state.
  Future<void> login({
    required String email,
    required String pin,
    required bool rememberMe,
  }) async {
    // Auth Lifecycle: Write Flow
    // 1. Triggers repository login (validation + persistence)
    // 2. Updates global state with the new session
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return ref
          .read(authRepositoryProvider)
          .login(email: email, pin: pin, rememberMe: rememberMe);
    });
  }
}
