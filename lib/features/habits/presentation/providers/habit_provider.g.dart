// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Presentation Provider: Manages the state for the Habit UI.
/// Boundary Rules:
/// - Interacts with the Domain layer (Repositories/Entities) only.
/// - NEVER accesses Data layer models, DAOs, or databases directly.

@ProviderFor(HabitList)
final habitListProvider = HabitListProvider._();

/// Presentation Provider: Manages the state for the Habit UI.
/// Boundary Rules:
/// - Interacts with the Domain layer (Repositories/Entities) only.
/// - NEVER accesses Data layer models, DAOs, or databases directly.
final class HabitListProvider
    extends $AsyncNotifierProvider<HabitList, List<Habit>> {
  /// Presentation Provider: Manages the state for the Habit UI.
  /// Boundary Rules:
  /// - Interacts with the Domain layer (Repositories/Entities) only.
  /// - NEVER accesses Data layer models, DAOs, or databases directly.
  HabitListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'habitListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$habitListHash();

  @$internal
  @override
  HabitList create() => HabitList();
}

String _$habitListHash() => r'3da2d4c9e3fc8979a84f7fe943895d33221dbc0f';

/// Presentation Provider: Manages the state for the Habit UI.
/// Boundary Rules:
/// - Interacts with the Domain layer (Repositories/Entities) only.
/// - NEVER accesses Data layer models, DAOs, or databases directly.

abstract class _$HabitList extends $AsyncNotifier<List<Habit>> {
  FutureOr<List<Habit>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<Habit>>, List<Habit>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Habit>>, List<Habit>>,
              AsyncValue<List<Habit>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
