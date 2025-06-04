import 'package:flutter/material.dart';
import 'package:smart_attendance_project/features/history_claim/constants/appcolors.dart'
    show HistoryAppColors;

class StatusBadge extends StatelessWidget {
  final String status;

  const StatusBadge({Key? key, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: HistoryAppColors.getStatusColor(status),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        _getStatusText(status),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'settled':
        return 'Settled';
      case 'failed':
        return 'Failed';
      case 'pending':
        return 'Processing';
      default:
        return status;
    }
  }
}

// Alternative Circular Status Indicator Widget
class StatusIndicator extends StatelessWidget {
  final String status;
  final double size;

  const StatusIndicator({Key? key, required this.status, this.size = 12})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: HistoryAppColors.getStatusColor(status),
        shape: BoxShape.circle,
      ),
    );
  }
}

// Tab Header Status Widget (for the Processing/Completed tabs)
class TabStatusHeader extends StatelessWidget {
  final String label;
  final bool isActive;
  final bool isProcessing;

  const TabStatusHeader({
    Key? key,
    required this.label,
    required this.isActive,
    required this.isProcessing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color:
                isProcessing
                    ? (isActive ? Colors.white : HistoryAppColors.warning)
                    : (isActive ? Colors.white : HistoryAppColors.success),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 8),
        Text(label),
      ],
    );
  }
}
