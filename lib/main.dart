import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/attendance/presentation/pages/attendance_history.dart';
import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history/leave_record.dart';
import 'package:smart_attendance_project/features/location/presentation/pages/splash_screen_2.dart';
import 'package:smart_attendance_project/features/login/presentation/pages/login_screen.dart';

import 'features/clams/presentation/pages/claim_history.dart';
import 'features/clams/presentation/pages/claims_create.dart';
import 'features/facebiometric/presentation/pages/face_biometric.dart';
import 'features/home_dashboard/presentation/pages/home_screen.dart';
import 'features/location/presentation/pages/location_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
        home: const LoginScreen(),
    );
  }
}


