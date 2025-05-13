import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/login/presentation/pages/otp_screen.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text.dart';
import '../widgets/login_button.dart';
import '../widgets/phone_no_field.dart';

class PhoneNoScreen extends StatefulWidget {
  const PhoneNoScreen({Key? key}) : super(key: key);

  @override
  State<PhoneNoScreen> createState() => _PhoneNoScreenState();
}

class _PhoneNoScreenState extends State<PhoneNoScreen> {
  final TextEditingController _phonenoController = TextEditingController();
  final colors = AppColors();

  @override
  Widget build(BuildContext context) {

    // media Query added
    // Get screen dimensions
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    // Define responsive dimensions
    final double logoVerticalPadding = screenHeight * 0.07;
    final double logoHorizontalPadding = screenWidth * 0.1;
    final double contentPadding = screenWidth * 0.05;
    final double logoFontSize = screenWidth * 0.07;
    final double brandNameFontSize = screenWidth * 0.045;
    final double brandSubtitleFontSize = screenWidth * 0.03;

    // Badge and text sizes
    final double badgeFontSize = screenWidth * 0.025;
    final double badgeIconSize = screenWidth * 0.03;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.025,
              vertical: screenHeight * 0.02
          ),
          color:colors.backgroundcolor,
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
                    width: 300, // optional
                    height: 150, // optional
                    fit: BoxFit.contain, // or cover
                  ),
                ),
              ),

            //   Main white container
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
                      child: Padding(padding: EdgeInsets.all(contentPadding),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // "NEW" badge
                            Row(
                              children: [
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.03,
                                      vertical: screenHeight * 0.005
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

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                PhoneNoField(controller: _phonenoController),
                                SizedBox(height: screenHeight * 0.015),
                                LoginButton(onPressed: () {
                                  Navigator.push(
                                      context, MaterialPageRoute(builder: (context)=>OtpScreen()));
                                  // Add your login logic here
                                }),

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
                                        style: TextStyle(
                                          color: Colors.blue,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            )

                          ],
                        ),

                      ),
                    ),
              )
              )
            ],
          ),
        ),
      ),
    );
  }
}
