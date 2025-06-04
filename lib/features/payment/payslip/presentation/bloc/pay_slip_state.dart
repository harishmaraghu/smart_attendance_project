import 'package:smart_attendance_project/features/payment/payslip/data/models/pay_slip_history_models.dart';

abstract class PayslipState {}

class PayslipInitial extends PayslipState {}

class PayslipLoading extends PayslipState {}

class PayslipLoaded extends PayslipState {
  final PayslipModel payslip;

  PayslipLoaded(this.payslip);
}

class PayslipError extends PayslipState {
  final String message;

  PayslipError(this.message);
}