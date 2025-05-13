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
        },
        builder: (context, state) {
          if (state.error != null) {
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
                      color: AppColors().lightbackgroundcolor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Latitude: ${state.latitude?.toStringAsFixed(6)}"),
                        Text("Longitude: ${state.longitude?.toStringAsFixed(6)}"),
                        const SizedBox(height: 8),
                        Text("Address: ${state.address ?? 'Loading address...'}"),
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
                            // Entry In
                            _timeCard(
                              icon: Icons.access_time,
                              time: formatTime(state.checkInTime),
                              label: "Entry in",
                              bgColor: Colors.green,
                              iconColor: Colors.white,
                            ),

                            // Entry Out
                            _timeCard(
                              icon: Icons.access_time,
                              time: formatTime(state.checkOutTime),
                              label: "Entry out",
                              bgColor: Colors.blue,
                              iconColor: Colors.white,
                            ),

                            // Total Hours
                            _timeCard(
                              icon: Icons.access_time,
                              time: calculateTotalHours(state.checkInTime, state.checkOutTime),
                              label: "total hrs",
                              bgColor: Colors.grey.shade200,
                              iconColor: Colors.grey,
                              textColor: Colors.black54,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Check In or Check Out button
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        final bloc = BlocProvider.of<LocationBloc>(context);
                        if (state.checkInTime == null) {
                          bloc.add(CheckInPressed());
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SplashScreen1(isCheckedIn: true),
                              ),
                            );
                          });
                        } else {
                          bloc.add(CheckOutPressed());
                          Future.delayed(const Duration(milliseconds: 1500), () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SplashScreen2(isCheckedIn: false),
                              ),
                            );
                          });
                        }
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        width: screenWidth * 0.4,
                        height: screenWidth * 0.4,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: state.checkInTime == null ? Colors.green : Colors.red,
                          border: Border.all(color: const Color(0xffF1FAFE), width: 15),
                          boxShadow: [
                            // Outer white glow
                            BoxShadow(
                              color: Colors.grey.withAlpha(80),
                              blurRadius: 20,
                              spreadRadius: 12,
                              offset: const Offset(0, 10),
                            ),
                            // Inner shadow to lift button
                            BoxShadow(
                              color: Colors.black.withAlpha(30),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: Center(
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
                                style: AppTextstyle.normal_text_2,
                              ),
                            ],
                          ),
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
}) {
  return Container(
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
        Text(
            time,
            style: AppTextstyle.pragra_text_2
        ),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: textColor),
        ),
      ],
    ),
  );
}