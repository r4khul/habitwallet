import 'package:flutter/material.dart';

class CategoryAssets {
  static const List<Color> palette = [
    Color(0xFF6366F1), // Indigo
    Color(0xFF8B5CF6), // Violet
    Color(0xFFEC4899), // Pink
    Color(0xFFEF4444), // Red
    Color(0xFFF59E0B), // Amber
    Color(0xFF10B981), // Emerald
    Color(0xFF06B6D4), // Cyan
    Color(0xFF3B82F6), // Blue
    Color(0xFF64748B), // Slate
  ];

  static const Map<String, IconData> icons = {
    'food': Icons.restaurant_rounded,
    'restaurant': Icons.restaurant_rounded,
    'shopping': Icons.shopping_bag_rounded,
    'shopping_bag': Icons.shopping_bag_rounded,
    'transport': Icons.directions_car_rounded,
    'directions_car': Icons.directions_car_rounded,
    'salary': Icons.payments_rounded,
    'payments': Icons.payments_rounded,
    'bills': Icons.receipt_long_rounded,
    'receipt_long': Icons.receipt_long_rounded,
    'entertainment': Icons.movie_rounded,
    'movie': Icons.movie_rounded,
    'health': Icons.medical_services_rounded,
    'medical_services': Icons.medical_services_rounded,
    'education': Icons.school_rounded,
    'school': Icons.school_rounded,
    'savings': Icons.savings_rounded,
    'travel': Icons.flight_rounded,
    'flight': Icons.flight_rounded,
    'other': Icons.category_rounded,
    'category': Icons.category_rounded,
  };

  /// Returns the appropriate [IconData] for a given icon name.
  /// Handles nulls, case-insensitivity, and provides a default fallback.
  static IconData getIcon(String? name) {
    if (name == null) return Icons.category_rounded;
    return icons[name] ?? icons[name.toLowerCase()] ?? Icons.category_rounded;
  }
}
