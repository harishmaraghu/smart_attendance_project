import 'loan_state.dart';

abstract class LoanEvent {}

class SubmitLoanForm extends LoanEvent {
  final String userId;
  final String userName;
  final String paymentClaimType;
  final int amount;
  final String duration;
  final int emiAmount;

  SubmitLoanForm({
    required this.userId,
    required this.userName,
    required this.paymentClaimType,
    required this.amount,
    required this.duration,
    required this.emiAmount,
  });
}



//Loan history
abstract class LoanHistoryEvent {}

class LoadLoanHistory extends LoanHistoryEvent {
  final String userId;
  LoadLoanHistory(this.userId);
}

class RefreshLoanHistory extends LoanHistoryEvent {
  final String userId;
  RefreshLoanHistory(this.userId);
}

class FilterLoanHistory extends LoanHistoryEvent {
  final FilterStatus status;
  FilterLoanHistory(this.status);
}