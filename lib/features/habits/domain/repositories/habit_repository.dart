import '../entities/habit.dart';

/// Domain Repository Interface: Defines how the app interacts with Habit data.
/// Boundary Rules:
/// - Pure Dart only.
/// - Implementation is handled in the Data layer.
abstract class HabitRepository {
  Future<List<Habit>> getHabits();
  Future<void> saveHabit(Habit habit);
  Future<void> deleteHabit(String id);
}
