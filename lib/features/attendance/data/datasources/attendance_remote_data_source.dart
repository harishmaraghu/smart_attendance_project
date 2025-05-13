// features/attendance/data/datasources/attendance_remote_data_source.dart

import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/attendance_record_model.dart';


class AttendanceRemoteDataSource {
  final String baseUrl;


  AttendanceRemoteDataSource(this.baseUrl);

  Future<List<AttendanceRecord>> fetchAttendanceHistory({
    required String employeeName,
    String? date,
  }) async {
    final url = Uri.parse('$baseUrl/attendance/history?employeeName=$employeeName${date != null ? '&date=$date' : ''}');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> jsonData = json.decode(response.body);
      return jsonData.map((e) => AttendanceRecord.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load attendance history');
    }
  }
}
