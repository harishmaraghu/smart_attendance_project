import 'package:flutter/material.dart';

class DateSelectorField extends StatelessWidget {
  final String title;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DateSelectorField({
    super.key,
    required this.title,
    required this.selectedDate,
    required this.onTap,
  });

  String _formatDate(DateTime? date) {
    if (date == null) return 'Select date';
    return "${date.day.toString().padLeft(2, '0')}/"
        "${date.month.toString().padLeft(2, '0')}/"
        "${date.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min, // ✅ Prevents unbounded height
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Text(
                  _formatDate(selectedDate),
                  style: const TextStyle(color: Colors.black),
                ),
                const Spacer(),
                const Icon(Icons.calendar_today, size: 18),
              ],
            ),
          ),
        )
      ],
    );
  }
}