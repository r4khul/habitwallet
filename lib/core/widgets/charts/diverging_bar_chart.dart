import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:habitwallet/core/theme/app_colors.dart';
import 'package:habitwallet/core/theme/app_typography.dart';
import 'package:intl/intl.dart';

import 'chart_types.dart';

/// A diverging bar chart that visualizes income (positive) and expense (negative) values.
///
/// Designed for high performance with minimal configuration.
/// Renders using [CustomPainter] for smooth 60fps animations.
/// Handles different time granularities: Daily, Weekly, Monthly, Yearly.
class DivergingBarChart extends StatefulWidget {
  const DivergingBarChart({
    super.key,
    required this.data,
    this.period = ChartPeriod.daily,
    this.height = 200,
    this.incomeColor,
    this.expenseColor,
    this.zeroLineColor,
    this.labelColor,
  });

  final List<ChartPoint> data;
  final ChartPeriod period;
  final double height;
  final Color? incomeColor;
  final Color? expenseColor;
  final Color? zeroLineColor;
  final Color? labelColor;

  @override
  State<DivergingBarChart> createState() => _DivergingBarChartState();
}

class _DivergingBarChartState extends State<DivergingBarChart>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  List<ChartPoint> _startData = [];
  List<ChartPoint> _endData = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    // Initial animation from zero
    _startData = widget.data
        .map((e) => ChartPoint(date: e.date, amount: 0, label: e.label))
        .toList();
    _endData = widget.data;
    _controller.forward();
  }

  @override
  void didUpdateWidget(DivergingBarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data != oldWidget.data) {
      // Capture current state of animation as the new start
      final currentData = _calculateCurrentData(_controller.value);
      setState(() {
        _startData = currentData;
        _endData = widget.data;
      });
      _controller.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<ChartPoint> _calculateCurrentData(double t) {
    if (_startData.isEmpty && _endData.isEmpty) return [];
    // Ensure we have a valid ChartDataTween
    final tween = ChartDataTween(begin: _startData, end: _endData);
    return tween.lerp(t);
  }

  _BarSettings _getBarSettings(ChartPeriod period) {
    switch (period) {
      case ChartPeriod.daily:
        return const _BarSettings(width: 12, spacing: 8);
      case ChartPeriod.weekly:
        return const _BarSettings(width: 16, spacing: 12);
      case ChartPeriod.monthly:
        return const _BarSettings(width: 20, spacing: 12);
      case ChartPeriod.yearly:
        return const _BarSettings(width: 24, spacing: 16);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty && _endData.isEmpty) {
      return SizedBox(
        height: widget.height,
        child: Center(
          child: Text(
            'No data',
            style: AppTypography.bodyMedium.copyWith(color: AppColors.grey500),
          ),
        ),
      );
    }

    final barSettings = _getBarSettings(widget.period);

    // Determine the number of items needed for width calculation.
    // Use the maximum length to avoid jitter during transition if one list is longer.
    final itemCount = math.max(_startData.length, _endData.length);

    final totalWidth = math.max(
      MediaQuery.of(context).size.width - 32,
      itemCount * (barSettings.width + barSettings.spacing) +
          barSettings.spacing,
    );

    return SizedBox(
      height: widget.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final curvedValue = Curves.easeOutCubic.transform(
              _controller.value,
            );
            final animatedData = _calculateCurrentData(curvedValue);
            return CustomPaint(
              size: Size(totalWidth, widget.height),
              painter: _DivergingBarChartPainter(
                data: animatedData,
                period: widget.period,
                incomeColor: widget.incomeColor ?? AppColors.success,
                expenseColor: widget.expenseColor ?? AppColors.error,
                zeroLineColor: widget.zeroLineColor ?? AppColors.grey300,
                labelStyle: AppTypography.labelSmall.copyWith(
                  color: widget.labelColor ?? AppColors.grey600,
                ),
                barWidth: barSettings.width,
                barSpacing: barSettings.spacing,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BarSettings {
  const _BarSettings({required this.width, required this.spacing});

  final double width;
  final double spacing;
}

class ChartDataTween extends Tween<List<ChartPoint>> {
  ChartDataTween({super.begin, super.end});

  @override
  List<ChartPoint> lerp(double t) {
    final start = begin ?? [];
    final finish = end ?? [];

    if (start.isEmpty && finish.isEmpty) return [];

    final count = math.max(start.length, finish.length);
    final result = <ChartPoint>[];

    for (var i = 0; i < count; i++) {
      if (i < start.length && i < finish.length) {
        // Interpolate existing
        final s = start[i];
        final f = finish[i];
        result.add(
          ChartPoint(
            date: f.date,
            amount: s.amount + (f.amount - s.amount) * t,
            label: f.label,
          ),
        );
      } else if (i < finish.length) {
        // New item appearing (fade in / scale up)
        final f = finish[i];
        result.add(
          ChartPoint(date: f.date, amount: f.amount * t, label: f.label),
        );
      } else if (i < start.length) {
        // Old item disappearing (fade out / scale down)
        final s = start[i];
        result.add(
          ChartPoint(date: s.date, amount: s.amount * (1 - t), label: s.label),
        );
      }
    }
    return result;
  }
}

class _DivergingBarChartPainter extends CustomPainter {
  _DivergingBarChartPainter({
    required this.data,
    required this.period,
    required this.incomeColor,
    required this.expenseColor,
    required this.zeroLineColor,
    required this.labelStyle,
    required this.barWidth,
    required this.barSpacing,
  });

  final List<ChartPoint> data;
  final ChartPeriod period;
  final Color incomeColor;
  final Color expenseColor;
  final Color zeroLineColor;
  final TextStyle labelStyle;
  final double barWidth;
  final double barSpacing;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    // 1. Calculate Range (Min/Max)
    double maxIncome = 0;
    double maxExpense = 0;

    for (var point in data) {
      if (point.amount > 0) maxIncome = math.max(maxIncome, point.amount);
      if (point.amount < 0) {
        maxExpense = math.max(maxExpense, point.amount.abs());
      }
    }

    // Add some headroom (10%)
    maxIncome *= 1.1;
    maxExpense *= 1.1;

    // Handle case where all are 0
    if (maxIncome == 0 && maxExpense == 0) maxIncome = 100;

    final totalRange = maxIncome + maxExpense;
    final safeTotalRange = totalRange == 0 ? 1.0 : totalRange;

    // 2. Determine Zero Line Y-Coordinate
    final labelHeight = 24.0;
    final chartHeight = size.height - labelHeight;
    final zeroLineY = (maxIncome / safeTotalRange) * chartHeight;

    final paintDetails = Paint()..style = PaintingStyle.fill;
    final linePaint = Paint()
      ..color = zeroLineColor
      ..strokeWidth = 1.0
      ..style = PaintingStyle.stroke;

    // 3. Draw Zero Line
    canvas.drawLine(
      Offset(0, zeroLineY),
      Offset(size.width, zeroLineY),
      linePaint,
    );

    // 4. Draw Bars & Labels
    // Move formatter creation outside loop, but inside paint is necessary unless cached
    final dateFormat = _getDateFormat(period);

    // Padding for alignment
    const startPadding = 16.0;

    for (var i = 0; i < data.length; i++) {
      final point = data[i];
      final x = startPadding + i * (barWidth + barSpacing);

      // Skip drawing if out of visible bounds (simple optimization)
      if (x > size.width) break;

      // Draw Bar
      if (point.amount.abs() > 0.01) {
        // Avoid drawing microscopic bars
        final isIncome = point.amount > 0;
        final barHeight = (point.amount.abs() / safeTotalRange) * chartHeight;

        // Position:
        // Income grows UP from zeroLineY
        // Expense grows DOWN from zeroLineY

        final top = isIncome ? (zeroLineY - barHeight) : zeroLineY;

        final barRect = RRect.fromRectAndCorners(
          Rect.fromLTWH(x, top, barWidth, barHeight),
          topLeft: isIncome ? const Radius.circular(4) : Radius.zero,
          topRight: isIncome ? const Radius.circular(4) : Radius.zero,
          bottomLeft: !isIncome ? const Radius.circular(4) : Radius.zero,
          bottomRight: !isIncome ? const Radius.circular(4) : Radius.zero,
        );

        paintDetails.color = isIncome ? incomeColor : expenseColor;
        canvas.drawRRect(barRect, paintDetails);
      }

      // Draw Label
      final labelText = point.label ?? dateFormat.format(point.date);
      final span = TextSpan(style: labelStyle, text: labelText);
      final tp = TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: ui.TextDirection.ltr,
      );
      tp.layout();

      final labelX = x + (barWidth - tp.width) / 2;
      final labelY = chartHeight + 8;
      tp.paint(canvas, Offset(labelX, labelY));
    }
  }

  DateFormat _getDateFormat(ChartPeriod period) {
    switch (period) {
      case ChartPeriod.daily:
        return DateFormat.E();
      case ChartPeriod.weekly:
        return DateFormat('Md');
      case ChartPeriod.monthly:
        return DateFormat.MMM();
      case ChartPeriod.yearly:
        return DateFormat.y();
    }
  }

  @override
  bool shouldRepaint(covariant _DivergingBarChartPainter oldDelegate) {
    return oldDelegate.data != data ||
        oldDelegate.period != period ||
        oldDelegate.incomeColor != incomeColor ||
        oldDelegate.expenseColor != expenseColor;
  }
}
