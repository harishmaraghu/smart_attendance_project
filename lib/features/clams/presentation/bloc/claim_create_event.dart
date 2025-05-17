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

class AttachmentAdded extends ClaimCreateEvent {
  final File attachment;
  AttachmentAdded(this.attachment);
}

class SubmitClaimForm extends ClaimCreateEvent {}
