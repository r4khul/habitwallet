/// Core failure models for error handling across all layers.
/// Boundary Rules:
/// - Pure Dart only.
/// - Does not depend on any features or external frameworks.
abstract class Failure {
  const Failure(this.message);
  final String message;
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server Failure']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Cache Failure']);
}
