import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/pages/home_screen.dart';
import 'package:smart_attendance_project/features/profile/presentation/widgets/crved.dart';
import '../../../../../core/constants/app_colors.dart';

class TopDashboardProfile extends StatefulWidget {
  final String username;
  final String? userId;
  final String? image;

  const TopDashboardProfile({
    Key? key,
    required this.userId,
    required this.username,
    required this.image,
  }) : super(key: key);

  @override
  State<TopDashboardProfile> createState() => _TopDashboardProfileState();
}

class _TopDashboardProfileState extends State<TopDashboardProfile> {
  final colors = AppColors();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SingleChildScrollView(
      child: Column(
        children: [
          // BLUE HEADER WITH CURVE
          ClipPath(
            clipper: BottomCurveClipper(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: screenHeight * 0.04,
                left: screenWidth * 0.05,
                right: screenWidth * 0.05,
                bottom: screenHeight * 0.06,
              ),
              decoration: BoxDecoration(
                color: colors.backgroundcolor,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () =>
                            Navigator.push(context,MaterialPageRoute(builder: (context)=>HomeScreen(username: widget.username, userId: widget.userId!))),
                        child: Image.asset(
                          'assets/icons/back_icon.png',
                          width: screenWidth * 0.12,
                          height: screenWidth * 0.10,
                        ),
                      ),
                      const Text(
                        'Profile screen',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 25),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: widget.image != null && widget.image!.isNotEmpty
                            ? NetworkImage(widget.image!)
                            : const AssetImage('assets/images/default_profile.jpg') as ImageProvider,
                      ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Hello, ${widget.username}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 2),
                          // const Text(
                          //   'Supervisor',
                          //   style: TextStyle(
                          //     fontSize: 12,
                          //     color: Colors.white70,
                          //   ),
                          // ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }


}
