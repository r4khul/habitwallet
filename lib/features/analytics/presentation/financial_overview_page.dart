import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitwallet/core/theme/app_colors.dart';
import 'package:habitwallet/core/theme/app_typography.dart';
import 'package:habitwallet/features/settings/presentation/providers/currency_provider.dart';

import '../domain/financial_data_models.dart';
import 'providers/financial_analytics_provider.dart';
import 'widgets/flow_chart.dart';
import 'widgets/summary_cards.dart';
import 'widgets/time_range_selector.dart';
import 'widgets/unified_category_breakdown.dart';

/// The main Financial Overview page.
class FinancialOverviewPage extends ConsumerWidget {
  const FinancialOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedRange = ref.watch(selectedTimeRangeProvider);
    final summaryAsync = ref.watch(financialSummaryProvider);
    final currencyAsync = ref.watch(currencyControllerProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : Colors.grey[50],
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: true,
            pinned: true,
            backgroundColor: isDark
                ? AppColors.darkBackground
                : Colors.grey[50],
            elevation: 0,
            surfaceTintColor: Colors.transparent,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back_rounded,
                color: isDark ? Colors.white : AppColors.grey900,
              ),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 56, bottom: 16),
              title: Text(
                'Financial Overview',
                style: AppTypography.headlineSmall.copyWith(
                  color: isDark ? Colors.white : AppColors.grey900,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: currencyAsync.when(
              data: (currency) => summaryAsync.when(
                data: (summary) => _buildContent(
                  context,
                  ref,
                  summary,
                  selectedRange,
                  currency.symbol,
                ),
                loading: () => _buildLoadingState(context),
                error: (error, stack) => _buildErrorState(context, error),
              ),
              loading: () => _buildLoadingState(context),
              error: (error, stack) => _buildErrorState(context, error),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    FinancialSummary summary,
    TimeRange selectedRange,
    String currencySymbol,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),

        // Time Range Selector
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: TimeRangeSelector(
              selected: selectedRange,
              onChanged: (range) {
                ref.read(selectedTimeRangeProvider.notifier).setRange(range);
              },
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Net Savings Card
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: NetSavingsCard(
            netSavings: summary.netSavings,
            savingsRate: summary.savingsRate,
            isPositive: summary.isPositive,
            currencySymbol: currencySymbol,
          ),
        ),

        const SizedBox(height: 16),

        // Summary Cards Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: SummaryCard(
                  title: 'Income',
                  value: '$currencySymbol${_formatAmount(summary.totalIncome)}',
                  icon: Icons.unarchive_rounded,
                  iconColor: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Expense',
                  value:
                      '$currencySymbol${_formatAmount(summary.totalExpense)}',
                  icon: Icons.archive_rounded,
                  iconColor: const Color(0xFFF43F5E),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Flow Chart Section
        _buildSectionHeader(
          context,
          'Money Flow',
          Icons.bar_chart_rounded,
          isDark,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.grey200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildChartLegend('Income', const Color(0xFF10B981)),
                    const SizedBox(width: 24),
                    _buildChartLegend('Expense', const Color(0xFFF43F5E)),
                  ],
                ),
                const SizedBox(height: 24),
                FlowChart(
                  data: summary.flowData,
                  timeRange: selectedRange,
                  currencySymbol: currencySymbol,
                ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 32),

        // Category Breakdown Section
        if (summary.categoryBreakdown.isNotEmpty) ...[
          _buildSectionHeader(
            context,
            'Where Your Money Goes',
            Icons.donut_large_rounded,
            isDark,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: UnifiedCategoryBreakdown(
              data: summary.categoryBreakdown,
              totalExpense: summary.totalExpense,
              currencySymbol: currencySymbol,
            ),
          ),
        ],

        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    bool isDark,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              color: isDark ? Colors.white : AppColors.grey900,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChartLegend(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: AppTypography.labelMedium.copyWith(
            color: AppColors.grey500,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 400,
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(strokeWidth: 3),
          const SizedBox(height: 24),
          Text(
            'Analyzing your finances...',
            style: AppTypography.bodyLarge.copyWith(
              color: isDark ? AppColors.grey400 : AppColors.grey600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, Object error) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 400,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            'Could not load analytics',
            style: AppTypography.titleMedium.copyWith(
              color: isDark ? Colors.white : AppColors.grey900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            error.toString(),
            style: AppTypography.bodySmall.copyWith(
              color: isDark ? AppColors.grey500 : AppColors.grey600,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(0);
  }
}
