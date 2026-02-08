enum ChartPeriod { daily, weekly, monthly, yearly }

class ChartPoint {
  final DateTime date;
  final double income;
  final double expense; // Expected to be negative or zero

  /// Optional label to override default date formatting
  final String? label;

  const ChartPoint({
    required this.date,
    this.income = 0,
    this.expense = 0,
    this.label,
  });

  /// Compatibility factory for single values
  factory ChartPoint.single({
    required DateTime date,
    required double amount,
    String? label,
  }) {
    return ChartPoint(
      date: date,
      income: amount > 0 ? amount : 0,
      expense: amount < 0 ? amount : 0,
      label: label,
    );
  }
}
