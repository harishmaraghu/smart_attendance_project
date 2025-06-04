import 'dart:io';
import 'dart:typed_data';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:path/path.dart' as path;
import 'package:crypto/crypto.dart';

class S3UploadService {
  static const String _attendanceFolder = 'attendance-images';

  /// Upload image to S3 with consistent naming that matches API expectations
  static Future<String?> uploadImage({
    required String imagePath,
    required String userId,
    String? customFileName,
    String? originalImageKey, // Add this parameter to maintain consistency
  }) async {
    try {
      // Validate file existence first
      final file = File(imagePath);
      if (!await file.exists()) {
        print('❌ File does not exist at path: $imagePath');
        // Try to find the file with corrected path (common issue with extra 'a' in filename)
        final correctedPath = _tryCorrectFilePath(imagePath);
        if (correctedPath != null && await File(correctedPath).exists()) {
          print('✅ Found file at corrected path: $correctedPath');
          return await _performUpload(correctedPath, userId, customFileName, originalImageKey);
        }
        throw Exception('Image file does not exist: $imagePath');
      }

      return await _performUpload(imagePath, userId, customFileName, originalImageKey);
    } catch (e) {
      print('❌ S3 upload failed: $e');
      if (e is StorageException) {
        print('Storage exception details: ${e.message}');
        print('Recovery suggestion: ${e.recoverySuggestion}');

        // Handle specific S3 access denied error
        if (e.message.contains('S3 access denied')) {
          print('🔧 Trying alternative upload method...');
          return await _uploadWithGuestAccess(imagePath, userId, customFileName, originalImageKey);
        }
      }
      return null;
    }
  }

  /// Main upload logic with consistent naming
  static Future<String?> _performUpload(
      String imagePath,
      String userId,
      String? customFileName,
      String? originalImageKey,
      ) async {
    final file = File(imagePath);

    // Use the original image key format for S3 filename to maintain consistency
    final fileName = originalImageKey ?? customFileName ?? _generateFileNameFromImageKey(imagePath, userId);
    final s3Key = '$_attendanceFolder/$fileName';

    // Read file as bytes
    final imageData = await file.readAsBytes();
    final fileSize = await file.length();

    print('📤 Starting S3 upload with consistent naming...');
    print('File path: $imagePath');
    print('File size: $fileSize bytes');
    print('S3 Key: $s3Key');
    print('Original Image Key: $originalImageKey');
    print('Content type: ${_getContentType(imagePath)}');

    try {
      // Method 1: Try uploadData first (recommended for newer Amplify versions)
      final uploadDataOperation = Amplify.Storage.uploadData(
        path: StoragePath.fromString(s3Key),
        data: StorageDataPayload.bytes(
          imageData,
          contentType: _getContentType(imagePath),
        ),
        options: const StorageUploadDataOptions(
          pluginOptions: S3UploadDataPluginOptions(
            useAccelerateEndpoint: false,
          ),
        ),
      );

      final result = await uploadDataOperation.result;
      print('✅ S3 upload successful via uploadData');
      print('Upload result path: ${result.uploadedItem.path}');

      // Generate public URL
      final publicUrl = await _generatePublicUrl(s3Key);
      return publicUrl;

    } catch (e) {
      print('❌ uploadData failed, trying uploadFile: $e');

      // Method 2: Fallback to uploadFile
      return await _uploadViaFile(imagePath, userId, customFileName, originalImageKey);
    }
  }

  /// Alternative upload method using uploadFile with consistent naming
  static Future<String?> _uploadViaFile(
      String imagePath,
      String userId,
      String? customFileName,
      String? originalImageKey,
      ) async {
    try {
      // Use the original image key format for consistency
      final fileName = originalImageKey ?? customFileName ?? _generateFileNameFromImageKey(imagePath, userId);
      final s3Key = '$_attendanceFolder/$fileName';

      print('📤 Trying S3 uploadFile method with consistent naming...');

      final uploadFileOperation = Amplify.Storage.uploadFile(
        localFile: AWSFile.fromPath(imagePath),
        path: StoragePath.fromString(s3Key),
        options: StorageUploadFileOptions(
          metadata: {
            'userId': userId,
            'uploadTime': DateTime.now().toIso8601String(),
            'contentType': _getContentType(imagePath),
            'originalImageKey': originalImageKey ?? fileName,
          },
          pluginOptions: const S3UploadFilePluginOptions(
            useAccelerateEndpoint: false,
          ),
        ),
      );

      final result = await uploadFileOperation.result;
      print('✅ S3 file upload successful with consistent naming');
      print('Upload result path: ${result.uploadedItem.path}');

      final publicUrl = await _generatePublicUrl(s3Key);
      return publicUrl;

    } catch (e) {
      print('❌ uploadFile also failed: $e');
      throw e;
    }
  }

  /// Upload with guest access level (fallback for permission issues)
  static Future<String?> _uploadWithGuestAccess(
      String imagePath,
      String userId,
      String? customFileName,
      String? originalImageKey,
      ) async {
    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        throw Exception('Image file does not exist: $imagePath');
      }

      // Use the original image key format for consistency
      final fileName = originalImageKey ?? customFileName ?? _generateFileNameFromImageKey(imagePath, userId);
      // Use public folder for guest access
      final s3Key = 'public/$_attendanceFolder/$fileName';
      final imageData = await file.readAsBytes();

      print('📤 Trying upload with guest access and consistent naming...');
      print('S3 Key with public prefix: $s3Key');

      final uploadDataOperation = Amplify.Storage.uploadData(
        path: StoragePath.fromString(s3Key),
        data: StorageDataPayload.bytes(
          imageData,
          contentType: _getContentType(imagePath),
        ),
        options: const StorageUploadDataOptions(
          pluginOptions: S3UploadDataPluginOptions(
            useAccelerateEndpoint: false,
          ),
        ),
      );

      final result = await uploadDataOperation.result;
      print('✅ S3 upload successful with guest access and consistent naming');

      final publicUrl = await _generatePublicUrl(s3Key);
      return publicUrl;

    } catch (e) {
      print('❌ Guest access upload failed: $e');
      return null;
    }
  }

  /// Try to correct common file path issues
  static String? _tryCorrectFilePath(String originalPath) {
    // Common issue: extra 'a' in filename (as seen in your logs)
    // scaled_3aa69910... vs scaled_3aaa69910...
    if (originalPath.contains('scaled_3aaa')) {
      final corrected = originalPath.replaceFirst('scaled_3aaa', 'scaled_3aa');
      print('🔧 Trying corrected path: $corrected');
      return corrected;
    }

    // Try other common corrections
    final directory = path.dirname(originalPath);
    final filename = path.basename(originalPath);

    // Remove duplicate characters in filename
    final correctedFilename = filename.replaceAll(RegExp(r'([a-f0-9])\1{2,}'), r'$1$1');
    if (correctedFilename != filename) {
      final correctedPath = path.join(directory, correctedFilename);
      print('🔧 Trying filename correction: $correctedPath');
      return correctedPath;
    }

    return null;
  }

  /// Generate public URL for uploaded file
  static Future<String> _generatePublicUrl(String s3Key) async {
    try {
      final getUrlOperation = Amplify.Storage.getUrl(
        path: StoragePath.fromString(s3Key),
        options: const StorageGetUrlOptions(
          pluginOptions: S3GetUrlPluginOptions(
            validateObjectExistence: false, // Don't validate to avoid permission issues
            expiresIn: Duration(days: 365),
          ),
        ),
      );

      final result = await getUrlOperation.result;
      print('✅ Generated public URL: ${result.url}');
      return result.url.toString();
    } catch (e) {
      print('❌ Failed to generate public URL: $e');
      // Return a fallback direct S3 URL
      const bucketName = 'smartattendanceproje63c9c38d5737442bb519faa59f42b766-dev';
      const region = 'ap-south-1';
      final fallbackUrl = 'https://$bucketName.s3.$region.amazonaws.com/$s3Key';
      print('🔄 Using fallback URL: $fallbackUrl');
      return fallbackUrl;
    }
  }

  /// Generate filename that matches the original image key format for API consistency
  static String _generateFileNameFromImageKey(String imagePath, String userId) {
    final fileName = path.basename(imagePath);
    final timestamp = DateTime.now().millisecondsSinceEpoch;

    // Use the same format as the API expects: attendance_timestamp_originalfilename
    return 'attendance_${timestamp}_$fileName';
  }

  /// Determine content type based on file extension
  static String _getContentType(String imagePath) {
    final extension = path.extension(imagePath).toLowerCase();
    switch (extension) {
      case '.jpg':
      case '.jpeg':
        return 'image/jpeg';
      case '.png':
        return 'image/png';
      case '.gif':
        return 'image/gif';
      case '.webp':
        return 'image/webp';
      case '.bmp':
        return 'image/bmp';
      default:
        return 'image/jpeg';
    }
  }

  /// Enhanced file validation
  static Future<bool> validateImageFile(String imagePath) async {
    try {
      final file = File(imagePath);

      if (!await file.exists()) {
        print('❌ File does not exist: $imagePath');
        return false;
      }

      final fileSize = await file.length();
      if (fileSize == 0) {
        print('❌ File is empty: $imagePath');
        return false;
      }

      if (fileSize > 10 * 1024 * 1024) { // 10MB limit
        print('❌ File too large: ${fileSize / (1024 * 1024)}MB');
        return false;
      }

      // Check if it's a valid image format
      final extension = path.extension(imagePath).toLowerCase();
      if (!['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'].contains(extension)) {
        print('❌ Unsupported image format: $extension');
        return false;
      }

      print('✅ File validation passed: $imagePath (${fileSize} bytes)');
      return true;

    } catch (e) {
      print('❌ File validation error: $e');
      return false;
    }
  }

  /// Upload with comprehensive validation and retry logic - Updated with consistent naming
  static Future<String?> uploadImageWithRetry({
    required String imagePath,
    required String userId,
    String? customFileName,
    String? originalImageKey, // Add this parameter
    int maxRetries = 3,
  }) async {
    // Validate file first
    if (!await validateImageFile(imagePath)) {
      return null;
    }

    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      print('🔄 Upload attempt $attempt of $maxRetries');

      final result = await uploadImage(
        imagePath: imagePath,
        userId: userId,
        customFileName: customFileName,
        originalImageKey: originalImageKey, // Pass the original image key
      );

      if (result != null) {
        print('✅ Upload successful on attempt $attempt');
        return result;
      }

      if (attempt < maxRetries) {
        print('⏳ Waiting before retry...');
        await Future.delayed(Duration(seconds: attempt * 2)); // Progressive delay
      }
    }

    print('❌ All upload attempts failed');
    return null;
  }

  /// Delete image from S3
  static Future<bool> deleteImage(String s3Key) async {
    try {
      await Amplify.Storage.remove(
        path: StoragePath.fromString(s3Key),
      ).result;

      print('✅ Image deleted from S3: $s3Key');
      return true;
    } catch (e) {
      print('❌ Failed to delete image from S3: $e');
      return false;
    }
  }

  /// Check if file exists in S3
  static Future<bool> fileExists(String s3Key) async {
    try {
      final getPropertiesOperation = Amplify.Storage.getProperties(
        path: StoragePath.fromString(s3Key),
      );

      await getPropertiesOperation.result;
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get file info from S3
  static Future<Map<String, dynamic>?> getFileInfo(String s3Key) async {
    try {
      final getPropertiesOperation = Amplify.Storage.getProperties(
        path: StoragePath.fromString(s3Key),
      );

      final result = await getPropertiesOperation.result;

      return {
        'path': result.storageItem.path,
        'size': result.storageItem.size,
        'lastModified': result.storageItem.lastModified,
        'eTag': result.storageItem.eTag,
        'metadata': result.storageItem.metadata,
      };
    } catch (e) {
      print('❌ Failed to get file info: $e');
      return null;
    }
  }
}
