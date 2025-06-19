import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/features/loan/data/models/loan_history_model.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_bloc.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_event.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_state.dart';
import 'package:smart_attendance_project/features/loan/presentation/widgets/history/history_tapbar.dart';

class HistoryView extends StatefulWidget {
  final String Userid;
  final String username;

  const HistoryView({required this.Userid, required this.username, Key? key})
      : super(key: key);

  @override
  State<HistoryView> createState() => _HistoryViewState();
}

class _HistoryViewState extends State<HistoryView> {
  @override
  void initState() {
    super.initState();
    // Load loan history when screen opens
    context.read<LoanHistoryBloc>().add(LoadLoanHistory(widget.Userid));
  }

  Map<String, bool> _showReasonMap = {};


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().loan_history_form_bg,
      body: SafeArea(
        child: Column(
          children: [
            TopDashboardinLoanHistory(), // Custom top widget (replaces AppBar)
            Expanded(
              child: BlocBuilder<LoanHistoryBloc, LoanHistoryState>(
                builder: (context, state) {
                  if (state is LoanHistoryLoading) {
                    return  Center(
                      child: CircularProgressIndicator(
                        color:AppColors().backgroundcolor,
                      ),
                    );
                  }

                  if (state is LoanHistoryError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.error_outline,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Error loading history',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            state.message,
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[500],
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton(
                            onPressed: () {
                              context.read<LoanHistoryBloc>().add(
                                LoadLoanHistory(widget.Userid),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF2196F3),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is LoanHistoryLoaded) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        context.read<LoanHistoryBloc>().add(
                          RefreshLoanHistory(widget.Userid),
                        );
                      },
                      child: Column(
                        children: [
                          // Filter cards row with continuous progress bar
                          Container(
                            margin: const EdgeInsets.all(18),
                            decoration: BoxDecoration(
                              color: AppColors().loan_history_form_bg,
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: AppColors().whitecolor,
                                width: 1,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors().block_color.withAlpha(16),
                                  blurRadius: 12,
                                  offset: const Offset(1, 2),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                // Status cards row
                                Row(
                                  children: [
                                    _buildStatusCard(
                                      image: Image.asset(
                                        'assets/icons/processing_icon.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                      label: 'Processing',
                                      isSelected: state.currentFilter == FilterStatus.processing,
                                      onTap: () => context.read<LoanHistoryBloc>().add(
                                        FilterLoanHistory(FilterStatus.processing),
                                      ),
                                    ),
                                    _buildStatusCard(
                                      image: Image.asset(
                                        'assets/icons/complete_icon.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                      label: 'Successful',
                                      isSelected: state.currentFilter == FilterStatus.successful,
                                      onTap: () => context.read<LoanHistoryBloc>().add(
                                        FilterLoanHistory(FilterStatus.successful),
                                      ),
                                    ),
                                    _buildStatusCard(
                                      image: Image.asset(
                                        'assets/icons/rejected_icon.png',
                                        width: 24,
                                        height: 24,
                                      ),
                                      label: 'Rejected',
                                      isSelected: state.currentFilter == FilterStatus.rejected,
                                      onTap: () => context.read<LoanHistoryBloc>().add(
                                        FilterLoanHistory(FilterStatus.rejected),
                                      ),
                                    ),
                                  ],
                                ),
                                // Continuous progress bar below all status cards
                                Container(
                                  height: 8,
                                  margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                                  child: Row(
                                    children: [
                                      // Processing section
                                      Expanded(
                                        child: Container(
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: state.currentFilter == FilterStatus.processing
                                                ? const Color(0xff08456B)
                                                : Colors.grey[300],
                                            borderRadius: const BorderRadius.only(
                                              topLeft: Radius.circular(6),
                                              bottomLeft: Radius.circular(6),
                                            ),
                                          ),
                                        ),
                                      ),
                                      // Successful section
                                      Expanded(
                                        child: Container(
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: state.currentFilter == FilterStatus.successful
                                                ? const Color(0xff27B130)
                                                : Colors.grey[300],
                                          ),
                                        ),
                                      ),
                                      // Rejected section
                                      Expanded(
                                        child: Container(
                                          height: 6,
                                          decoration: BoxDecoration(
                                            color: state.currentFilter == FilterStatus.rejected
                                                ? Colors.red
                                                : Colors.grey[300],
                                            borderRadius: const BorderRadius.only(
                                              topRight: Radius.circular(6),
                                              bottomRight: Radius.circular(6),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // History List
                          Expanded(
                            child: state.filteredItems.isEmpty
                                ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.history,
                                    size: 64,
                                    color: Colors.grey[300],
                                  ),
                                  const SizedBox(height: 16),
                                  Text(
                                    state.currentFilter == FilterStatus.all
                                        ? 'No history found'
                                        : 'No ${_getFilterLabel(state.currentFilter)} items found',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (state.currentFilter != FilterStatus.all)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 16),
                                      child: TextButton(
                                        onPressed: () => context
                                            .read<LoanHistoryBloc>()
                                            .add(
                                          FilterLoanHistory(FilterStatus.all),
                                        ),
                                        child: const Text('Show All'),
                                      ),
                                    ),
                                ],
                              ),
                            )
                                : ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              itemCount: state.filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = state.filteredItems[index];
                                return _buildHistoryItem(item, state.currentFilter);
                              },
                            ),
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

  Widget _buildStatusCard({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Widget image,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              image,
              const SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    color: Colors.grey
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryItem(LoanHistoryItem item, FilterStatus currentFilter) {
    final bool isProcessing =
        item.status.toLowerCase() != 'approved' &&
            item.status.toLowerCase() != 'rejected';
    final bool isRejected = item.status.toLowerCase() == 'rejected';

    // Get the unique key for this item's show reason state
    final String itemKey = '${item.dateOfClaim}_${item.amount}_${item.paymentClaimType}';

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors().loan_history_form_bg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors().whitecolor,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(30),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Show tracking progress for processing items
          if (isProcessing && currentFilter == FilterStatus.processing)
            _buildTrackingProgress(item),

          // First Layer/Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: AppColors().whitecolor,
                  width: 4,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Received',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDate(item.dateOfClaim),
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                // Text(
                //   _formatTime(item.dateOfClaim),
                //   style: TextStyle(
                //     fontSize: 12,
                //     color: Colors.grey[600],
                //     fontWeight: FontWeight.w500,
                //   ),
                // ),
              ],
            ),
          ),

          // Second Layer/Section
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                    color: AppColors().whitecolor,
                    width: 2
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.displayType,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Date of claim ${_formatDate(item.dateOfClaim)}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      item.formattedAmount,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          child: Text(
                            _getDisplayStatus(item.status),
                            style: TextStyle(
                              fontSize: 12,
                              color: _getStatusColor(item.status),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        // Show "View Reason" button only for rejected items
                        if (isRejected && item.rejectionReason != null && item.rejectionReason!.isNotEmpty)
                          const SizedBox(width: 8),
                        if (isRejected && item.rejectionReason != null && item.rejectionReason!.isNotEmpty)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _showReasonMap[itemKey] = !(_showReasonMap[itemKey] ?? false);
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    (_showReasonMap[itemKey] ?? false)
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    size: 12,
                                    color: Colors.red,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    (_showReasonMap[itemKey] ?? false)
                                        ? 'Hide Reason'
                                        : 'View Reason',
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.red,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Rejection Reason Section (conditionally shown)
          if (isRejected &&
              item.rejectionReason != null &&
              item.rejectionReason!.isNotEmpty &&
              (_showReasonMap[itemKey] ?? false))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.05),
                border: Border(
                  top: BorderSide(
                    color: Colors.red.withOpacity(0.2),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 16,
                        color: Colors.red[700],
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Rejection Reason',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.red[700],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.rejectionReason!,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.red[600],
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTrackingProgress(LoanHistoryItem item) {
    final bool isCompleted =
        item.status.toLowerCase() == 'approved' &&
            item.managementApproval?.toLowerCase() == 'approved';

    Color progressColor;
    if (item.status.toLowerCase() == 'approved' &&
        item.managementApproval?.toLowerCase() == 'approved') {
      progressColor = const Color(0xFF27B130); // Green
    } else if (item.status.toLowerCase() == 'rejected') {
      progressColor = Colors.red; // Red
    } else {
      switch (item.currentApprovalStage) {
        case 'admin_review':
          progressColor = const Color(0xFF2196F3); // Blue
          break;
        case 'management_review':
        case 'management_pending':
          progressColor = const Color(0xFFFF9800); // Orange
          break;
        default:
          progressColor = const Color(0xFF2196F3); // Default Blue
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Tracking Progress',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: isCompleted ? 1.0 : null,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
          minHeight: 8,
        ),
        const SizedBox(height: 8),
        Text(
          isCompleted ? 'Loan request successfully completed' : 'Processing...',
          style: TextStyle(
            color: isCompleted ? const Color(0xFF27B130) : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }


// Timeline step widget
  Widget _buildTimelineStep({
    required String title,
    required String subtitle,
    required bool isActive,
    required bool isCompleted,
    required Color progressColor,
  }) {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted
                ? const Color(0xFF27B130)
                : isActive
                ? progressColor
                : Colors.grey[300],
            border: Border.all(
              color: Colors.white,
              width: 2,
            ),
          ),
          child: isCompleted
              ? const Icon(
            Icons.check,
            size: 14,
            color: Colors.white,
          )
              : isActive
              ? Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          )
              : null,
        ),
        const SizedBox(height: 6),
        Text(
          title,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.black87 : Colors.grey[500],
          ),
        ),
        Text(
          subtitle,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w400,
            color: isActive ? Colors.grey[600] : Colors.grey[400],
          ),
        ),
      ],
    );
  }

// Timeline connector widget
  Widget _buildTimelineConnector({
    required bool isActive,
    required Color progressColor,
  }) {
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 30),
        decoration: BoxDecoration(
          color: isActive ? progressColor : Colors.grey[300],
          borderRadius: BorderRadius.circular(1),
        ),
      ),
    );
  }





  Color _getStatusColor(String status) {
    // You might want to pass the whole item instead of just status string
    switch (status.toLowerCase()) {
      case 'successful':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.blue;
    }
  }

  String _getDisplayStatus(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Successful';
      case 'rejected':
        return 'Rejected';
      default:
        return 'Processing';
    }
  }

  String _getFilterLabel(FilterStatus filter) {
    switch (filter) {
      case FilterStatus.processing:
        return 'processing';
      case FilterStatus.successful:
        return 'successful';
      case FilterStatus.rejected:
        return 'rejected';
      default:
        return 'all';
    }
  }

  String _formatDate(String dateString) {
    try {
      final date = DateTime.parse(dateString);
      return DateFormat('dd MMM yy').format(date);
    } catch (e) {
      return dateString;
    }
  }

  // String _formatTime(String dateString) {
  //   try {
  //     final date = DateTime.parse(dateString);
  //     return DateFormat('hh:mm a').format(date);
  //   } catch (e) {
  //     // Optionally print error or handle logging
  //     return DateFormat('hh:mm a').format(DateTime.now()); // Return current time if parsing fails
  //   }
  // }
}


