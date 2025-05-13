import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../../../../core/constants/app_colors.dart';

class PhoneNoField extends StatelessWidget {
  final TextEditingController controller;
  const PhoneNoField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Phone Number",
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
        ),
        const SizedBox(height: 8),
        IntlPhoneField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            filled: true,
            fillColor: Colors.grey[100],
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          initialCountryCode: 'IN', // Change based on your default
          onChanged: (phone) {
            print(phone.completeNumber);
          },
        ),
      ],
    );
  }
}
