import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_text.dart';
import '../widgets/otpinput_field.dart';
import '../widgets/verify_button_widget.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final colors = AppColors();
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  final List<TextEditingController> _controllers =
  List.generate(6, (_) => TextEditingController());

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenHeight = screenSize.height;
    final screenWidth = screenSize.width;

    final double logoHorizontalPadding = screenWidth * 0.1;
    final double contentPadding = screenWidth * 0.05;

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.025, vertical: screenHeight * 0.02),
          color: colors.backgroundcolor,
          child: Column(
            children: [
              // Logo
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
                    width: 300,
                    height: 150,
                    fit: BoxFit.contain,
                  ),
                ),
              ),

              // Main container
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
                          SizedBox(height: screenHeight * 0.03),
                          Center(
                            child: Text(
                              "OTP Verification",
                              style: AppTextstyle.headingText(context)
                            ),

                          ),
                          SizedBox(height: screenHeight * 0.015),
                          Center(
                            child: Text(
                              "Please enter code we sent to you.",
                              style: AppTextstyle.normal_text,
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.05),

                          // OTP Input Fields
                          // ✅ Use custom widget
                          OtpInputWidget(
                            controllers: _controllers,
                            focusNodes: _focusNodes,
                            fieldWidth: screenWidth * 0.1,
                          ),
                          SizedBox(height: screenHeight * 0.04),

                          // Verify Button
                          SizedBox(
                            width: double.infinity,
                            child: VerifyButtonWidget(
                              onPressed: () {
                                String otpCode = _controllers.map((e) => e.text).join();
                                print("Entered OTP: $otpCode");
                                // Add validation or backend call here
                              },
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.025),
                          // Don't have an ottp
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Did't receive code?",
                                style: AppTextstyle.resent_text
                              ),
                              TextButton(
                                onPressed: () {},
                                style: TextButton.styleFrom(
                                  padding: EdgeInsets.zero,
                                  minimumSize: Size.zero,
                                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                ),
                                child: Text(
                                  "Resend",
                                  style: AppTextstyle.blue_text
                                ),
                              ),
                            ],
                          ),
                        ],
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
