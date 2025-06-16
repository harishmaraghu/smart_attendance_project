import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';

import '../../../../core/constants/shared_prefsHelper.dart';
import '../../../../services/s3_upload_service.dart';
import '../../../location/data/repositories/location_repository_impl.dart';
import '../../../location/domain/usecases/get_address_from_coordinates.dart';
import '../../../location/domain/usecases/get_current_location.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../location/presentation/bloc/location_event.dart';
import '../../../location/presentation/pages/location_screen.dart' hide LocationBloc;

class FaceBiometric extends StatefulWidget {
  const FaceBiometric({super.key});

  @override
  State<FaceBiometric> createState() => _FaceBiometricState();
}

class _FaceBiometricState extends State<FaceBiometric> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  String? _generatedImageKey; // Store the generated image key consistently
  bool _isProcessing = false;

  /// Generate consistent image key with timestamp and user info
  String _generateImageKey(String imagePath) {
    final fileName = imagePath.split('/').last;
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;

    // Consistent format: attendance_timestamp_filename
    final imageKey = "attendance_${timestamp}_$fileName";
    print('🔑 Generated consistent image key: $imageKey');
    return imageKey;
  }

  Future<void> _openCamera() async {
    if (_isProcessing) return; // Prevent multiple simultaneous captures

    setState(() => _isProcessing = true);

    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 800,
        maxHeight: 800,
      );

      if (photo != null) {
        setState(() {
          _image = photo;
          _generatedImageKey = _generateImageKey(photo.path); // Generate ONCE
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Photo captured successfully!"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        print('📸 Image captured with consistent key: $_generatedImageKey');
      }
    } catch (e) {
      print('❌ Camera capture error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to capture photo: $e"),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() => _isProcessing = false);
    }
  }

  void _retakePhoto() {
    setState(() {
      _image = null;
      _generatedImageKey = null; // Reset key for new image
    });
    _openCamera();
  }

  void _proceedToLocation() {
    if (_image == null || _generatedImageKey == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please take a photo first."),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Pass the SAME image key to maintain consistency
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BlocProvider(
          create: (context) => LocationBloc(
            getCurrentLocation: GetCurrentLocation(),
            getAddressFromCoordinates: GetAddressFromCoordinates(),
            locationRepo: LocationRepositoryImpl(),
            imagePath: _image!.path,
            imageKey: _generatedImageKey!, // Pass consistent key
          )..add(LoadLocation()),
          child: LocationScreen(imagePath: _image!.path),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors().backgroundcolor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Padding(
            padding: EdgeInsets.all(8.0), // Optional: adds some space around the icon
            child: Image.asset(
              'assets/icons/back_icon.png',
              width: screenWidth * 0.08,
              height: screenWidth * 0.08,
            ),
          ),
        ),
        // title: const Text("Face Verification"), // Uncomment if you want a title
      ),


      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Please take a clear photo of your face",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[700],
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              if (_image == null) ...[
                GestureDetector(
                  onTap: _isProcessing ? null : _openCamera,
                  child: Container(
                    width: screenWidth * 0.5,
                    height: screenWidth * 0.5,
                    decoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      color: _isProcessing ? Colors.grey.shade200 : Colors.blue.shade100,
                      border: Border.all(
                        color: _isProcessing ? Colors.grey.shade300 : Colors.blue.shade300,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: (_isProcessing ? Colors.grey : Colors.blue).withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: _isProcessing
                        ? const CircularProgressIndicator()
                        : Icon(
                      Icons.camera_alt,
                      size: screenWidth * 0.15,
                      color: Colors.blue,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _isProcessing ? "Opening camera..." : "Tap to open camera",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ] else ...[
                Container(
                  width: screenWidth * 0.6,
                  height: screenWidth * 0.6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.green, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: Image.file(
                      File(_image!.path),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _retakePhoto,
                      icon: const Icon(Icons.refresh),
                      label: const Text("Retake"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: _isProcessing ? null : _proceedToLocation,
                      icon: const Icon(Icons.check),
                      label: const Text("Continue"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                      ),
                    ),
                  ],
                ),

                // const SizedBox(height: 20),

                // Image info display
                // Container(
                //   padding: const EdgeInsets.all(12),
                //   decoration: BoxDecoration(
                //     color: Colors.grey[100],
                //     borderRadius: BorderRadius.circular(10),
                //   ),
                //   // child: Column(
                //   //   children: [
                //   //     Text(
                //   //       "Image captured successfully ✓",
                //   //       style: TextStyle(
                //   //         color: Colors.green[700],
                //   //         fontWeight: FontWeight.w500,
                //   //       ),
                //   //     ),
                //   //     const SizedBox(height: 5),
                //   //     Text(
                //   //       "File: ${_image!.name}",
                //   //       style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                //   //       textAlign: TextAlign.center,
                //   //     ),
                //   //     const SizedBox(height: 5),
                //   //     Text(
                //   //       "Key: $_generatedImageKey",
                //   //       style: TextStyle(
                //   //         fontSize: 10,
                //   //         color: Colors.blue[600],
                //   //         fontWeight: FontWeight.w500,
                //   //       ),
                //   //       textAlign: TextAlign.center,
                //   //     ),
                //   //     const SizedBox(height: 5),
                //   //     Text(
                //   //       "Ready for single upload",
                //   //       style: TextStyle(
                //   //         fontSize: 11,
                //   //         color: Colors.blue[600],
                //   //         fontWeight: FontWeight.w500,
                //   //       ),
                //   //     ),
                //   //   ],
                //   // ),
                // ),
              ],

              const SizedBox(height: 40),

              if (_image == null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue[700], size: 24),
                      const SizedBox(height: 8),
                      Text(
                        "Tips for best results:",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue[700]),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "• Ensure good lighting\n• Look directly at camera\n• Remove sunglasses/hat",
                        style: TextStyle(fontSize: 12, color: Colors.blue[600]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}



