import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:habitwallet/core/providers/shared_preferences_provider.dart';
import 'package:habitwallet/core/providers/sync_provider.dart';
import 'package:habitwallet/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app_router.dart';
import 'core/providers/locale_provider.dart';
import 'core/providers/theme_provider.dart';
import 'core/theme/app_theme.dart';
import 'core/util/notification_service.dart';
import 'features/settings/presentation/providers/notification_provider.dart';

/// Entry point of the Habit Wallet application.
/// Handles initialization of services, native splash screen, and root widget setup.
void main() async {
  final widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

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
    final locale = ref.watch(localeControllerProvider);

    ref.watch(notificationControllerProvider);
    ref.watch(syncControllerProvider);

    ref.listen(routerProvider, (prev, next) {
      FlutterNativeSplash.remove();
    });

    _platformBrightness ??=
        WidgetsBinding.instance.platformDispatcher.platformBrightness;

    final isDarkMode =
        themeMode == ThemeMode.dark ||
        (themeMode == ThemeMode.system &&
            _platformBrightness == Brightness.dark);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: AppTheme.getOverlayStyle(isDark: isDarkMode),
      child: MaterialApp.router(
        title: 'Habit Wallet',
        debugShowCheckedModeBanner: false,
        routerConfig: routerConfig,
        themeMode: themeMode,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        locale: locale,
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
