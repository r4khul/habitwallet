// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Sync Controller: Orchestrates the synchronization lifecycle.
/// Guarantees:
/// - Explicit, user-initiated retries.
/// - Deterministic state transitions (idle -> syncing -> idle/failed).
/// - No automatic retry loops.

@ProviderFor(SyncController)
final syncControllerProvider = SyncControllerProvider._();

/// Sync Controller: Orchestrates the synchronization lifecycle.
/// Guarantees:
/// - Explicit, user-initiated retries.
/// - Deterministic state transitions (idle -> syncing -> idle/failed).
/// - No automatic retry loops.
final class SyncControllerProvider
    extends $NotifierProvider<SyncController, SyncState> {
  /// Sync Controller: Orchestrates the synchronization lifecycle.
  /// Guarantees:
  /// - Explicit, user-initiated retries.
  /// - Deterministic state transitions (idle -> syncing -> idle/failed).
  /// - No automatic retry loops.
  SyncControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncControllerHash();

  @$internal
  @override
  SyncController create() => SyncController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncState>(value),
    );
  }
}

String _$syncControllerHash() => r'427113b70e2ed3271a2b87c04c91b29502b41e10';

/// Sync Controller: Orchestrates the synchronization lifecycle.
/// Guarantees:
/// - Explicit, user-initiated retries.
/// - Deterministic state transitions (idle -> syncing -> idle/failed).
/// - No automatic retry loops.

abstract class _$SyncController extends $Notifier<SyncState> {
  SyncState build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<SyncState, SyncState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SyncState, SyncState>,
              SyncState,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
