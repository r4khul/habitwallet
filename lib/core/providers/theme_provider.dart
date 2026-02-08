import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_provider.g.dart';

/// Theme Controller: Manages the application's overall theme mode.
/// Responsibility:
/// - Persists/recovers theme preference (future enhancement).
/// - Provides deterministic switching between light, dark, and system modes.
@riverpod
class ThemeController extends _$ThemeController {
  @override
  ThemeMode build() {
    // Default to dark mode as per refined design aesthetics
    return ThemeMode.dark;
  }

  /// Sets the application theme mode.
  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  /// Toggles between light and dark modes.
  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}
