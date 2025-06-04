import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiClient {
  static const String baseUrl = 'https://qdt85bl4n9.execute-api.ap-south-1.amazonaws.com/default';

  Future<List<dynamic>> fetchClaims(String userId) async {
    try {
      print('Fetching claims for userId: $userId'); // Print userId

      final response = await http.post(
        Uri.parse('$baseUrl/Claimsuser'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'Userid': userId,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}'); // Optional: to inspect the body

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data;
      } else {
        throw Exception('Failed to load claims: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching claims for userId $userId: $e'); // Print error
      throw Exception('Network error: $e');
    }
  }

}