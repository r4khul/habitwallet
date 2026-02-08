enum ChartPeriod { daily, weekly, monthly, yearly }

class ChartPoint {
  final DateTime date;
  final double amount;

  /// Optional label to override default date formatting
  final String? label;

  const ChartPoint({required this.date, required this.amount, this.label});
}
