// lib/services/loan_service.dart
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoanService {
  static Future<bool> applyLoan({
    required String userId,
    required String userName,
    required String paymentClaimType,
    required int amount,
    required String duration,
    required int emiAmount,
  }) async {
    final url = Uri.parse('https://irb5h5e5yk.execute-api.ap-south-1.amazonaws.com/default/LoanApply');

    final body = {
      "userid": userId,
      "username": userName,
      "payment_claim_type": paymentClaimType,
      "amount": amount,
      "duration": duration,
      "emi_amount": emiAmount,
    };

    print("claim create succesfuly------------1");

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    print("claim create succesfuly------------12");

    return response.statusCode == 200;


  }

}
