import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/categories/presentation/categories_page.dart';
import '../features/transactions/presentation/add_edit_transaction_page.dart';
import '../features/transactions/presentation/transaction_details_page.dart';
import '../features/transactions/presentation/transactions_page.dart';

part 'app_router.g.dart';

/// App Router Provider: Integrated with Authentication State.
/// Responsibility:
/// - Rebuilds the router whenever the [authControllerProvider] state evolves.
/// - Handles deterministic redirection (Guard) for protected routes.
/// - Preserves deep-link intentions during authentication transitions.
@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authControllerProvider);

  return GoRouter(
    initialLocation: '/home',
    // Refresh the router when auth state changes (loading -> data/error)
    refreshListenable: authState.when(
      data: (_) => null,
      error: (e, s) => null,
      loading: () => null,
    ),
    redirect: (context, state) {
      // Deterministic Startup: Wait for the initial session check to complete.
      if (authState.isLoading || authState.hasError) return null;

      final session = authState.value;
      final isLoggingIn = state.matchedLocation == '/login';

      // Accessing path to preserve deep links
      final fromLocation = state.uri.toString();

      if (session == null) {
        // Auth Redirection: Protected -> Login
        // Avoid infinite loop if already at /login
        if (isLoggingIn) return null;

        // Preserve original intent for post-login redirection
        return '/login?from=$fromLocation';
      }

      // Auth Redirection: Authenticated -> Home (or preserved intent)
      if (isLoggingIn) {
        final destination = state.uri.queryParameters['from'] ?? '/home';
        // Ensure we don't redirect to /login again if 'from' was corrupted
        return destination == '/login' ? '/home' : destination;
      }

      // Allow access to protected routes
      return null;
    },
    routes: [
      GoRoute(path: '/', redirect: (context, state) => '/home'),
      GoRoute(
        path: '/home',
        builder: (context, state) => const TransactionsPage(),
      ),
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(
        path: '/add-tx',
        builder: (context, state) => const AddEditTransactionPage(),
      ),
      GoRoute(
        path: '/edit-tx/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AddEditTransactionPage(transactionId: id);
        },
      ),
      GoRoute(
        path: '/tx/:id',
        builder: (context, state) =>
            TransactionDetailsPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/categories',
        builder: (context, state) => const CategoriesPage(),
      ),
    ],
  );
}
