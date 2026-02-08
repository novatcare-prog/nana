import 'package:flutter/material.dart';

class FluidsScreen extends StatelessWidget {
  const FluidsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fluids'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Image/Icon Section
            Center(
              child: Container(
                height: 120,
                width: 120,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.water_drop,
                    size: 60, color: Colors.blue.shade300),
              ),
            ),
            const SizedBox(height: 24),

            // Section 1: For Any Sick Child
            const _InfoCard(
              title: 'For Any Sick Child',
              color: Colors.teal,
              icon: Icons.sick_outlined,
              content: Column(
                children: [
                  _BulletPoint(
                      text:
                          'Breastfeed frequently and for longer at each feed.'),
                  _BulletPoint(
                    text:
                        'Increase fluid. Give soup, rice water, yoghurt drinks or clean and safe water, if not on exclusive breastfeeding.',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Section 2: Child with Diarrhoea
            const _InfoCard(
              title: 'Child with Diarrhoea',
              subtitle: 'Giving more fluids can be life saving',
              color: Colors.orange,
              icon: Icons
                  .medical_services_outlined, // Using a generic medical icon
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '1) For children not on exclusive breastfeeding:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: EdgeInsets.only(left: 8),
                    child: Text(
                      'Give extra fluids as much as the child will take:',
                      style: TextStyle(fontStyle: FontStyle.italic),
                    ),
                  ),
                  _BulletPoint(text: 'ORS solution'),
                  _BulletPoint(
                      text:
                          'Food based fluids such as Soup, Rice, Yoghurt drink'),
                  _BulletPoint(text: 'Clean and safe water'),
                  _BulletPoint(
                      text:
                          'Breastfeed more frequently and longer at each feeding'),
                  _BulletPoint(
                      text:
                          'Continue giving extra fluids until diarrhoea stops'),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Text(
                    '2) For babies on exclusive breastfeeding:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  SizedBox(height: 8),
                  _BulletPoint(
                      text:
                          'Breastfeed more frequently and longer at each breastfeed'),
                  _BulletPoint(text: 'Give ORS solutions'),
                  SizedBox(height: 16),
                  Divider(),
                  SizedBox(height: 16),
                  Text(
                    '3) Zinc Supplementation:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  _BulletPoint(
                      text:
                          'Give zinc as advised by health worker until it is finished.'),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Vomiting Advice
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.blue),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'If the child vomits, wait for 10 minutes then give small frequent sips.',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.blue.shade900,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color color;
  final IconData icon;
  final Widget content;

  const _InfoCard({
    required this.title,
    this.subtitle,
    required this.color,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.toUpperCase(),
                        style: TextStyle(
                          color: color,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: color.withOpacity(0.8),
                            fontSize: 12,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ],
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;

  const _BulletPoint({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: Theme.of(context).textTheme.bodyLarge?.color,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
