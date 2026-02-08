import 'package:intl/intl.dart';

/// Utility class for formatting numbers and currencies in a human-readable way.
class FormattingUtils {
  /// Formats a double into a compact, human-readable string (e.g., 1.2K, 3.4M).
  ///
  /// [amount] The number to format.
  /// [symbol] Optional currency symbol to prefix.
  /// [decimalDigits] Number of decimal digits to show for compact values.
  static String formatCompact(
    double amount, {
    String symbol = '',
    int decimalDigits = 1,
  }) {
    final absAmount = amount.abs();

    if (absAmount < 1000) {
      // For small amounts, show up to 2 decimal places, but remove trailing .00
      String formatted = absAmount.toStringAsFixed(2);
      if (formatted.endsWith('.00')) {
        formatted = formatted.substring(0, formatted.length - 3);
      } else if (formatted.contains('.') && formatted.endsWith('0')) {
        formatted = formatted.substring(0, formatted.length - 1);
      }
      return '$symbol$formatted';
    }

    final formatter = NumberFormat.compact();
    formatter.maximumFractionDigits = decimalDigits;

    String compactValue = formatter.format(absAmount);
    return '$symbol$compactValue';
  }

  /// Formats a double as currency with full precision (e.g., $1,234.56).
  static String formatFullCurrency(double amount, {String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(amount);
  }
}
