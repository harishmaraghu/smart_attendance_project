import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/features/attendance/presentation/widgets/top_dashboard.dart';
import 'package:smart_attendance_project/features/attendance/utilites/utility.dart';

import '../../data/models/attendance_record_model.dart';
import '../../data/repositories/attendance_repository_impl.dart';

class AttendanceHistory extends StatefulWidget {
  final String Userid;
  const AttendanceHistory({super.key, required this.Userid});

  @override
  State<AttendanceHistory> createState() => _AttendanceHistoryState();
}

class _AttendanceHistoryState extends State<AttendanceHistory> {
  final colors = AppColors();
  final AttendanceRepository _attendanceRepository = AttendanceRepository();
  final AttendanceUtility _utility = AttendanceUtility();

  Future<List<AttendanceRecord>>? _attendanceRecords;
  DateTime? selectedDate;
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    // Load data without date filter initially
    _loadAttendanceData();
  }

  Future<void> _loadAttendanceData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // // Call API - if date is selected, pass both userId and date, otherwise just userId
      if (selectedDate != null) {
        _attendanceRecords = _attendanceRepository.getAttendanceemployeeByDate(
            widget.Userid,
            selectedDate!
        );
      } else {
        _attendanceRecords = _attendanceRepository.getAttendanceemployee(
            widget.Userid
        );
      }

      // Wait for future to complete to catch any errors
      await _attendanceRecords;
    } catch (e) {
      setState(() {
        _errorMessage = "Failed to load attendance data: $e";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Format date to display format (1 April 2025)
  String formatDate(DateTime date) {
    return _utility.formatDisplayDate(date);
  }

  // Format date for API (YYYY-MM-DD)
  String formatDateForApi(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  // Open Date Picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );

    if (picked != null && (selectedDate == null || !_utility.isSameDay(picked, selectedDate!))) {
      setState(() {
        selectedDate = picked;
      });
      // Reload data with the new date
      _loadAttendanceData();
    }
  }

  // Clear date filter
  void _clearDateFilter() {
    setState(() {
      selectedDate = null;
    });
    _loadAttendanceData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            TopDashboardHeaderinAttendance(),
            _buildDateSelector(),
            Expanded(
              child: Container(
                color: colors.whitecolor,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _errorMessage != null
                    ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(_errorMessage!),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadAttendanceData,
                        child: const Text("Retry"),
                      ),
                    ],
                  ),
                )
                    : _buildAttendanceList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      alignment: Alignment.centerLeft,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            onTap: () => _selectDate(context),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Text(
                  selectedDate == null
                      ? "Pick a date"
                      : formatDate(selectedDate!),
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              if (selectedDate != null)
                IconButton(
                  onPressed: _clearDateFilter,
                  icon: const Icon(Icons.clear, color: Colors.red),
                  tooltip: "Clear date filter",
                ),
              if (_isLoading)
                 const SizedBox(
                //   width: 20,
                //   height: 20,
                //   child: CircularProgressIndicator(strokeWidth: 2),
                 ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAttendanceList() {
    return FutureBuilder<List<AttendanceRecord>>(
      future: _attendanceRecords,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Error: ${snapshot.error}"),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadAttendanceData,
                  child: const Text("Retry"),
                ),
              ],
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.event_busy, size: 64, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  selectedDate == null
                      ? "No attendance records found"
                      : "No attendance records found for ${formatDate(selectedDate!)}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _loadAttendanceData,
                  child: const Text("Refresh"),
                ),
              ],
            ),
          );
        }

        final records = snapshot.data!;
        records.sort((a, b) => b.date.compareTo(a.date));

        return ListView.builder(
          itemCount: records.length,
          itemBuilder: (context, index) {
            final record = records[index];
            final isPresent = record.status == "Present";

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 6),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          formatDate(record.date),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          record.status,
                          style: TextStyle(
                            color: Color(_utility.getStatusColor(record.status)),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        InkWell(
                          onTap: () => _showAttendanceDetails(record),
                          child: const Icon(Icons.remove_red_eye_outlined,
                              color: Colors.blue),
                        ),
                      ],
                    ),
                    const Divider(thickness: 1),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text("Check in",
                                style: TextStyle(color: Colors.grey)),
                            Text(_utility.formatTimeForDisplay(record.inTime)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("Check out",
                                style: TextStyle(color: Colors.grey)),
                            Text(_utility.formatTimeForDisplay(record.outTime)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("Total hr",
                                style: TextStyle(color: Colors.grey)),
                            Text(record.totalHours ?? "N/A"),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showAttendanceDetails(AttendanceRecord record) {
    showDialog(
      // barrierColor: colors.backgroundcolor,
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Attendance Details - ${formatDate(record.date)}"),
        content: Column(

          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Employee: ${record.name}"),
            const SizedBox(height: 8),
            Text("Status: ${record.status}",
                style: TextStyle(color: Color(_utility.getStatusColor(record.status)))),
            const SizedBox(height: 8),
            Text("Check-in Time: ${_utility.formatTimeForDisplay(record.inTime)}"),
            Text("Check-out Time: ${_utility.formatTimeForDisplay(record.outTime)}"),
            Text("Total Hours: ${record.totalHours ?? "N/A"}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }
}