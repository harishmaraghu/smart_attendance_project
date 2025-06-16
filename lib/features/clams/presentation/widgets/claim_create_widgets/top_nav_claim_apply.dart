import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';
import 'package:smart_attendance_project/features/history_claim/presentation/screens/claim_history_screen.dart';

// import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history/leave_record.dart';
// import 'package:smart_attendance_project/features/leave/presentation/pages/leaveapply/leave_apply_screen.dart';
import '../../../../../core/constants/app_colors.dart';

class TopDashboardHeaderinClaimApply extends StatefulWidget {
  final String userId;

  const TopDashboardHeaderinClaimApply({required this.userId, super.key});

  @override
  State<TopDashboardHeaderinClaimApply> createState() =>
      _TopDashboardHeaderinClaimApplyState();
}

class _TopDashboardHeaderinClaimApplyState
    extends State<TopDashboardHeaderinClaimApply> {
  final colors = AppColors();

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
        color: colors.button_background_color,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Image.asset(
                      'assets/icons/back_icon.png',
                      width: screenWidth * 0.08,
                      height: screenWidth * 0.08,
                    ),
                  ),

                  SizedBox(width: 12),
                  Text(
                    "Create Claim",
                    style: AppTextstyle.heading_text.copyWith(fontSize: 18),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => ClaimHistoryScreen(userId: widget.userId),
                    ),
                  );
                },

                child: Image.asset(
                  'assets/icons/history_icon.png',
                  width: screenWidth * 0.08,
                  height: screenWidth * 0.08,
                ),

                // child: Text("Apply Leave", style: AppTextstyle.pragra_text),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

// ElevatedButton(
// onPressed: () {
// Navigator.push(
// context,
// MaterialPageRoute(
// builder: (context) => ClaimHistoryScreen(userId: widget.userId),
// ),
// );
// },
// child: Text("View Claim History"),
// )
