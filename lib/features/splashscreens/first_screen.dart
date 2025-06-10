import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/features/login/presentation/pages/login_screen.dart';

class FirstScreen extends StatefulWidget {
  const FirstScreen({super.key});

  @override
  State<FirstScreen> createState() => _FirstScreenState();
}

class _FirstScreenState extends State<FirstScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final height = size.height;
    final width = size.width;

    return Scaffold(
      backgroundColor: AppColors().getstart_backgroundcolor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(width * 0.04),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: height * 0.04),
                  Text(
                    'Powered by',
                    style: TextStyle(
                      fontSize: width * 0.045,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical: height * 0.01,
                      horizontal: width * 0.06,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E80C9),
                      borderRadius: BorderRadius.circular(width * 0.05),
                    ),
                    child: Text(
                      'Beza Technology - Smart',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: width * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(height: height * 0.015),
                  Text(
                    'Attendance Made simple',
                    style: TextStyle(
                      fontSize: width * 0.04,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: height * 0.15),
                  Image.asset(
                    'assets/images/splashscreen.png',
                    width: width * 1.5,
                    fit: BoxFit.contain,
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                    vertical: height * 0.018,
                    horizontal: width * 0.08,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(width * 0.1),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.arrow_forward, color: const Color(0xFF1E80C9), size: width * 0.06),
                      SizedBox(width: width * 0.05),
                      Text(
                        'Get Started',
                        style: TextStyle(fontSize: width * 0.055, color: Colors.black87),
                      ),
                      SizedBox(width: width * 0.025),
                      Icon(Icons.check_circle, color: const Color(0xFF1E80C9), size: width * 0.06),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
