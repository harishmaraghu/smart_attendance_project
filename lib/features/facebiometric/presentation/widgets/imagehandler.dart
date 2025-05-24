import 'dart:io';
import 'dart:convert';
import 'dart:typed_data';

class ImageHandler {
  /// Generate a unique image key based on timestamp and file info
  static String generateImageKey({
    String? originalPath,
    String? customPrefix,
    String timeType = "attendance",
  }) {
    final now = DateTime.now();
    final timestamp = now.millisecondsSinceEpoch;

    if (originalPath != null && originalPath.isNotEmpty) {
      final fileName = originalPath.split('/').last;
      final extension = fileName.contains('.') ? fileName.split('.').last : 'jpg';
      return "${customPrefix ?? timeType}_${timestamp}.$extension";
    }

    return "${customPrefix ?? timeType}_$timestamp.jpg";
  }

  /// Convert image file to base64 string for API upload
  static Future<String?> convertToBase64(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        print("❌ Image file does not exist: $imagePath");
        return null;
      }

      final bytes = await file.readAsBytes();
      final base64String = base64Encode(bytes);

      print("✅ Image converted to base64, size: ${base64String.length} characters");
      return base64String;
    } catch (e) {
      print("❌ Error converting image to base64: $e");
      return null;
    }
  }

  /// Get image file information
  static Future<Map<String, dynamic>?> getImageInfo(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return null;
      }

      final stat = await file.stat();
      final fileName = imagePath.split('/').last;

      return {
        'fileName': fileName,
        'filePath': imagePath,
        'fileSize': stat.size,
        'fileSizeFormatted': _formatFileSize(stat.size),
        'lastModified': stat.modified,
        'extension': fileName.contains('.') ? fileName.split('.').last.toLowerCase() : 'unknown',
      };
    } catch (e) {
      print("❌ Error getting image info: $e");
      return null;
    }
  }

  /// Format file size in human readable format
  static String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }

  /// Validate if the file is a valid image
  static Future<bool> isValidImage(String? imagePath) async {
    if (imagePath == null || imagePath.isEmpty) {
      return false;
    }

    try {
      final file = File(imagePath);
      if (!await file.exists()) {
        return false;
      }

      final fileName = imagePath.split('/').last.toLowerCase();
      final validExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp'];

      for (final ext in validExtensions) {
        if (fileName.endsWith('.$ext')) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print("❌ Error validating image: $e");
      return false;
    }
  }

  /// Create image upload payload for API
  static Future<Map<String, dynamic>?> createImageUploadPayload({
    required String? imagePath,
    required String imageKey,
    bool includeBase64 = true,
    Map<String, dynamic>? additionalData,
  }) async {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }

    try {
      final imageInfo = await getImageInfo(imagePath);
      if (imageInfo == null) {
        return null;
      }

      final payload = <String, dynamic>{
        'imageKey': imageKey,
        'fileName': imageInfo['fileName'],
        'fileSize': imageInfo['fileSize'],
        'extension': imageInfo['extension'],
        'uploadTimestamp': DateTime.now().toIso8601String(),
      };

      if (includeBase64) {
        final base64Data = await convertToBase64(imagePath);
        if (base64Data != null) {
          payload['imageData'] = base64Data;
          payload['encoding'] = 'base64';
        }
      } else {
        payload['filePath'] = imagePath;
      }

      // Add any additional data
      if (additionalData != null) {
        payload.addAll(additionalData);
      }

      return payload;
    } catch (e) {
      print("❌ Error creating image upload payload: $e");
      return null;
    }
  }

  /// Clean up temporary image files (optional)
  static Future<void> cleanupTempImages(List<String> imagePaths) async {
    for (final path in imagePaths) {
      try {
        final file = File(path);
        if (await file.exists()) {
          await file.delete();
          print("🗑️ Cleaned up temp image: $path");
        }
      } catch (e) {
        print("⚠️ Failed to cleanup image $path: $e");
      }
    }
  }
}