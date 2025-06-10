class LeaveDashboardModel {
  final String userId;
  final String name;
  final int totalAnnualLeave;
  final int usedAnnualLeave;
  final int remainingAnnualLeave;
  final int totalSickLeave;
  final int usedSickLeave;
  final int remainingSickLeave;

  LeaveDashboardModel({
    required this.userId,
    required this.name,
    required this.totalAnnualLeave,
    required this.usedAnnualLeave,
    required this.remainingAnnualLeave,
    required this.totalSickLeave,
    required this.usedSickLeave,
    required this.remainingSickLeave,
  });

  factory LeaveDashboardModel.fromJson(Map<String, dynamic> json) {
    return LeaveDashboardModel(
      userId: json['Userid'] ?? '',
      name: json['Name'] ?? '',
      totalAnnualLeave: json['TotalAnnualLeave'] ?? 0,
      usedAnnualLeave: json['UsedAnnualLeave'] ?? 0,
      remainingAnnualLeave: json['RemainingAnnualLeave'] ?? 0,
      totalSickLeave: json['TotalSickLeave'] ?? 0,
      usedSickLeave: json['UsedSickLeave'] ?? 0,
      remainingSickLeave: json['RemainingSickLeave'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Userid': userId,
      'Name': name,
      'TotalAnnualLeave': totalAnnualLeave,
      'UsedAnnualLeave': usedAnnualLeave,
      'RemainingAnnualLeave': remainingAnnualLeave,
      'TotalSickLeave': totalSickLeave,
      'UsedSickLeave': usedSickLeave,
      'RemainingSickLeave': remainingSickLeave,
    };
  }
}