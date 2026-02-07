import 'package:go_router/go_router.dart';
import '../features/habits/presentation/pages/habits_page.dart';

/// App Router: Application-wide routing configuration.
/// This layer assembles routes from various features.
final router = GoRouter(
  initialLocation: '/',
  routes: [GoRoute(path: '/', builder: (context, state) => const HabitsPage())],
);
