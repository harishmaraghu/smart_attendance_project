import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/shared_prefsHelper.dart';
import '../../data/models/checkin_request_model.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/usecases/get_address_from_coordinates.dart';
import '../../domain/usecases/get_current_location.dart';
import 'location_event.dart';
import 'location_state.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final GetAddressFromCoordinates getAddressFromCoordinates;
  final LocationRepositoryImpl locationRepo;

  final Duration locationTimeout = const Duration(seconds: 30); // Increased timeout

  // Store the image path for dynamic usage
  String? _imagePath;

  LocationBloc({
    required this.getCurrentLocation,
    required this.getAddressFromCoordinates,
    required this.locationRepo,
    String? imagePath, // Add imagePath parameter
  }) : super(LocationState()) {
    _imagePath = imagePath; // Initialize with provided image path
    on<LoadLocation>(_onLoadLocation);
    on<CheckInPressed>(_onCheckIn);
    on<CheckOutPressed>(_onCheckOut);
    on<UpdateImagePath>(_onUpdateImagePath); // Add new event handler
  }

  // Method to update image path dynamically
  void _onUpdateImagePath(UpdateImagePath event, Emitter<LocationState> emit) {
    _imagePath = event.imagePath;
  }





  Future<void> _onLoadLocation(LoadLocation event, Emitter<LocationState> emit) async {
    try {
      // First emit a loading state
      emit(state.copyWith(error: null)); // Clear any previous errors

      final position = await getCurrentLocation().timeout(locationTimeout);

      // After getting position, fetch address
      String? address;
      try {
        address = await getAddressFromCoordinates(position.latitude, position.longitude)
            .timeout(const Duration(seconds: 10));
      } catch (e) {
        print("⚠️ Address lookup failed: $e");
        address = "Address lookup failed";
      }

      final checkInTime = await locationRepo.getCheckInTime();

      emit(state.copyWith(
        latitude: position.latitude,
        longitude: position.longitude,
        address: address,
        checkInTime: checkInTime,
        checkOutTime: null,
      ));
    } catch (e) {
      print("❌ Location Error: $e");
      emit(state.copyWith(
          error: "Location permission denied or unavailable. Please check your device settings."
      ));
    }
  }



  String _generateImageKey(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      // Fallback to timestamp-based key if no image path
      return "attendance_${DateTime.now().millisecondsSinceEpoch}.jpg";
    }

    // Extract filename from path
    final fileName = imagePath.split('/').last;
    final now = DateTime.now();

    // Create a more descriptive key with timestamp
    return "attendance_${now.millisecondsSinceEpoch}_$fileName";
  }


  // Helper method to convert local file path to uploadable format
  String _processImagePath(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return "no_image_captured";
    }

    // You can implement additional processing here:
    // - Convert to base64 if needed
    // - Upload to cloud storage and return URL
    // - Process the image (resize, compress, etc.)

    return imagePath; // Return the path as-is for now
  }

  //CHECK IN CHECK OUT
  Future<void> sendCheckEvent({
    required String timeType,
    required Emitter<LocationState> emit,
  }) async {
    final now = DateTime.now();
    // Get user name from SharedPreferences
    final userName = await SharedPrefsHelper.getUsername();

    try {
      // Ensure we have location data
      if (state.latitude == null || state.longitude == null) {
        print("❌ No location data available for $timeType");
        return;
      }

      if (timeType == "inTime") {
        await locationRepo.saveCheckInTime(now);
      } else {
        await locationRepo.removeCheckInTime();
      }

      final dynamicImageKey = _generateImageKey(_imagePath);
      final processedImagePath = _processImagePath(_imagePath);

      final checkData = CheckInRequestModel(
        name: userName,
        date: now.toIso8601String().split("T")[0],
        time: "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        timeType: timeType,
        imageKey: dynamicImageKey, // More dynamic placeholder
        latitude: state.latitude!,
        longitude: state.longitude!,
      );

      // Log request payload
      print("📤 Sending $timeType data: ${checkData.toJson()}");
      print("Name: ${checkData.name}");
      print("Date: ${checkData.date}");
      print("Time: ${checkData.time}");
      print("Time Type: ${checkData.timeType}");
      print("Image Key: ${checkData.imageKey}");
      print("Image Path: $processedImagePath");
      print("Latitude: ${checkData.latitude}");
      print("Longitude: ${checkData.longitude}");

      await locationRepo.checkInToServer(checkData)
          .timeout(const Duration(seconds: 15));

      print("✅ $timeType API success");

      emit(state.copyWith(
        checkInTime: timeType == "inTime" ? now : null,
        checkOutTime: timeType == "outTime" ? now : null,
      ));
    } catch (e) {
      print("❌ Error in $timeType: $e");
      // You might want to show an error message to the user here
    }
  }

  Future<void> _onCheckIn(CheckInPressed event, Emitter<LocationState> emit) async {
    await sendCheckEvent(timeType: "inTime", emit: emit);
  }

  Future<void> _onCheckOut(CheckOutPressed event, Emitter<LocationState> emit) async {
    await sendCheckEvent(timeType: "outTime", emit: emit);
  }
}