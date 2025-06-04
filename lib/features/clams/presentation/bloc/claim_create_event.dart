import 'dart:io';

abstract class ClaimCreateEvent {}

class ClaimGroupChanged extends ClaimCreateEvent {
  final String claimGroup;
  ClaimGroupChanged(this.claimGroup);
}

class ClaimNameChanged extends ClaimCreateEvent {
  final String claimName;
  ClaimNameChanged(this.claimName);
}

class ReceiptNoChanged extends ClaimCreateEvent {
  final String receiptNo;
  ReceiptNoChanged(this.receiptNo);
}

class ReceiptAmountChanged extends ClaimCreateEvent {
  final String amount;
  ReceiptAmountChanged(this.amount);
}

class ClaimableAmountChanged extends ClaimCreateEvent {
  final String claimableAmount;
  ClaimableAmountChanged(this.claimableAmount);
}

class ClaimAttachmentChanged extends ClaimCreateEvent {
  final File file;
  ClaimAttachmentChanged(this.file);
}


class SubmitClaimForm extends ClaimCreateEvent {}

class ResetForm extends ClaimCreateEvent {}

class ClearError extends ClaimCreateEvent {}


/////////////////////////ClaimHistoryEvent based bloc//////////////////////

// claim_history_event.dart
// abstract class ClaimHistoryEvent {}
//
// class FetchClaimHistory extends ClaimHistoryEvent {
//   final String userId;
//   FetchClaimHistory(this.userId);
// }


