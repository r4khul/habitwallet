import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:habitwallet/core/theme/app_colors.dart';
import 'package:habitwallet/core/theme/app_typography.dart';

import '../domain/financial_data_models.dart';
import 'providers/financial_analytics_provider.dart';
import 'widgets/category_donut_chart.dart';
import 'widgets/flow_chart.dart';
import 'widgets/summary_cards.dart';
import 'widgets/time_range_selector.dart';

/// The main Financial Overview page.
///
/// Displays:
/// - Time range selector (Day/Week/Month/Year).
/// - Summary cards (Income, Expense, Net Savings).
/// - Income vs Expense flow chart (diverging bar chart).
/// - Category-wise expense breakdown (donut chart).
class FinancialOverviewPage extends ConsumerWidget {
  const FinancialOverviewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final selectedRange = ref.watch(selectedTimeRangeProvider);
    final summaryAsync = ref.watch(financialSummaryProvider);

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // App Bar
          SliverAppBar(
            expandedHeight: 100,
            floating: true,
            pinned: true,
            backgroundColor: isDark ? AppColors.darkBackground : Colors.white,
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
                style: AppTypography.headlineMedium.copyWith(
                  color: isDark ? Colors.white : AppColors.grey900,
                ),
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: summaryAsync.when(
              data: (summary) =>
                  _buildContent(context, ref, summary, selectedRange),
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
                  value: '\$${_formatAmount(summary.totalIncome)}',
                  icon: Icons.arrow_downward_rounded,
                  iconColor: const Color(0xFF10B981),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SummaryCard(
                  title: 'Expense',
                  value: '\$${_formatAmount(summary.totalExpense)}',
                  icon: Icons.arrow_upward_rounded,
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
          Icons.show_chart_rounded,
          isDark,
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkCard : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.grey200,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                  blurRadius: 16,
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
                    const SizedBox(width: 20),
                    _buildChartLegend('Expense', const Color(0xFFF43F5E)),
                  ],
                ),
                const SizedBox(height: 16),
                FlowChart(
                  data: summary.flowData,
                  timeRange: selectedRange,
                  height: 200,
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
            Icons.pie_chart_rounded,
            isDark,
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.grey200,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CategoryDonutChart(
                data: summary.categoryBreakdown,
                totalExpense: summary.totalExpense,
                size: 180,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Category List (detailed breakdown)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: _buildCategoryList(
              context,
              summary.categoryBreakdown,
              isDark,
            ),
          ),
        ],

        const SizedBox(height: 40),
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
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 18, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: AppTypography.titleLarge.copyWith(
              color: isDark ? Colors.white : AppColors.grey900,
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
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: AppTypography.labelSmall.copyWith(color: AppColors.grey500),
        ),
      ],
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    List<CategorySpend> categories,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.grey200,
        ),
      ),
      child: Column(
        children: categories.asMap().entries.map((entry) {
          final index = entry.key;
          final cat = entry.value;
          final isLast = index == categories.length - 1;

          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              border: isLast
                  ? null
                  : Border(
                      bottom: BorderSide(
                        color: isDark
                            ? AppColors.darkBorder
                            : AppColors.grey200,
                      ),
                    ),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Color(cat.categoryColor).withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    _getCategoryIcon(cat.categoryIcon),
                    size: 18,
                    color: Color(cat.categoryColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        cat.categoryName,
                        style: AppTypography.bodyMedium.copyWith(
                          color: isDark ? Colors.white : AppColors.grey900,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      // Progress bar
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: LinearProgressIndicator(
                          value: cat.percentage / 100,
                          backgroundColor: isDark
                              ? AppColors.grey800
                              : AppColors.grey200,
                          valueColor: AlwaysStoppedAnimation(
                            Color(cat.categoryColor),
                          ),
                          minHeight: 4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${_formatAmount(cat.amount)}',
                      style: AppTypography.bodyMedium.copyWith(
                        color: isDark ? Colors.white : AppColors.grey900,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${cat.percentage.toStringAsFixed(1)}%',
                      style: AppTypography.labelSmall.copyWith(
                        color: isDark ? AppColors.grey500 : AppColors.grey600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
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
          SizedBox(
            width: 32,
            height: 32,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Analyzing your finances...',
            style: AppTypography.bodyMedium.copyWith(
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

  IconData _getCategoryIcon(String iconName) {
    switch (iconName) {
      case 'food':
        return Icons.restaurant_rounded;
      case 'transport':
        return Icons.directions_car_rounded;
      case 'shopping':
        return Icons.shopping_bag_rounded;
      case 'entertainment':
        return Icons.movie_rounded;
      case 'health':
        return Icons.favorite_rounded;
      case 'salary':
        return Icons.account_balance_wallet_rounded;
      case 'others':
        return Icons.more_horiz_rounded;
      default:
        return Icons.category_rounded;
    }
  }

  String _formatAmount(double amount) {
    if (amount >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    } else if (amount >= 1000) {
      return '${(amount / 1000).toStringAsFixed(1)}K';
    }
    return amount.toStringAsFixed(2);
  }
}
