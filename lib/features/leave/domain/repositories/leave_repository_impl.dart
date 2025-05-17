import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:smart_attendance_project/features/leave/domain/repositories/leave_repository.dart';

import '../../data/models/leave_apply_request_model.dart';


class LeaveRepositoryImpl implements LeaveRepository {

  @override
  Future<void> applyLeave(LeaveApplyRequestModel request) async {
    final uri = Uri.parse("https://n3a8cyqi9h.execute-api.ap-south-1.amazonaws.com/default/LeaveRequestHandler");

    String? base64Attachment;

    String _formatDate(DateTime date) {
      return "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
    }


    if (request.attachmentPath != null && request.attachmentPath!.isNotEmpty) {
      final file = File(request.attachmentPath!);
      final bytes = await file.readAsBytes();

      final mimeType = _getMimeType(request.attachmentPath!); // e.g. image/png, application/pdf
      final base64Data = base64Encode(bytes);
      base64Attachment = "data:$mimeType;base64,$base64Data";

    }

    final body = {
      "userName": request.userName,
      "leavecategory": request.leaveCategory,
      "from_date": request.fromDate,
      "to_date": request.toDate,
      "reason": request.reason,
      if (base64Attachment != null) "attachment": base64Attachment,
    };

    print("Sending Leave Apply Request (JSON with optional base64 file):");
    body.forEach((key, value) {
      print("$key: ${key == "attachment" ? "[base64 file data truncated]" : value}");

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
    final extension = path.split('.').last.toLowerCase();
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
  Future<List<LeaveHistoryModel>> fetchLeaveHistory() async {
    final uri = Uri.parse("https://yourapi.com/leave/history");
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((e) => LeaveHistoryModel.fromJson(e)).toList();
    } else {
      throw Exception("Failed to load leave history");
    }
  }
}
