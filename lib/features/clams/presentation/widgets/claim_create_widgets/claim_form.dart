import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import '../../../../../core/constants/app_text.dart';
import '../../bloc/claim_create_bloc.dart';
import '../../bloc/claim_create_event.dart';
import '../../bloc/claim_create_state.dart';
import 'claim_create_button.dart';

class ClaimForm extends StatefulWidget {
  final String userId;
  final String userName;
  const ClaimForm({
    required this.userId, required this.userName,
    super.key,
  });

  @override
  State<ClaimForm> createState() => _ClaimFormState();


}

class _ClaimFormState extends State<ClaimForm> {
  File? selectedAttachment;
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
    // Final confirmation dialog
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Photo"),
              onTap: () async {
                Navigator.pop(context);
                final pickedFile = await ImagePicker().pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  final file = File(pickedFile.path);
                  context.read<ClaimCreateBloc>().add(AttachmentAdded(file));
                }
              },
            ),
            ListTile(
              leading: Icon(Icons.folder),
              title: Text("Pick File"),
              onTap: () async {
                Navigator.pop(context);
                final result = await FilePicker.platform.pickFiles();
                if (result != null && result.files.single.path != null) {
                  final file = File(result.files.single.path!);
                  context.read<ClaimCreateBloc>().add(AttachmentAdded(file));
                }
              },
            ),
          ],
        );
      },
    );
    BlocBuilder<ClaimCreateBloc, ClaimCreateState>(
      builder: (context, state) {
        if (state.attachment != null) {
          return Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              "Selected: ${state.attachment!.path.split('/').last}",
              style: const TextStyle(color: Colors.black),
            ),
          );
        }
        return SizedBox.shrink();
      },
    );


  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors().claim_form_card_bg_color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: const [
                Icon(Icons.receipt_long, color: Colors.white),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    "Enter Details\nSubmit your expense details for office-related purchases to claim reimbursement.",
                    style:   TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text("Claim Group Name*", style: AppTextstyle.claim_form_heading_text),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(),
            items: ['Entertainment claim', 'Travel claim']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {
              if (value != null) {
                context.read<ClaimCreateBloc>().add(ClaimGroupChanged(value));
              }
            },
          ),

          const SizedBox(height: 16),
          Text("Claim Name*", style: AppTextstyle.claim_form_heading_text),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            decoration: _inputDecoration(),
            items: ['All', 'Meal', 'Transport']
                .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                .toList(),
            onChanged: (value) {context.read<ClaimCreateBloc>().add(ClaimNameChanged(value!));},
          ),
          const SizedBox(height: 16),
          Text("Receipt No*", style: AppTextstyle.claim_form_heading_text),
          const SizedBox(height: 8),
          TextFormField(
            decoration: _inputDecoration(),
            onChanged: (value) {
              context.read<ClaimCreateBloc>().add(ReceiptNoChanged(value));
            },
          ),

          const SizedBox(height: 16),
          Text("Receipt Amount*", style: AppTextstyle.claim_form_heading_text),
          const SizedBox(height: 8),
          TextFormField(
            decoration: _inputDecoration(hintText: 'SGD'),
            onChanged: (value) {
              context.read<ClaimCreateBloc>().add(ReceiptAmountChanged(value));
            },
          ),

          const SizedBox(height: 16),
          Text("Claimable Amount*", style: AppTextstyle.claim_form_heading_text),
          const SizedBox(height: 8),
          TextFormField(
            decoration: _inputDecoration(hintText: 'SGD'),
            onChanged: (value) {
              context.read<ClaimCreateBloc>().add(ClaimableAmountChanged(value));
            },
          ),


          const SizedBox(height: 16),
          Text("Attachment", style: AppTextstyle.claim_form_heading_text),
          const SizedBox(height: 8),
          ClaimAttachmentButton(onPressed:claimattachmentbutton ),
          if (selectedAttachment != null)
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                "Selected: ${selectedAttachment!.path.split('/').last}",
                style: const TextStyle(color: Colors.black),
              ),
            ),

          const SizedBox(height: 24),
          const SizedBox(height: 24),
           ClaimCreateButton(onPressed:_createbutton, ),

        ]),
      ),
    );
  }
}
