import 'dart:io';

import '../../data/models/claim_history_model.dart';

class ClaimCreateState {
  final String? claimGroup;
  final String? claimName;
  final String? receiptNo;
  final String? receiptAmount;
  final String? claimableAmount;
  final File? attachment;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;
  final bool isLoading;

  ClaimCreateState({
    this.claimGroup,
    this.claimName,
    this.receiptNo,
    this.receiptAmount,
    this.claimableAmount,
    this.attachment,
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
    this.isLoading = false,
  });

  ClaimCreateState copyWith({
    String? claimGroup,
    String? claimName,
    String? receiptNo,
    String? receiptAmount,
    String? claimableAmount,
    File? attachment,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return ClaimCreateState(
      claimGroup: claimGroup ?? this.claimGroup,
      claimName: claimName ?? this.claimName,
      receiptNo: receiptNo ?? this.receiptNo,
      receiptAmount: receiptAmount ?? this.receiptAmount,
      claimableAmount: claimableAmount ?? this.claimableAmount,
      attachment: attachment ?? this.attachment,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,

    );
  }
}


///////////////////////ClaimHistoryEvent based bloc////////////////////////
//
// // claim_history_state.dart
// abstract class ClaimHistoryState {}
//
// class ClaimHistoryInitial extends ClaimHistoryState {}
//
// class ClaimHistoryLoading extends ClaimHistoryState {}
//
// class ClaimHistoryLoaded extends ClaimHistoryState {
//   final List<ClaimHistoryModel> claims;
//   ClaimHistoryLoaded(this.claims);
// }
//
// class ClaimHistoryError extends ClaimHistoryState {
//   final String message;
//   ClaimHistoryError(this.message);
// }
