import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Presentation Page: Main screen for viewing habits.
/// Should only contain UI logic and listen to providers.
class HabitsPage extends ConsumerWidget {
  const HabitsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Habits')),
      body: const Center(child: Text('Start building healthy habits!')),
    );
  }
}
