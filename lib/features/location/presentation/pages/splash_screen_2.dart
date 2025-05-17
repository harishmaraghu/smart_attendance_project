import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';

import '../../../../core/constants/app_text.dart';
import '../../../home_dashboard/presentation/pages/home_screen.dart';

class SplashScreen2 extends StatefulWidget {
  final bool isCheckedIn;
  const SplashScreen2({super.key,this.isCheckedIn = true});

  @override
  State<SplashScreen2> createState() => _SplashScreen1State();
}

class _SplashScreen1State extends State<SplashScreen2> {

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const HomeScreen(isCheckedIn: false,username: AutofillHints.username),
        ),
      );
    });
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    return  Scaffold(
      backgroundColor: AppColors().backgroundcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/high_five.png',
              width: screenWidth * 0.15,  // 12% of screen width
              height: screenWidth * 0.15,
            ),
            SizedBox(height: screenHeight * 0.03),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Text('Your workday is complete. See you tomorrow',
                  style: AppTextstyle.normal_text.copyWith(
                  color: AppColors().whitecolor,
                    fontSize: screenWidth * 0.045,
                ),
                  textAlign: TextAlign.center,
                ),),



          ],
        ),
      ),
    );
  }
}
