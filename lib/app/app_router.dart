import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/habits/presentation/pages/habits_page.dart';

part 'app_router.g.dart';

/// App Router Provider: Rebuilds when authentication state changes.
/// Responsibility: Handles redirection logic based on session presence.
@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: authState.when(
      data: (_) => null,
      error: (e, s) => null,
      loading: () => null,
    ),
    redirect: (context, state) {
      if (authState.isLoading || authState.hasError) return null;

      final session = authState.value;
      final isLoggingIn = state.matchedLocation == '/login';

      if (session == null) {
        // Not logged in -> force login
        return isLoggingIn ? null : '/login';
      }

      if (isLoggingIn) {
        // Logged in -> redirect away from login
        return '/';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/', builder: (context, state) => const HabitsPage()),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
    ],
  );
}
