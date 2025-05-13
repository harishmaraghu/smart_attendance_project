import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';

class AppTextstyle {
   static final _colors = AppColors();


   static const double _baseFontSize = 14;

   static final login_heading = TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: _colors.whitecolor,
   );

   // Heading  text pages
   static TextStyle headingText(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return TextStyle(
         fontSize: screenWidth * 0.06,
         fontWeight: FontWeight.bold,
         color: Color(0xff1D4C66),
      );
   }


   // Heading  text pages
   static TextStyle secound_heading_Text(BuildContext context) {
      final screenWidth = MediaQuery.of(context).size.width;
      return TextStyle(
         fontSize: screenWidth * 0.04,
         fontWeight: FontWeight.bold,
         color: _colors.block_color,
      );
   }

   // normal white
   static final normal_text_2 = TextStyle(
      fontSize: 18,
      color: _colors.whitecolor
   );


   static final pragra_text_2 = TextStyle(
      fontSize: 12,
      color: _colors.whitecolor,
      fontWeight: FontWeight.bold
   );

   // normal block
   static final normal_text = TextStyle(
      fontSize: 18,
      color: _colors.block_color,
   );


   static final pragra_text = TextStyle(
      fontSize: 12,
      color: _colors.block_color,
   );

   static final button_text = TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: _colors.button_bg_text_color,
   );

   static final ElevatedButton_text = ElevatedButton.styleFrom(
   backgroundColor: _colors.button_background_color,
   foregroundColor: _colors.button_bg_text_color,
   minimumSize: const Size(double.infinity, 48),
   shape: RoundedRectangleBorder(
   borderRadius: BorderRadius.circular(8),
   )
   );

   static final forgot_text= TextStyle(
      color: _colors.block_color,
      fontSize: 12,
      fontWeight: FontWeight.bold
   );



   // login screen page outline button
   static final OutlineButton=OutlinedButton.styleFrom(
      minimumSize: const Size(double.infinity, 48),
      side: BorderSide(color: _colors.block_color.withOpacity(0.3)),
      backgroundColor: _colors.getstart_backgroundcolor,
      shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(8),
      ),
   );

   //  Otp page resent text
   static final resent_text=TextStyle(color: _colors.block_color, fontSize: 12,);

  //Resent & Signinup text style
   static final blue_text=TextStyle(
      color: Colors.blue,
      fontWeight: FontWeight.w500,
   );


}
