import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/transaction_repository_provider.dart';
import '../../domain/transaction_repository.dart';
import 'transaction_providers.dart';

part 'sync_provider.g.dart';

/// Domain-state model for Sync.
/// Responsibility: Holds sync status and error metadata.
class SyncState {
  SyncState({required this.status, this.errorMessage, this.lastSyncTime});

  final SyncStatus status;
  final String? errorMessage;
  final DateTime? lastSyncTime;

  SyncState copyWith({
    SyncStatus? status,
    String? errorMessage,
    DateTime? lastSyncTime,
  }) {
    return SyncState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  bool get isSyncing => status == SyncStatus.syncing;
  bool get hasFailed => status == SyncStatus.failed;
}

/// Sync Controller: Orchestrates the synchronization lifecycle.
/// Guarantees:
/// - Explicit, user-initiated retries.
/// - Deterministic state transitions (idle -> syncing -> idle/failed).
/// - No automatic retry loops.
@riverpod
class SyncController extends _$SyncController {
  @override
  SyncState build() {
    return SyncState(status: SyncStatus.idle);
  }

  /// Triggers a manual synchronization.
  /// Safety Guarantees:
  /// - Idempotent: If already syncing, subsequent calls do nothing.
  /// - Error Isolation: Failures are caught and surfaced via state, not thrown to UI.
  Future<void> sync() async {
    if (state.isSyncing) return;

    // Transition to syncing state and clear previous errors
    state = SyncState(
      status: SyncStatus.syncing,
      lastSyncTime: state.lastSyncTime,
    );

    try {
      final repository = ref.read(transactionRepositoryProvider);

      // Perform the actual work in the repository layer
      await repository.syncWithRemote();

      // On success: update time and return to idle
      state = state.copyWith(
        status: SyncStatus.idle,
        lastSyncTime: DateTime.now(),
      );

      // Refresh transaction list to reflect merged remote changes
      ref.read(transactionControllerProvider.notifier).refresh();
    } on Object catch (e) {
      // On failure: local data is preserved in repository layer
      // surfacing the error for the UI to display retry button
      state = state.copyWith(
        status: SyncStatus.failed,
        errorMessage: e.toString(),
      );
    }
  }
}
