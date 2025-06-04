import 'package:smart_attendance_project/features/leave/leave_dashboard/data/models/leavedashboard_model.dart';

abstract class LeaveDashboardState {}

class LeaveDashboardInitial extends LeaveDashboardState {}

class LeaveDashboardLoading extends LeaveDashboardState {}

class LeaveDashboardLoaded extends LeaveDashboardState {
  final LeaveDashboardModel leaveDashboard;

  LeaveDashboardLoaded({required this.leaveDashboard});
}

class LeaveDashboardError extends LeaveDashboardState {
  final String message;

  LeaveDashboardError({required this.message});
}