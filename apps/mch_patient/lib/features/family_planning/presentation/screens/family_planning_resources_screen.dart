import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FamilyPlanningResourcesScreen extends StatelessWidget {
  const FamilyPlanningResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('family_planning.resources_title'.tr()),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _ResourceCard(
            title: 'family_planning.res_who_title'.tr(), // "WHO Guidelines"
            description: 'family_planning.res_who_desc'
                .tr(), // "Comprehensive guide on family planning..."
            icon: FontAwesomeIcons.bookMedical,
            color: Colors.blue,
            url: 'https://www.who.int/health-topics/family-planning',
          ),
          const SizedBox(height: 16),
          _ResourceCard(
            title: 'family_planning.res_spacing_title'.tr(), // "Birth Spacing"
            description: 'family_planning.res_spacing_desc'
                .tr(), // "Wait at least 24 months..."
            icon: FontAwesomeIcons.child,
            color: Colors.green,
            url: 'https://www.who.int/publications/i/item/WHO-RHR-05.13',
          ),
          const SizedBox(height: 16),
          _ResourceCard(
            title: 'family_planning.res_contraception_title'
                .tr(), // "Contraception Methods"
            description: 'family_planning.res_contraception_desc'
                .tr(), // "Explore different options..."
            icon: FontAwesomeIcons.pills,
            color: Colors.purple,
            url: 'https://www.who.int/health-topics/contraception',
          ),
          const SizedBox(height: 16),
          _ResourceCard(
            title: 'family_planning.res_htsp_title'.tr(), // "Healthy Timing"
            description: 'family_planning.res_htsp_desc'
                .tr(), // "Better outcomes for mother and baby."
            icon: FontAwesomeIcons.clock,
            color: Colors.orange,
            url: null,
          ),
        ],
      ),
    );
  }
}

class _ResourceCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final String? url;

  const _ResourceCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    this.url,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // In a real app with url_launcher, we'd open the URL here.
          // For now, we'll just show a snackbar or copy to clipboard if needed.
          if (url != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Visit: $url')),
            );
          }
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    if (url != null) ...[
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            'family_planning.tap_to_learn'
                                .tr(), // "Tap to learn more"
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: color,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 12, color: color),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
