import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitwallet/core/providers/shared_preferences_provider.dart';
import 'package:habitwallet/core/providers/sync_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_router.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/util/notification_service.dart';
import 'features/settings/presentation/providers/notification_provider.dart';

void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Parallel initialization for faster startup
  final results = await Future.wait([
    SharedPreferences.getInstance(),
    NotificationService().init().then((_) => null),
  ]);

  final prefs = results[0] as SharedPreferences;

  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      child: const HabitWalletApp(),
    ),
  );
}

class HabitWalletApp extends ConsumerStatefulWidget {
  const HabitWalletApp({super.key});

  @override
  ConsumerState<HabitWalletApp> createState() => _HabitWalletAppState();
}

class _HabitWalletAppState extends ConsumerState<HabitWalletApp>
    with WidgetsBindingObserver {
  // Cache platform brightness to avoid constant MediaQuery lookups
  Brightness? _platformBrightness;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // Only rebuild when platform brightness actually changes
    final newBrightness =
        WidgetsBinding.instance.platformDispatcher.platformBrightness;
    if (_platformBrightness != newBrightness) {
      setState(() {
        _platformBrightness = newBrightness;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final routerConfig = ref.watch(routerProvider);
    final themeMode = ref.watch(themeControllerProvider);

    // Initialize notification listener (does not cause rebuild)
    ref.watch(notificationControllerProvider);

    // Trigger background sync on start (does not cause rebuild)
    ref.watch(syncControllerProvider);

    // Remove splash screen once the initial auth state is ready
    ref.listen(routerProvider, (prev, next) {
      FlutterNativeSplash.remove();
    });

    // Use cached brightness or get initial value
    _platformBrightness ??=
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final isDarkMode =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            _platformBrightness == Brightness.dark);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDarkMode
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: MaterialApp.router(
        title: 'Habit Wallet',
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        themeMode: themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
      ),
    );
  }
}
