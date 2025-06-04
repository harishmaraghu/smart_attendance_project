import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/payment/payslip/data/models/pay_slip_history_models.dart';

class PayslipDeductions extends StatelessWidget {
  final Deductions deductions;

  const PayslipDeductions({
    Key? key,
    required this.deductions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_down, color: Colors.red.shade600),
              const SizedBox(width: 8),
              Text(
                'Deductions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.red.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDeductionRow('Loan Deduction', deductions.loanDeduction),
          _buildDeductionRow('Transport Charges', deductions.transportCharges),
          const Divider(),
          _buildDeductionRow(
            'Total Deductions',
            deductions.totalDeductions,
            isTotal: true,
          ),
        ],
      ),
    );
  }

  Widget _buildDeductionRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              color: Colors.red.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
