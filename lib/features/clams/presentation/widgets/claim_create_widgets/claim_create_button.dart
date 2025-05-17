import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_text.dart';

class ClaimCreateButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ClaimCreateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {


    return ElevatedButton(
      onPressed: onPressed,
      style: AppTextstyle.ElevatedButton_text_leave_apply,
      child: Text("Save", style: AppTextstyle.button_text),
    );
  }
}


class ClaimAttachmentButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ClaimAttachmentButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {


    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
    padding: const EdgeInsets.all(12),
    backgroundColor: Colors.grey[300],
    ),
    child:  Icon(Icons.add, color: Colors.black),

    );
  }
}

