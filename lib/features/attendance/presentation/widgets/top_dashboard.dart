import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/shared_prefsHelper.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';
// import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history/leave_record.dart';
import '../../../../core/constants/app_colors.dart';


class TopDashboardHeaderinAttendance extends StatefulWidget {
  @override
  State<TopDashboardHeaderinAttendance> createState() => _TopDashboardHeaderinAttendanceState();
}

class _TopDashboardHeaderinAttendanceState extends State<TopDashboardHeaderinAttendance> {
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


              // Notification Icon with onTap
              GestureDetector(
                onTap: () {
                  // Handle notification tap here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No new notifications'),
                    ),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.notifications_none,
                      color: AppColors().dashboard_icon_color, size: 22),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
