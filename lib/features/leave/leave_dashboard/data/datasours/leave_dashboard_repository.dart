
// repositories/leave_dashboard_repository.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/data/models/leavedashboard_model.dart';

class LeaveDashboardRepository {
  final Dio _dio;
  static const String _baseUrl = 'https://jb5pc7sacj.execute-api.ap-south-1.amazonaws.com/default/Leavedashboard';

  LeaveDashboardRepository({Dio? dio}) : _dio = dio ?? Dio();

  Future<LeaveDashboardModel> getLeaveDashboard({
    required String userId,
    required String name,
  }) async {
    try {
      final requestData = {
        "Userid": userId,
        "name": name,
      };

      print('Sending POST request to $_baseUrl with data: $requestData');

      final response = await _dio.post(
        _baseUrl,
        data: requestData,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
        ),
      );

      print('Response status code: ${response.statusCode}');
      print('Response data runtimeType: ${response.data.runtimeType}');
      print('Response data: ${response.data}');

      dynamic responseData = response.data;

      // If the response is a String, decode it to JSON
      if (responseData is String) {
        responseData = json.decode(responseData);
      }

      return LeaveDashboardModel.fromJson(responseData);
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

}