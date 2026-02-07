import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/habit.dart';

part 'habit_provider.g.dart';

/// Feature State: Manages the collection of habits.
/// Responsibility: Provides an observable list of habits and handles habit logic.
/// Ownership: Feature logic; calls repository only.
@riverpod
class HabitList extends _$HabitList {
  @override
  FutureOr<List<Habit>> build() async {
    // In a real app, this would watch a repository:
    // final repository = ref.watch(habitRepositoryProvider);
    // return repository.getHabits();
    return [];
  }

  /// Adds a new habit and updates the state.
  Future<void> addHabit(String title) async {
    // Logic for interacting with repository and updating state
  }
}
