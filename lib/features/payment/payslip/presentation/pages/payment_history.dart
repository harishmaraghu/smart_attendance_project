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
  // These should come from your app's state management or parameters
  late String currentDate;

  @override
    @override
  void initState() {
    super.initState();
    // Initialize current date - use selected date or current month
    currentDate = widget.selectedDate ?? _getCurrentMonthYear();

    // Load payslip data on page load
    context.read<PayslipBloc>().add(
      LoadPayslip(
        userId: widget.userId,
        username: widget.username,
        date: currentDate,
      ),
    );
  }


  String _getCurrentMonthYear() {
    final now = DateTime.now();
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[now.month - 1]} ${now.year}';
  }

  void _onDateChanged(String newDate) {
    setState(() {
      currentDate = newDate;
    });
    // Reload payslip data with new date
    context.read<PayslipBloc>().add(
      LoadPayslip(
        userId: widget.userId,
        username: widget.username,
        date: newDate,
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
               currentDate: currentDate,
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
                            date: currentDate,
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
                                  date: currentDate,
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
