// import 'package:smart_attendance_project/features/loan/data/models/loan_history_model.dart';

import 'package:smart_attendance_project/features/loan/data/models/loan_history_model.dart';

abstract class LoanHistoryRepository {
  Future<LoanHistoryResponse> getLoanHistory(String userId);
}