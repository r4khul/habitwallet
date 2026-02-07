import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app_router.dart';

void main() {
  runApp(const ProviderScope(child: HabitWalletApp()));
}

class HabitWalletApp extends StatelessWidget {
  const HabitWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Habit Wallet',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
