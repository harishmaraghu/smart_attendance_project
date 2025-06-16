class LoanHistoryResponse {
  final List<LoanHistoryItem> data;
  LoanHistoryResponse({required this.data});

  factory LoanHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LoanHistoryResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => LoanHistoryItem.fromJson(item as Map<String, dynamic>))
          .toList() ?? [],
    );
  }
}

class LoanHistoryItem {
  final String userid;
  final String dateOfClaim;
  final double amount;
  final String paymentClaimType;
  final String duration;
  final double emiAmount;
  final String status;
  final String description;
  final String managementApproval;
  final String managementDescription;
  final String username;
  final int stage;

  LoanHistoryItem({
    required this.userid,
    required this.dateOfClaim,
    required this.amount,
    required this.paymentClaimType,
    required this.duration,
    required this.emiAmount,
    required this.status,
    required this.description,
    required this.managementApproval,
    required this.managementDescription,
    required this.username,
    required this.stage,
  });

  factory LoanHistoryItem.fromJson(Map<String, dynamic> json) {
    return LoanHistoryItem(
      userid: json['userid']?.toString() ?? '',
      dateOfClaim: json['date_of_claim']?.toString() ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      paymentClaimType: json['payment_claim_type']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      emiAmount: (json['emi_amount'] ?? 0).toDouble(),
      status: json['status']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      managementApproval: json['management_approval']?.toString() ?? '',
      managementDescription: json['management_description']?.toString() ?? '',
      username: json['username']?.toString() ?? '',
      stage: json['stage'] ?? 0,
    );
  }

  // Enhanced status checking based on your 3-stage logic
  bool get isSuccessful {
    return stage == 2 && status.toLowerCase() != 'rejected';
  }

  bool get isRejected {
    return status.toLowerCase() == 'rejected';
  }

  bool get isProcessing {
    return !isSuccessful && !isRejected;
  }

  // Progress calculation based on your 3-stage system
  double get progressPercentage {
    if (isRejected) return 0.0;

    switch (stage) {
      case 0:
        return 0.0; // 0% - Initial submission/tracking
      case 1:
        return 0.5; // 50% - Admin approved
      case 2:
        return 1.0; // 100% - Completed/Success
      default:
        return 0.0; // Default to 0%
    }
  }

  // Current approval stage for UI display
  String get currentApprovalStage {
    if (isRejected) return 'rejected';

    switch (stage) {
      case 0:
        return 'tracking'; // Initial tracking stage
      case 1:
        return 'admin_approved'; // Admin approval completed
      case 2:
        return 'completed'; // Final success stage
      default:
        return 'pending';
    }
  }

  // Detailed status description for progress tracking
  String get detailedStatusDescription {
    if (isRejected) return 'Application Rejected';

    switch (stage) {
      case 0:
        return 'Application Submitted - Tracking Started';
      case 1:
        return 'Admin Approved - Processing';
      case 2:
        return 'Application Completed Successfully';
      default:
        return 'Application Pending';
    }
  }

  // Next stage description
  String get nextStageDescription {
    if (isRejected || isSuccessful) return '';

    switch (stage) {
      case 0:
        return 'Admin Approval';
      case 1:
        return 'Final Completion';
      default:
        return 'Processing';
    }
  }

  // Display status for UI
  String get displayStatus {
    if (isRejected) return 'Rejected';

    switch (stage) {
      case 0:
        return 'Tracking';
      case 1:
        return 'Admin Approved';
      case 2:
        return 'Completed';
      default:
        return 'Processing';
    }
  }

  // Display type (e.g., "Loan Application")
  String get displayType {
    return '$paymentClaimType Application';
  }

  // Formatted amount with currency
  String get formattedAmount {
    return '₹${amount.toStringAsFixed(0)}';
  }

  // Rejection reason (if applicable)
  String? get rejectionReason {
    if (isRejected && description.isNotEmpty) {
      return description;
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'userid': userid,
      'date_of_claim': dateOfClaim,
      'amount': amount,
      'payment_claim_type': paymentClaimType,
      'duration': duration,
      'emi_amount': emiAmount,
      'status': status,
      'description': description,
      'management_approval': managementApproval,
      'management_description': managementDescription,
      'username': username,
      'stage': stage,
    };
  }

  @override
  String toString() {
    return 'LoanHistoryItem(userid: $userid, amount: $amount, status: $status, stage: $stage, isSuccessful: $isSuccessful, isRejected: $isRejected, progressPercentage: $progressPercentage)';
  }
}