import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:smart_attendance_project/features/payment/payslip/data/models/pay_slip_history_models.dart';

class PayslipApiService {
  final Dio _dio = Dio();

  static const String baseUrl = 'https://f3iuldia4e.execute-api.ap-south-1.amazonaws.com/default';

  PayslipApiService() {
    // Add interceptors for better debugging
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      error: true,
    ));
  }

  Future<PayslipModel> getPayslip({
    required String userId,
    required String username,
    required String date,
  }) async {
    try {
      print('Making API call with params: userId=$userId, username=$username, date=$date');

      final response = await _dio.get(
        '$baseUrl/Payslip',
        queryParameters: {
          'userId': userId,
          'username': username,
          'date': date,
        },
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          validateStatus: (status) {
            // Accept status codes from 200-299 and 404 for debugging
            return status != null && status < 500;
          },
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data: ${response.data}');

      if (response.statusCode == 200) {
        // Handle different response data types
        dynamic data;
        if (response.data is String) {
          print('Response is string, decoding...');
          data = jsonDecode(response.data);
        } else if (response.data is Map) {
          print('Response is already a Map');
          data = response.data;
        } else {
          print('Unexpected response type: ${response.data.runtimeType}');
          throw Exception('Unexpected response format');
        }

        print('Parsed data: $data');
        return PayslipModel.fromJson(data);
      } else if (response.statusCode == 404) {
        print('404 Error - Payslip not found for the given parameters');
        throw Exception('No payslip found for $date. Please check the date or try a different month.');
      } else {
        print('HTTP Error: ${response.statusCode}');
        throw Exception('Server returned ${response.statusCode}: ${response.statusMessage}');
      }
    } on DioException catch (e) {
      print('DioException occurred: ${e.type}');
      print('Error message: ${e.message}');
      print('Response: ${e.response?.data}');

      if (e.response != null) {
        final statusCode = e.response!.statusCode;
        if (statusCode == 404) {
          throw Exception('No payslip found for $date. Please try a different month.');
        } else if (statusCode == 400) {
          throw Exception('Invalid request. Please check your parameters.');
        } else if (statusCode == 500) {
          throw Exception('Server error. Please try again later.');
        } else {
          throw Exception('Server error (${statusCode}): ${e.response!.statusMessage}');
        }
      } else {
        // Network error
        if (e.type == DioExceptionType.connectionTimeout) {
          throw Exception('Connection timeout. Please check your internet connection.');
        } else if (e.type == DioExceptionType.receiveTimeout) {
          throw Exception('Request timeout. Please try again.');
        } else {
          throw Exception('Network error: ${e.message}');
        }
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }
}