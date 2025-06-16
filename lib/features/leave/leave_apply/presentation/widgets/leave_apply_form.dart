// leave_apply_form.dart

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart' show BlocProvider;
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/data/models/leave_apply_request_model.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/domain/repositories/leave_repository_impl.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/presentation/widgets/date_selector_field.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/presentation/widgets/leave_apply_button.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/data/datasours/leave_dashboard_repository.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/bloc/leave_dash_bloc.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/screens/leave_dashboard_page.dart';

class LeaveApplyForm extends StatefulWidget {
  final String userId;
  final String userName;


  const LeaveApplyForm({Key? key, required this.userId,required this.userName}) : super(key: key);

  @override
  State<LeaveApplyForm> createState() => _LeaveApplyFormState();
}

class _LeaveApplyFormState extends State<LeaveApplyForm> {
  String? selectedLeaveCategory;
  DateTime? _fromDate;
  DateTime? _toDate;
  final TextEditingController _reasonController = TextEditingController();
  File? selectedFile;
  // final LeaveDashboardRepository _repository;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context, bool isFromDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        if (isFromDate) {
          _fromDate = picked;
        } else {
          _toDate = picked;
        }
      });
    }
  }

  String _formatDate(DateTime date) {
    return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }


  Future<void> _pickFile() async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedFile = File(result.files.single.path!);
      });
    }
  }

  Future<void> _leaveApply() async {
    if (selectedLeaveCategory == null || _fromDate == null || _toDate == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill all mandatory fields")),
      );
      return;
    }

    if (_toDate!.isBefore(_fromDate!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("To Date must be same or after From Date")),
      );
      return;
    }

    final request = LeaveApplyRequestModel(
      userId: widget.userId,
      userName: widget.userName,
      leaveCategory: selectedLeaveCategory!,
      fromDate: _formatDate(_fromDate!),
      toDate: _formatDate(_toDate!),
      reason: _reasonController.text.trim(),
      attachmentPath: selectedFile?.path,
    );

    final repository = LeaveRepositoryImpl();
    try {
      await repository.applyLeave(request);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Leave applied successfully")),
      );

      // Reset form fields
      setState(() {
        selectedLeaveCategory = null;
        _fromDate = null;
        _toDate = null;
        _reasonController.clear();
        selectedFile = null;
      });

      // Navigate to LeaveDashboardPage after successful application
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BlocProvider(
            create: (context) => LeaveDashboardBloc(
              repository: LeaveDashboardRepository(), // Replace with your actual repository implementation
            ),
            child: LeaveDashboardPage(
              Userid: widget.userId,
              username: widget.userName,
            ),
          ),
        ),
      );

    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Subtitle above the form
          Text("Create Leave", style: AppTextstyle.form_2_heading_text_bold.copyWith(fontSize: 16)),
          const SizedBox(height: 2),
          Text(
            "Please fill the option to take leave",
            style: AppTextstyle.pragra_text.copyWith(color: Colors.grey[700]),
          ),
          const SizedBox(height: 16),

          // Leave Form Container
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors().form_bg_color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Leave Category", style: AppTextstyle.form_heading_text_bold),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectedLeaveCategory,
                      hint: Text("Select Leave Category", style: AppTextstyle.form_input_text_bold),
                      items: const [
                        DropdownMenuItem(value: "Annual Leave", child: Text("Annual Leave")),
                        DropdownMenuItem(value: "Sick Leave", child: Text("Sick Leave")),
                      ],
                      onChanged: (value) {
                        setState(() {
                          selectedLeaveCategory = value;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: DateSelectorField(
                        title: "From Date",
                        selectedDate: _fromDate,
                        onTap: () => _selectDate(context, true),
                        titleTextStyle: AppTextstyle.form_heading_text_bold,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DateSelectorField(
                        title: "To Date",
                        selectedDate: _toDate,
                        onTap: () => _selectDate(context, false),
                        titleTextStyle: AppTextstyle.form_heading_text_bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text("Reason", style: AppTextstyle.form_heading_text_bold),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: TextField(
                    controller: _reasonController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Reason",
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text("Attachment (optional)", style: AppTextstyle.form_heading_text_bold),
                const SizedBox(height: 8),
                InkWell(
                  onTap: _pickFile,
                  child: Container(
                    decoration: BoxDecoration(
                      // color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.upload_file_rounded, color: Colors.white),
                        const SizedBox(width: 6),
                        Text("Upload", style: AppTextstyle.normal_text_2.copyWith(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.center,
                  child: LeaveApplyButton(onPressed: _leaveApply),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
