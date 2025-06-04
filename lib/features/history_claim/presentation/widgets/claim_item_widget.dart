import 'package:flutter/material.dart';
import 'package:smart_attendance_project/core/utils/date_formatter.dart';
// import 'package:smart_attendance_project/core/utilits/date_formatter.dart' show DateFormatter;
import 'package:smart_attendance_project/features/history_claim/constants/app_strings.dart';
import 'package:smart_attendance_project/features/history_claim/constants/appcolors.dart' show HistoryAppColors;
import '../../data/models/claim_model.dart';


import 'status_badge_widget.dart';

  class ClaimItemWidget extends StatelessWidget {
    final ClaimModel claim;




    const ClaimItemWidget({Key? key, required this.claim}) : super(key: key);

    @override
    Widget build(BuildContext context) {


      void showFailureDescriptionDialog(BuildContext context, String? description) {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text(
              'Reason for Failure',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: HistoryAppColors.error,
              ),
            ),
            content: Text(
              description ?? 'No description provided.',
              style: const TextStyle(
                fontSize: 14,
                color: HistoryAppColors.textPrimary,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  'Close',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: HistoryAppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        );
      }



      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: HistoryAppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormatter.formatAmount(claim.claimableAmount),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: claim.status.toLowerCase() == 'failed'
                        ? HistoryAppColors.textPrimary
                        : HistoryAppColors.success,
                  ),
                ),
                StatusBadge(status: claim.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              HistoryAppStrings.claimAmount,
              style: const TextStyle(
                fontSize: 14,
                color: HistoryAppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              claim.claimGroupName,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: HistoryAppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormatter.formatDate(claim.date),
              style: const TextStyle(
                fontSize: 14,
                color: HistoryAppColors.textSecondary,
              ),
            ),

            if (claim.status.toLowerCase() == 'failed') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    showFailureDescriptionDialog(context, claim.description);
                  },
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: HistoryAppColors.textSecondary),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    HistoryAppStrings.explore,
                    style: TextStyle(
                      color: HistoryAppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }
