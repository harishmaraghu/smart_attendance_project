// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../bloc/claim_create_bloc.dart';
// import '../bloc/claim_create_event.dart';
// import '../widgets/claim_history_widgets/claim_card.dart';
// import '../widgets/claim_history_widgets/claim_history_tabs.dart';
// import '../widgets/claim_history_widgets/clain_history_top_navbar.dart';
//
// class ClaimHistory extends StatefulWidget {
//   final String Userid;
//
//   const ClaimHistory({required this.Userid,super.key});
//
//   @override
//   State<ClaimHistory> createState() => _ClaimHistoryState();
// }
//
// class _ClaimHistoryState extends State<ClaimHistory> {
//   bool isProcessingSelected = true;
//
//
//
//   @override
//   void initState() {
//     super.initState();
//     context.read<ClaimHistoryBloc>().add(FetchClaimHistory(widget.Userid));
//   }
//
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           TopDashboarinClaimHistory(),
//           const SizedBox(height: 9), // Replace with TopDashboarinClaimHistory if needed
//           ClaimHistoryTabs(
//             isProcessingSelected: isProcessingSelected,
//             onTabChange: (bool value) {
//               setState(() {
//                 isProcessingSelected = value;
//               });
//             },
//           ),
//           Expanded(
//             child: Container(
//               color: Colors.white,
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Expanded(
//                     child: ListView(
//                       children: isProcessingSelected
//                           ? _buildProcessingCards()
//                           : _buildCompletedCards(),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   List<Widget> _buildProcessingCards() {
//     return [
//       ClaimCard(
//         amount: "\$10.00",
//         title: "Entertainment claim",
//         date: "12-05-2025",
//         status: "Failed",
//         statusColor: Colors.red,
//         showExplore: true,
//       ),
//     ];
//   }
//
//   List<Widget> _buildCompletedCards() {
//     return [
//       ClaimCard(
//         amount: "\$10.00",
//         title: "Entertainment claim",
//         date: "12-05-2025",
//         status: "Settled",
//         statusColor: Colors.green,
//       ),
//       ClaimCard(
//         amount: "\$10.00",
//         title: "Entertainment claim",
//         date: "12-05-2025",
//         status: "Settled",
//         statusColor: Colors.green,
//       ),
//     ];
//   }
//
//
// }
//
