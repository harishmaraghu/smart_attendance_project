import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text.dart';

class VerifyButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;

  const VerifyButtonWidget({
    super.key,
    required this.onPressed,
    this.title = 'Login',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors().button_background_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(
          title,
          style: AppTextstyle.button_text,
        ),
      ),
    );
  }
}
