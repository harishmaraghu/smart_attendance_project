

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/core/constants/shared_prefsHelper.dart' show SharedPrefsHelper;
import 'package:smart_attendance_project/features/attendance/data/models/attendance_record_model.dart';
import 'package:smart_attendance_project/features/attendance/presentation/pages/attendance_history.dart';
import 'package:smart_attendance_project/features/facebiometric/presentation/pages/face_biometric.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/widgets/bottom_nav_bar.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/widgets/top_dashboard.dart';
import 'package:smart_attendance_project/features/profile/presentation/screens/profile.dart';
import 'package:smart_attendance_project/features/splashscreens/first_screen.dart';
import 'package:smart_attendance_project/features/work_loaction_profile/location/presentations/screens/work_location.dart';

class HomeScreen extends StatefulWidget {
  final bool isCheckedIn;
  final String username;
  final String userId;

  const HomeScreen({
    super.key,
    required this.username,
    required this.userId,
    this.isCheckedIn = false,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final colors = AppColors();
  String displayUsername = '';
  int _selectedIndex = 0;
  late bool _isCheckedIn;
  List<AttendanceRecord> recentAttendance = [];
  bool isLoadingAttendance = false;

  // Add PageController for managing pages
  late PageController _pageController;

  // Store user profile data
  String? userImageUrl;

  @override
  void initState() {
    super.initState();
    _isCheckedIn = widget.isCheckedIn;
    _pageController = PageController(initialPage: 0);
    _loadUsername();
    _loadRecentAttendance();
    _loadUserProfileData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _loadUserProfileData() async {
    try {
      final imageUrl = await SharedPrefsHelper.getUserImageUrl();
      setState(() {
        userImageUrl = imageUrl;
      });
    } catch (e) {
      print('Error loading user profile data: $e');
    }
  }

  void _onTabSelected(int index) {
    setState(() {
      _selectedIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _toggleCheckInStatus() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FaceBiometric()),
    );
  }

  Future<void> _loadUsername() async {
    try {
      final savedUsername = await SharedPrefsHelper.getUsername();
      setState(() {
        displayUsername =
        savedUsername.isNotEmpty ? savedUsername : widget.username;
      });
    } catch (e) {
      setState(() {
        displayUsername = widget.username;
      });
    }
  }

  Future<List<AttendanceRecord>> getAttendanceemployee(String userid) async {
    final url = Uri.parse("https://ectzis56w6.execute-api.ap-south-1.amazonaws.com/default/GetAttendanceuser");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"Userid": userid}),
    );

    print('API Response for all records: ${response.body}');
    print('Status Code: ${response.statusCode}');

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => AttendanceRecord.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load attendance records");
    }
  }


  Future<void> _logout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      try {
        // Clear user data from SharedPreferences
        await SharedPrefsHelper.clearUserData();

        // Navigate back to FirstScreen (splash screen)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FirstScreen()),
              (route) => false,
        );
      } catch (e) {
        print('Logout error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error during logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }


  Future<void> _loadRecentAttendance() async {
    setState(() {
      isLoadingAttendance = true;
    });

    try {
      final allRecords = await getAttendanceemployee(widget.userId);

      // Sort by date (most recent first) and take only last 3 days
      allRecords.sort((a, b) => b.date.compareTo(a.date));
      final now = DateTime.now();
      final threeDaysAgo = now.subtract(const Duration(days: 3));

      final filteredRecords = allRecords.where((record) {
        return record.date.isAfter(threeDaysAgo) || record.date.isAtSameMomentAs(threeDaysAgo);
      }).take(3).toList();

      setState(() {
        recentAttendance = filteredRecords;
        isLoadingAttendance = false;
      });
    } catch (e) {
      print('Error loading attendance: $e');
      setState(() {
        isLoadingAttendance = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textScale = MediaQuery.textScaleFactorOf(context);

    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        children: [
          // Home Page
          _buildHomePage(screenSize, textScale),

          // Profile Page
          Profile(
            userId: widget.userId,
            username: displayUsername.isNotEmpty ? displayUsername : widget.username,
            image: userImageUrl,
          ),
        ],
      ),

      // Floating Action Button - Show on both pages with different functionality
      floatingActionButton: _buildFloatingActionButton(screenSize, textScale),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      // Bottom Navigation Bar - Always show with notch for FAB
      bottomNavigationBar: BottomNavBar(
        onFabPressed: () {
          // Optional
        },
        onTabSelected: _onTabSelected,
        selectedIndex: _selectedIndex,
        showNotch: true, // Always show notch since FAB is always present
      ),
    );
  }

  Widget _buildFloatingActionButton(Size screenSize, double textScale) {
    // Same Login/Logout functionality for both Home and Profile pages
    return Container(
      height: screenSize.height * 0.10,
      width: screenSize.width * 0.24,
      decoration: BoxDecoration(
        color: colors.backgroundcolor,
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: colors.backgroundcolor.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: colors.backgroundcolor,
        borderRadius: BorderRadius.circular(25),
        child: InkWell(
          onTap: () {
            if (_isCheckedIn) {
              _toggleCheckInStatus();
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const FaceBiometric()),
              );
            }
          },
          borderRadius: BorderRadius.circular(70),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.emoji_emotions_outlined,
                size: screenSize.width * 0.08,
                color: colors.whitecolor,
              ),
              const SizedBox(height: 4),
              Text(
                _isCheckedIn ? 'Logout' : 'Login',
                style: TextStyle(
                  color: colors.whitecolor,
                  fontWeight: FontWeight.bold,
                  fontSize: screenSize.width * 0.04 * textScale,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHomePage(Size screenSize, double textScale) {
    return SafeArea(
      child: Column(
        children: [
          TopDashboardHeader(
            username: displayUsername.isNotEmpty
                ? displayUsername
                : widget.username,
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Container(
              width: double.infinity,
              color: colors.whitecolor,
              padding: EdgeInsets.symmetric(
                horizontal: screenSize.width * 0.05,
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Activities Section
                    _buildActivitiesSection(context, screenSize),
                    const SizedBox(height: 25),

                    // Recent Attendance Section
                    _buildRecentSection(context, screenSize),
                    const SizedBox(height: 100), // Space for FAB
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF006EB5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivitiesSection(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Activities',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActivityCard(
                title: 'Performance',
                subtitle: 'based on work days',
                icon: Icons.trending_up,
                color: AppColors().button_background_color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WorkLocation(userId: widget.userId,), // Replace with your actual screen class
                    ),
                  );
                },
                child: _buildActivityCard(
                  title: 'Updated',
                  subtitle: 'Please check your work location',
                  icon: Icons.update,
                  color: AppColors().backgroundcolor,
                ),
              ),
            ),

          ],
        ),
      ],
    );
  }

  Widget _buildActivityCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: 22,
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentSection(BuildContext context, Size screenSize) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AttendanceHistory(
                      Userid: widget.userId,
                    ),
                  ),
                );
              },
              child: const Text(
                'View all',
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF006EB5),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (isLoadingAttendance)
          const Center(
            child: CircularProgressIndicator(),
          )
        else if (recentAttendance.isEmpty)
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
              child: Text(
                'No recent attendance records',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          )
        else
          Container(
            decoration: BoxDecoration(
              color: AppColors().button_background_color,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                for (int i = 0; i < recentAttendance.length; i++) ...[
                  buildAttendanceRow(recentAttendance[i]),
                  if (i < recentAttendance.length - 1)
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      child: Row(
                        children: List.generate(
                          40,
                              (index) => Expanded(
                            child: Container(
                              height: 1,
                              color: index % 2 == 0 ? Colors.white54 : Colors.transparent,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
      ],
    );
  }

  Widget buildAttendanceRow(AttendanceRecord record) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Date and Status Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${record.date.day} ${_monthName(record.date.month)} ${record.date.year}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                record.status,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Check in, Check out, Total hr Row
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Check in",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimeOnly(record.inTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Vertical divider
              Container(
                height: 40,
                width: 1,
                color: Colors.white54,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Check out",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatTimeOnly(record.outTime),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),

              // Vertical divider
              Container(
                height: 40,
                width: 1,
                color: Colors.white54,
              ),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Text(
                      "Total hr",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      record.totalHours ?? "0hr",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildAttendanceCard(AttendanceRecord record) {
    return buildAttendanceRow(record);
  }

  String _formatTimeOnly(String? time) {
    if (time == null || time.isEmpty) return "--:--";

    try {
      final parts = time.split(' ');
      if (parts.length == 2) {
        return parts[1]; // Return only the time part
      }
    } catch (e) {
      print("Time format error: $e");
    }

    return time; // Fallback
  }

  String _monthName(int month) {
    const months = [
      "Jan", "Feb", "Mar", "Apr", "May", "Jun",
      "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"
    ];
    return months[month - 1];
  }
}

// Updated BottomNavBar class to work with PageView
