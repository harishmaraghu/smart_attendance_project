import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_attendance_project/features/payment/payslip/data/models/pay_slip_history_models.dart';

class PayslipApiService {
  final Dio _dio = Dio();

  static const String baseUrl = 'https://f3iuldia4e.execute-api.ap-south-1.amazonaws.com/default';

  Future<PayslipModel> getPayslip({
    required String userId,
    required String username,
    required String date,
  }) async {
    try {
      final response = await _dio.get(
        '$baseUrl/Payslip',
        queryParameters: {
          'userId': userId,
          'username': username,
          'date': date,
        },
      );

      if (response.statusCode == 200) {
        // Decode string to Map if response.data is a string
        final data = response.data is String
            ? jsonDecode(response.data)
            : response.data;

        return PayslipModel.fromJson(data);
      }else {
        throw Exception('Failed to load payslip');
      }
    } on DioException catch (e) {
      if (e.response != null) {
        throw Exception('Server error: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
