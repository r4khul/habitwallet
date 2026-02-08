// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Application State: Manages the global authentication session.
/// Responsibility: Exposes the current session and handles session transitions.
/// Lifecycle: App-wide (keepAlive: true).

@ProviderFor(isNewUser)
final isNewUserProvider = IsNewUserProvider._();

/// Application State: Manages the global authentication session.
/// Responsibility: Exposes the current session and handles session transitions.
/// Lifecycle: App-wide (keepAlive: true).

final class IsNewUserProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  /// Application State: Manages the global authentication session.
  /// Responsibility: Exposes the current session and handles session transitions.
  /// Lifecycle: App-wide (keepAlive: true).
  IsNewUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isNewUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isNewUserHash();

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    return isNewUser(ref);
  }
}

String _$isNewUserHash() => r'96c7012706d0a378d06c65ead21dd6d024068b97';

@ProviderFor(AuthController)
final authControllerProvider = AuthControllerProvider._();

final class AuthControllerProvider
    extends $AsyncNotifierProvider<AuthController, AuthSession?> {
  AuthControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authControllerHash();

  @$internal
  @override
  AuthController create() => AuthController();
}

String _$authControllerHash() => r'd0bcec17a420f9fd297f1cfe25794e80d052ccb4';

abstract class _$AuthController extends $AsyncNotifier<AuthSession?> {
  FutureOr<AuthSession?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AuthSession?>, AuthSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AuthSession?>, AuthSession?>,
              AsyncValue<AuthSession?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
