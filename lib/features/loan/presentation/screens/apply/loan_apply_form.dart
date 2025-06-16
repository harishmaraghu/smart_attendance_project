// import 'package:flutter/material.dart';
// import 'package:smart_attendance_project/features/loan/presentation/screens/apply/loan_form.dart';
// import 'package:smart_attendance_project/features/loan/presentation/widgets/apply/topbarloanapply.dart';
//
// class LoanApplyForm extends StatefulWidget {
//   final String userId;
//   final String userName;
//   const LoanApplyForm({required this.userId, required this.userName, Key? key}) : super(key: key);
//
//   @override
//   State<LoanApplyForm> createState() => _LoanApplyFormState();
// }
//
// class _LoanApplyFormState extends State<LoanApplyForm> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body: SafeArea(
//           child: Column(
//             children: [
//               TopDashboardinLoanApply(),
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.all(16),
//                   child: LoanForm(Userid: widget.userId,username: widget.userName,),
//                 ),
//               ),
//             ],
//           ),
//         ),
//     );
//   }
// }
