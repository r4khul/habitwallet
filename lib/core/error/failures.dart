/// Core failure models for error handling across all layers.
/// Boundary Rules:
/// - Pure Dart only.
/// - Does not depend on any features or external frameworks.
abstract class Failure implements Exception {
  const Failure(this.message);
  final String message;

  @override
  String toString() => message;
}

/// Represents failures occurring in the remote data source.
class ServerFailure extends Failure {
  const ServerFailure([
    super.message = 'External service error. Please try again.',
  ]);
}

/// Represents failures occurring in the local persistence layer.
class DatabaseFailure extends Failure {
  const DatabaseFailure([
    super.message = 'Local storage error. Please restart the app.',
  ]);
}

/// Represents failures related to authentication.
class AuthFailure extends Failure {
  const AuthFailure([
    super.message = 'Authentication failed. Please log in again.',
  ]);
}

/// Represents failures occurring during data synchronization.
class SyncFailure extends Failure {
  const SyncFailure([
    super.message = 'Sync failed. Local data is safe, will retry later.',
  ]);
}
