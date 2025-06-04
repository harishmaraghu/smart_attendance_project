import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/facebiometric/presentation/pages/face_biometric.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/shared_prefsHelper.dart';
import '../../../location/presentation/pages/location_screen.dart';
import '../../../profile/presentation/screens/profile_page.dart';
import '../widgets/bottom_nav_bar.dart';
import '../widgets/top_dashboard.dart';

class HomeScreen extends StatefulWidget {
  final bool isCheckedIn;
  final String username;

  const HomeScreen({super.key,required this.username ,this.isCheckedIn = false});


  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final colors = AppColors();
  String displayUsername = '';
  int _selectedIndex = 0;
  late bool _isCheckedIn;


  @override
  void initState() {
    super.initState();
    _isCheckedIn = widget.isCheckedIn;
    _loadUsername();
  }

  void _toggleCheckInStatus() {
    // User is checking out, navigate to LocationScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const FaceBiometric()),
    );
  }


  // Load username from SharedPreferences or use passed username
  Future<void> _loadUsername() async {
    try {
      final savedUsername = await SharedPrefsHelper.getUsername();
      setState(() {
        displayUsername = savedUsername.isNotEmpty ? savedUsername : widget.username;
      });
    } catch (e) {
      setState(() {
        displayUsername = widget.username; // Fallback to passed username
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(

      body: SafeArea(
        child: Column(
          children: [
            // Top blue container with greeting and icons
            TopDashboardHeader(username: displayUsername.isNotEmpty ? displayUsername : widget.username),

            // Body content (can be added below)
            Expanded(
              child: Container(
                color: colors.whitecolor,
                child: Center(
                  child: Text("Main content here"),
                ),
              ),
            ),
          ],
        ),
      ),

    //Bottom navigation
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 80, // Adjust the height as per your design needs
        width: 100, // Set the width of the button
        decoration: BoxDecoration(
          color: colors.backgroundcolor,
          borderRadius: BorderRadius.circular(25), // Rounded corners
          boxShadow: [
            BoxShadow(
              color: colors.backgroundcolor.withAlpha((255 * 0.4).toInt()), // 40% opacity shadow
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Material(
          color: colors.backgroundcolor, // Set the background color for the Material widget
          borderRadius: BorderRadius.circular(25),
          child: InkWell(
            onTap: () {
              if (_isCheckedIn) {
                // Handle logout (checkout)
                _toggleCheckInStatus();
              } else {
                // Go to face biometric login
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FaceBiometric()),
                );
              }
            },
            borderRadius: BorderRadius.circular(40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.emoji_emotions_outlined,
                  size: 30, // Adjust the icon size as needed
                  color: colors.whitecolor,
                ),
                SizedBox(height: 4),
            Text(
              _isCheckedIn ? 'Logout' : 'Login',
              style: TextStyle(
                color: colors.whitecolor,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            )
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        onFabPressed: () {
          // Optional if FAB inside nav widget
        },
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        selectedIndex: _selectedIndex,
      ),

    );
  }


}
