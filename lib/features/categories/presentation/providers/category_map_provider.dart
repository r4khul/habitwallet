import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/category_entity.dart';
import 'category_providers.dart';

part 'category_map_provider.g.dart';

/// Provides a Map of categories for O(1) lookups.
/// Used by lists to avoid N+1 provider lookups.
@riverpod
Future<Map<String, CategoryEntity>> categoryMap(Ref ref) async {
  final categories = await ref.watch(categoryControllerProvider.future);
  return {for (var c in categories) c.id: c};
}
