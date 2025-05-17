import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/leave/presentation/widgets/leave_apply_form.dart';
import 'package:smart_attendance_project/features/leave/presentation/widgets/topnavbar_leave_apply.dart';




class LeaveApplyScreen extends StatefulWidget {
  final String username;
  const LeaveApplyScreen({required this.username, Key? key}) : super(key: key);

  @override
  State<LeaveApplyScreen> createState() => _LeaveApplyScreenState();
}

class _LeaveApplyScreenState extends State<LeaveApplyScreen> {
  String? selectedLeaveCategory;

  final TextEditingController _reasonController = TextEditingController();
  File? selectedFile;



  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            TopDashboardHeaderinLeaveApply(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: LeaveApplyForm(username: widget.username),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
