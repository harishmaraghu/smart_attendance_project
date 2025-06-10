import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';

// import '../../../../attendance/presentation/widgets/top_dashboard.dart';
import '../../../data/models/leave_apply_request_model.dart';
import '../../../domain/repositories/leave_repository_impl.dart';
import '../../widgets/topnavbar_leave_record.dart';

class LeaveHistory extends StatefulWidget {
  final String Userid;


  const LeaveHistory({required this.Userid,super.key });

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
      final data = await repo.fetchLeaveHistory(widget.Userid);
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
        return AppColors().success_color;
      case 'rejected':
        return AppColors().rejected_color;
      case 'inprogress':
      case 'process':
        return AppColors().form_bg_color;
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
    final screenSize = MediaQuery.of(context).size;
    final textScale = MediaQuery.textScaleFactorOf(context);
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

            // Tab bar with responsive margins
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.02,
                vertical: screenSize.height * 0.015,
              ),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors().whitecolor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: false,
                labelPadding: EdgeInsets.symmetric(horizontal: screenSize.width * 0.02),
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

            // Content loader or list
            isLoading
                ? const Expanded(child: Center(child: CircularProgressIndicator()))
                : Expanded(
              child: filteredData.isEmpty
                  ? const Center(child: Text("No records found"))
                  : ListView.builder(
                padding: EdgeInsets.all(screenSize.width * 0.03),
                itemCount: filteredData.length,
                itemBuilder: (context, index) {
                  final item = filteredData[index];
                  return leaveCard(
                    screenSize,
                    item.title,
                    item.fromDate,
                    item.toDate,
                    item.status,
                    getStatusColor(item.status),
                    textScale,
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


Widget leaveCard(Size screenSize, String title, String fromDate, String toDate, String status, Color statusColor, double textScale) {
  return Container(
    margin: EdgeInsets.symmetric(vertical: screenSize.height * 0.012),
    decoration: BoxDecoration(
      color: Colors.white70,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        Container(
          width: 10,
          height: screenSize.height * 0.1,
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
            contentPadding: EdgeInsets.symmetric(
              horizontal: screenSize.width * 0.04,
              vertical: screenSize.height * 0.01,
            ),
            title: Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: screenSize.width * 0.045 * textScale,
              ),
            ),
            subtitle: Text(
              "From $fromDate  To $toDate",
              style: TextStyle(
                fontSize: screenSize.width * 0.038 * textScale,
              ),
            ),
            trailing: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.03,
                vertical: screenSize.height * 0.005,
              ),
              decoration: BoxDecoration(
                color: statusColor,
                borderRadius: BorderRadius.circular(50),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: screenSize.width * 0.035 * textScale,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
