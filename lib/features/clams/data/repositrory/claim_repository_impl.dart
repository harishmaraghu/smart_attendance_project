import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:smart_attendance_project/features/clams/data/models/claim_history_model.dart';
import 'claim_exceptions.dart';

class ClaimRepository {
  final Dio _dio = Dio();

  ClaimRepository() {
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 60);
    _dio.options.sendTimeout = const Duration(minutes: 2);

    _dio.interceptors.add(LogInterceptor(
      request: true,
      requestBody: true,
      requestHeader: true,
      responseBody: true,
      responseHeader: true,
      error: true,
    ));
  }

  String getFileSizeString(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  // Method 1: Send as JSON with base64 encoded attachment (FIXED)
  Future<Map<String, dynamic>> createClaimAsJson({
    required String claimGroup,
    required String claimName,
    required String receiptNo,
    required String receiptAmount,
    required String claimableAmount,
    required String userId,
    required String userName,
    File? attachment,
  }) async {
    try {
      final validationError = _validateClaimData(
        claimGroup: claimGroup,
        claimName: claimName,
        receiptNo: receiptNo,
        receiptAmount: receiptAmount,
        claimableAmount: claimableAmount,
        attachment: attachment,
        userId: userId,
        userName: userName,
      );

      if (validationError != null) {
        throw ClaimValidationException(validationError);
      }

      // Prepare JSON payload with correct data types matching backend expectations
      final Map<String, dynamic> payload = {
        "Userid": userId.trim(),
        "userName": userName.trim(),
        "ClaimGroupName": claimGroup.trim(),
        "ClaimName": claimName.trim(),
        "ReceiptNo": receiptNo.trim(),
        "ReceiptAmount": receiptAmount.trim(), // Keep as string as expected by backend
        "ClaimableAmount": int.parse(claimableAmount.trim()), // Convert to int as expected by backend
      };

      // Add base64 encoded attachment if present - THIS IS REQUIRED by backend
      if (attachment != null) {
        final bytes = await attachment.readAsBytes();
        final base64String = base64Encode(bytes);
        payload["Attachment"] = base64String;

        print("📎 Attachment size: ${getFileSizeString(bytes.length)}");
        print("📎 Base64 size: ${getFileSizeString(base64String.length)}");
      } else {
        // Backend requires attachment, so we'll add a dummy one for testing
        payload["Attachment"] = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mNkYPhfDwAChwGA60e6kgAAAABJRU5ErkJggg=="; // 1x1 transparent PNG
        print("⚠️ No attachment provided, using dummy attachment");
      }

      print("📤 Submitting Claim as JSON:");
      print("Payload keys: ${payload.keys.toList()}");
      print("ClaimableAmount type: ${payload['ClaimableAmount'].runtimeType}");
      print("Full payload (without attachment): ${payload.keys.map((k) => k == 'Attachment' ? '$k: [base64 data]' : '$k: ${payload[k]}').join(', ')}");

      final response = await _dio.post(
        "https://645aib996k.execute-api.ap-south-1.amazonaws.com/default/Claimsapply",
        data: payload, // Send as Map, let Dio handle JSON encoding
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          sendTimeout: const Duration(minutes: 3),
          validateStatus: (status) => status != null,
        ),
      );

      return _handleResponse(response);
    } on ClaimValidationException {
      rethrow;
    } on FormatException catch (e) {
      print("🚨 Format Exception (likely ClaimableAmount parsing): $e");
      throw ClaimSubmissionException("Invalid claimable amount format. Please enter a valid number.");
    } on DioException catch (e) {
      print("🚨 DioException: ${e.toString()}");
      print("🚨 Error type: ${e.type}");
      if (e.response != null) {
        print("🚨 Response status: ${e.response!.statusCode}");
        print("🚨 Response data: ${e.response!.data}");
        print("🚨 Response headers: ${e.response!.headers}");
      }
      throw ClaimSubmissionException(_handleDioError(e));
    } catch (e) {
      print("🚨 Unexpected error: $e");
      throw ClaimSubmissionException(
          "An unexpected error occurred: ${e.toString()}");
    }
  }

  // Method 2: Test with minimal payload to isolate the issue
  Future<Map<String, dynamic>> testMinimalRequest({
    required String userId,
    required String userName,
  }) async {
    try {
      final payload = {
        "Userid": userId.trim(),
        "userName": userName.trim(),
        "ClaimGroupName": "Test Group",
        "ClaimName": "Test Claim",
        "ReceiptNo": "TEST001",
        "ReceiptAmount": "100.00",
        "ClaimableAmount": 50,
        "Attachment": "dGVzdA==" // base64 encoded "test"
      };

      print("🧪 Testing minimal request:");
      print("Payload: ${jsonEncode(payload)}");

      final response = await _dio.post(
        "https://645aib996k.execute-api.ap-south-1.amazonaws.com/default/Claimsapply",
        data: payload,
        options: Options(
          contentType: 'application/json',
          headers: {
            'Accept': 'application/json',
            'Content-Type': 'application/json',
          },
          validateStatus: (status) => status != null,
        ),
      );

      return _handleResponse(response);
    } catch (e) {
      print("🧪 Minimal test failed: $e");
      rethrow;
    }
  }

  // Method 3: Test different HTTP methods
  Future<Map<String, dynamic>> testWithGet() async {
    try {
      print("🧪 Testing GET request to check if endpoint is alive:");

      final response = await _dio.get(
        "https://645aib996k.execute-api.ap-south-1.amazonaws.com/default/Claimsapply",
        options: Options(
          validateStatus: (status) => status != null,
        ),
      );

      print("GET Response: ${response.statusCode} - ${response.data}");
      return _handleResponse(response);
    } catch (e) {
      print("🧪 GET test result: $e");
      rethrow;
    }
  }

  // Method 4: Improved multipart with proper headers and debugging
  Future<Map<String, dynamic>> createClaimWithMultipart({
    required String claimGroup,
    required String claimName,
    required String receiptNo,
    required String receiptAmount,
    required String claimableAmount,
    required String userId,
    required String userName,
    File? attachment,
  }) async {
    try {
      final validationError = _validateClaimData(
        claimGroup: claimGroup,
        claimName: claimName,
        receiptNo: receiptNo,
        receiptAmount: receiptAmount,
        claimableAmount: claimableAmount,
        attachment: attachment,
        userId: userId,
        userName: userName,
      );

      if (validationError != null) {
        throw ClaimValidationException(validationError);
      }

      // Create FormData with proper field mapping
      final formData = FormData();

      // Add text fields
      formData.fields.addAll([
        MapEntry("Userid", userId.trim()),
        MapEntry("userName", userName.trim()),
        MapEntry("ClaimGroupName", claimGroup.trim()),
        MapEntry("ClaimName", claimName.trim()),
        MapEntry("ReceiptNo", receiptNo.trim()),
        MapEntry("ReceiptAmount", receiptAmount.trim()),
        MapEntry("ClaimableAmount", claimableAmount.trim()),
      ]);

      // Add file if present
      if (attachment != null) {
        final fileName = attachment.path.split("/").last;
        String? contentType = _getContentType(fileName);

        formData.files.add(MapEntry(
          "Attachment",
          await MultipartFile.fromFile(
            attachment.path,
            filename: fileName,
            contentType: contentType != null
                ? DioMediaType.parse(contentType)
                : null,
          ),
        ));
      }

      print("📤 Submitting Claim as Multipart:");
      formData.fields.forEach((field) {
        print("  ${field.key}: ${field.value}");
      });
      if (formData.files.isNotEmpty) {
        for (var fileEntry in formData.files) {
          final file = fileEntry.value;
          print("  ${fileEntry.key}: MultipartFile(${file.filename}, ${file.contentType})");
        }
      }

      final response = await _dio.post(
        "https://645aib996k.execute-api.ap-south-1.amazonaws.com/default/Claimsapply",
        data: formData,
        options: Options(
          contentType: 'multipart/form-data',
          sendTimeout: const Duration(minutes: 3),
          validateStatus: (status) => status != null,
        ),
      );

      return _handleResponse(response);
    } on ClaimValidationException {
      rethrow;
    } on DioException catch (e) {
      print("🚨 DioException: ${e.toString()}");
      throw ClaimSubmissionException(_handleDioError(e));
    } catch (e) {
      print("🚨 Unexpected error: $e");
      throw ClaimSubmissionException(
          "An unexpected error occurred: ${e.toString()}");
    }
  }

  // Helper method to determine content type
  String? _getContentType(String fileName) {
    final extension = fileName.toLowerCase().split('.').last;
    switch (extension) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'pdf':
        return 'application/pdf';
      case 'doc':
        return 'application/msword';
      case 'docx':
        return 'application/vnd.openxmlformats-officedocument.wordprocessingml.document';
      default:
        return null;
    }
  }

  String? _validateClaimData({
    required String claimGroup,
    required String claimName,
    required String receiptNo,
    required String receiptAmount,
    required String claimableAmount,
    required String userId,
    required String userName,
    File? attachment,
  }) {
    // Check required fields
    if (claimGroup.trim().isEmpty) return "Please select a claim group";
    if (claimName.trim().isEmpty) return "Please enter a claim name";
    if (receiptNo.trim().isEmpty) return "Please enter a receipt number";
    if (receiptAmount.trim().isEmpty) return "Please enter the receipt amount";
    if (claimableAmount.trim().isEmpty) return "Please enter the claimable amount";
    if (userId.trim().isEmpty) return "User ID is required";
    if (userName.trim().isEmpty) return "User name is required";

    // Validate numeric fields
    final receiptAmountNum = double.tryParse(receiptAmount.trim());
    if (receiptAmountNum == null || receiptAmountNum <= 0) {
      return "Receipt amount must be a valid positive number";
    }

    final claimableAmountNum = double.tryParse(claimableAmount.trim());
    if (claimableAmountNum == null || claimableAmountNum <= 0) {
      return "Claimable amount must be a valid positive number";
    }

    // Check if claimable amount doesn't exceed receipt amount
    if (claimableAmountNum > receiptAmountNum) {
      return "Claimable amount cannot exceed receipt amount";
    }

    return null;
  }

  Map<String, dynamic> _handleResponse(Response response) {
    print("✅ API Response: ${response.statusCode}");
    print("Response data: ${response.data}");
    print("Response headers: ${response.headers}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      return {
        'success': true,
        'message': 'Claim submitted successfully',
        'data': response.data,
      };
    } else if (response.statusCode == 500) {
      final errorMessage = _extractErrorMessage(response);
      print("🚨 Server Error 500: $errorMessage");

      // More specific error handling for JSON parsing issues
      if (errorMessage != null) {
        if (errorMessage.contains("Expecting value: line 1 column 1") ||
            errorMessage.contains("JSON") ||
            errorMessage.contains("parsing")) {
          throw ClaimSubmissionException(
              "Data format error: The server couldn't process the request data. "
                  "This might be due to missing required fields or incorrect data format."
          );
        }
        if (errorMessage.contains("base64")) {
          throw ClaimSubmissionException(
              "File upload error: There was an issue processing the attached file. "
                  "Please try with a different file or contact support."
          );
        }
      }

      throw ClaimSubmissionException(
          "Server Error: ${errorMessage ?? 'Unknown server error'}");
    } else {
      final errorMessage = _extractErrorMessage(response);
      throw ClaimSubmissionException(
          "Server Error (${response.statusCode}): $errorMessage");
    }
  }

  String _handleDioError(DioException e) {
    print("🚨 Dio Error: ${e.type} - ${e.message}");
    print("🚨 Response: ${e.response?.data}");
    print("🚨 Response Headers: ${e.response?.headers}");

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        return "Connection timeout. Please check your internet connection and try again.";
      case DioExceptionType.sendTimeout:
        return "Upload timeout. Please try with a smaller file or check your connection.";
      case DioExceptionType.receiveTimeout:
        return "Server response timeout. Please try again in a moment.";
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 500) {
          final errorMsg = _extractErrorMessage(e.response);
          if (errorMsg != null && (
              errorMsg.contains("Expecting value: line 1 column 1") ||
                  errorMsg.contains("JSON") ||
                  errorMsg.contains("parsing"))) {
            return "Data format error: Please check all required fields are filled correctly.";
          }
          return "Internal server error: ${errorMsg ?? 'Unknown error'}";
        }
        return _extractErrorMessage(e.response) ??
            "Server returned an error (${e.response?.statusCode})";
      case DioExceptionType.cancel:
        return "Request was cancelled";
      case DioExceptionType.connectionError:
        return "No internet connection. Please check your network and try again.";
      default:
        return "Network error occurred. Please check your connection and try again.";
    }
  }

  String? _extractErrorMessage(Response? response) {
    if (response?.data == null) return null;

    try {
      final data = response!.data;
      if (data is Map<String, dynamic>) {
        return data['message'] ??
            data['error'] ??
            data['details'] ??
            data['body'] ??
            "HTTP ${response.statusCode}";
      } else if (data is String) {
        // Handle cases where the error message is wrapped in quotes
        if (data.startsWith('"') && data.endsWith('"') && data.length > 2) {
          return data.substring(1, data.length - 1);
        }
        return data;
      }
    } catch (e) {
      print("Error parsing response: $e");
    }

    return "HTTP ${response?.statusCode} ${response?.statusMessage}";
  }

  bool isValidFileType(File file) {
    final extension = file.path.toLowerCase().split('.').last;
    const allowedExtensions = [
      'jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'heic',
      'pdf', 'doc', 'docx', 'txt', 'rtf',
      'xls', 'xlsx', 'csv',
    ];
    return allowedExtensions.contains(extension);
  }

  // Enhanced debugging method
  Future<void> debugApiEndpoint() async {
    print("🔍 Starting comprehensive API debugging...");

    // Test 1: Check if endpoint is reachable with GET
    try {
      print("\n🧪 Test 1: Testing GET request...");
      await testWithGet();
    } catch (e) {
      print("❌ GET test failed: $e");
    }

    // Test 2: Minimal POST with required fields only
    try {
      print("\n🧪 Test 2: Testing minimal POST with required fields...");
      await testMinimalRequest(userId: "TEST001", userName: "Test User");
    } catch (e) {
      print("❌ Minimal POST failed: $e");
    }

    // Test 3: Empty POST to see what error we get
    try {
      print("\n🧪 Test 3: Testing empty POST...");
      final response = await _dio.post(
        "https://645aib996k.execute-api.ap-south-1.amazonaws.com/default/Claimsapply",
        data: {},
        options: Options(
          contentType: 'application/json',
          validateStatus: (status) => status != null,
        ),
      );
      print("Empty POST response: ${response.statusCode} - ${response.data}");
    } catch (e) {
      print("❌ Empty POST failed: $e");
    }

    // Test 4: Raw string POST
    try {
      print("\n🧪 Test 4: Testing raw string POST...");
      final response = await _dio.post(
        "https://645aib996k.execute-api.ap-south-1.amazonaws.com/default/Claimsapply",
        data: '{"Userid":"TEST","userName":"Test"}',
        options: Options(
          contentType: 'application/json',
          validateStatus: (status) => status != null,
        ),
      );
      print("Raw string POST response: ${response.statusCode} - ${response.data}");
    } catch (e) {
      print("❌ Raw string POST failed: $e");
    }

    print("\n🔍 Debugging complete. Check the logs above for insights.");
  }
}




//hostory

// claim_history_repository.dart
class ClaimHistoryRepository {
  final Dio dio;

  ClaimHistoryRepository(this.dio);

  Future<List<ClaimHistoryModel>> getClaimHistory(String userId) async {
    final response = await dio.post(
      'https://qdt85bl4n9.execute-api.ap-south-1.amazonaws.com/default/Claimsuser',
      data: {'Userid': userId},
    );

    final List data = response.data;
    return data.map((json) => ClaimHistoryModel.fromJson(json)).toList();
  }
}
