import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/util/theme_extension.dart';
import '../providers/date_filter_provider.dart';

class DateRangeSelector extends ConsumerWidget {
  const DateRangeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentFilter = ref.watch(dateFilterControllerProvider);

    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          _buildFilterChip(
            context,
            ref,
            label: 'Today',
            isSelected: currentFilter.label == 'Today',
            onTap: () =>
                ref.read(dateFilterControllerProvider.notifier).setToday(),
          ),
          _buildFilterChip(
            context,
            ref,
            label: 'This Week',
            isSelected: currentFilter.label == 'This Week',
            onTap: () =>
                ref.read(dateFilterControllerProvider.notifier).setThisWeek(),
          ),
          _buildFilterChip(
            context,
            ref,
            label: 'This Month',
            isSelected: currentFilter.label == 'This Month',
            onTap: () =>
                ref.read(dateFilterControllerProvider.notifier).setThisMonth(),
          ),
          _buildFilterChip(
            context,
            ref,
            label: 'This Year',
            isSelected: currentFilter.label == 'This Year',
            onTap: () =>
                ref.read(dateFilterControllerProvider.notifier).setThisYear(),
          ),
          _buildFilterChip(
            context,
            ref,
            label: 'All Time',
            isSelected: currentFilter.label == 'All Time',
            onTap: () =>
                ref.read(dateFilterControllerProvider.notifier).setAllTime(),
          ),
          _buildCustomChip(context, ref, currentFilter),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context,
    WidgetRef ref, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = context.isDarkMode;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkCard : AppColors.grey100),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.grey200),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.grey700),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCustomChip(
    BuildContext context,
    WidgetRef ref,
    DateRangeFilter filter,
  ) {
    final isDark = context.isDarkMode;
    final isSelected = filter.isCustom;

    String label = 'Custom Range';
    if (isSelected) {
      final df = DateFormat('d MMM');
      label = '${df.format(filter.start)} - ${df.format(filter.end)}';
    }

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: InkWell(
        onTap: () => _showRangePicker(context, ref),
        borderRadius: BorderRadius.circular(20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.primary
                : (isDark ? AppColors.darkCard : AppColors.grey100),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : (isDark ? AppColors.darkBorder : AppColors.grey200),
            ),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.date_range_rounded,
                size: 16,
                color: isSelected
                    ? Colors.white
                    : (isDark ? Colors.white70 : AppColors.grey700),
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: isSelected
                      ? Colors.white
                      : (isDark ? Colors.white70 : AppColors.grey700),
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showRangePicker(BuildContext context, WidgetRef ref) async {
    final theme = Theme.of(context);
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              surface: context.isDarkMode
                  ? AppColors.darkSurface
                  : Colors.white,
              onSurface: context.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      ref
          .read(dateFilterControllerProvider.notifier)
          .setCustomRange(picked.start, picked.end);
    }
  }
}
