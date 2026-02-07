import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/auth_repository_provider.dart';
import '../../domain/auth_session.dart';

part 'auth_providers.g.dart';

/// State Provider for the current active authentication session.
@riverpod
Future<AuthSession?> authSession(Ref ref) {
  final repository = ref.watch(authRepositoryProvider);
  return repository.getSession();
}
