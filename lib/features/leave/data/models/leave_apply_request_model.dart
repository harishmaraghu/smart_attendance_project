class LeaveApplyRequestModel {
  // final int userId;
  final String userName;
  final String leaveCategory;
  final String fromDate;
  final String toDate;
  final String reason;
  final String? attachmentPath; // Local file path for upload

  LeaveApplyRequestModel({
    // required this.userId,
    required this.userName,
    required this.leaveCategory,
    required this.fromDate,
    required this.toDate,
    required this.reason,
    this.attachmentPath,
  });
}


// leave history
class LeaveHistoryModel {
  final String title;
  final String fromDate;
  final String toDate;
  final String status;

  LeaveHistoryModel({
    required this.title,
    required this.fromDate,
    required this.toDate,
    required this.status,
  });

  factory LeaveHistoryModel.fromJson(Map<String, dynamic> json) {
    return LeaveHistoryModel(
      title: json['title'],
      fromDate: json['from_date'],
      toDate: json['to_date'],
      status: json['status'],
    );
  }
}


//
