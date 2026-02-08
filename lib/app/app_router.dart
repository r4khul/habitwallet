import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/analytics/presentation/financial_overview_page.dart';
import '../features/auth/presentation/login_page.dart';
import '../features/auth/presentation/providers/auth_providers.dart';
import '../features/categories/presentation/categories_page.dart';
import '../features/profile/presentation/profile_edit_page.dart';
import '../features/settings/presentation/settings_page.dart';
import '../features/transactions/presentation/add_edit_transaction_page.dart';
import '../features/transactions/presentation/transaction_details_page.dart';
import '../features/transactions/presentation/transactions_page.dart';
import '../features/auth/presentation/splash_page.dart';

part 'app_router.g.dart';

/// App Router Provider: Integrated with Authentication State.
/// Responsibility:
/// - Rebuilds the router whenever the [authControllerProvider] state evolves.
/// - Handles deterministic redirection (Guard) for protected routes.
/// - Preserves deep-link intentions during authentication transitions.
@riverpod
GoRouter router(Ref ref) {
  final authState = ref.watch(authControllerProvider);
  final isNewUserAsync = ref.watch(isNewUserProvider);

  return GoRouter(
    initialLocation: '/',
    // Refresh the router when auth or new user status changes
    refreshListenable: Listenable.merge([
      authState.when(
        data: (_) => ValueNotifier(0),
        error: (e, s) => ValueNotifier(0),
        loading: () => ValueNotifier(0),
      ),
      isNewUserAsync.when(
        data: (_) => ValueNotifier(0),
        error: (e, s) => ValueNotifier(0),
        loading: () => ValueNotifier(0),
      ),
    ]),
    redirect: (context, state) {
      // 1. Wait for both initial session and "new user" check to complete.
      // While loading, we stay at the initial location (Home).
      // The native splash screen will still be visible if the app is starting.
      if (authState.isLoading || isNewUserAsync.isLoading) {
        return state.matchedLocation == '/' ? null : '/';
      }

      if (authState.hasError || isNewUserAsync.hasError) return null;

      final session = authState.value;
      final isNew = isNewUserAsync.value ?? true;
      final isLoggingIn = state.matchedLocation == '/login';

      // 2. Auth Redirection Logic
      if (session == null) {
        // If the user has never registered, force them to Auth (Login/Register)
        if (isNew) {
          if (isLoggingIn) return null;
          return '/login';
        }

        // If the user is returning but has no active session, allow them to stay at Home
        // (Local access). If they are at Login, they can browse back to Home.
        return null;
      }

      // 3. Authenticated Redirection
      // Prevent authenticated users from staying at Login
      if (isLoggingIn) {
        final destination = state.uri.queryParameters['from'] ?? '/home';
        return destination == '/login' ? '/home' : destination;
      }

      // 4. Final Departure from Splash
      // If we are still at splash but not loading, go to home
      if (state.matchedLocation == '/') {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/analytics',
        builder: (context, state) => const FinancialOverviewPage(),
      ),
      GoRoute(path: '/', builder: (context, state) => const SplashPage()),
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
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileEditPage(),
      ),
    ],
  );
}
