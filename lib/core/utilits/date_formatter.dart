import 'package:intl/intl.dart';

class DateFormatter {
  static String formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd-MM-yyyy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  static String formatAmount(double amount) {
    return '\$${amount.toStringAsFixed(2)}';
  }
}