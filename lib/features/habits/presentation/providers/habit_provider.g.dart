// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Feature State: Manages the collection of habits.
/// Responsibility: Provides an observable list of habits and handles habit logic.
/// Ownership: Feature logic; calls repository only.

@ProviderFor(HabitList)
final habitListProvider = HabitListProvider._();

/// Feature State: Manages the collection of habits.
/// Responsibility: Provides an observable list of habits and handles habit logic.
/// Ownership: Feature logic; calls repository only.
final class HabitListProvider
    extends $AsyncNotifierProvider<HabitList, List<Habit>> {
  /// Feature State: Manages the collection of habits.
  /// Responsibility: Provides an observable list of habits and handles habit logic.
  /// Ownership: Feature logic; calls repository only.
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

/// Feature State: Manages the collection of habits.
/// Responsibility: Provides an observable list of habits and handles habit logic.
/// Ownership: Feature logic; calls repository only.

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
