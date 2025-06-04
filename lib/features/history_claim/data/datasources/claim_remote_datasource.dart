import 'package:smart_attendance_project/features/history_claim/constants/network.dart' show ApiClient;

import '../models/claim_model.dart';


abstract class ClaimRemoteDataSource {
  Future<List<ClaimModel>> getClaims(String userId);
}

class ClaimRemoteDataSourceImpl implements ClaimRemoteDataSource {
  final ApiClient apiClient;

  ClaimRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<List<ClaimModel>> getClaims(String userId) async {
    try {
      final jsonList = await apiClient.fetchClaims(userId);
      return ClaimModel.fromJsonList(jsonList);
    } catch (e) {
      throw Exception('Failed to fetch claims: $e');
    }
  }
}