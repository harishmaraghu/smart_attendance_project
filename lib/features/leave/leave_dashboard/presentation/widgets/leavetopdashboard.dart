import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/presentation/pages/leaveapply/leave_apply_screen.dart';
// import 'package:smart_attendance_project/features/leave/presentation/pages/leaveapply/leave_apply_screen.dart';

class TopDashboardHeaderinleavedashboard extends StatefulWidget {
  final String userId;
  final String userName;

  const TopDashboardHeaderinleavedashboard({
    required this.userId,
    required this.userName,
    super.key,
  });

  @override
  State<TopDashboardHeaderinleavedashboard> createState() => _TopDashboardHeaderinAttendanceState();
}


class _TopDashboardHeaderinAttendanceState extends State<TopDashboardHeaderinleavedashboard> {
  final colors = AppColors();
  String username = 'User';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container (
      width: double.infinity,
      padding: EdgeInsets.only(
        top: screenHeight * 0.04,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        bottom: screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundcolor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with menu and notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu Icon with PopupMenu
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/icons/back_icon.png',
                  width: screenWidth * 0.10,
                  height: screenWidth * 0.10,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => LeaveApplyScreen(
                        userId: widget.userId,
                        userName: widget.userName,
                      ),
                    ),
                  );
                },

                child: Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text("Leave apply",style: AppTextstyle.pragra_text,)
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
