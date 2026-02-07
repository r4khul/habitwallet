import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/habit.dart';

part 'habit_provider.g.dart';

/// Presentation Provider: Manages the state for the Habit UI.
/// Interacts with the Domain layer (Repositories/Entities).
@riverpod
class HabitList extends _$HabitList {
  @override
  FutureOr<List<Habit>> build() async {
    // State initialization logic
    return [];
  }

  Future<void> addHabit(String title) async {
    // Interaction with repository
  }
}
