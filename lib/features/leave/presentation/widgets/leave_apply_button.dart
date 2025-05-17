import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_text.dart';

class LeaveApplyButton extends StatelessWidget {
  final VoidCallback onPressed;

  const LeaveApplyButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {


    return ElevatedButton(
      onPressed: onPressed,
      style: AppTextstyle.ElevatedButton_text_leave_apply,
      child: Text("Apply", style: AppTextstyle.button_text),
    );
  }
}