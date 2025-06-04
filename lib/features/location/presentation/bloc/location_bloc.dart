// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../../../core/constants/shared_prefsHelper.dart';
// import '../../data/models/checkin_request_model.dart';
// import '../../data/repositories/location_repository_impl.dart';
// import '../../domain/usecases/get_address_from_coordinates.dart';
// import '../../domain/usecases/get_current_location.dart';
// import 'location_event.dart';
// import 'location_state.dart';
//
// class LocationBloc extends Bloc<LocationEvent, LocationState> {
//   final GetCurrentLocation getCurrentLocation;
//   final GetAddressFromCoordinates getAddressFromCoordinates;
//   final LocationRepositoryImpl locationRepo;
//
//   final Duration locationTimeout = const Duration(seconds: 30); // Increased timeout
//
//   // Store the image path for dynamic usage
//   String? _imagePath;
//
//   LocationBloc({
//     required this.getCurrentLocation,
//     required this.getAddressFromCoordinates,
//     required this.locationRepo,
//     String? imagePath, // Add imagePath parameter
//   }) : super(LocationState()) {
//     _imagePath = imagePath; // Initialize with provided image path
//     on<LoadLocation>(_onLoadLocation);
//     on<CheckInPressed>(_onCheckIn);
//     on<CheckOutPressed>(_onCheckOut);
//    ; // Add new event handler
//   }
//
//
//
//
//
//
//
//   Future<void> _onLoadLocation(LoadLocation event, Emitter<LocationState> emit) async {
//     try {
//       // First emit a loading state
//       emit(state.copyWith(error: null)); // Clear any previous errors
//
//       final position = await getCurrentLocation().timeout(locationTimeout);
//
//       // After getting position, fetch address
//       String? address;
//       try {
//         address = await getAddressFromCoordinates(position.latitude, position.longitude)
//             .timeout(const Duration(seconds: 10));
//       } catch (e) {
//         print("⚠️ Address lookup failed: $e");
//         address = "Address lookup failed";
//       }
//
//       final checkInTime = await locationRepo.getCheckInTime();
//
//       emit(state.copyWith(
//         latitude: position.latitude,
//         longitude: position.longitude,
//         address: address,
//         checkInTime: checkInTime,
//         checkOutTime: null,
//       ));
//     } catch (e) {
//       print("❌ Location Error: $e");
//       emit(state.copyWith(
//           error: "Location permission denied or unavailable. Please check your device settings."
//       ));
//     }
//   }
//
//
//
//   String _generateImageKey(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) {
//       // Fallback to timestamp-based key if no image path
//       return "attendance_${DateTime.now().millisecondsSinceEpoch}.jpg";
//     }
//
//     // Extract filename from path
//     final fileName = imagePath.split('/').last;
//     final now = DateTime.now();
//
//     // Create a more descriptive key with timestamp
//     return "attendance_${now.millisecondsSinceEpoch}_$fileName";
//   }
//
//
//   // Helper method to convert local file path to uploadable format
//   String _processImagePath(String? imagePath) {
//     if (imagePath == null || imagePath.isEmpty) {
//       return "no_image_captured";
//     }
//
//     // You can implement additional processing here:
//     // - Convert to base64 if needed
//     // - Upload to cloud storage and return URL
//     // - Process the image (resize, compress, etc.)
//
//     return imagePath; // Return the path as-is for now
//   }
//
//   //CHECK IN CHECK OUT
//   Future<void> sendCheckEvent({
//     required String timeType,
//     required Emitter<LocationState> emit,
//   }) async {
//     final now = DateTime.now();
//     // Get user name from SharedPreferences
//     final userName = await SharedPrefsHelper.getUsername();
//
//     try {
//       // Ensure we have location data
//       if (state.latitude == null || state.longitude == null) {
//         print("❌ No location data available for $timeType");
//         return;
//       }
//
//       if (timeType == "inTime") {
//         await locationRepo.saveCheckInTime(now);
//       } else {
//         await locationRepo.removeCheckInTime();
//       }
//
//       final dynamicImageKey = _generateImageKey(_imagePath);
//       final processedImagePath = _processImagePath(_imagePath);
//
//       final checkData = CheckInRequestModel(
//         name: userName,
//         date: now.toIso8601String().split("T")[0],
//         time: "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
//         timeType: timeType,
//         imageKey: dynamicImageKey, // More dynamic placeholder
//         latitude: state.latitude!,
//         longitude: state.longitude!,
//       );
//
//       // Log request payload
//       print("📤 Sending $timeType data: ${checkData.toJson()}");
//       print("Name: ${checkData.name}");
//       print("Date: ${checkData.date}");
//       print("Time: ${checkData.time}");
//       print("Time Type: ${checkData.timeType}");
//       print("Image Key: ${checkData.imageKey}");
//       print("Image Path: $processedImagePath");
//       print("Latitude: ${checkData.latitude}");
//       print("Longitude: ${checkData.longitude}");
//
//       await locationRepo.checkInToServer(checkData)
//           .timeout(const Duration(seconds: 15));
//
//       print("✅ $timeType API success");
//
//       emit(state.copyWith(
//         checkInTime: timeType == "inTime" ? now : null,
//         checkOutTime: timeType == "outTime" ? now : null,
//       ));
//     } catch (e) {
//       print("❌ Error in $timeType: $e");
//       // You might want to show an error message to the user here
//     }
//   }
//
//   Future<void> _onCheckIn(CheckInPressed event, Emitter<LocationState> emit) async {
//     await sendCheckEvent(timeType: "inTime", emit: emit);
//   }
//
//   Future<void> _onCheckOut(CheckOutPressed event, Emitter<LocationState> emit) async {
//     await sendCheckEvent(timeType: "outTime", emit: emit);
//   }
// }

import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as path;
import '../../../../core/constants/shared_prefsHelper.dart';
import '../../../../services/s3_upload_service.dart';
import '../../data/models/checkin_request_model.dart';
import '../../data/repositories/location_repository_impl.dart';
import '../../domain/usecases/get_address_from_coordinates.dart';
import '../../domain/usecases/get_current_location.dart';
import 'location_event.dart';
import 'location_state.dart';
import 'package:uuid/uuid.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  final GetCurrentLocation getCurrentLocation;
  final GetAddressFromCoordinates getAddressFromCoordinates;
  final LocationRepositoryImpl locationRepo;
  final Duration locationTimeout = const Duration(seconds: 30);

  // Core image data - SINGLE SOURCE OF TRUTH
  final String? _imagePath;
  final String? _consistentImageKey; // Received from FaceBiometric

  // Upload tracking
  String? _uploadedImageUrl;
  String? _s3Key;
  bool _uploadInProgress = false;
  bool _uploadCompleted = false;
  int _uploadRetryCount = 0;
  static const int _maxUploadRetries = 3;

  LocationBloc({
    required this.getCurrentLocation,
    required this.getAddressFromCoordinates,
    required this.locationRepo,
    String? imagePath,
    String? imageKey,
  }) : _imagePath = imagePath,
        _consistentImageKey = imageKey,
        super(LocationState()) {

    print('🏗️ LocationBloc initialized with SINGLE UPLOAD strategy:');
    print('├─ Image Path: $_imagePath');
    print('├─ Consistent Key: $_consistentImageKey');
    print('├─ Upload Status: Not started');
    print('└─ Strategy: One key, one upload, no duplicates');

    on<LoadLocation>(_onLoadLocation);
    on<CheckInPressed>(_onCheckIn);
    on<CheckOutPressed>(_onCheckOut);
    on<UploadImageToS3>(_onUploadImageToS3);
    on<RetryImageUpload>(_onRetryImageUpload);
  }

  // ============================================================================
  // SINGLE UPLOAD IMPLEMENTATION - NO DUPLICATES
  // ============================================================================

  Future<void> _onUploadImageToS3(UploadImageToS3 event, Emitter<LocationState> emit) async {
    // GUARD: Prevent multiple simultaneous uploads
    if (_uploadInProgress || _uploadCompleted) {
      print('🚫 Upload already in progress or completed, skipping...');
      print('├─ In Progress: $_uploadInProgress');
      print('├─ Completed: $_uploadCompleted');
      print('└─ Uploaded URL: $_uploadedImageUrl');
      return;
    }

    // GUARD: Validate required data
    if (_imagePath == null || _consistentImageKey == null) {
      final error = 'Missing required upload data: path=${_imagePath != null}, key=${_consistentImageKey != null}';
      print('❌ $error');
      emit(state.copyWith(error: error, isUploadingImage: false));
      return;
    }

    // GUARD: Check retry limit
    if (_uploadRetryCount >= _maxUploadRetries) {
      final error = 'Maximum upload retries reached ($_uploadRetryCount/$_maxUploadRetries)';
      print('❌ $error');
      emit(state.copyWith(error: error, isUploadingImage: false));
      return;
    }

    _uploadInProgress = true;
    _uploadRetryCount++;

    try {
      emit(state.copyWith(isUploadingImage: true, error: null));

      final userName = await SharedPrefsHelper.getUsername();
      final userId = userName ?? 'unknown_user';

      print('📤 SINGLE UPLOAD ATTEMPT #$_uploadRetryCount:');
      print('├─ Image Path: $_imagePath');
      print('├─ Consistent Key: $_consistentImageKey');
      print('├─ User ID: $userId');
      print('├─ Max Retries: $_maxUploadRetries');
      print('└─ Upload Strategy: SINGLE UPLOAD ONLY');

      // Validate file before upload
      if (!await S3UploadService.validateImageFile(_imagePath!)) {
        throw Exception('Image file validation failed');
      }

      // CRITICAL: Use the consistent key from FaceBiometric
      final uploadedUrl = await S3UploadService.uploadImageWithRetry(
        imagePath: _imagePath!,
        userId: userId,
        originalImageKey: _consistentImageKey!, // Use EXACT key from FaceBiometric
        maxRetries: 1, // Handle retries at this level
      );

      if (uploadedUrl != null && uploadedUrl.isNotEmpty) {
        // SUCCESS: Mark as completed
        _uploadedImageUrl = uploadedUrl;
        _s3Key = _extractS3KeyFromUrl(uploadedUrl) ?? 'attendance-images/$_consistentImageKey';
        _uploadCompleted = true;
        _uploadRetryCount = 0; // Reset on success

        print('✅ SINGLE UPLOAD SUCCESS:');
        print('├─ Upload URL: $uploadedUrl');
        print('├─ S3 Key: $_s3Key');
        print('├─ Consistent Key: $_consistentImageKey');
        print('├─ Upload Completed: $_uploadCompleted');
        print('└─ STATUS: SUCCESS - No duplicates created');

        emit(state.copyWith(
          isUploadingImage: false,
          uploadedImageUrl: uploadedUrl,
          s3Key: _s3Key,
          error: null,
        ));
      } else {
        throw Exception('S3 upload returned null or empty URL');
      }

    } catch (e) {
      print('❌ Upload attempt #$_uploadRetryCount failed: $e');

      // Schedule retry if within limits
      if (_uploadRetryCount < _maxUploadRetries) {
        final delaySeconds = pow(2, _uploadRetryCount - 1).toInt(); // Exponential backoff
        print('⏳ Scheduling retry #${_uploadRetryCount + 1} in ${delaySeconds}s...');

        emit(state.copyWith(
          isUploadingImage: false,
          error: 'Upload failed, retrying in ${delaySeconds}s... ($_uploadRetryCount/$_maxUploadRetries)',
        ));

        Future.delayed(Duration(seconds: delaySeconds), () {
          if (!isClosed && !_uploadCompleted) {
            add(RetryImageUpload());
          }
        });
      } else {
        emit(state.copyWith(
          isUploadingImage: false,
          error: 'Upload failed after $_maxUploadRetries attempts: ${e.toString()}',
        ));
      }
    } finally {
      _uploadInProgress = false;
    }
  }

  void _onRetryImageUpload(RetryImageUpload event, Emitter<LocationState> emit) {
    if (!_uploadCompleted && _uploadRetryCount < _maxUploadRetries) {
      print('🔄 Retrying upload (${_uploadRetryCount + 1}/$_maxUploadRetries)...');
      add(UploadImageToS3());
    }
  }

  String? _extractS3KeyFromUrl(String url) {
    try {
      final uri = Uri.parse(url);
      if (uri.host.contains('amazonaws.com')) {
        String path = uri.path;
        if (path.startsWith('/')) path = path.substring(1);
        return path.isNotEmpty ? path : 'attendance-images/$_consistentImageKey';
      }
      return 'attendance-images/$_consistentImageKey';
    } catch (e) {
      print('⚠️ Failed to extract S3 key, using consistent key: $e');
      return 'attendance-images/$_consistentImageKey';
    }
  }

  // ============================================================================
  // LOCATION AND CHECK-IN/OUT HANDLING
  // ============================================================================

  Future<void> _onLoadLocation(LoadLocation event, Emitter<LocationState> emit) async {
    try {
      emit(state.copyWith(error: null));

      print('🌍 Loading location...');
      final position = await getCurrentLocation().timeout(locationTimeout);
      print('✅ Location: ${position.latitude}, ${position.longitude}');

      String? address;
      try {
        address = await getAddressFromCoordinates(position.latitude, position.longitude)
            .timeout(const Duration(seconds: 10));
        print('✅ Address: $address');
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
      ));

      // AUTO-UPLOAD: Start upload if not already completed
      if (_imagePath != null && !_uploadCompleted && !_uploadInProgress) {
        print('🔄 Starting auto-upload with consistent key...');
        add(UploadImageToS3());
      } else if (_uploadCompleted) {
        print('✅ Upload already completed, skipping auto-upload');
      }

    } catch (e) {
      print("❌ Location Error: $e");
      emit(state.copyWith(
          error: "Location permission denied or unavailable. Please check settings."
      ));
    }
  }

  Future<void> _sendCheckEvent({
    required String timeType,
    required Emitter<LocationState> emit,
  }) async {
    final now = DateTime.now();
    final userName = await SharedPrefsHelper.getUsername();

    try {
      if (state.latitude == null || state.longitude == null) {
        emit(state.copyWith(error: 'Location data not available'));
        return;
      }

      print('📤 Starting $timeType process...');

      // ENSURE UPLOAD COMPLETION: Wait for upload if in progress
      if (_imagePath != null && !_uploadCompleted) {
        if (!_uploadInProgress) {
          print("📤 Starting upload before $timeType...");
          add(UploadImageToS3());
        }

        // Wait for upload completion with timeout
        int waitAttempts = 0;
        const maxWaitAttempts = 15; // 15 seconds max wait

        while (!_uploadCompleted && waitAttempts < maxWaitAttempts) {
          await Future.delayed(const Duration(seconds: 1));
          waitAttempts++;

          if (state.error?.contains('upload') == true) {
            print("⚠️ Upload failed, proceeding with local path");
            break;
          }
        }

        if (!_uploadCompleted && waitAttempts >= maxWaitAttempts) {
          print("⚠️ Upload timeout, proceeding without S3 URL");
        }
      }

      // Update local time storage
      if (timeType == "inTime") {
        await locationRepo.saveCheckInTime(now);
      } else {
        await locationRepo.removeCheckInTime();
      }

      // Create check-in request with consistent data
      final checkData = CheckInRequestModel(
        name: userName,
        date: now.toIso8601String().split("T")[0],
        time: "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}",
        timeType: timeType,
        imageKey: _consistentImageKey ?? 'no_key_generated', // Use consistent key
        imageUrl: _uploadedImageUrl, // S3 URL if uploaded
        latitude: state.latitude!,
        longitude: state.longitude!,
      );

      print("📤 Sending $timeType with CONSISTENT data:");
      print("├─ Name: ${checkData.name}");
      print("├─ Time Type: ${checkData.timeType}");
      print("├─ Consistent Image Key: ${checkData.imageKey}");
      print("├─ S3 Upload URL: ${_uploadedImageUrl ?? 'Not uploaded'}");
      print("├─ Upload Status: ${_uploadCompleted ? 'COMPLETED' : 'PENDING/FAILED'}");
      print("├─ Retry Count: $_uploadRetryCount");
      print("└─ STRATEGY: Single upload, consistent naming");

      await locationRepo.checkInToServer(checkData).timeout(const Duration(seconds: 20));

      print("✅ $timeType API call successful");

      emit(state.copyWith(
        checkInTime: timeType == "inTime" ? now : null,
        checkOutTime: timeType == "outTime" ? now : null,
        error: null,
        isUploadingImage: false,
      ));

    } catch (e) {
      print("❌ $timeType error: $e");
      emit(state.copyWith(
        error: "Failed to $timeType: ${e.toString()}",
        isUploadingImage: false,
      ));
    }
  }

  Future<void> _onCheckIn(CheckInPressed event, Emitter<LocationState> emit) async {
    await _sendCheckEvent(timeType: "inTime", emit: emit);
  }

  Future<void> _onCheckOut(CheckOutPressed event, Emitter<LocationState> emit) async {
    await _sendCheckEvent(timeType: "outTime", emit: emit);
  }

  // ============================================================================
  // STATUS AND UTILITY METHODS
  // ============================================================================

  /// Get comprehensive upload status
  Map<String, dynamic> getUploadStatus() {
    return {
      'strategy': 'Single Upload with Consistent Key',
      'hasImagePath': _imagePath != null,
      'hasConsistentKey': _consistentImageKey != null,
      'uploadInProgress': _uploadInProgress,
      'uploadCompleted': _uploadCompleted,
      'uploadedUrl': _uploadedImageUrl,
      's3Key': _s3Key,
      'consistentImageKey': _consistentImageKey,
      'imagePath': _imagePath,
      'retryCount': _uploadRetryCount,
      'maxRetries': _maxUploadRetries,
      'canRetry': _uploadRetryCount < _maxUploadRetries && !_uploadCompleted,
      'status': _uploadCompleted ? 'SUCCESS' :
      _uploadInProgress ? 'IN_PROGRESS' :
      _uploadRetryCount > 0 ? 'RETRYING' : 'NOT_STARTED',
      'duplicatePrevention': 'Guaranteed - Single key, single upload',
    };
  }

  /// Check if image is successfully uploaded
  bool get isImageUploaded => _uploadCompleted && _uploadedImageUrl != null;

  /// Get the consistent image key used throughout the process
  String? get consistentImageKey => _consistentImageKey;

  /// Get upload progress description
  String get uploadProgressDescription {
    if (_uploadCompleted) return 'Upload completed successfully';
    if (_uploadInProgress) return 'Upload in progress...';
    if (_uploadRetryCount > 0) return 'Retrying upload ($_uploadRetryCount/$_maxUploadRetries)';
    return 'Upload not started';
  }

  /// Manual retry trigger
  void retryUpload() {
    if (!_uploadCompleted && _uploadRetryCount < _maxUploadRetries) {
      add(RetryImageUpload());
    }
  }

  @override
  Future<void> close() {
    print('🔄 LocationBloc closing - Upload status: ${_uploadCompleted ? "COMPLETED" : "INCOMPLETE"}');
    return super.close();
  }
}