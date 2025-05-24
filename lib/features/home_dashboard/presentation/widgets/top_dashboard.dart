import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';
import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history/leave_record.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/shared_prefsHelper.dart';
import '../../../attendance/presentation/pages/attendance_history.dart';
import '../../../login/presentation/pages/login_screen.dart';
import '../../../payment/presentation/pages/payment_history.dart';

class TopDashboardHeader extends StatefulWidget {
  final String username;

  const TopDashboardHeader({Key? key, required this.username}) : super(key: key);

  @override
  _TopDashboardHeaderState createState() => _TopDashboardHeaderState();
}

class _TopDashboardHeaderState extends State<TopDashboardHeader> {
  final colors = AppColors();
  String? userImageUrl;
  String? userCategory;
  String displayUsername = '';






  @override
  void initState() {
    super.initState();
    _loadUserData();
  }


  Future<void> _loadUserData() async {
    try {
      final username = await SharedPrefsHelper.getUsername();
      final imageUrl = await SharedPrefsHelper.getUserImageUrl();
      final category = await SharedPrefsHelper.getUserCategory();

      setState(() {
        displayUsername = username;
        userImageUrl = imageUrl;
        userCategory = category;
      });
    } catch (e) {
      print('Error loading user data: $e');
      setState(() {
        displayUsername = widget.username; // Fallback to passed username
      });
    }
  }



  Future<void> _handleLogout() async {
    if (!mounted) return;

    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.logout, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          content: Text(
            'Are you sure you want to logout?',
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Logout',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ],
        );
      },
    );

    if (shouldLogout != true || !mounted) return;

    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext loadingContext) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    color: colors.backgroundcolor,
                  ),
                  SizedBox(height: 16),
                  Text('Logging out...'),
                ],
              ),
            ),
          ),
        );
      },
    );

    try {
      // Clear all user data from SharedPreferences
      await SharedPrefsHelper.clearUserData();

      // Optional: Add a small delay for better UX
      await Future.delayed(Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigate to login screen and remove all previous routes
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => LoginScreen()),
            (route) => false, // This removes all previous routes
      );

      // Show success message (optional)
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Logged out successfully'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      // Handle logout error
      if (mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error logging out: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: screenHeight * 0.04,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        bottom: screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundcolor,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with menu and notification
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Menu Icon with PopupMenu
              PopupMenuButton<String>(
                offset: Offset(0, 40), // Adjust dropdown position below the icon
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                itemBuilder: (BuildContext context) => [
                  PopupMenuItem(value: 'attendance', child: Text('Attendance')),
                  PopupMenuItem(
                    value: 'logout',
                    child: Row(
                      children: [
                        Icon(Icons.logout, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text(
                          'Logout',
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (!mounted) return;

                  switch (value) {
                    case 'logout':
                      _handleLogout(); // Call the logout function
                      break;
                    case 'attendance':
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => AttendanceHistory(username: displayUsername)),
                      );
                      break;
                    case 'profile':
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Profile feature coming soon')),
                      );
                      break;
                    case 'settings':
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Settings feature coming soon')),
                      );
                      break;
                  }
                },
                child: Icon(Icons.menu, color: Colors.white, size: 28),
              ),

              // Notification Icon with onTap
              GestureDetector(
                onTap: () {
                  // Handle notification tap here
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No new notifications')),
                  );
                },
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.notifications_none,
                      color: AppColors().dashboard_icon_color, size: 22),
                ),
              ),
            ],
          ),

          SizedBox(height: 20),

          // Greeting text
          Text.rich(
            TextSpan(
              text: 'Hello, ',
              style: TextStyle(fontSize: 22, color: Colors.white),
              children: [
                TextSpan(
                  text: '${displayUsername}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Welcome back to your dashboard.',
            style: TextStyle(fontSize: 14, color: Colors.white70),
          ),
          SizedBox(height: 20),

          // Floating white card with icons
          Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildIcon(Icons.access_time, 'Attendance', () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => AttendanceHistory(username: displayUsername)));
                }),
                _buildIcon(Icons.assignment, 'Claims', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ClaimsCreate()));
                }),
                _buildIcon(Icons.receipt_long, 'Payslip', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentHistory()));
                }),
                _buildIcon(Icons.time_to_leave, 'Leave', () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => LeaveHistory()));
                }),
              ],
            ),

          ),
        ],
      ),
    );
  }

  Widget _buildIcon(IconData icon, String label,VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column( children: [
        CircleAvatar(
          radius: 15,
          backgroundColor: AppColors().dashboard_icon_background, // A subtle color, e.g., light grey or blue tint
          child: Icon(
            icon,
            color: colors.dashboard_icon_color, // Use your defined dashboard icon color
            size: 23,
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
      ],),

    );
  }
}
