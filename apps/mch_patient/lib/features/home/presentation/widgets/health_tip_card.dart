import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../education/data/tips_data.dart';

class HealthTipCard extends StatelessWidget {
  final Tip? tip;

  const HealthTipCard({super.key, this.tip});

  @override
  Widget build(BuildContext context) {
    if (tip == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(tip!.icon ?? Icons.lightbulb,
              color: const Color(0xFF1976D2), size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'health_tip.did_you_know'.tr(),
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                    letterSpacing: 1.5,
                  ),
                ),
                const SizedBox(height: 8),
                if (tip!.title != null) ...[
                  Text(
                    tip!.title!,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0D47A1),
                    ),
                  ),
                  const SizedBox(height: 4),
                ],
                Text(
                  tip!.content,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0D47A1),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
