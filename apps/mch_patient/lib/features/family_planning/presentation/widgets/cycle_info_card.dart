import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class CycleInfoCard extends StatelessWidget {
  final String status;
  final int? daysUntilPeriod;
  final VoidCallback? onLogPeriod;

  const CycleInfoCard({
    super.key,
    required this.status,
    this.daysUntilPeriod,
    this.onLogPeriod,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusKey;
    IconData statusIcon;

    switch (status) {
      case 'period':
        statusColor = const Color(0xFFEF5350); // Red
        statusKey = 'family_planning.status_period';
        statusIcon = Icons.water_drop;
        break;
      case 'fertile':
        statusColor = const Color(0xFF66BB6A); // Green
        statusKey = 'family_planning.status_fertile';
        statusIcon = Icons.child_care;
        break;
      case 'ovulation':
        statusColor = const Color(0xFF42A5F5); // Blue
        statusKey = 'family_planning.status_ovulation';
        statusIcon = Icons.egg_alt;
        break;
      default: // safe
        statusColor = Colors.grey;
        statusKey = 'family_planning.status_safe';
        statusIcon = Icons.shield_outlined;
    }

    // Fallback if translations missing during dev
    String statusText = statusKey;
    if (statusText.startsWith('family_planning.')) {
      // Temporary fallback
      statusText = status.toUpperCase();
    }

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'family_planning.today_status'.tr(), // "TODAY'S STATUS"
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(statusIcon, color: statusColor, size: 28),
                          const SizedBox(width: 8),
                          Text(
                            statusText, // e.g. "Fertile Window"
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: statusColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (daysUntilPeriod != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$daysUntilPeriod',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        Text(
                          'family_planning.days_to_period'
                              .tr(), // "Days to period"
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const Divider(height: 32),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'family_planning.prediction_disclaimer'
                      .tr(), // "Predictions are estimates only"
                  style: TextStyle(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey[500],
                  ),
                ),
                if (onLogPeriod != null)
                  TextButton.icon(
                    onPressed: onLogPeriod,
                    icon: const Icon(Icons.add, size: 16),
                    label: Text('family_planning.log_period'.tr()),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
