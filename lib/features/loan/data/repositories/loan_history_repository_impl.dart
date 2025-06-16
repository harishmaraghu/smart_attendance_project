import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:smart_attendance_project/features/loan/data/models/loan_history_model.dart';
import 'package:smart_attendance_project/features/loan/data/repositories/loan_history_repository.dart';

class LoanHistoryRepositoryImpl implements LoanHistoryRepository {
  final Dio _dio;
  static const String baseUrl = 'https://5a5n23d935.execute-api.ap-south-1.amazonaws.com/default';

  LoanHistoryRepositoryImpl({Dio? dio}) : _dio = dio ?? Dio();

  @override
  Future<LoanHistoryResponse> getLoanHistory(String userId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/Loanhistory',
        queryParameters: {'userid': userId},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
          },
          receiveTimeout: const Duration(seconds: 10),
        ),
      );

      print('Status Code: ${response.statusCode}');
      print('Response data: ${response.data}');
      print('Data type: ${response.data.runtimeType}');

      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          return LoanHistoryResponse.fromJson(response.data);
        } else if (response.data is String) {
          final parsed = jsonDecode(response.data);
          if (parsed is Map<String, dynamic>) {
            return LoanHistoryResponse.fromJson(parsed);
          } else {
            throw Exception('Expected Map<String, dynamic> but got ${parsed.runtimeType}');
          }
        } else {
          throw Exception('Expected Map<String, dynamic> but got ${response.data.runtimeType}');
        }
      } else {
        throw Exception('Failed to load loan history: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

}