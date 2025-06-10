import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as context;
import 'package:smart_attendance_project/features/attendance/presentation/pages/attendance_history.dart';

import 'package:smart_attendance_project/features/location/presentation/pages/splash_screen_2.dart';
import 'package:smart_attendance_project/features/login/presentation/pages/login_screen.dart';
import 'package:smart_attendance_project/features/splashscreens/first_screen.dart';

import 'amplifyconfiguration.dart';
import 'features/clams/presentation/pages/claim_history.dart';
import 'features/clams/presentation/pages/claims_create.dart';
import 'features/facebiometric/presentation/pages/face_biometric.dart';
import 'features/home_dashboard/presentation/bloc/hoembloc.dart';
import 'features/home_dashboard/presentation/pages/home_screen.dart';
import 'features/location/presentation/pages/location_screen.dart';


class AmplifyConfig {
  static Future<void> configureAmplify() async {
    try {
      // Add plugins
      await Amplify.addPlugins([
        AmplifyAuthCognito(),
        AmplifyStorageS3(),
      ]);

      // Configure Amplify
      await Amplify.configure(amplifyconfig);

      print('✅ Amplify successfully configured');
    } on AmplifyAlreadyConfiguredException {
      print('⚠️ Amplify was already configured');
    } catch (e) {
      print('❌ Failed to configure Amplify: $e');
      rethrow;
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    await AmplifyConfig.configureAmplify();
  } catch (e) {
    print('Failed to configure Amplify: $e');
  }

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<UserDataBloc>(
          create: (context) => UserDataBloc(),
        ),
        // Add other BLoCs as needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart Attendance',
        home: const FirstScreen(),
      ),
    );
  }
}


