import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/features/history_claim/presentation/screens/claim_history_screen.dart' show ClaimHistoryScreen;
import '../../../../../core/constants/app_text.dart';
import '../../bloc/claim_create_bloc.dart';
import '../../bloc/claim_create_event.dart';
import '../../bloc/claim_create_state.dart';
import '../../pages/claim_history.dart';
import 'claim_create_button.dart';

class ClaimForm extends StatefulWidget {
  final String userId;
  final String userName;

  const ClaimForm({
    required this.userId,
    required this.userName,
    super.key,
  });

  @override
  State<ClaimForm> createState() => _ClaimFormState();
}

class _ClaimFormState extends State<ClaimForm> {
  InputDecoration _inputDecoration({String? hintText}) {
    return InputDecoration(
      hintText: hintText ?? '',
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
    );
  }

  Future<void> _createbutton() async {
    context.read<ClaimCreateBloc>().add(SubmitClaimForm());
  }

  Future<void> claimattachmentbutton() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      final file = File(result.files.single.path!);
      context.read<ClaimCreateBloc>().add(ClaimAttachmentChanged(file));
    }

  }



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ClaimCreateBloc, ClaimCreateState>(
      builder: (context, state) {
        return Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors().claim_form_card_bg_color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child:  Row(
                    children: [
                      Icon(Icons.receipt_long, color: Colors.white),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          "Enter Details\nSubmit your expense details for office-related purchases to claim reimbursement.",
                          style: TextStyle(color: Colors.white, fontSize: 14),
                        ),

                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ClaimHistoryScreen(userId: widget.userId),
                            ),
                          );
                        },
                        child: Text("View Claim History"),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Claim Group Name
                Text("Claim Group Name*", style: AppTextstyle.claim_form_heading_text),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration(),
                  value: (state.claimGroup == null || state.claimGroup!.isEmpty) ? null : state.claimGroup,
                  items: [
                    'Transport Charges',
                    'MRT Charges',
                    'MC Amount',
                    'Material Reimbursement',
                    'Project wise',
                    'Food or Entertainment'
                  ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ClaimCreateBloc>().add(ClaimGroupChanged(value));
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Claim Name
                Text("Claim Name*", style: AppTextstyle.claim_form_heading_text),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration(),
                  value: (state.claimName == null || state.claimName!.isEmpty) ? null : state.claimName,
                  items: ['All', 'Meal', 'Transport']
                      .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ClaimCreateBloc>().add(ClaimNameChanged(value));
                    }
                  },
                ),

                const SizedBox(height: 16),

                // Receipt No
                Text("Receipt No*", style: AppTextstyle.claim_form_heading_text),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: _inputDecoration(),
                  onChanged: (value) {
                    context.read<ClaimCreateBloc>().add(ReceiptNoChanged(value));
                  },
                ),

                const SizedBox(height: 16),

                // Receipt Amount
                Text("Receipt Amount*", style: AppTextstyle.claim_form_heading_text),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: _inputDecoration(hintText: 'SGD'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<ClaimCreateBloc>().add(ReceiptAmountChanged(value));
                  },
                ),

                const SizedBox(height: 16),

                // Claimable Amount
                Text("Claimable Amount*", style: AppTextstyle.claim_form_heading_text),
                const SizedBox(height: 8),
                TextFormField(
                  decoration: _inputDecoration(hintText: 'SGD'),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    context.read<ClaimCreateBloc>().add(ClaimableAmountChanged(value));
                  },
                ),

                const SizedBox(height: 16),



                Text("Attachment", style: AppTextstyle.claim_form_heading_text),
                const SizedBox(height: 8),
                ClaimAttachmentButton(onPressed: claimattachmentbutton),

                    // Preview the filename
                if (state.attachment != null)
                  Text('Selected file: ${state.attachment!.path.split("/").last}'),


                // Attachment
                // Text("Attachment", style: AppTextstyle.claim_form_heading_text),
                // const SizedBox(height: 8),
                // ClaimAttachmentButton(onPressed: claimattachmentbutton),

                // Show attachment preview
                // _buildAttachmentPreview(state.attachment),

                const SizedBox(height: 24),

                // Submit Button
                ClaimCreateButton(onPressed: _createbutton),

                // Loading indicator - Check if state has isLoading property
                if (state.isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16.0),
                    child: Center(child: CircularProgressIndicator()),
                  ),

                // Error message - Safe null check
                if (state.errorMessage != null && state.errorMessage!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      state.errorMessage!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}