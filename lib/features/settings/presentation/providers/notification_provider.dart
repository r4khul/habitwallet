import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:habitwallet/core/util/notification_service.dart';
import 'package:habitwallet/features/settings/data/notification_repository.dart';
import 'package:habitwallet/features/settings/domain/notification_settings.dart';
import 'package:habitwallet/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'notification_provider.g.dart';

@Riverpod(keepAlive: true)
class NotificationController extends _$NotificationController {
  @override
  NotificationSettings build() {
    final repository = ref.watch(notificationRepositoryProvider);
    final settings = repository.getSettings();

    // Listen to transaction changes to update schedule
    ref.listen(transactionControllerProvider, (previous, next) {
      _updateSchedule();
    }, fireImmediately: true);

    return settings;
  }

  Future<void> _updateSchedule() async {
    final settings = state;
    final service = NotificationService();

    if (!settings.isEnabled) {
      await service.cancelAll();
      return;
    }

    // Get all dates that have transactions logged to skip reminders for those days
    final transactionsAsync = ref.read(transactionControllerProvider);

    // Don't schedule if transactions are still loading initially
    if (transactionsAsync.isLoading && !transactionsAsync.hasValue) return;
    final datesToSkip = <DateTime>{};

    if (transactionsAsync.hasValue) {
      for (final tx in transactionsAsync.value!) {
        // Normalize to date only for comparison
        final date = DateTime(
          tx.timestamp.year,
          tx.timestamp.month,
          tx.timestamp.day,
        );
        datesToSkip.add(date);
      }
    }

    // Schedule the notifications for the next 14 days
    // Individual days will be skipped if they are in datesToSkip
    await service.scheduleDailyReminder(
      time: settings.reminderTime,
      datesToSkip: datesToSkip,
      isDebug: kDebugMode,
    );
  }

  Future<void> toggleEnabled(bool value) async {
    state = state.copyWith(isEnabled: value);
    await ref.read(notificationRepositoryProvider).saveSettings(state);
    await _updateSchedule(); // Update schedule immediately on toggle
  }

  Future<void> updateTime(TimeOfDay time) async {
    state = state.copyWith(reminderTimeStr: '${time.hour}:${time.minute}');
    await ref.read(notificationRepositoryProvider).saveSettings(state);
    await _updateSchedule(); // Update schedule immediately on time change
  }
}
