import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/features/login/presentation/pages/phone_no_screen.dart';
import 'package:smart_attendance_project/features/login/presentation/widgets/password_field.dart';

import '../../../../core/constants/app_text.dart';
import '../../../../core/constants/shared_prefsHelper.dart';
import '../../../home_dashboard/presentation/pages/home_screen.dart';
import '../../data/datasources/login_remote_datasource.dart';
import '../../data/repositories/login_repository.dart';
import '../widgets/login_button.dart';
import '../widgets/username_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscurePassword = true;
  final colors = AppColors();
  late final LoginRepository _repository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _repository = LoginRepository(remoteDataSource: LoginRemoteDataSource());
    // Removed _checkLoginStatus() from here since it's now handled in FirstScreen
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _repository.login(
        _usernameController.text,
        _passwordController.text,
      );

      print("------------------------Login Success: $result");

      // Save login response to SharedPreferences
      await SharedPrefsHelper.saveUserData(result);

      // Get username from saved data
      final username = await SharedPrefsHelper.getUsername();
      final userId = await SharedPrefsHelper.getUserId() ?? '';

      // Navigate to home screen with dynamic username
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            username: username,
            userId: userId,
          ),
        ),
      );
    } catch (e) {
      print("Login Error: $e");
      // Show error to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Login failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    // Define responsive dimensions
    final double logoVerticalPadding = screenHeight * 0.07;
    final double logoHorizontalPadding = screenWidth * 0.1;
    final double contentPadding = screenWidth * 0.05;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.015,
              vertical: screenHeight * 0.01
          ),
          color: colors.backgroundcolor,
          child: Column(
            children: [
              // Top part with logo
              Container(
                padding: EdgeInsets.only(
                  top: screenHeight * 0.02,
                  left: logoHorizontalPadding,
                  right: logoHorizontalPadding,
                  bottom: screenHeight * 0.015,
                ),
                child: Center(
                  child: Image.asset(
                    'assets/images/logo.png',
                    width: 200, // optional
                    height: 150, // optional
                    fit: BoxFit.contain, // or cover
                  ),
                ),
              ),
              // Main white container
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: colors.whitecolor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(screenWidth * 0.1),
                      topRight: Radius.circular(screenWidth * 0.1),
                      bottomLeft: Radius.circular(screenWidth * 0.05),
                      bottomRight: Radius.circular(screenWidth * 0.05),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: EdgeInsets.all(contentPadding),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "NEW" badge
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.01,
                                      vertical: screenHeight * 0.002
                                  ),
                                  child: Row(
                                    children: [
                                      Image.asset(
                                        'assets/icons/hello_icon.png',
                                        width: 50, // optional
                                        height: 50, // optional
                                        fit: BoxFit.contain, // or cover
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.01),

                            // Description text
                            Text(
                              "Securely access your profile, mark attendance, "
                                  "and view reports—all in one place.",
                              style: AppTextstyle.pragra_text,
                            ),

                            SizedBox(height: screenHeight * 0.03),

                            // Login heading
                            Text(
                                "Login",
                                style: AppTextstyle.headingText(context)
                            ),

                            SizedBox(height: screenHeight * 0.02),

                            // Username field
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                UsernameField(controller: _usernameController),
                                SizedBox(height: screenHeight * 0.02),
                                PasswordField(
                                  controller: _passwordController,
                                  obscureText: _obscurePassword,
                                  onToggleVisibility: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),

                                // Forgot password link
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                        "Forgot password?",
                                        style: AppTextstyle.forgot_text
                                    ),
                                  ),
                                ),

                                SizedBox(height: screenHeight * 0.015),

                                _isLoading
                                    ? Container(
                                  width: double.infinity,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    color: colors.backgroundcolor.withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                                    : LoginButton(onPressed: _login),
                              ],
                            ),

                            SizedBox(height: screenHeight * 0.01),

                            // Or divider
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Divider(color: colors.block_color.withOpacity(0.3)),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
                                    child: Text(
                                      "Or",
                                      style: TextStyle(color: colors.block_color),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(color: colors.block_color.withOpacity(0.3)),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.01),

                            // Login with phone number
                            OutlinedButton(
                              onPressed: () {
                                Navigator.push(context,
                                  MaterialPageRoute(builder: (context)=>PhoneNoScreen()),);
                              },
                              style: AppTextstyle.OutlineButton,
                              child: Text(
                                "Login with phone number",
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),

                            SizedBox(height: screenHeight * 0.025),

                            // Don't have an account
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't you have an account? ",
                                  style: TextStyle(color: colors.block_color),
                                ),
                                TextButton(
                                  onPressed: () {},
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    minimumSize: Size.zero,
                                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  child: Text(
                                      "sign up",
                                      style: AppTextstyle.resent_text
                                  ),
                                ),
                              ],
                            ),
                          ]
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}