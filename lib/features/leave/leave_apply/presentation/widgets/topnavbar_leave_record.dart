import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/core/constants/app_text.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/bloc/hoembloc.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/bloc/hoemevent.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/bloc/hoemstate.dart';
import 'package:smart_attendance_project/features/home_dashboard/presentation/pages/home_screen.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/presentation/pages/leaveapply/leave_apply_screen.dart';


class TopDashboardHeaderinLeave extends StatefulWidget {
  @override
  State<TopDashboardHeaderinLeave> createState() => _TopDashboardHeaderinLeaveState();
}

class _TopDashboardHeaderinLeaveState extends State<TopDashboardHeaderinLeave> {
  final colors = AppColors();

  @override
  void initState() {
    super.initState();
    context.read<UserDataBloc>().add(LoadUserDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return BlocBuilder<UserDataBloc, UserDataState>(
        builder: (context, state) {
          String? username;
          String? userImageUrl;
          String? userCategory;
          String? userId;
          if (state is UserDataLoaded) {
            username = state.username;
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

          return Container  (
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
                  GestureDetector(
                    onTap: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>HomeScreen(
                              username: username ?? 'Guest',userId: userId ?? '0',)));
                      },
                    child: Image.asset(
                      'assets/icons/back_icon.png',
                      width: screenWidth * 0.10,
                      height: screenWidth * 0.10,
                    ),
                  ),


                  // Notification Icon with onTap
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context)=>
                              LeaveApplyScreen(userId: userId ?? '',userName: username ?? '',)));

                    },
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text("Leave apply",style: AppTextstyle.pragra_text,)
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }
    );
  }
}
