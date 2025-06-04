import 'dart:convert';

class ClaimModel {
  final String claimGroupName;
  final double claimableAmount;
  final String date;
  final String status;
  final String? description;

  ClaimModel({
    required this.claimGroupName,
    required this.claimableAmount,
    required this.date,
    required this.status,
    this.description,
  });

  factory ClaimModel.fromJson(Map<String, dynamic> json) {
    return ClaimModel(
      claimGroupName: json['ClaimGroupName'] ?? '',
      claimableAmount: (json['ClaimableAmount'] ?? 0.0).toDouble(),
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      description: json['Description'],
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

  static List<ClaimModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => ClaimModel.fromJson(json)).toList();
  }
}
