import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitwallet/core/theme/app_colors.dart';
import 'package:habitwallet/core/widgets/charts/chart_types.dart';
import 'package:habitwallet/core/widgets/charts/diverging_bar_chart.dart';
import 'package:habitwallet/features/transactions/domain/transaction_entity.dart';
import 'package:habitwallet/features/transactions/presentation/providers/transaction_providers.dart';
import 'package:intl/intl.dart';

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  ChartPeriod _selectedPeriod = ChartPeriod.daily;

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: transactionsAsync.when(
        data: (transactions) {
          if (transactions.isEmpty) {
            return const Center(child: Text('No transactions to analyze'));
          }

          final chartData = _aggregateData(transactions, _selectedPeriod);

          return SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Financial Overview',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                ),
                const SizedBox(height: 16),
                _PeriodSelector(
                  selected: _selectedPeriod,
                  onChanged: (period) =>
                      setState(() => _selectedPeriod = period),
                ),
                const SizedBox(height: 24),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        Container(
                          height: 300,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Theme.of(
                                context,
                              ).dividerColor.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Income vs Expense',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.titleMedium,
                                  ),
                                  // Could add totals here
                                ],
                              ),
                              const SizedBox(height: 24),
                              Expanded(
                                child: DivergingBarChart(
                                  data: chartData,
                                  period: _selectedPeriod,
                                  incomeColor: AppColors.success,
                                  expenseColor: AppColors.error,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
      ),
    );
  }

  List<ChartPoint> _aggregateData(
    List<TransactionEntity> transactions,
    ChartPeriod period,
  ) {
    final groupedIncome = <String, double>{};
    final groupedExpense = <String, double>{};
    final dates = <String, DateTime>{};

    for (var tx in transactions) {
      final dateKey = _getDateKey(tx.timestamp, period);
      if (!dates.containsKey(dateKey)) {
        dates[dateKey] = _normalizeDate(tx.timestamp, period);
      }

      if (tx.isIncome) {
        groupedIncome[dateKey] = (groupedIncome[dateKey] ?? 0) + tx.amount;
      } else {
        groupedExpense[dateKey] = (groupedExpense[dateKey] ?? 0) + tx.amount;
      }
    }

    final allKeys = {...groupedIncome.keys, ...groupedExpense.keys}.toList()
      ..sort((a, b) => dates[a]!.compareTo(dates[b]!));

    final result = <ChartPoint>[];
    for (var key in allKeys) {
      final date = dates[key]!;
      final inc = groupedIncome[key] ?? 0;
      final exp = groupedExpense[key] ?? 0;

      result.add(ChartPoint(date: date, income: inc, expense: exp));
    }
    return result;
  }

  DateTime _normalizeDate(DateTime date, ChartPeriod period) {
    switch (period) {
      case ChartPeriod.daily:
        return DateTime(date.year, date.month, date.day);
      case ChartPeriod.weekly:
        // Start of week (Monday)
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        return DateTime(startOfWeek.year, startOfWeek.month, startOfWeek.day);
      case ChartPeriod.monthly:
        return DateTime(date.year, date.month);
      case ChartPeriod.yearly:
        return DateTime(date.year);
    }
  }

  String _getDateKey(DateTime date, ChartPeriod period) {
    switch (period) {
      case ChartPeriod.daily:
        return '${date.year}-${date.month}-${date.day}';
      case ChartPeriod.weekly:
        // Use week number or start date string
        final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
        return '${startOfWeek.year}-W${_weekNumber(startOfWeek)}';
      case ChartPeriod.monthly:
        return '${date.year}-${date.month}';
      case ChartPeriod.yearly:
        return '${date.year}';
    }
  }

  int _weekNumber(DateTime date) {
    // Simple week number calc
    final dayOfYear = int.parse(DateFormat('D').format(date));
    return ((dayOfYear - date.weekday + 10) / 7).floor();
  }
}

class _PeriodSelector extends StatelessWidget {
  const _PeriodSelector({required this.selected, required this.onChanged});

  final ChartPeriod selected;
  final ValueChanged<ChartPeriod> onChanged;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: ChartPeriod.values.map((period) {
          final isSelected = selected == period;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ChoiceChip(
              label: Text(period.name.toUpperCase()),
              selected: isSelected,
              onSelected: (_) => onChanged(period),
              labelStyle: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? Colors.white : AppColors.grey600,
              ),
              selectedColor: AppColors.primary,
              backgroundColor: Theme.of(context).cardColor,
              // Remove checkmark
              showCheckmark: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: isSelected ? Colors.transparent : AppColors.grey300,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
