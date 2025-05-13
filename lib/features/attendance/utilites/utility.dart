import 'package:intl/intl.dart';

class AttendanceUtility {
  // Check if two dates are the same day
  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // Format date to display format (1 April 2025)
  String formatDisplayDate(DateTime date) {
    return DateFormat("d MMMM yyyy").format(date);
  }

  // Format date for API requests (YYYY-MM-DD)
  String formatApiDate(DateTime date) {
    return DateFormat("yyyy-MM-dd").format(date);
  }

  // Format time for display (hh:mm a)
  String formatTimeForDisplay(String? timeString) {
    if (timeString == null || timeString.isEmpty) {
      return "N/A";
    }

    try {
      final timeParts = timeString.split(':');
      final hour = int.parse(timeParts[0]);
      final minute = int.parse(timeParts[1]);

      final time = DateTime(2025, 1, 1, hour, minute);
      return DateFormat("hh:mm a").format(time);
    } catch (e) {
      return timeString; // Return original if parsing fails
    }
  }

  // Get appropriate color for attendance status
  int getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'present':
        return 0xFF4CAF50; // Green
      case 'absent':
        return 0xFFF44336; // Red
      case 'late':
        return 0xFFFF9800; // Orange
      case 'half day':
        return 0xFFFFEB3B; // Yellow
      default:
        return 0xFF9E9E9E; // Grey
    }
  }
}