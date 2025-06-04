import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../../../../core/constants/app_colors.dart';



class TopDashboardProfile extends StatefulWidget {




  const TopDashboardProfile({
    super.key,


  });

  @override
  State<TopDashboardProfile> createState() =>
      _TopDashboardProfileState();
}

class _TopDashboardProfileState
    extends State<TopDashboardProfile> {
  final colors = AppColors();



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: screenHeight * 0.04,
        left: screenWidth * 0.05,
        right: screenWidth * 0.05,
        bottom: screenHeight * 0.02,
      ),
      decoration: BoxDecoration(
        color: colors.backgroundcolor,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(30),
          bottomRight: Radius.circular(30),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with back and calendar icon
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Back Icon
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Image.asset(
                  'assets/icons/back_icon.png',
                  width: screenWidth * 0.10,
                  height: screenWidth * 0.10,
                ),
              ),
              // Calendar Icon
               Text('Profile ', style: TextStyle(
                 fontSize: 16,
                 color: Colors.white
               ),)
            ],
          ),

        ],
      ),
    );
  }
}

