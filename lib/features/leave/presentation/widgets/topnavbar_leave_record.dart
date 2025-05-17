import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/pages/home_screen.dart';
import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history/leave_record.dart';
import 'package:smart_attendance_project/features/leave/presentation/pages/leaveapply/leave_apply_screen.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../attendance/presentation/pages/attendance_history.dart';
import '../../../payment/presentation/pages/payment_history.dart';

class TopDashboardHeaderinLeave extends StatelessWidget {
  final colors = AppColors();
  final String username ="demo";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container  (
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
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>HomeScreen(username: username,)));
                  },
                child: Image.asset(
                  'assets/icons/back_icon.png',
                  width: screenWidth * 0.10,
                  height: screenWidth * 0.10,
                ),
              ),


              // Notification Icon with onTap
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context)=>LeaveApplyScreen(username: username,)));

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
