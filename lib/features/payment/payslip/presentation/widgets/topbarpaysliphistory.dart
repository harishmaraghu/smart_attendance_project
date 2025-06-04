import 'package:flutter/material.dart';
import 'package:month_picker_dialog/month_picker_dialog.dart';
import '../../../../../core/constants/app_colors.dart';



class TopDashboardinpaysliphistory extends StatefulWidget {
  final String userId;
  final String username;
  final String currentDate;
  final Function(String) onDateChanged;

  const TopDashboardinpaysliphistory({
    super.key,
    required this.userId,
    required this.username,
    required this.currentDate,
    required this.onDateChanged,
  });

  @override
  State<TopDashboardinpaysliphistory> createState() =>
      _TopDashboardinpaysliphistoryState();
}

class _TopDashboardinpaysliphistoryState
    extends State<TopDashboardinpaysliphistory> {
  final colors = AppColors();

  String _formatDateForDisplay(DateTime date) {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  DateTime _parseDateString(String dateString) {
    // Parse "June 2025" format back to DateTime
    final parts = dateString.split(' ');
    if (parts.length == 2) {
      final months = [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ];
      final monthIndex = months.indexOf(parts[0]);
      final year = int.tryParse(parts[1]);
      if (monthIndex != -1 && year != null) {
        return DateTime(year, monthIndex + 1);
      }
    }
    return DateTime.now(); // Fallback
  }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
              GestureDetector(
                onTap: () async {
                  final currentDate = _parseDateString(widget.currentDate);
                  final selectedDate = await showMonthPicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: currentDate,
                  );

                  if (selectedDate != null) {
                    final formattedDate = _formatDateForDisplay(selectedDate);
                    print("Selected Month: ${selectedDate.month}, Year: ${selectedDate.year}");
                    print("Formatted Date: $formattedDate");

                    // Call the callback to update the date in parent widget
                    widget.onDateChanged(formattedDate);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.calendar_today,
                    color: colors.dashboard_icon_color,
                    size: 22,
                  ),
                ),
              ),


              GestureDetector(
                onTap: ()  {},
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.share,
                    color: colors.dashboard_icon_color,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),

        ],
      ),
    );
  }
}

