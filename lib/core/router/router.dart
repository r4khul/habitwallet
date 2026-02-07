import 'package:go_router/go_router.dart';
import '../../presentation/pages/habits_page.dart';

/// Core Router: Application-wide routing configuration.
/// Encapsulates navigation logic and deep link handling.
final router = GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => const HabitsPage())],
);
