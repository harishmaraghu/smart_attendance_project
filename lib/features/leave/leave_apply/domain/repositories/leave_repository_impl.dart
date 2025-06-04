import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
// import 'package:smart_attendance_project/features/leave/domain/repositories/leave_repository.dart';
import 'package:smart_attendance_project/features/leave/leave_apply/domain/repositories/leave_repository.dart';

import '../../data/models/leave_apply_request_model.dart';


class LeaveRepositoryImpl implements LeaveRepository {

  @override
  Future<void> applyLeave(LeaveApplyRequestModel request) async {
    final uri = Uri.parse(
        "https://pb1xgio0bb.execute-api.ap-south-1.amazonaws.com/default/Leaveapply");

    String? base64Attachment;

    String _formatDate(DateTime date) {
      return "${date.year.toString().padLeft(4, '0')}-${date.month.toString()
          .padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }


    if (request.attachmentPath != null && request.attachmentPath!.isNotEmpty) {
      final file = File(request.attachmentPath!);
      final bytes = await file.readAsBytes();

      final mimeType = _getMimeType(
          request.attachmentPath!); // e.g. image/png, application/pdf
      final base64Data = base64Encode(bytes);
      base64Attachment = "data:$mimeType;base64,$base64Data";
    }

    final body = {
      "userId": request.userId,
      "userName": request.userName,
      "leavecategory": request.leaveCategory,
      "from_date": request.fromDate,
      "to_date": request.toDate,
      "reason": request.reason,
      if (base64Attachment != null) "attachment": base64Attachment,
    };

    print("Sending Leave Apply Request (JSON with optional base64 file):");
    body.forEach((key, value) {
      print("$key: ${key == "attachment"
          ? "[base64 file data truncated]"
          : value}");
    });

    final response = await http.post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: "application/json",
      },
      body: jsonEncode(body),
    );

    print("Response Status: ${response.statusCode}");
    print("Response Body: ${response.body}");

    if (response.statusCode != 200) {
      try {
        final errorJson = jsonDecode(response.body);
        print("Server Error: ${errorJson['error'] ?? response.body}");
      } catch (_) {
        print("Raw Error: ${response.body}");
      }
      throw Exception("Failed to apply for leave");
    }
  }

  String _getMimeType(String path) {
    final extension = path
        .split('.')
        .last
        .toLowerCase();
    switch (extension) {
      case 'png':
        return 'image/png';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'pdf':
        return 'application/pdf';
      default:
        return 'application/octet-stream';
    }
  }


  @override
  Future<List<LeaveHistoryModel>> fetchLeaveHistory(String userId) async {
    final uri = Uri.parse(
        "https://u5hs3h51i2.execute-api.ap-south-1.amazonaws.com/default/Leavehistoryuser");

    try {
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(
            {'Userid': userId}), // Make sure this matches what your API expects
      );

      print('User ID: $userId');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      print('Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // Extract 'leaves' from the root object
        final List<dynamic> leaves = json['leaves'];

        return leaves.map((e) => LeaveHistoryModel.fromJson(e)).toList();
      } else if (response.statusCode == 400) {
        throw Exception("Bad request. Please check your input.");
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        throw Exception("Unauthorized. Please login again.");
      } else if (response.statusCode == 500) {
        throw Exception("Server error. Please try again later.");
      } else {
        throw Exception("Unexpected error: ${response.statusCode}");
      }
    } on FormatException catch (e) {
      throw Exception("Response format error: ${e.message}");
    } on SocketException {
      throw Exception("No internet connection. Please check your network.");
    }  catch (e) {
      // Catch-all for any other exceptions
      throw Exception("Something went wrong: $e");
    }
  }
}
