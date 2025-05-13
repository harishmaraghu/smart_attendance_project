class AttendanceRecord {
  final DateTime date;
  final String name;
  final String? inTime;
  final String? outTime;
  String? totalHours;
  String status;

  AttendanceRecord({
    required this.date,
    required this.name,
    this.inTime,
    this.outTime,
    this.totalHours,
    required this.status,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    // Parse date from string
    final DateTime parsedDate = DateTime.parse(json['date']);

    // Default status is absent, will be updated based on inTime/outTime
    String status = 'Absent';

    // Determine status - Present if at least inTime or outTime exists
    if (json['inTime'] != null && json['inTime'].toString().isNotEmpty) {
      status = 'Present';
    } else if (json['outTime'] != null && json['outTime'].toString().isNotEmpty) {
      status = 'Present';
    }

    // Create record with basic information from API
    final record = AttendanceRecord(
      date: parsedDate,
      name: json['name'] ?? '',
      inTime: json['inTime'],
      outTime: json['outTime'],
      totalHours: null, // Will be calculated after initialization
      status: status,
    );

    // Calculate total hours
    record.calculateTotalHours();

    return record;
  }

  // Calculate total hours if both inTime and outTime are available
  void calculateTotalHours() {
    if (inTime != null && inTime!.isNotEmpty &&
        outTime != null && outTime!.isNotEmpty) {
      try {
        // Parse the time strings
        final inTimeParts = inTime!.split(':');
        final outTimeParts = outTime!.split(':');

        if (inTimeParts.length == 2 && outTimeParts.length == 2) {
          final inDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              int.parse(inTimeParts[0]),
              int.parse(inTimeParts[1])
          );

          final outDateTime = DateTime(
              date.year,
              date.month,
              date.day,
              int.parse(outTimeParts[0]),
              int.parse(outTimeParts[1])
          );

          // Handle case where checkout is next day
          final Duration difference = outDateTime.isAfter(inDateTime)
              ? outDateTime.difference(inDateTime)
              : outDateTime.add(const Duration(days: 1)).difference(inDateTime);

          final hours = difference.inHours;
          final minutes = (difference.inMinutes % 60);

          totalHours = "${hours}hr ${minutes > 0 ? '${minutes}min' : ''}";
        } else {
          totalHours = "N/A";
        }
      } catch (e) {
        totalHours = "N/A";
      }
    } else {
      totalHours = "N/A";
    }
  }
}