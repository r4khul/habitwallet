import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';

/// Domain Entity: Pure Dart model representing a Habit.
/// Boundary Rules:
/// - Pure Dart only (no Flutter, Riverpod, or Data layer imports).
/// - No JSON serialization logic (handled in Data layer models).
@freezed
abstract class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
    required DateTime createdAt,
  }) = _Habit;
}
