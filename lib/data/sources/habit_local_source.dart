import '../models/habit_model.dart';

/// Data Source: Direct interface with the database or API.
abstract class HabitLocalSource {
  Future<List<HabitModel>> getHabits();
  Future<void> saveHabit(String id);
  Future<void> deleteHabit(String id);
}
