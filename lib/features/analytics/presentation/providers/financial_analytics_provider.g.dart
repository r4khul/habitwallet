// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'financial_analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provider for the selected time range state.

@ProviderFor(SelectedTimeRange)
final selectedTimeRangeProvider = SelectedTimeRangeProvider._();

/// Provider for the selected time range state.
final class SelectedTimeRangeProvider
    extends $NotifierProvider<SelectedTimeRange, TimeRange> {
  /// Provider for the selected time range state.
  SelectedTimeRangeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'selectedTimeRangeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$selectedTimeRangeHash();

  @$internal
  @override
  SelectedTimeRange create() => SelectedTimeRange();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TimeRange value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TimeRange>(value),
    );
  }
}

String _$selectedTimeRangeHash() => r'18fdaf83bc2a2798550ee3a886e405eacc9c05b5';

/// Provider for the selected time range state.

abstract class _$SelectedTimeRange extends $Notifier<TimeRange> {
  TimeRange build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<TimeRange, TimeRange>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<TimeRange, TimeRange>,
              TimeRange,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Provider for the aggregated financial summary.
/// Reacts to both time range and transaction/category changes.

@ProviderFor(financialSummary)
final financialSummaryProvider = FinancialSummaryProvider._();

/// Provider for the aggregated financial summary.
/// Reacts to both time range and transaction/category changes.

final class FinancialSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<FinancialSummary>,
          FinancialSummary,
          FutureOr<FinancialSummary>
        >
    with $FutureModifier<FinancialSummary>, $FutureProvider<FinancialSummary> {
  /// Provider for the aggregated financial summary.
  /// Reacts to both time range and transaction/category changes.
  FinancialSummaryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'financialSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$financialSummaryHash();

  @$internal
  @override
  $FutureProviderElement<FinancialSummary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<FinancialSummary> create(Ref ref) {
    return financialSummary(ref);
  }
}

String _$financialSummaryHash() => r'c2279096ec6582d8c1d945b859847eae01c9afe9';
