// services/location_api_service.dart
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_attendance_project/features/work_loaction_profile/location/models/work_loaction.dart';


class LocationApiService {
  final Dio _dio = Dio();

  // Enhanced API service with better debugging
  Future<List<LocationAssignment>> fetchLocationAssignments(String userId) async {
    try {
      print('Making API request for userId: $userId');

      final response = await _dio.get(
        'https://99i86f2wf7.execute-api.ap-south-1.amazonaws.com/default/Locationassign',
        queryParameters: {'userid': userId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) => status! < 500, // Accept all responses below 500
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response headers: ${response.headers}');
      print('Raw response data: ${response.data}');
      print('Response data type: ${response.data.runtimeType}');

      // Check if response is successful
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.statusMessage}');
      }

      final data = response.data;

      // Handle different response types
      if (data is String) {
        print('Response is a String, attempting to parse as JSON');
        try {
          // Try to parse the string as JSON
          final jsonData = json.decode(data);
          return _parseLocationData(jsonData);
        } catch (e) {
          print('Failed to parse string as JSON: $e');
          print('String content: $data');
          throw Exception('Invalid JSON response: $data');
        }
      } else if (data is Map<String, dynamic>) {
        print('Response is a Map');
        return _parseLocationData(data);
      } else if (data is List) {
        print('Response is a List');
        return _parseLocationData(data);
      } else {
        print('Unexpected response type: ${data.runtimeType}');
        throw Exception('Unexpected response format: expected JSON, got ${data.runtimeType}');
      }

    } on DioException catch (e) {
      print('Dio error type: ${e.type}');
      print('Dio error message: ${e.message}');
      print('Dio response status: ${e.response?.statusCode}');
      print('Dio response data: ${e.response?.data}');

      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout - please check your internet connection');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout - please try again');
      } else if (e.type == DioExceptionType.badResponse) {
        throw Exception('Server error: ${e.response?.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('General error: $e');
      throw Exception('API Error: ${e.toString()}');
    }
  }

// Helper method to parse location data
  List<LocationAssignment> _parseLocationData(dynamic data) {
    try {
      if (data is Map<String, dynamic>) {
        // Single object response
        final assignment = LocationAssignment.fromJson(data);
        return [assignment];
      } else if (data is List) {
        // List response
        return data.map((item) {
          if (item is Map<String, dynamic>) {
            return LocationAssignment.fromJson(item);
          } else {
            throw Exception('Invalid item in list: ${item.runtimeType}');
          }
        }).toList();
      } else {
        throw Exception('Expected Map or List, got ${data.runtimeType}');
      }
    } catch (e) {
      print('Error parsing location data: $e');
      print('Data: $data');
      rethrow;
    }
  }


}
