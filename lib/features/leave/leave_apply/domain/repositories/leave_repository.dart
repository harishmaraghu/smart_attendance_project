import '../../data/models/leave_apply_request_model.dart';

abstract class LeaveRepository {
  Future<List<LeaveHistoryModel>> fetchLeaveHistory(String Userid);
}



