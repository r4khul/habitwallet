import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:habitwallet/core/theme/app_colors.dart';
import 'package:habitwallet/core/theme/app_typography.dart';

import '../../domain/financial_data_models.dart';

/// A modern donut chart showing category-wise expense breakdown.
///
/// Features:
/// - Animated arc segments with smooth entry animations.
/// - Center hole with total amount.
/// - Horizontal legend with percentages.
/// - Touch interactions for segment selection.
/// - Dark/light mode adaptive colors.
class CategoryDonutChart extends StatefulWidget {
  const CategoryDonutChart({
    super.key,
    required this.data,
    required this.totalExpense,
    this.size = 200,
  });

  final List<CategorySpend> data;
  final double totalExpense;
  final double size;

  @override
  State<CategoryDonutChart> createState() => _CategoryDonutChartState();
}

class _CategoryDonutChartState extends State<CategoryDonutChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _controller.forward();
  }

  @override
  void didUpdateWidget(CategoryDonutChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data.length != widget.data.length ||
        oldWidget.totalExpense != widget.totalExpense) {
      _selectedIndex = null;
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    if (widget.data.isEmpty) {
      return SizedBox(
        height: widget.size + 100,
        child: Center(
          child: Text(
            'No expenses to analyze',
            style: AppTypography.bodyMedium.copyWith(
              color: isDark ? AppColors.grey500 : AppColors.grey600,
            ),
          ),
        ),
      );
    }

    return Column(
      children: [
        // Donut Chart
        SizedBox(
          height: widget.size,
          width: widget.size,
          child: GestureDetector(
            onTapDown: (details) => _handleTap(details.localPosition),
            child: AnimatedBuilder(
              animation: _animation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _DonutPainter(
                    data: widget.data,
                    progress: _animation.value,
                    selectedIndex: _selectedIndex,
                    totalExpense: widget.totalExpense,
                    isDark: isDark,
                  ),
                );
              },
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Legend
        _buildLegend(context, isDark),
      ],
    );
  }

  void _handleTap(Offset position) {
    final center = Offset(widget.size / 2, widget.size / 2);
    final touchVector = position - center;
    final distance = touchVector.distance;

    // Check if tap is within the donut ring
    final outerRadius = widget.size / 2 - 8;
    final innerRadius = outerRadius * 0.6;

    if (distance < innerRadius || distance > outerRadius) {
      setState(() => _selectedIndex = null);
      return;
    }

    // Calculate angle
    var angle = math.atan2(touchVector.dy, touchVector.dx);
    angle = angle + math.pi / 2; // Rotate to start from top
    if (angle < 0) angle += 2 * math.pi;

    // Find which segment was tapped
    double currentAngle = 0;
    for (var i = 0; i < widget.data.length; i++) {
      final sweep = (widget.data[i].percentage / 100) * 2 * math.pi;
      if (angle >= currentAngle && angle < currentAngle + sweep) {
        setState(() {
          _selectedIndex = _selectedIndex == i ? null : i;
        });
        return;
      }
      currentAngle += sweep;
    }
  }

  Widget _buildLegend(BuildContext context, bool isDark) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      alignment: WrapAlignment.center,
      children: List.generate(widget.data.length, (index) {
        final item = widget.data[index];
        final isSelected = _selectedIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              _selectedIndex = _selectedIndex == index ? null : index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected
                  ? Color(item.categoryColor).withValues(alpha: 0.15)
                  : (isDark ? AppColors.darkCard : Colors.white),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected
                    ? Color(item.categoryColor)
                    : (isDark ? AppColors.darkBorder : AppColors.grey200),
                width: isSelected ? 1.5 : 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Color(item.categoryColor),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  item.categoryName,
                  style: AppTypography.labelMedium.copyWith(
                    color: isDark ? Colors.white : AppColors.grey800,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '${item.percentage.toStringAsFixed(0)}%',
                  style: AppTypography.labelSmall.copyWith(
                    color: isDark ? AppColors.grey400 : AppColors.grey500,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _DonutPainter extends CustomPainter {
  _DonutPainter({
    required this.data,
    required this.progress,
    required this.selectedIndex,
    required this.totalExpense,
    required this.isDark,
  });

  final List<CategorySpend> data;
  final double progress;
  final int? selectedIndex;
  final double totalExpense;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final outerRadius = size.width / 2 - 8;
    final innerRadius = outerRadius * 0.6;
    final strokeWidth = outerRadius - innerRadius;

    // Draw background ring
    final bgPaint = Paint()
      ..color = isDark
          ? AppColors.grey800.withValues(alpha: 0.3)
          : AppColors.grey200.withValues(alpha: 0.5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    canvas.drawCircle(center, innerRadius + strokeWidth / 2, bgPaint);

    // Draw segments
    double startAngle = -math.pi / 2; // Start from top

    for (var i = 0; i < data.length; i++) {
      final item = data[i];
      final sweepAngle = (item.percentage / 100) * 2 * math.pi * progress;
      final isSelected = selectedIndex == i;

      final paint = Paint()
        ..color = Color(
          item.categoryColor,
        ).withValues(alpha: selectedIndex != null && !isSelected ? 0.3 : 1.0)
        ..style = PaintingStyle.stroke
        ..strokeWidth = isSelected ? strokeWidth + 6 : strokeWidth
        ..strokeCap = StrokeCap.butt;

      final radius = isSelected
          ? innerRadius + strokeWidth / 2 + 3
          : innerRadius + strokeWidth / 2;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center text
    _drawCenterText(canvas, center, totalExpense);
  }

  void _drawCenterText(Canvas canvas, Offset center, double total) {
    // Label
    final labelPainter = TextPainter(
      text: TextSpan(
        text: 'Total Spent',
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: isDark ? AppColors.grey400 : AppColors.grey500,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    labelPainter.paint(
      canvas,
      Offset(center.dx - labelPainter.width / 2, center.dy - 16),
    );

    // Amount
    final formattedAmount = _formatAmount(total);
    final amountPainter = TextPainter(
      text: TextSpan(
        text: '\$$formattedAmount',
        style: TextStyle(
          fontFamily: AppTypography.fontFamily,
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: isDark ? Colors.white : AppColors.grey900,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    amountPainter.paint(
      canvas,
      Offset(center.dx - amountPainter.width / 2, center.dy + 2),
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

  @override
  bool shouldRepaint(_DonutPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.data != data ||
        oldDelegate.isDark != isDark;
  }
}
