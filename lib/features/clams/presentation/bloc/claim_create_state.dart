import 'dart:io';

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
