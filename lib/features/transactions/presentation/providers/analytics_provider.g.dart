// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(aggregatedChartData)
final aggregatedChartDataProvider = AggregatedChartDataFamily._();

final class AggregatedChartDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ChartPoint>>,
          List<ChartPoint>,
          FutureOr<List<ChartPoint>>
        >
    with $FutureModifier<List<ChartPoint>>, $FutureProvider<List<ChartPoint>> {
  AggregatedChartDataProvider._({
    required AggregatedChartDataFamily super.from,
    required ChartPeriod super.argument,
  }) : super(
         retry: null,
         name: r'aggregatedChartDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$aggregatedChartDataHash();

  @override
  String toString() {
    return r'aggregatedChartDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<ChartPoint>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<ChartPoint>> create(Ref ref) {
    final argument = this.argument as ChartPeriod;
    return aggregatedChartData(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is AggregatedChartDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$aggregatedChartDataHash() =>
    r'ef13ab8ea5e06ae13707f230860ff19552b567e6';

final class AggregatedChartDataFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<ChartPoint>>, ChartPeriod> {
  AggregatedChartDataFamily._()
    : super(
        retry: null,
        name: r'aggregatedChartDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  AggregatedChartDataProvider call(ChartPeriod period) =>
      AggregatedChartDataProvider._(argument: period, from: this);

  @override
  String toString() => r'aggregatedChartDataProvider';
}
