import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_entity.freezed.dart';

/// Domain Entity: Simple value object representing a budget category.
///
/// **Business Rules:**
/// 1. **User-Editable**: Categories are dynamic classifications created or
///    modified by the user.
/// 2. **Value Object**: Equality is based on the [name] of the category.
@freezed
abstract class CategoryEntity with _$CategoryEntity {
  const factory CategoryEntity({
    /// The display name and unique identifier for this category.
    required String name,
  }) = _CategoryEntity;
}
