class ClaimHistoryModel {
  final String claimGroupName;
  final double claimableAmount;
  final String date;
  final String status;
  final String? description;

  ClaimHistoryModel({
    required this.claimGroupName,
    required this.claimableAmount,
    required this.date,
    required this.status,
    this.description,
  });

  factory ClaimHistoryModel.fromJson(Map<String, dynamic> json) {
    return ClaimHistoryModel(
      claimGroupName: json['ClaimGroupName'] ?? '',
      claimableAmount: (json['ClaimableAmount'] ?? 0).toDouble(),
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      description: json['Description'], // nullable
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ClaimGroupName': claimGroupName,
      'ClaimableAmount': claimableAmount,
      'date': date,
      'status': status,
      if (description != null) 'Description': description,
    };
  }
}
