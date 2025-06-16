import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';


class TopDashboardHeaderinLeaveApply extends StatelessWidget {
  final colors = AppColors();


  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container  (
      width: double.infinity,
      padding: EdgeInsets.only(
        top: screenHeight * 0.05,
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
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Menu Icon with PopupMenu
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/icons/back_icon.png',
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.10,
                ),
              ),
              SizedBox(width: 12),
              Text('Create Leave',style: AppTextstyle.heading_text.copyWith(
                fontSize: 18,
              ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
