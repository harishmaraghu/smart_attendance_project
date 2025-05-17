import 'package:flutter/material.dart';

class ClaimHistoryTabs extends StatelessWidget {
  final bool isProcessingSelected;
  final ValueChanged<bool> onTabChange;

  const ClaimHistoryTabs({
    super.key,
    required this.isProcessingSelected,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white, // Set background color to white
      padding: const EdgeInsets.symmetric(horizontal: 15.0,),
      child: Row(
        children: [
          _buildTabItem("Processing", isProcessingSelected, true),
          Expanded(
            child: Container(
              height: 1,
              color: Colors.grey.shade300,
            ),
          ),
          _buildTabItem("Completed", !isProcessingSelected, false),
        ],
      ),
    );
  }

  Widget _buildTabItem(String label, bool isActive, bool isProcessing) {
    return GestureDetector(
      onTap: () => onTabChange(isProcessing),
      child: Column(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: isActive ? Colors.green : Colors.grey.shade200,
              shape: BoxShape.circle,
              border: Border.all(
                color: isActive ? Colors.green : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: isActive
                ? const Icon(
              Icons.check,
              size: 14,
              color: Colors.white,
            )
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: isActive ? Colors.black : Colors.grey,
              fontWeight: isActive ? FontWeight.w500 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}