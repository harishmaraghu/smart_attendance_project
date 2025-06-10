import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/bloc/pay_slip_bloc.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/bloc/pay_slip_event.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/bloc/pay_slip_state.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/widgets/Deductions.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/widgets/Earnings.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/widgets/Netsalary.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/widgets/PayslipCompanyHeader.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/widgets/employe.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/widgets/topbarpaysliphistory.dart';

class PaymentHistory extends StatefulWidget {
  final String userId;
  final String username;
  final String? selectedDate;

  const PaymentHistory({
    required this.userId,
    required this.username,
    this.selectedDate,
    super.key});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  late String currentDate;
  late String displayDate; // For UI display

  @override
  void initState() {
    super.initState();
    // Initialize current date - use selected date or current month
    if (widget.selectedDate != null) {
      currentDate = widget.selectedDate!;
      displayDate = _convertToDisplayFormat(currentDate);
    } else {
      final now = DateTime.now();
      currentDate = _getCurrentMonthYearForApi();
      displayDate = _getCurrentMonthYearForDisplay();
    }

    print('Initial date for API: $currentDate');
    print('Initial date for display: $displayDate');

    // Load payslip data on page load
    context.read<PayslipBloc>().add(
      LoadPayslip(
        userId: widget.userId,
        username: widget.username,
        date: currentDate,
      ),
    );
  }

  // Format for API: YYYY-MM (e.g., "2025-05")
  String _getCurrentMonthYearForApi() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}';
  }

  // Format for display: Month YYYY (e.g., "May 2025")
  String _getCurrentMonthYearForDisplay() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  // Convert API format (YYYY-MM) to display format (Month YYYY)
  String _convertToDisplayFormat(String apiDate) {
    try {
      final parts = apiDate.split('-');
      if (parts.length == 2) {
        final year = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final months = [
          'January', 'February', 'March', 'April', 'May', 'June',
          'July', 'August', 'September', 'October', 'November', 'December'
        ];
        return '${months[month - 1]} $year';
      }
    } catch (e) {
      print('Error converting date format: $e');
    }
    return apiDate; // Return original if conversion fails
  }

  // Convert display format (Month YYYY) to API format (YYYY-MM)
  String _convertToApiFormat(String displayDate) {
    try {
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];

      final parts = displayDate.split(' ');
      if (parts.length == 2) {
        final monthName = parts[0];
        final year = parts[1];
        final monthIndex = months.indexOf(monthName) + 1;
        return '$year-${monthIndex.toString().padLeft(2, '0')}';
      }
    } catch (e) {
      print('Error converting date format: $e');
    }
    return displayDate; // Return original if conversion fails
  }

  void _onDateChanged(String newDisplayDate) {
    final newApiDate = _convertToApiFormat(newDisplayDate);

    print('Display date changed to: $newDisplayDate');
    print('API date changed to: $newApiDate');

    setState(() {
      currentDate = newApiDate;
      displayDate = newDisplayDate;
    });

    // Reload payslip data with new date
    context.read<PayslipBloc>().add(
      LoadPayslip(
        userId: widget.userId,
        username: widget.username,
        date: currentDate,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [
            TopDashboardinpaysliphistory(
              userId: widget.userId,
              username: widget.username,
              currentDate: displayDate, // Pass display format to UI
              onDateChanged: _onDateChanged,
            ),
            Expanded(
              child: BlocBuilder<PayslipBloc, PayslipState>(
                builder: (context, state) {
                  if (state is PayslipLoading) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else if (state is PayslipLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<PayslipBloc>().add(
                          RefreshPayslip(
                            userId: widget.userId,
                            username: widget.username,
                            date: currentDate, // Use API format
                          ),
                        );
                      },
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            PayslipCompanyHeader(payslip: state.payslip),
                            const SizedBox(height: 16),
                            PayslipEmployeeInfo(payslip: state.payslip),
                            const SizedBox(height: 16),
                            PayslipEarnings(earnings: state.payslip.earnings),
                            const SizedBox(height: 16),
                            PayslipDeductions(deductions: state.payslip.deductions),
                            const SizedBox(height: 16),
                            PayslipNetSalary(netSalary: state.payslip.netSalary),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    );
                  } else if (state is PayslipError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.red.shade400,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading payslip',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.red.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              context.read<PayslipBloc>().add(
                                LoadPayslip(
                                  userId: widget.userId,
                                  username: widget.username,
                                  date: currentDate, // Use API format
                                ),
                              );
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
