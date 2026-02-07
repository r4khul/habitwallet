import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: HabitWalletApp()));
}

class HabitWalletApp extends StatelessWidget {
  const HabitWalletApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp();
  }
}
