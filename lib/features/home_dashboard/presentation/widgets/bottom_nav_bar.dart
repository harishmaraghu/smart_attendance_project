import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/shared_prefsHelper.dart';
import 'package:smart_attendance_project/profile/presentation/screens/profile_page.dart';
import '../../../../core/constants/app_colors.dart';
// import '../../../profile/presentation/screens/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final colors = AppColors();

  final Function onFabPressed;
  final Function(int) onTabSelected;
  final int selectedIndex;

  BottomNavBar({
    required this.onFabPressed,
    required this.onTabSelected,
    required this.selectedIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: AppColors().whitecolor,
      notchMargin: 8,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(child: _buildBottomItem(Icons.home, "Home", 0, context)),
            Flexible(child: _buildBottomItem(Icons.person, "Profile", 1, context)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomItem(IconData icon, String label, int index,BuildContext context) {
    final isActive = selectedIndex == index;

    return GestureDetector(
      onTap: ()async{
        // Call onTabSelected to update the selected tab, and navigate if necessary
        onTabSelected(index);
        if (index == 1) { // If the profile tab is selected
          // Get user data from SharedPreferences
          final userId = await SharedPrefsHelper.getUserId();
          final username = await SharedPrefsHelper.getUsername();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProfileScreen(
                userId: userId,
                username: username,
              ),
            ),
          );
        }
      },
      child: SizedBox(
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(  // Wrap with Flexible
              child: Container(
                padding: EdgeInsets.all(6),
                decoration: isActive
                    ? BoxDecoration(
                  color: colors.backgroundcolor.withAlpha((255 * 0.10).toInt()), // 10% opacity
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: colors.backgroundcolor.withAlpha((255 * 0.4).toInt()), // 40% opacity
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                )
                    : null,
                child: Icon(
                  icon,
                  size: 20,
                  color: isActive
                      ? colors.backgroundcolor
                      : colors.backgroundcolor.withAlpha((255 * 0.4).toInt()), // 40%
                ),
              ),
            ),
            SizedBox(height: 2),
            Flexible(  // Wrap with Flexible
              child: Text(
                label,
                style: TextStyle(
                  color: isActive
                      ? colors.backgroundcolor
                      : colors.backgroundcolor.withAlpha((255 * 0.4).toInt()),
                  fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
