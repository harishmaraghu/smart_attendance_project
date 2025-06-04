class PayslipModel {
  final String company;
  final String address;
  final String paySlipFor;
  final String employeeName;
  final String userId;
  final String fileName;
  final Earnings earnings;
  final Deductions deductions;
  final double netSalary;

  PayslipModel({
    required this.company,
    required this.address,
    required this.paySlipFor,
    required this.employeeName,
    required this.userId,
    required this.fileName,
    required this.earnings,
    required this.deductions,
    required this.netSalary,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    return PayslipModel(
      company: json['company'] ?? '',
      address: json['address'] ?? '',
      paySlipFor: json['paySlipFor'] ?? '',
      employeeName: json['employeeName'] ?? '',
      userId: json['userId'] ?? '',
      fileName: json['fileName'] ?? '',
      earnings: Earnings.fromJson(json['earnings'] ?? {}),
      deductions: Deductions.fromJson(json['deductions'] ?? {}),
      netSalary: (json['netSalary'] ?? 0).toDouble(),
    );
  }
}

class Earnings {
  final double grossSalary;
  final double totalEarnings;

  Earnings({
    required this.grossSalary,
    required this.totalEarnings,
  });

  factory Earnings.fromJson(Map<String, dynamic> json) {
    return Earnings(
      grossSalary: (json['grossSalary'] ?? 0).toDouble(),
      totalEarnings: (json['totalEarnings'] ?? 0).toDouble(),
    );
  }
}

class Deductions {
  final double loanDeduction;
  final double transportCharges;
  final double totalDeductions;

  Deductions({
    required this.loanDeduction,
    required this.transportCharges,
    required this.totalDeductions,
  });

  factory Deductions.fromJson(Map<String, dynamic> json) {
    return Deductions(
      loanDeduction: (json['loanDeduction'] ?? 0).toDouble(),
      transportCharges: (json['transportCharges'] ?? 0).toDouble(),
      totalDeductions: (json['totalDeductions'] ?? 0).toDouble(),
    );
  }
}
