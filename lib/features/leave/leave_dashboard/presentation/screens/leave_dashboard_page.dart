import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/presentation/pages/leave_history/leave_record.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/data/models/leavedashboard_model.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/bloc/leave_dash_bloc.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/bloc/leave_dash_event.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/bloc/leave_dash_state.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/widgets/dashbord_widgets.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/widgets/leavetopdashboard.dart' show TopDashboardHeaderinleavedashboard;
// import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history/leave_record.dart';


class LeaveDashboardPage extends StatefulWidget {
  final String Userid;
  final String username;
  const LeaveDashboardPage({required this.Userid, required this.username,super.key});

  @override
  State<LeaveDashboardPage> createState() => _LeaveDashboardPageState();
}

class _LeaveDashboardPageState extends State<LeaveDashboardPage> {
  @override
  void initState() {
    super.initState();
    // Load dashboard data when page initializes
    context.read<LeaveDashboardBloc>().add(
      LoadLeaveDashboard(
        userId:widget.Userid, // Replace with actual user ID
        name: widget.username, // Replace with actual name
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: Column(
          children: [
            // Top navbar
             TopDashboardHeaderinleavedashboard(userId: widget.Userid,userName: widget.username,),

            // Body content
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  context.read<LeaveDashboardBloc>().add(
                    RefreshLeaveDashboard(
                      userId:widget.Userid, // Replace with actual user ID
                      name: widget.username,// Replace with actual name
                    ),
                  );
                },
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: BlocBuilder<LeaveDashboardBloc, LeaveDashboardState>(
                      builder: (context, state) {
                        if (state is LeaveDashboardLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (state is LeaveDashboardLoaded) {
                          return _buildDashboardContent(state.leaveDashboard);
                        } else if (state is LeaveDashboardError) {
                          return _buildErrorWidget(state.message);
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent(LeaveDashboardModel dashboard) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Overall Leave Details',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[800],
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Track your total, used, and remaining leaves at a glance.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Leave Cards
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LeaveCardWidget(
              title: 'Total Annual\nLeave',
              count: dashboard.totalAnnualLeave.toString().padLeft(2, '0'),
              subtitle: '',
              backgroundColor: Colors.blue[600]!,
            ),
            LeaveCardWidget(
              title: 'Leave Taken',
              count: dashboard.usedAnnualLeave.toString().padLeft(2, '0'),
              subtitle: 'Balance Leave ${dashboard.remainingAnnualLeave.toString().padLeft(2, '0')}',
              backgroundColor: Colors.blue[200]!,
              textColor: Colors.blue[800]!,
            ),
          ],
        ),

        const SizedBox(height: 16),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            LeaveCardWidget(
              title: 'Total Sick\nLeave',
              count: dashboard.totalSickLeave.toString().padLeft(2, '0'),
              subtitle: '',
              backgroundColor: Colors.blue[800]!,
            ),
            LeaveCardWidget(
              title: 'Leave Taken',
              count: dashboard.usedSickLeave.toString().padLeft(2, '0'),
              subtitle: 'Balance Leave ${dashboard.remainingSickLeave.toString().padLeft(2, '0')}',
              backgroundColor: Colors.blue[400]!,
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Leave History Button
        Center(
          child: ElevatedButton(
            onPressed: () {
              if (widget.Userid.isNotEmpty) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LeaveHistory(Userid: widget.Userid),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("User ID not found")),
                );
              }
            },

            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[400],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              elevation: 2,
            ),
            child: const Text(
              'Leave History',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),

        const SizedBox(height: 24),

        // Additional Info Cards
        // _buildInfoCard(
        //   'Annual Leave Summary',
        //   'Used: ${dashboard.usedAnnualLeave} / ${dashboard.totalAnnualLeave}',
        //   'Remaining: ${dashboard.remainingAnnualLeave} days',
        //   Colors.green[100]!,
        //   Colors.green[800]!,
        // ),

        // const SizedBox(height: 16),

        // _buildInfoCard(
        //   'Sick Leave Summary',
        //   'Used: ${dashboard.usedSickLeave} / ${dashboard.totalSickLeave}',
        //   'Remaining: ${dashboard.remainingSickLeave} days',
        //   Colors.orange[100]!,
        //   Colors.orange[800]!,
        // ),
      ],
    );
  }

  // Widget _buildInfoCard(String title, String subtitle, String trailing, Color backgroundColor, Color textColor) {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: backgroundColor,
  //       borderRadius: BorderRadius.circular(12),
  //       border: Border.all(color: textColor.withOpacity(0.2)),
  //     ),
  //     child: Column(
  //       crossAxisAlignment: CrossAxisAlignment.start,
  //       children: [
  //         Text(
  //           title,
  //           style: TextStyle(
  //             fontSize: 16,
  //             fontWeight: FontWeight.bold,
  //             color: textColor,
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           subtitle,
  //           style: TextStyle(
  //             fontSize: 14,
  //             color: textColor.withOpacity(0.8),
  //           ),
  //         ),
  //         const SizedBox(height: 4),
  //         Text(
  //           trailing,
  //           style: TextStyle(
  //             fontSize: 14,
  //             fontWeight: FontWeight.w600,
  //             color: textColor,
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildErrorWidget(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 64,
            color: Colors.red[400],
          ),
          const SizedBox(height: 16),
          Text(
            'Error Loading Dashboard',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.read<LeaveDashboardBloc>().add(
                LoadLeaveDashboard(
                  userId:widget.Userid, // Replace with actual user ID
                  name: widget.username,
                ),
              );
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
