import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';

import '../../../../attendance/presentation/widgets/top_dashboard.dart';
import '../../../data/models/leave_apply_request_model.dart';
import '../../../domain/repositories/leave_repository_impl.dart';
import '../../widgets/topnavbar_leave_record.dart';

class LeaveHistory extends StatefulWidget {
  const LeaveHistory({super.key});

  @override
  State<LeaveHistory> createState() => _LeaveHistoryState();
}

class _LeaveHistoryState extends State<LeaveHistory> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<LeaveHistoryModel> leaveData = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() => setState(() {}));
    fetchLeaveData();
  }

  Future<void> fetchLeaveData() async {
    final repo = LeaveRepositoryImpl();
    try {
      final data = await repo.fetchLeaveHistory();
      setState(() {
        leaveData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'inprogress':
      case 'process':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  String getSelectedStatus() {
    switch (_tabController.index) {
      case 1:
        return 'Inprogress';
      case 2:
        return 'Approved';
      case 3:
        return 'Rejected';
      default:
        return 'All';
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedStatus = getSelectedStatus();
    final filteredData = selectedStatus == 'All'
        ? leaveData
        : leaveData.where((item) => item.status.toLowerCase() == selectedStatus.toLowerCase()).toList();


    return Scaffold(
      backgroundColor: AppColors().whitecolor,
      body: SafeArea(
        child: Column(
          children: [
            TopDashboardHeaderinLeave(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors().whitecolor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                indicator: BoxDecoration(
                  color: AppColors().button_background_color,
                  borderRadius: BorderRadius.circular(8),
                ),
                indicatorColor: Colors.transparent,
                indicatorSize: TabBarIndicatorSize.tab,
                tabs: const [
                  Tab(child: Text('All')),
                  Tab(child: Text('Process')),
                  Tab(child: Text('Approved')),
                  Tab(child: Text('Rejected')),
                ],
              ),
            ),
            isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
              child: filteredData.isEmpty
                  ? const Center(child: Text("No records found"))
                  : ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final item = filteredData[index];
                  return leaveCard(
                    item.title,
                    item.fromDate,
                    item.toDate,
                    item.status,
                    getStatusColor(item.status),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget leaveCard(String title, String fromDate, String toDate, String status, Color statusColor) {
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 10),
    decoration: BoxDecoration(
      color: AppColors().card_background_color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          width: 10,
          height: 80,
          decoration: BoxDecoration(
            color: statusColor,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(12),
              bottomLeft: Radius.circular(12),
            ),
          ),
        ),
        Expanded(
          child: ListTile(
            title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text("From $fromDate  To $toDate"),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(status, style: const TextStyle(color: Colors.white)),
            ),
          ),
        ),
      ],
    ),
  );
}
