abstract class PayslipEvent {}

class LoadPayslip extends PayslipEvent {
  final String userId;
  final String username;
  final String date;

  LoadPayslip({
    required this.userId,
    required this.username,
    required this.date,
  });
}

class RefreshPayslip extends PayslipEvent {
  final String userId;
  final String username;
  final String date;

  RefreshPayslip({
    required this.userId,
    required this.username,
    required this.date,
  });
}