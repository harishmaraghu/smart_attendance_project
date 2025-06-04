import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';
import 'package:smart_attendance_project/features/history_claim/presentation/screens/claim_history_screen.dart';
// import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history/leave_record.dart';
// import 'package:smart_attendance_project/features/leave/presentation/pages/leaveapply/leave_apply_screen.dart';
import '../../../../../core/constants/app_colors.dart';

class TopDashboardHeaderinClaimApply extends StatelessWidget {
  final colors = AppColors();
  final String userId;
  final String userName;

   TopDashboardHeaderinClaimApply({
    required this.userId,
    required this.userName,
    super.key,
  });

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
              // Back Icon
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/icons/back_icon.png',
                  width: screenWidth * 0.12,
                  height: screenWidth * 0.10,
                ),
              ),

              // Title (Centered-ish)
              Text(
                'Create Claim',
                style: AppTextstyle.normal_text_2,
              ),

              // History Button/Icon (You can replace with Icon or Image as needed)
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClaimHistoryScreen(userId: userId),
                  ),
                ),
                child: Icon(Icons.history), // or use Image.asset() for custom icon
              ),
            ],
          ),

        ],
      ),
    );
  }
}
