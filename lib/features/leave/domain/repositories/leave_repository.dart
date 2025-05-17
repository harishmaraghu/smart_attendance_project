import '../../data/models/leave_apply_request_model.dart';

abstract class LeaveRepository {
  Future<void> applyLeave(LeaveApplyRequestModel request);
  Future<List<LeaveHistoryModel>> fetchLeaveHistory();
}


