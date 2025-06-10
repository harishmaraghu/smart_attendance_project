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

  const HomeScreen({
    super.key,
    required this.username,
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

  @override
  void initState() {
    super.initState();
    _isCheckedIn = widget.isCheckedIn;
    _loadUsername();
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

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final textScale = MediaQuery.textScaleFactorOf(context);
    final isPortrait =
        MediaQuery.of(context).orientation == Orientation.portrait;

    return Scaffold(
      body: SafeArea(
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
                child: Center(
                  child: Text(
                    "Main content here",
                    style: TextStyle(
                      fontSize: screenSize.width * 0.045 * textScale,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),

      // Floating Action Button (Login/Logout)
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
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
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavBar(
        onFabPressed: () {
          // Optional
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
