// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Feature State: Manages the collection of categories.
/// Responsibility: Provides an observable list of categories.
/// Ownership: Feature state; calls repository only.

@ProviderFor(CategoryController)
final categoryControllerProvider = CategoryControllerProvider._();

/// Feature State: Manages the collection of categories.
/// Responsibility: Provides an observable list of categories.
/// Ownership: Feature state; calls repository only.
final class CategoryControllerProvider
    extends $AsyncNotifierProvider<CategoryController, List<CategoryEntity>> {
  /// Feature State: Manages the collection of categories.
  /// Responsibility: Provides an observable list of categories.
  /// Ownership: Feature state; calls repository only.
  CategoryControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryControllerHash();

  @$internal
  @override
  CategoryController create() => CategoryController();
}

String _$categoryControllerHash() =>
    r'8db86742d631ba20e5eff7a18088a947ef21483a';

/// Feature State: Manages the collection of categories.
/// Responsibility: Provides an observable list of categories.
/// Ownership: Feature state; calls repository only.

abstract class _$CategoryController
    extends $AsyncNotifier<List<CategoryEntity>> {
  FutureOr<List<CategoryEntity>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<CategoryEntity>>, List<CategoryEntity>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CategoryEntity>>,
                List<CategoryEntity>
              >,
              AsyncValue<List<CategoryEntity>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
