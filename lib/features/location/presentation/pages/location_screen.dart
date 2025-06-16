import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';
import 'package:smart_attendance_project/features/location/presentation/pages/splash_screen_1.dart';
import 'package:smart_attendance_project/features/location/presentation/pages/splash_screen_2.dart';

import '../../../../core/constants/app_text.dart';
import '../../../home_dashboard/presentation/pages/home_screen.dart';
import '../bloc/location_bloc.dart';
import '../bloc/location_event.dart';
import '../bloc/location_state.dart';

class LocationScreen extends StatefulWidget {
  final bool isCheckout;
  final String? imagePath;


  const LocationScreen({super.key, this.isCheckout = false, this.imagePath});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? _mapController;
  bool _isMapReady = false;
  String selectedLabel = "Entry in"; // default selected


  @override
  void initState() {
    super.initState();
    // Load location when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LocationBloc>().add(LoadLocation());
    });
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  String formatTime(DateTime? time) {
    if (time == null) return "-";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  String calculateTotalHours(DateTime? checkInTime, DateTime? checkOutTime) {
    if (checkInTime != null && checkOutTime != null) {
      final duration = checkOutTime.difference(checkInTime);
      return "${duration.inHours}h ${duration.inMinutes.remainder(60)}m";
    }
    return "-";
  }

  @override
  // Updated LocationScreen with proper navigation handling

  @override
  Widget build(BuildContext context) {
    // Using MediaQuery to get the screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: BlocConsumer<LocationBloc, LocationState>(
        listener: (context, state) {
          // Update map when location is loaded
          if (state.latitude != null && state.longitude != null && _mapController != null && _isMapReady) {
            _mapController?.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(state.latitude!, state.longitude!),
                  zoom: 16,
                ),
              ),
            );
          }

          // ✅ Handle navigation only on successful API response
          if (state.shouldNavigate && state.navigationTimeType != null) {
            print("✅ API Success - Navigating for ${state.navigationTimeType}");

            if (state.navigationTimeType == "inTime") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen1(isCheckedIn: true),
                ),
              );
            } else if (state.navigationTimeType == "outTime") {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const SplashScreen2(isCheckedIn: false),
                ),
              );
            }
          }

          // ✅ Show error messages if API fails
          if (state.error != null && state.error!.contains("Failed to")) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error!),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state.error != null && !state.error!.contains("Failed to")) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(state.error!, style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<LocationBloc>().add(LoadLocation());
                    },
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          }

          if (state.latitude != null && state.longitude != null) {
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: screenHeight * 0.35,
                    child: GoogleMap(
                      initialCameraPosition: CameraPosition(
                        target: LatLng(state.latitude!, state.longitude!),
                        zoom: 16,
                      ),
                      markers: {
                        Marker(
                          markerId: const MarkerId("current_location"),
                          position: LatLng(state.latitude!, state.longitude!),
                        )
                      },
                      onMapCreated: (controller) {
                        _mapController = controller;
                        setState(() {
                          _isMapReady = true;
                        });
                      },
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),

                  // "Location" Text Outside Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text("Location", style: AppTextstyle.secound_heading_Text(context)),
                  ),

                  Container(
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors().whitecolor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.location_on, size: 20, color: Colors.grey),
                            SizedBox(width: 8), // Space between icon and text
                            Expanded(
                              child: Text(
                                "Address: ${state.address ?? 'Loading address...'}",
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // "Date & Time" Text Outside Container
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Date & Time", style: AppTextstyle.secound_heading_Text(context)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _timeCard(
                              icon: Icons.access_time,
                              time: formatTime(state.checkInTime),
                              label: "Entry in",
                              bgColor: selectedLabel == "Entry in" ? AppColors().backgroundcolor : Colors.blue,
                              iconColor: AppColors().whitecolor,
                              onTap: () {
                                setState(() {
                                  selectedLabel = "Entry in";
                                });
                              },
                            ),
                            _timeCard(
                              icon: Icons.access_time,
                              time: formatTime(state.checkOutTime),
                              label: "Entry out",
                              bgColor: selectedLabel == "Entry out" ? AppColors().backgroundcolor : Colors.green,
                              iconColor: AppColors().whitecolor,
                              onTap: () {
                                setState(() {
                                  selectedLabel = "Entry out";
                                });
                              },
                            ),
                            _timeCard(
                              icon: Icons.access_time,
                              time: calculateTotalHours(state.checkInTime, state.checkOutTime),
                              label: "total hrs",
                              bgColor: selectedLabel == "total hrs" ? Colors.grey.shade400 : Colors.grey.shade200,
                              iconColor: Colors.grey,
                              textColor: Colors.black54,
                              onTap: () {
                                setState(() {
                                  selectedLabel = "total hrs";
                                });
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ✅ Updated Check In or Check Out button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        // ✅ Prevent multiple taps while processing
                        if (state.isUploadingImage) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please wait, processing..."),
                              duration: Duration(seconds: 2),
                            ),
                          );
                          return;
                        }

                        final bloc = BlocProvider.of<LocationBloc>(context);
                        if (state.checkInTime == null) {
                          print("🔄 Initiating Check In...");
                          bloc.add(CheckInPressed());
                        } else {
                          print("🔄 Initiating Check Out...");
                          bloc.add(CheckOutPressed());
                        }
                        // ✅ Navigation now handled in BlocListener based on API success
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: screenWidth * 0.3,
                        height: screenWidth * 0.3,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: state.checkInTime == null ? Colors.green : Colors.red,
                          border: Border.all(color: const Color(0xffF1FAFE), width: 10),
                          boxShadow: [
                            // Outer white glow
                            BoxShadow(
                              color: Colors.grey.withAlpha(80),
                              blurRadius: 18,
                              spreadRadius: 10,
                              offset: const Offset(0, 8),
                            ),
                            // Inner shadow to lift button
                            BoxShadow(
                              color: Colors.black.withAlpha(28),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Stack(
                          children: [
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.touch_app,
                                    color: Colors.white,
                                    size: screenWidth * 0.1,
                                  ),
                                  SizedBox(height: screenHeight * 0.01),
                                  Text(
                                    state.checkInTime == null ? "Check In" : "Check Out",
                                    style: AppTextstyle.normal_text_2.copyWith(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            // ✅ Show loading indicator while processing
                            if (state.isUploadingImage)
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.black.withOpacity(0.3),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: screenHeight * 0.02),
                ],
              ),
            );
          } else {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Loading location data..."),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}

Widget _timeCard({
  required IconData icon,
  required String time,
  required String label,
  required Color bgColor,
  required Color iconColor,
  Color textColor = Colors.white,
  required VoidCallback onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      width: 80,
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(height: 4),
          Text(time, style: AppTextstyle.pragra_text_2),
          Text(
            label,
            style: TextStyle(fontSize: 12, color: textColor),
          ),
        ],
      ),
    ),
  );
}
