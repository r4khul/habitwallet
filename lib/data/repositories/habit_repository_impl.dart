import '../../domain/entities/habit.dart';
import '../../domain/repositories/habit_repository.dart';
import '../sources/habit_local_source.dart';

/// Data Repository Implementation: Concrete implementation of the domain repository.
/// Orchestrates data flow between local/remote sources and maps to domain entities.
class HabitRepositoryImpl implements HabitRepository {
  HabitRepositoryImpl(this._localSource);

  final HabitLocalSource _localSource;

  @override
  Future<List<Habit>> getHabits() async {
    final models = await _localSource.getHabits();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> saveHabit(Habit habit) {
    // Mapping model logic would go here
    return _localSource.saveHabit(habit.id);
  }

  @override
  Future<void> deleteHabit(String id) {
    return _localSource.deleteHabit(id);
  }
}
