import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:smart_attendance_project/core/constants/app_colors.dart';

import '../../../location/data/repositories/location_repository_impl.dart';
import '../../../location/domain/usecases/get_address_from_coordinates.dart';
import '../../../location/domain/usecases/get_current_location.dart';
import '../../../location/presentation/bloc/location_bloc.dart';
import '../../../location/presentation/bloc/location_event.dart';
import '../../../location/presentation/pages/location_screen.dart';

class FaceBiometric extends StatefulWidget {
  const FaceBiometric({super.key});

  @override
  State<FaceBiometric> createState() => _FaceBiometricState();
}

class _FaceBiometricState extends State<FaceBiometric> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  Future<void> _openCamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      setState(() {
        _image = photo;
      });
    }
  }

  void _sendImage() {
    if (_image != null) {
      // Send logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Image sent successfully!")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please take a photo first.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors().backgroundcolor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Round camera button
            GestureDetector(
              onTap: _openCamera,
              child: CircleAvatar(
                radius: 80,
                backgroundColor: Colors.blue.shade100,
                child: Icon(Icons.document_scanner, size: 40, color: Colors.blue),
              ),
            ),
            const SizedBox(height: 20),

            // Show preview (optional)
            if (_image != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(_image!.path),
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),

            const SizedBox(height: 30),
            // Show file path
            if (_image != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _image!.path,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),


            // Send Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BlocProvider(
                      create: (context) => LocationBloc(
                        getCurrentLocation: GetCurrentLocation(),
                        getAddressFromCoordinates: GetAddressFromCoordinates(),
                        locationRepo: LocationRepositoryImpl(),
                      )..add(LoadLocation()),
                      child: LocationScreen(imagePath: _image!.path),
                    ),
                  ),
                );

              },
              icon: const Icon(Icons.qr_code_scanner_sharp),
              label: const Text("Send"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            )

          ],
        ),
      ),
    );
  }
}

