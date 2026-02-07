// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// State Provider for the current active authentication session.

@ProviderFor(authSession)
final authSessionProvider = AuthSessionProvider._();

/// State Provider for the current active authentication session.

final class AuthSessionProvider
    extends
        $FunctionalProvider<
          AsyncValue<AuthSession?>,
          AuthSession?,
          FutureOr<AuthSession?>
        >
    with $FutureModifier<AuthSession?>, $FutureProvider<AuthSession?> {
  /// State Provider for the current active authentication session.
  AuthSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authSessionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authSessionHash();

  @$internal
  @override
  $FutureProviderElement<AuthSession?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AuthSession?> create(Ref ref) {
    return authSession(ref);
  }
}

String _$authSessionHash() => r'6b0825181771baa6191ba0b2ca5ae45f79e4257d';
