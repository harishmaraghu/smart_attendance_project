import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_attendance_project/features/attendance/presentation/pages/attendance_history.dart';
import 'package:smart_attendance_project/features/clams/presentation/pages/claims_create.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/data/datasours/leave_dashboard_repository.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/bloc/leave_dash_bloc.dart';
import 'package:smart_attendance_project/features/leave/leave_dashboard/presentation/screens/leave_dashboard_page.dart';
import 'package:smart_attendance_project/features/loan/presentation/bloc/loan_bloc.dart';
import 'package:smart_attendance_project/features/loan/presentation/screens/apply/loan_form.dart';
import 'package:smart_attendance_project/features/profile/presentation/widgets/topbarprofile.dart';

import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/profile/presentation/widgets/crved.dart';
import 'package:smart_attendance_project/features/work_loaction_profile/location/presentations/screens/work_location.dart';
import '../../../../../core/constants/app_colors.dart';

class Profile extends StatefulWidget {
  final String username;
  final String? userId;
  final String? image;

  const Profile({
    Key? key,
    required this.userId,
    required this.username,
    required this.image,
  }) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final colors = AppColors();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F9FF),
      body: SafeArea(
        child: Column(
          children: [
            // Top header section
            TopDashboardProfile(
              userId: widget.userId,
              username: widget.username,
              image: widget.image,
            ),

            // Expanded area for content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // White card with Profile & Work Location
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _profileTile(Icons.person, "Profile", () {}),
                          const Divider(height: 1),
                          _profileTile(Icons.location_on, "Work Location", () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => // In Profile screen
                                WorkLocation(userId: widget.userId!),
                              ),
                            );
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Records',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Records Card
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        children: [
                          _profileTile(Icons.access_time, "Attendance", () {
                            if (widget.userId != null && widget.userId!.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => AttendanceHistory(Userid: widget.userId!),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("User ID not found")),
                              );
                            }
                          }),

                          const Divider(height: 1),
                          _profileTile(Icons.person_outline, "Leave", () {
                            if (widget.userId != null && widget.userId!.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => LeaveDashboardBloc(
                                      repository: LeaveDashboardRepository(),
                                    ),
                                    child: LeaveDashboardPage(
                                      Userid: widget.userId!,
                                      username: widget.username,
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
                          const Divider(height: 1),
                          _profileTile(Icons.receipt_long, "Claim", () {
                            if (widget.userId != null && widget.userId!.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ClaimsCreate(Userid: widget.userId!,username:widget.username),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("User ID not found")),
                              );
                            }
                          }),
                          const Divider(height: 1),
                          _profileTile(Icons.folder, "Loan", () {
                            if (widget.userId != null && widget.userId!.isNotEmpty) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider(
                                    create: (context) => LoanBloc(), // Fixed syntax
                                    child: LoanForm(
                                      Userid: widget.userId!, // Pass userId
                                      username: widget.username, // Pass username
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
                          }),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.withOpacity(0.1),
        child: Icon(icon, color: Colors.blue),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }
}

