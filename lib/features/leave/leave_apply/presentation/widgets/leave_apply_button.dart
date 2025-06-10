import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';

class LeaveApplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LeaveApplyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Align(
      alignment: Alignment.centerRight, // Right align the button
      child: SizedBox(
        height: 50,
        width: screenWidth * 0.3,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // or use your AppColor
            side: const BorderSide( // Border style
              color: Colors.white,  // Border color
              width: 1,             // Border thickness
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13),
            ),
          ),
          child: Text("Apply", style: AppTextstyle.button_text),
        ),
      ),
    );
  }
}

