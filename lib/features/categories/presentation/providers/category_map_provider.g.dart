// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides a Map of categories for O(1) lookups.
/// Used by lists to avoid N+1 provider lookups.

@ProviderFor(categoryMap)
final categoryMapProvider = CategoryMapProvider._();

/// Provides a Map of categories for O(1) lookups.
/// Used by lists to avoid N+1 provider lookups.

final class CategoryMapProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, CategoryEntity>>,
          Map<String, CategoryEntity>,
          FutureOr<Map<String, CategoryEntity>>
        >
    with
        $FutureModifier<Map<String, CategoryEntity>>,
        $FutureProvider<Map<String, CategoryEntity>> {
  /// Provides a Map of categories for O(1) lookups.
  /// Used by lists to avoid N+1 provider lookups.
  CategoryMapProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryMapProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryMapHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, CategoryEntity>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, CategoryEntity>> create(Ref ref) {
    return categoryMap(ref);
  }
}

String _$categoryMapHash() => r'ee186787d77d8bbe5746b6cab4a3c4ee10018452';
