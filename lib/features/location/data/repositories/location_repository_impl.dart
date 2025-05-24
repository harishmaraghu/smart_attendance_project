import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/checkin_request_model.dart';

class LocationRepositoryImpl {
  Future<void> saveCheckInTime(DateTime time) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('checkInTime', time.toIso8601String());
  }

  Future<DateTime?> getCheckInTime() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString('checkInTime');
    return stored != null ? DateTime.parse(stored) : null;
  }

  Future<void> removeCheckInTime() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('checkInTime');
  }


  Future<void> checkInToServer(CheckInRequestModel data) async {
    final url = Uri.parse(
        "https://eybtt1i5q4.execute-api.ap-south-1.amazonaws.com/default/FaceRecognition");

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(data.toJson()),
    );

    print("📥 --------------Response status: ${response.statusCode}");
    print("📥 ----------------Response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception("Failed to check in: ${response.body}");
    }
  }

}

