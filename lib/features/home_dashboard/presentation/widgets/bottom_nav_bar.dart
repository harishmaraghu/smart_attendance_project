import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/shared_prefsHelper.dart';
import 'package:smart_attendance_project/features/profile/presentation/screens/profile.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/screens/profile_page.dart';

class BottomNavBar extends StatelessWidget {
  final colors = AppColors();

  final Function onFabPressed;
  final Function(int) onTabSelected;
  final int selectedIndex;

  BottomNavBar({
    required this.onFabPressed,
    required this.onTabSelected,
    required this.selectedIndex,
    required bool showNotch,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      color: AppColors().whitecolor,
      notchMargin: 13,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 5),
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

  Widget _buildBottomItem(IconData icon, String label, int index, BuildContext context) {
    final isActive = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        // Simply call the callback to switch pages
        onTabSelected(index);
      },
      child: SizedBox(
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 26, // fixed size for consistent shadow circle
              width: 36,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isActive
                    ? colors.backgroundcolor.withOpacity(0.1)
                    : Colors.transparent,
                boxShadow: isActive
                    ? [
                  BoxShadow(
                    color: colors.backgroundcolor.withOpacity(0.4),
                    blurRadius: 6,
                    offset: Offset(0, 2),
                  ),
                ]
                    : [],
              ),
              child: Center(
                child: Icon(
                  icon,
                  size: 20,
                  color: isActive
                      ? colors.backgroundcolor
                      : colors.backgroundcolor.withOpacity(0.4),
                ),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive
                    ? colors.backgroundcolor
                    : colors.backgroundcolor.withOpacity(0.4),
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
