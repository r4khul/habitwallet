import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app_router.dart';

void main() {
  runApp(const ProviderScope(child: HabitWalletApp()));
}

class HabitWalletApp extends ConsumerWidget {
  const HabitWalletApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routerConfig = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Habit Wallet',
      debugShowCheckedModeBanner: false,
      routerConfig: routerConfig,
      theme: ThemeData(fontFamily: 'Chillax', useMaterial3: true),
    );
  }
}
