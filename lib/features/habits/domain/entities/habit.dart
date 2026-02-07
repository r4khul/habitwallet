import 'package:freezed_annotation/freezed_annotation.dart';

part 'habit.freezed.dart';

/// Domain Entity: Pure Dart model representing a Habit.
/// This layer has NO dependencies on Flutter or the Data layer.
@freezed
abstract class Habit with _$Habit {
  const factory Habit({
    required String id,
    required String title,
    @Default(false) bool isCompleted,
    required DateTime createdAt,
  }) = _Habit;
}
