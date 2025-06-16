import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/data/datasours/leave_dashboard_repository.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/bloc/leave_dash_bloc.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/screens/leave_dashboard_page.dart';
import 'package:smart_attendance_project/features/loan/domain/loan_repo_impl.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_bloc.dart';
import 'package:smart_attendance_project/features/loan/presentation/screens/apply/loan_form.dart';
import 'package:smart_attendance_project/features/payment/payslip/data/services/payslipapiservice.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/bloc/pay_slip_bloc.dart';
import 'package:smart_attendance_project/features/payment/payslip/presentation/pages/payment_history.dart';
import 'package:smart_attendance_project/features/splashscreens/first_screen.dart';
// import 'package:smart_attendance_project/features/leave/presentation/pages/leave_history/leave_record.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/shared_prefsHelper.dart';
import '../../../attendance/presentation/pages/attendance_history.dart';
import '../../../login/presentation/pages/login_screen.dart';

import '../bloc/hoembloc.dart';
import '../bloc/hoemevent.dart';
import '../bloc/hoemstate.dart';

class TopDashboardHeader extends StatefulWidget {
  final String username;

  const TopDashboardHeader({Key? key, required this.username}) : super(key: key);

  @override
  _TopDashboardHeaderState createState() => _TopDashboardHeaderState();
}

class _TopDashboardHeaderState extends State<TopDashboardHeader> {
  final colors = AppColors();

  @override
  void initState() {
    super.initState();
    context.read<UserDataBloc>().add(LoadUserDataEvent());
  }

  Future<void> _logout() async {
    // Show confirmation dialog
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Logout'),
            ),
          ],
        );
      },
    );

    if (shouldLogout == true) {
      try {
        // Clear user data from SharedPreferences
        await SharedPrefsHelper.clearUserData();

        // Navigate back to FirstScreen (splash screen)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const FirstScreen()),
              (route) => false,
        );
      } catch (e) {
        print('Logout error: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error during logout'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<UserDataBloc, UserDataState>(
        builder: (context, state) {
          String displayUsername = widget.username;
          String? userImageUrl;
          String? userCategory;
          String? userId;

          if (state is UserDataLoaded) {
            displayUsername = state.username;
            userImageUrl = state.userImageUrl;
            userCategory = state.userCategory;
            userId = state.userId;
          } else if (state is UserDataError) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(state.message),
                    backgroundColor: Colors.orange,
                    action: SnackBarAction(
                      label: 'Retry',
                      onPressed: () {
                        context.read<UserDataBloc>().add(LoadUserDataEvent());
                      },
                    ),
                  ),
                );
              }
            });
          }


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
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row with menu and notification
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Menu Icon with PopupMenu
                  PopupMenuButton<String>(
                    offset: Offset(0, 40), // Adjust dropdown position below the icon
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    itemBuilder: (BuildContext context) => [
                      PopupMenuItem(value: 'attendance', child: Text('Attendance')),
                      PopupMenuItem(
                        value: 'logout',
                        child: Row(
                          children: [
                            Icon(Icons.logout, color: Colors.red, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Logout',
                              style: TextStyle(color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ],
                    onSelected: (value) {
                      if (!mounted) return;

                      switch (value) {
                        case 'logout':
                          _logout();
                          break;
                        case 'attendance':
                        // Use userId from BLoC state instead of SharedPrefs call
                          if (userId != null && userId.isNotEmpty) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AttendanceHistory(Userid: userId!),
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('User ID not found')),
                            );
                          }
                          break;
                        case 'profile':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Profile feature coming soon')),
                          );
                          break;
                        case 'settings':
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Settings feature coming soon')),
                          );
                          break;
                      }
                    },
                    child: Icon(Icons.menu, color: Colors.white, size: 28),
                  ),

                  // Notification Icon with onTap
                  GestureDetector(
                    onTap: () {
                      // Handle notification tap here
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('No new notifications')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.notifications, // This is the filled version
                        color: AppColors().dashboard_icon_color,
                        size: 22,
                      ),
                    ),

                  ),
                ],
              ),

              SizedBox(height: 20),

              // Greeting text with loading state handling
              if (state is UserDataLoading)
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Loading...',
                      style: TextStyle(fontSize: 22, color: Colors.white),
                    ),
                  ],
                )
              else
                Text.rich(
                  TextSpan(
                    text: 'Hello, ',
                    style: TextStyle(fontSize: 22, color: Colors.white),
                    children: [
                      TextSpan(
                        text: displayUsername,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

              SizedBox(height: 4),
              Text(
                'Welcome back to your dashboard.',
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              SizedBox(height: 20),

              // Floating white card with icons
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // _buildIcon(Icons.access_time, 'Attendance', () {
                    //   // Use userId from BLoC state instead of async SharedPrefs call
                    //   if (userId != null && userId.isNotEmpty) {
                    //     Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //         builder: (_) => AttendanceHistory(Userid: userId!),
                    //       ),
                    //     );
                    //   } else {
                    //     ScaffoldMessenger.of(context).showSnackBar(
                    //       const SnackBar(content: Text("User ID not found")),
                    //     );
                    //   }
                    // }),
                    _buildIcon(Icons.assignment, 'Claims', () {

                      if (userId != null && userId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ClaimsCreate(Userid: userId!,username:displayUsername),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User ID not found")),
                        );
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => ClaimsCreate()));
                    }),

                    _buildIcon(Icons.access_time, 'Loan', () {

                      if (userId != null && userId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => LoanBloc(), // Fixed syntax
                              child: LoanForm(
                                Userid: userId!, // Pass userId
                                username: displayUsername, // Pass username
                                 // Will use current month, or pass specific date
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User ID not found")),
                        );
                      }
                      // Navigator.push(context, MaterialPageRoute(builder: (_) => ClaimsCreate()));
                    }),

                    _buildIcon(Icons.receipt_long, 'Payslip', () {

                      if (userId != null && userId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => PayslipBloc(PayslipApiService()), // Fixed syntax
                              child: PaymentHistory(
                                userId: userId!, // Pass userId
                                username: displayUsername, // Pass username
                                selectedDate: null, // Will use current month, or pass specific date
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User ID not found")),
                        );
                      }




                      // Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentHistory()));
                    }),
                    _buildIcon(Icons.time_to_leave, 'Leave', () {
                      if (userId != null && userId.isNotEmpty) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => BlocProvider(
                              create: (context) => LeaveDashboardBloc(
                                repository: LeaveDashboardRepository(),
                              ),
                              child: LeaveDashboardPage(
                                Userid: userId!,
                                username: displayUsername,
                              ),
                            ),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("User ID not found")),
                        );
                      }
                    }),
                  ],
                ),

              ),
            ],
          ),
        );
      }
    );
  }

  Widget _buildIcon(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white, // Outer box color
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.3), // glow-like shadow
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: AppColors().dashboard_icon_background, // Blue fill
              child: Icon(
                icon,
                color: Color(0xff2478AA), // Icon color (white on blue)
                size: 22,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

}
