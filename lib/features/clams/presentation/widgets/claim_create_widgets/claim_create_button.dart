import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/constants/app_text.dart';
import '../../bloc/claim_create_bloc.dart';
import '../../bloc/claim_create_event.dart';
import '../../bloc/claim_create_state.dart';


class ClaimCreateButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ClaimCreateButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        BlocBuilder<ClaimCreateBloc, ClaimCreateState>(
          builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: state.isSubmitting ? null : onPressed,
                style: AppTextstyle.ElevatedButton_text_leave_apply,
                child: state.isSubmitting
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    SizedBox(width: 8),
                    Text("Submitting..."),
                  ],
                )
                    : Text("Save", style: AppTextstyle.button_text),
              ),
            );
          },
        ),
        BlocBuilder<ClaimCreateBloc, ClaimCreateState>(
          builder: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: Colors.red.shade200),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.error_outline, color: Colors.red, size: 16),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }
}


class ClaimAttachmentButton extends StatelessWidget {
  final VoidCallback onPressed;
  const ClaimAttachmentButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.attach_file, color: Colors.grey),
              ),
              const SizedBox(width: 12),
              const Text(
                'Add Attachment',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),
              const Icon(Icons.add, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
