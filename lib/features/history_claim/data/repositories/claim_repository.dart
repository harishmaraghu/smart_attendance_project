import 'package:smart_attendance_project/features/history_claim/data/datasources/claim_remote_datasource.dart' show ClaimRemoteDataSource;
import 'package:smart_attendance_project/features/history_claim/data/models/claim_model.dart' show ClaimModel;

abstract class ClaimHisRepository {
  Future<List<ClaimModel>> getClaims(String userId);
}

class ClaimRepositoryImpl implements ClaimHisRepository {
  final ClaimRemoteDataSource remoteDataSource;

  ClaimRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<ClaimModel>> getClaims(String userId) async {
    return await remoteDataSource.getClaims(userId);
  }
}
