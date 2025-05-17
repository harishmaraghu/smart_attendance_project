import 'dart:io';
import 'package:dio/dio.dart';

class ClaimRepository {
  final Dio _dio = Dio();

  Future<void> createClaim({
    required String claimGroup,
    required String claimName,
    required String receiptNo,
    required String receiptAmount,
    required String claimableAmount,
    required File attachment,
    required String userId,
    required String userName,
  }) async {
    try {
      final formData = FormData.fromMap({
        "claim_group_name": claimGroup,
        "claim_name": claimName,
        "receipt_no": receiptNo,
        "receipt_amount": receiptAmount,
        "claimable_amount": claimableAmount,
        "user_id": userId,
        "user_name": userName,
        "attachment": await MultipartFile.fromFile(
          attachment.path,
          filename: attachment.path.split('/').last,
        ),
      });

      print("📤 Sending Claim Data to API:");
      formData.fields.forEach((element) {
        print("${element.key}: ${element.value}");
      });
      print("📎 Attachment: ${attachment.path}");

      final response = await _dio.post(
        "https://n3a8cyqi9h.execute-api.ap-south-1.amazonaws.com/default/cleamcreated",
        data: formData,
        options: Options(headers: {
          "Content-Type": "multipart/form-data",
        }),
      );

      print("✅ API Response: ${response.statusCode}");
      print(response.data);

      if (response.statusCode != 200) {
        throw Exception("❌ Failed: ${response.statusCode} ${response.statusMessage}");
      }
    } catch (e) {
      print("🚨 Error during claim creation: $e");
      throw Exception("Claim submission failed: $e");
    }
  }
}
