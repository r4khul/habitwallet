// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Theme Controller: Manages the application's overall theme mode.
/// Responsibility:
/// - Persists/recovers theme preference (future enhancement).
/// - Provides deterministic switching between light, dark, and system modes.

@ProviderFor(ThemeController)
final themeControllerProvider = ThemeControllerProvider._();

/// Theme Controller: Manages the application's overall theme mode.
/// Responsibility:
/// - Persists/recovers theme preference (future enhancement).
/// - Provides deterministic switching between light, dark, and system modes.
final class ThemeControllerProvider
    extends $NotifierProvider<ThemeController, ThemeMode> {
  /// Theme Controller: Manages the application's overall theme mode.
  /// Responsibility:
  /// - Persists/recovers theme preference (future enhancement).
  /// - Provides deterministic switching between light, dark, and system modes.
  ThemeControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeControllerHash();

  @$internal
  @override
  ThemeController create() => ThemeController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeControllerHash() => r'ba94892748b5c1941f7dc8956222cd0ea9ae5308';

/// Theme Controller: Manages the application's overall theme mode.
/// Responsibility:
/// - Persists/recovers theme preference (future enhancement).
/// - Provides deterministic switching between light, dark, and system modes.

abstract class _$ThemeController extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
