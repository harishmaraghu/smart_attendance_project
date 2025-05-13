import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_history.dart';
import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../attendance/presentation/pages/attendance_history.dart';
import '../../../payment/presentation/pages/payment_history.dart';

class TopDashboardHeader extends StatelessWidget {
  final colors = AppColors();
  final String username ="demo";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
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
              PopupMenuButton<String>(
                offset: Offset(0, 40), // Adjust dropdown position below the icon
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(value: 'attendance', child: Text('Attendance')),
                  PopupMenuItem(value: 'logout', child: Text('Logout')),
                ],
                onSelected: (value) {
                  if (value == 'logout') {
                    // Logout logic
                  } else if (value == 'attendance') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AttendanceHistory(username: username)),
                    );
                  }
                },
                child: Icon(Icons.menu, color: Colors.white, size: 28),
              ),

              // Notification Icon with onTap
              GestureDetector(
                onTap: () {
                  // Handle notification tap here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No new notifications')),
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

          SizedBox(height: 20),

          // Greeting text
          Text.rich(
            TextSpan(
              text: 'Hello, ',
              style: TextStyle(fontSize: 22, color: Colors.white),
              children: [
                TextSpan(
                  text: '${username}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Welcome back to your dashboard.',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          SizedBox(height: 20),

          // Floating white card with icons
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIcon(Icons.access_time, 'Attendance', () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => AttendanceHistory(username: username)));
                }),
                _buildIcon(Icons.assignment, 'Claims', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ClaimsHistory()));
                }),
                _buildIcon(Icons.receipt_long, 'Payslip', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentHistory()));
                }),
                _buildIcon(Icons.time_to_leave, 'Leave', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LeaveHistory()));
                }),
              ],
            ),

          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, String label,VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column( children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors().dashboard_icon_background, // A subtle color, e.g., light grey or blue tint
          child: Icon(
            icon,
            color: colors.dashboard_icon_color, // Use your defined dashboard icon color
            size: 23,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],),

    );
  }

}
