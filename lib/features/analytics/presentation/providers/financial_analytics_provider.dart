import 'dart:isolate';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../categories/presentation/providers/category_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../domain/financial_aggregator.dart';
import '../../domain/financial_data_models.dart';

part 'financial_analytics_provider.g.dart';

/// Provider for the selected time range state.
@riverpod
class SelectedTimeRange extends _$SelectedTimeRange {
  @override
  TimeRange build() => TimeRange.monthly;

  void setRange(TimeRange range) {
    state = range;
  }
}

/// Provider for the aggregated financial summary.
/// Reacts to both time range and transaction/category changes.
@riverpod
Future<FinancialSummary> financialSummary(Ref ref) async {
  final range = ref.watch(selectedTimeRangeProvider);
  final transactions = await ref.watch(transactionControllerProvider.future);
  final categories = await ref.watch(categoryControllerProvider.future);

  // Calculate in background isolate to unblock UI thread
  return Isolate.run(() {
    const aggregator = FinancialAggregator();
    return aggregator.aggregate(
      transactions: transactions,
      categories: categories,
      range: range,
    );
  });
}
