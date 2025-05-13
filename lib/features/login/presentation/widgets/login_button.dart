import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';

class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LoginButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {


    return ElevatedButton(
      onPressed: onPressed,
      style: AppTextstyle.ElevatedButton_text,
      child: Text("Login", style: AppTextstyle.button_text),
    );
  }
}
