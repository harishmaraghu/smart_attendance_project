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

    // Get attendance records for a specific employee and date
    Future<List<AttendanceRecord>> getAttendanceRecords(String employeeName, DateTime? date) async {
      try {
        // Build URL with query parameters
        final queryParams = {
          'employeeName': employeeName,
        };

        if (date != null) {
          queryParams['date'] = _formatDateForApi(date);
        }

        // Build URI with query parameters
        final uri = Uri.parse(baseUrl).replace(queryParameters: queryParams);

        // Print the full request URI
        print("Requesting attendance records from: $uri");

        // Make the API call
        final response = await http.get(uri);

        // Print raw response
        print("Raw response status: ${response.statusCode}");
        print("Raw response body: ${response.body}");

        if (response.statusCode == 200) {
          // Parse response
          final List<dynamic> jsonData = json.decode(response.body);

          // Print decoded JSON data
          print("Decoded JSON: $jsonData");

          // Convert to list of AttendanceRecord objects
          final List<AttendanceRecord> records = jsonData.map((json) {
            final record = AttendanceRecord.fromJson(json);
            record.calculateTotalHours(); // Calculate total hours
            print("Parsed record: $record"); // Print each record
            return record;
          }).toList();

          return records;
        } else {
          throw Exception('Failed to load attendance records: ${response.statusCode}');
        }
      } catch (e) {
        print('Error: $e');
        throw Exception('Error fetching attendance records: $e');
      }
    }


  }