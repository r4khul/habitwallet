import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_summary.freezed.dart';

@freezed
abstract class TransactionSummary with _$TransactionSummary {
  const factory TransactionSummary({
    required double totalIncome,
    required double totalExpense,
    required double net,
    required Map<String, double> categoryBreakdown,
  }) = _TransactionSummary;
}
