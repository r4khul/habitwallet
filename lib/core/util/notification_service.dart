import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._internal();
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // 1. Initialize Timezones
    tz.initializeTimeZones();

    var locationName = 'UTC';
    try {
      final timeZoneName = (await FlutterTimezone.getLocalTimezone())
          .toString();

      // Handle cases where the returned value is a wrapped string like "TimezoneInfo(Asia/Kolkata, ...)"
      if (timeZoneName.contains('(') && timeZoneName.contains(')')) {
        final startIndex = timeZoneName.indexOf('(') + 1;
        final commaIndex = timeZoneName.indexOf(',');
        final endIndex = timeZoneName.indexOf(')');

        if (commaIndex != -1 && commaIndex > startIndex) {
          locationName = timeZoneName.substring(startIndex, commaIndex).trim();
        } else if (endIndex > startIndex) {
          locationName = timeZoneName.substring(startIndex, endIndex).trim();
        } else {
          locationName = timeZoneName;
        }
      } else {
        locationName = timeZoneName;
      }

      tz.setLocalLocation(tz.getLocation(locationName));
    } on Object catch (e) {
      debugPrint(
        'NotificationService: Failed to set local location "$locationName", falling back to UTC: $e',
      );
      tz.setLocalLocation(tz.getLocation('UTC'));
    }

    // 2. Android settings
    const androidSettings = AndroidInitializationSettings(
      '@mipmap/launcher_icon',
    );

    // 3. iOS settings
    const iosSettings = DarwinInitializationSettings();

    final initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // v20+ uses named parameter 'settings'
    await _notifications.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (details) {
        // Handle notification click if needed
      },
    );

    // Request permissions for Android 13+
    if (Platform.isAndroid) {
      await _notifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.requestNotificationsPermission();
    }
  }

  /// Generates a stable, unique ID for a specific date.
  /// This allows us to target and cancel a specific day's notification.
  int _getNotificationIdForDate(DateTime date) {
    // Using a simple hash that fits in 32-bit int
    // Result = (Year % 10 * 400) + dayOfYear
    final jan1 = DateTime(date.year, 1, 1);
    final dayOfYear = date.difference(jan1).inDays;
    return 1000 + ((date.year % 10) * 400) + dayOfYear;
  }

  Future<void> scheduleDailyReminder({
    required TimeOfDay
    time, // This will be ignored in favor of hardcoded 8 PM, keeping sig for compatibility or refactor
    required Set<DateTime> datesToSkip,
    int daysAhead = 14,
    bool isDebug = false, // Pass this from the controller
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    // Hardcoded to 8 PM as per new requirement
    const targetHour = 20;
    const targetMinute = 0;

    for (var i = 0; i < daysAhead; i++) {
      final targetDate = now.add(Duration(days: i));
      final notificationId = _getNotificationIdForDate(targetDate);

      final isToday = i == 0;
      final skipThisDate = datesToSkip.any(
        (d) =>
            d.year == targetDate.year &&
            d.month == targetDate.month &&
            d.day == targetDate.day,
      );

      if (skipThisDate) {
        await _notifications.cancel(id: notificationId);
        continue;
      }

      var scheduledDate = tz.TZDateTime(
        tz.local,
        targetDate.year,
        targetDate.month,
        targetDate.day,
        targetHour,
        targetMinute,
      );

      // Special logic for TODAY
      if (isToday) {
        // If time passed
        if (scheduledDate.isBefore(now)) {
          if (isDebug) {
            // DEBUG: Schedule for now + 60 seconds
            scheduledDate = now.add(const Duration(seconds: 5));
          } else {
            // RELEASE: Missed the slot, move to tomorrow (or just skip loop iteration as tomorrow is covered by i=1)
            continue;
          }
        }
      }

      await _notifications.zonedSchedule(
        id: notificationId,
        title: 'Daily Check-in 📝',
        body: "Don't forget to track your income or expenses today!",
        scheduledDate: scheduledDate,
        notificationDetails: const NotificationDetails(
          android: AndroidNotificationDetails(
            'daily_no_tx_reminder',
            'Transaction Reminders',
            channelDescription: 'Notifies you if no transactions were logged',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        // Switch to inexact to avoid crash without permission
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      );
    }
  }

  Future<void> cancelReminderForDate(DateTime date) async {
    final id = _getNotificationIdForDate(date);
    await _notifications.cancel(id: id);
  }

  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  Future<void> cancelById(int id) async {
    await _notifications.cancel(id: id);
  }
}
