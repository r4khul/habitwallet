import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../features/categories/data/category_repository_provider.dart';
import '../../features/transactions/data/transaction_repository_provider.dart';

part 'sync_provider.g.dart';

@riverpod
class SyncController extends _$SyncController {
  @override
  void build() {
    // Background sync on start.
    // We don't await it here to avoid blocking startup.
    Future.microtask(syncAll);
  }

  Future<void> syncAll() async {
    final txRepo = ref.read(transactionRepositoryProvider);
    final catRepo = ref.read(categoryRepositoryProvider);

    // Sync categories first to ensure they exist for transactions
    try {
      await catRepo.syncWithRemote();
      await txRepo.syncWithRemote();
    } on Object catch (_) {
      // Errors are handled in repos
    }
  }
}
