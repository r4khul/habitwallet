import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';

/// Domain Entity: Simple value object representing a budget category.
/// Boundary Rules: Pure Dart only, immutable.
@freezed
abstract class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({required String name}) = _CategoryEntity;
}
