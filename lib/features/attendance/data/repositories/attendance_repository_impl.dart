  import 'dart:convert';
  import 'package:http/http.dart' as http;
  import 'package:intl/intl.dart';
  import '../models/attendance_record_model.dart';

  class AttendanceRepository {

    final String baseUrl = "https://dpnurcoima.execute-api.ap-south-1.amazonaws.com/default/GetAttendanceRecords";

    // Format date for API request (YYYY-MM-DD)
    String _formatDateForApi(DateTime date) {
      return DateFormat("yyyy-MM-dd").format(date);

    }
// Add this method to your AttendanceRepository class

    Future<List<AttendanceRecord>> getAttendanceemployee(String userid) async {
      final url = Uri.parse("https://ectzis56w6.execute-api.ap-south-1.amazonaws.com/default/GetAttendanceuser");

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"Userid": userid}),
      );

      print('API Response for all records: ${response.body}');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => AttendanceRecord.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load attendance records");
      }
    }

// New method for date-specific attendance records
    Future<List<AttendanceRecord>> getAttendanceemployeeByDate(String userid, DateTime date) async {
      final url = Uri.parse("https://s05fcfq582.execute-api.ap-south-1.amazonaws.com/default/getattendancebydate");

      // Format date as YYYY-MM-DD
      final formattedDate = "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Userid": userid,
          "date": formattedDate
        }),
      );

      print('API Response for date $formattedDate: ${response.body}');
      print('Status Code: ${response.statusCode}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => AttendanceRecord.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load attendance records for selected date");
      }
    }
  }

