import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/habit.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

/// Data Model (DTO): Handles JSON serialization and data source mapping.
/// Contains logic to convert to/from Domain Entities.
@freezed
abstract class HabitModel with _$HabitModel {
  const factory HabitModel({
    required String id,
    required String title,
    required bool isCompleted,
    required String createdAt,
  }) = _HabitModel;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);

  factory HabitModel.fromEntity(Habit habit) => HabitModel(
    id: habit.id,
    title: habit.title,
    isCompleted: habit.isCompleted,
    createdAt: habit.createdAt.toIso8601String(),
  );

  const HabitModel._();

  Habit toEntity() => Habit(
    id: id,
    title: title,
    isCompleted: isCompleted,
    createdAt: DateTime.parse(createdAt),
  );
}
