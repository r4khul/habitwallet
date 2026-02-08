import 'package:flutter/material.dart';
import 'package:habitwallet/core/theme/app_colors.dart';
import 'package:habitwallet/core/theme/app_typography.dart';

import '../../domain/financial_data_models.dart';
import 'category_donut_chart.dart';

/// A unified category breakdown widget that binds a donut chart with a list.
///
/// Features:
/// - Centered donut chart (larger than before).
/// - Interactive list that highlights on chart tap and vice versa.
/// - Detailed progress bars and percentages.
/// - Theme adaptive design.
class UnifiedCategoryBreakdown extends StatefulWidget {
  const UnifiedCategoryBreakdown({
    super.key,
    required this.data,
    required this.totalExpense,
    this.currencySymbol = r'$',
  });

  final List<CategorySpend> data;
  final double totalExpense;
  final String currencySymbol;

  @override
  State<UnifiedCategoryBreakdown> createState() =>
      _UnifiedCategoryBreakdownState();
}

class _UnifiedCategoryBreakdownState extends State<UnifiedCategoryBreakdown> {
  int? _selectedIndex;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        // Centered larger donut chart
        Container(
          padding: const EdgeInsets.symmetric(vertical: 32),
          child: Center(
            child: CategoryDonutChart(
              data: widget.data,
              totalExpense: widget.totalExpense,
              size: 220, // Increased size
              selectedIndex: _selectedIndex,
              currencySymbol: widget.currencySymbol,
              onSelectionChanged: (index) {
                setState(() => _selectedIndex = index);
              },
            ),
          ),
        ),

        const SizedBox(height: 8),

        // Interactive Category List
        Container(
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
            children: widget.data.asMap().entries.map((entry) {
              final index = entry.key;
              final cat = entry.value;
              final isSelected = _selectedIndex == index;
              final isLast = index == widget.data.length - 1;

              return InkWell(
                onTap: () {
                  setState(() {
                    _selectedIndex = isSelected ? null : index;
                  });
                },
                borderRadius: isLast
                    ? const BorderRadius.vertical(bottom: Radius.circular(20))
                    : index == 0
                    ? const BorderRadius.vertical(top: Radius.circular(20))
                    : null,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? Color(cat.categoryColor).withValues(alpha: 0.08)
                        : Colors.transparent,
                    border: isLast
                        ? null
                        : Border(
                            bottom: BorderSide(
                              color: isDark
                                  ? AppColors.darkBorder
                                  : AppColors.grey200,
                              width: 0.8,
                            ),
                          ),
                  ),
                  child: Row(
                    children: [
                      // Icon with background
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(
                            cat.categoryColor,
                          ).withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(12),
                          border: isSelected
                              ? Border.all(
                                  color: Color(cat.categoryColor),
                                  width: 1.5,
                                )
                              : null,
                        ),
                        child: Icon(
                          _getCategoryIcon(cat.categoryIcon),
                          size: 20,
                          color: Color(cat.categoryColor),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Name and Progress
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cat.categoryName,
                              style: AppTypography.bodyLarge.copyWith(
                                color: isDark
                                    ? Colors.white
                                    : AppColors.grey900,
                                fontWeight: isSelected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: cat.percentage / 100,
                                backgroundColor: isDark
                                    ? AppColors.grey800
                                    : AppColors.grey100,
                                valueColor: AlwaysStoppedAnimation(
                                  Color(cat.categoryColor),
                                ),
                                minHeight: 6,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 16),

                      // Amount and Percentage
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.currencySymbol}${_formatAmount(cat.amount)}',
                            style: AppTypography.bodyLarge.copyWith(
                              color: isDark ? Colors.white : AppColors.grey900,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            '${cat.percentage.toStringAsFixed(1)}%',
                            style: AppTypography.labelSmall.copyWith(
                              color: isSelected
                                  ? Color(cat.categoryColor)
                                  : (isDark
                                        ? AppColors.grey400
                                        : AppColors.grey600),
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
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
