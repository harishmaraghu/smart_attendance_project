import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:smart_attendance_project/features/work_loaction_profile/location/data/repo/work_location_impl.dart';
import 'package:smart_attendance_project/features/work_loaction_profile/location/models/work_loaction.dart';
import 'package:smart_attendance_project/features/work_loaction_profile/location/presentations/screens/LocationViewPage.dart';
import 'package:smart_attendance_project/features/work_loaction_profile/location/presentations/widgets/topbar_loaction.dart';

class WorkLocation extends StatefulWidget {
  final String? userId;
  const WorkLocation({required this.userId, super.key});

  @override
  State<WorkLocation> createState() => _WorkLocationState();
}

class _WorkLocationState extends State<WorkLocation> {
  final LocationApiService _apiService = LocationApiService();

  List<LocationAssignment> locationHistory = [];
  bool isLoading = true;
  bool hasError = false;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchLocationHistory();
  }

  Future<void> fetchLocationHistory() async {
    print('fetchLocationHistory called');
    print('Widget userId: ${widget.userId}');

    if (widget.userId == null) {
      setState(() {
        hasError = true;
        errorMessage = 'User ID is required';
        isLoading = false;
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasError = false;
      errorMessage = '';
    });

    try {
      print('Calling API service...');
      final assignments = await _apiService.fetchLocationAssignments(widget.userId!);
      print('Received ${assignments.length} assignments');

      // Sort assignments by date
      assignments.sort((a, b) {
        try {
          return DateTime.parse(b.assigningDate).compareTo(DateTime.parse(a.assigningDate));
        } catch (e) {
          print('Error sorting dates: $e');
          return 0; // Keep original order if dates can't be parsed
        }
      });

      setState(() {
        locationHistory = assignments;
        isLoading = false;
        hasError = false;
      });

      print('Successfully loaded ${locationHistory.length} location assignments');

    } catch (e) {
      print('Error in fetchLocationHistory: $e');
      setState(() {
        hasError = true;
        errorMessage = e.toString().replaceAll('Exception: ', '');
        isLoading = false;
      });
    }
  }


  String formatDate(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime yesterday = today.subtract(const Duration(days: 1));
      DateTime assignmentDate = DateTime(date.year, date.month, date.day);

      if (assignmentDate == today) {
        return 'Today';
      } else if (assignmentDate == yesterday) {
        return 'Yesterday';
      } else {
        return DateFormat('dd MMM yy').format(date);
      }
    } catch (e) {
      return dateString;
    }
  }

  String getTimeAgo(String dateString) {
    try {
      DateTime date = DateTime.parse(dateString);
      Duration difference = DateTime.now().difference(date);

      if (difference.inMinutes < 60) {
        return '${difference.inMinutes} mins ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Top bar section
            TopDashboardinprofilelocation(),

            // Body content
            Expanded(child: buildContent()),
          ],
        ),
      ),
    );
  }

  // Widget buildHeader() {
  //   return Container(
  //     padding: const EdgeInsets.all(16),
  //     decoration: const BoxDecoration(
  //       color: Color(0xFF2196F3),
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(20),
  //         bottomRight: Radius.circular(20),
  //       ),
  //     ),
  //     child: Column(
  //       children: [
  //         TopDashboardinprofilelocation(), ],
  //     ),
  //   );
  // }

  Widget buildContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFF2196F3)));
    } else if (hasError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
            const SizedBox(height: 16),
            Text(errorMessage, style: const TextStyle(fontSize: 16, color: Colors.red), textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  isLoading = true;
                  hasError = false;
                });
                fetchLocationHistory();
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2196F3), foregroundColor: Colors.white),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    } else if (locationHistory.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_off, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text('No location assignments found', style: TextStyle(fontSize: 16, color: Colors.grey)),
          ],
        ),
      );
    } else {
      return RefreshIndicator(
        onRefresh: fetchLocationHistory,
        color: const Color(0xFF2196F3),
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: locationHistory.length + 1, // +1 for the new header container
          itemBuilder: (context, index) {
            if (index == 0) {
              // Your new top container (informative header)
              return Container(
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2196F3),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.person_pin_circle, color: Colors.white, size: 20),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Location Assigned',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xFF2196F3)),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'View your daily assigned work locations and track where you\'ve worked each day.',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }

            final assignment = locationHistory[index - 1]; // because 0 is used by the new header
            final isNewDate = index == 1 ||
                formatDate(assignment.assigningDate) != formatDate(locationHistory[index - 2].assigningDate);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (isNewDate)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(formatDate(assignment.assigningDate),
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey)),
                        Text(getTimeAgo(assignment.assigningDate),
                            style: const TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                buildAssignmentCard(assignment),
                const SizedBox(height: 16),
              ],
            );
          },
        ),
      );
    }
  }


  Widget buildAssignmentCard(LocationAssignment assignment) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                    Icons.person_pin_circle, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Location Assigned', style: TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w600)),
                    Text('Your assigned work location has been updated.',
                        style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              // 👇👇 Make this clickable
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) =>
                          LocationViewPage(
                            workDate: assignment.assigningDate,
                            location: assignment.location,
                            assignedBy: assignment.assignedByName,
                          ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.visibility, size: 12, color: Colors.green),
                      SizedBox(width: 4),
                      Text('View',
                          style: TextStyle(fontSize: 10,
                              color: Colors.green,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.grey[50], borderRadius: BorderRadius.circular(8)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 16, color: Colors.red),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(assignment.location,
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.person, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text('Assigned by: ${assignment.assignedByName}',
                        style: const TextStyle(
                            fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}
