// loan_state.dart
// abstract class LoanState {}
//
// class LoanInitial extends LoanState {}
//
// class LoanLoading extends LoanState {}
//
// class LoanSuccess extends LoanState {}
//
// class LoanFailure extends LoanState {
//   final String error;
//   LoanFailure(this.error);
// }


import 'package:smart_attendance_project/features/loan/data/models/loan_history_model.dart';

abstract class LoanState {}

class LoanInitial extends LoanState {}

class LoanLoading extends LoanState {}

class LoanSuccess extends LoanState {}

class LoanFailure extends LoanState {
  final String message;
  LoanFailure(this.message);
}



//loan history

enum FilterStatus { all, processing, successful, rejected }

abstract class LoanHistoryState {}

class LoanHistoryInitial extends LoanHistoryState {}

class LoanHistoryLoading extends LoanHistoryState {}

class LoanHistoryLoaded extends LoanHistoryState {
  final List<LoanHistoryItem> allItems;
  final List<LoanHistoryItem> filteredItems;
  final int processingCount;
  final int successfulCount;
  final int rejectedCount;
  final FilterStatus currentFilter;

  LoanHistoryLoaded({
    required this.allItems,
    required this.filteredItems,
    required this.processingCount,
    required this.successfulCount,
    required this.rejectedCount,
    required this.currentFilter,
  });
}

class LoanHistoryError extends LoanHistoryState {
  final String message;
  LoanHistoryError(this.message);
}