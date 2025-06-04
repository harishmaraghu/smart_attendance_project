abstract class LeaveDashboardEvent {}

class LoadLeaveDashboard extends LeaveDashboardEvent {
  final String userId;
  final String name;

  LoadLeaveDashboard({
    required this.userId,
    required this.name,
  });
}

class RefreshLeaveDashboard extends LeaveDashboardEvent {
  final String userId;
  final String name;

  RefreshLeaveDashboard({
    required this.userId,
    required this.name,
  });
}