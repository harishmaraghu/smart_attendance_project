import 'package:flutter/material.dart';

class HistoryAppColors {
  static const Color primary = Color(0xFF2196F3);
  static const Color background = Color(0xff3AB6FF);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Color(0xFF666666);
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
  static const Color pending = Color(0xFF9E9E9E);

  // Status colors
  static Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'settled':
        return success;
      case 'failed':
        return error;
      case 'pending':
        return pending;
      default:
        return pending;
    }
  }
}