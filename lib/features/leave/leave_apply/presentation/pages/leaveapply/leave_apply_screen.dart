import 'dart:io';
import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/presentation/widgets/leave_apply_form.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/presentation/widgets/topnavbar_leave_apply.dart';
// import 'package:smart_attendance_project/features/leave/presentation/widgets/leave_apply_form.dart';
// import 'package:smart_attendance_project/features/leave/presentation/widgets/topnavbar_leave_apply.dart';




class LeaveApplyScreen extends StatefulWidget {
  final String userId;
  final String userName;
  const LeaveApplyScreen
      ({required this.userId, required this.userName, Key? key}) : super(key: key);

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
                child: LeaveApplyForm(userId: widget.userId,userName: widget.userName,),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
