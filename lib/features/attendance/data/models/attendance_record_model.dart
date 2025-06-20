class AttendanceRecord {
  final DateTime date;
  final String? inTime;
  final String? outTime;
  final String status;
  final String name;
  final String? totalHours;

  AttendanceRecord({
    required this.date,
    this.inTime,
    this.outTime,
    required this.status,
    required this.name,
    this.totalHours,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    final rawInTime = json['inTime'];
    final rawOutTime = json['outTime'];

    String? inTime = _extractTime(rawInTime);
    String? outTime = _extractTime(rawOutTime);

    return AttendanceRecord(
      date: DateTime.parse(json['date']),
      inTime: inTime,
      outTime: outTime,
      status: (inTime != null && outTime != null) ? "Present" : "Absent",
      name: json['name'] ?? "demo",
      totalHours: _calculateTotalHours(inTime, outTime),
    );
  }

  static String? _extractTime(dynamic value) {
    if (value == null) return null;

    final str = value.toString();
    final timeRegex = RegExp(r'(\d{2}:\d{2})'); // Matches "08:00", "14:45", etc.

    final match = timeRegex.firstMatch(str);
    return match != null ? match.group(1) : null;
  }


  static String? _calculateTotalHours(String? inTime, String? outTime) {
    if (inTime == null || outTime == null) return null;

    try {
      final inParts = inTime.split(":").map(int.parse).toList();
      final outParts = outTime.split(":").map(int.parse).toList();

      final inDateTime = DateTime(0, 1, 1, inParts[0], inParts[1]);
      final outDateTime = DateTime(0, 1, 1, outParts[0], outParts[1]);

      final duration = outDateTime.difference(inDateTime);

      // Handle case where checkout is next day (negative duration)
      if (duration.isNegative) {
        final nextDayOutDateTime = DateTime(0, 1, 2, outParts[0], outParts[1]);
        final correctedDuration = nextDayOutDateTime.difference(inDateTime);
        return "${correctedDuration.inHours}h ${correctedDuration.inMinutes % 60}m";
      }

      return "${duration.inHours}h ${duration.inMinutes % 60}m";
    } catch (e) {
      print('Error calculating total hours: $e');
      return null;
    }
  }

  @override
  String toString() {
    return 'AttendanceRecord(date: $date, inTime: $inTime, outTime: $outTime, status: $status, name: $name, totalHours: $totalHours)';
  }
}