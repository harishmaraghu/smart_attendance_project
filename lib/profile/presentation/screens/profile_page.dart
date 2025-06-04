import 'package:flutter/material.dart';
import 'package:smart_attendance_project/profile/data/servcices/profile_services.dart';
import 'package:smart_attendance_project/profile/models/profilemodels.dart';
import 'package:smart_attendance_project/profile/presentation/widgets/error_widgets.dart';
import 'package:smart_attendance_project/profile/presentation/widgets/profile_widgets.dart';
import 'package:smart_attendance_project/profile/presentation/widgets/topbarprofile.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  final String? username;

  const ProfileScreen({
    Key? key,
    this.userId,
    this.username,
  }) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModel? profile;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Use provided userId and username, or default values for testing
      final userId = widget.userId ?? '';
      final username = widget.username ?? '';

      final fetchedProfile = await ProfileApiService.getProfile(userId, username);

      if (fetchedProfile != null) {
        setState(() {
          profile = fetchedProfile;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
    child: isLoading
    ? LoadingWidget()
        : hasError
    ? ProfileErrorWidget(onRetry: _loadProfile)
    : _buildProfileContent(),
    ),);

  }

  Widget _buildProfileContent() {
    if (profile == null) {
      return ProfileErrorWidget(onRetry: _loadProfile);
    }

    return SingleChildScrollView(
      child: Column(
        children: [

          TopDashboardProfile(),
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(32),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                ProfileImageWidget(
                  imageUrl: profile!.imageUrl,
                  size: 120,
                ),
                SizedBox(height: 16),
                Text(
                  profile!.name,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'User ID: ${profile!.userid}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          // Profile Information Cards
          ProfileInfoCard(
            title: 'Phone Number',
            value: profile!.phonenumber,
            icon: Icons.phone,
          ),

          ProfileInfoCard(
            title: 'Passport Number',
            value: profile!.passportnumber,
            icon: Icons.assignment,
          ),

          ProfileInfoCard(
            title: 'Visa Number',
            value: profile!.visanumber,
            icon: Icons.card_membership,
          ),

          SizedBox(height: 24),

          // Action Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle edit profile
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Edit profile functionality to be implemented')),
                      );
                    },
                    child: Text('Edit Profile'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      // Handle logout
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Logout'),
                          content: Text('Are you sure you want to logout?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                                // Implement logout logic
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Logout functionality to be implemented')),
                                );
                              },
                              child: Text('Logout'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 32),
        ],
      ),
    );
  }


}
