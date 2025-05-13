import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/login_model.dart';

class LoginRemoteDataSource {
  final String baseUrl = "https://crv2ac19lj.execute-api.ap-south-1.amazonaws.com/default/LoginAuthFunction";

  Future<Map<String, dynamic>> login(LoginModel model) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(model.toJson()),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception("Failed to login: ${response.statusCode}");
    }
  }
}
