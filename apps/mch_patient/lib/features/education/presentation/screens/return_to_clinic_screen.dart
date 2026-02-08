import 'package:flutter/material.dart';

class ReturnToClinicScreen extends StatelessWidget {
  const ReturnToClinicScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('When to Return'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Warning
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                children: [
                  const Icon(Icons.warning_amber_rounded,
                      color: Colors.red, size: 40),
                  const SizedBox(height: 8),
                  const Text(
                    'RETURN IMMEDIATELY',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Bring your child to the clinic immediately if they show any of these signs.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.red.shade900,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 1. Any Sick Child
            const _UnifiedSymptomCard(
              title: 'Any Sick Child',
              color: Colors.orange,
              icon: Icons.sick,
              symptoms: [
                'Not able to drink or breastfeed',
                'Becomes sicker',
                'Develops a fever',
              ],
            ),

            // 2. Cough or Cold
            const _UnifiedSymptomCard(
              title: 'Cough or Cold',
              color: Colors.blue,
              icon: Icons.air,
              symptoms: [
                'Fast breathing',
                'Difficult breathing',
              ],
            ),

            // 3. Diarrhoea
            const _UnifiedSymptomCard(
              title: 'Diarrhoea',
              color: Colors.brown,
              icon: Icons.water_drop, // loosely representing fluid loss/issue
              symptoms: [
                'Blood in stool',
                'Drinking poorly',
              ],
            ),

            // 4. Young Infant Specific
            const _UnifiedSymptomCard(
              title: 'Young Infants',
              subtitle: 'In addition to above signs',
              color: Colors.purple,
              icon: Icons.child_care,
              symptoms: [
                'Breastfeeding poorly',
                'Feels unusually cold or hot',
                'Palms and soles appear yellow',
              ],
            ),

            const SizedBox(height: 20),
            // Center Clinic Graphic / Summary Reassurance
            Opacity(
              opacity: 0.7,
              child: Column(
                children: [
                  Icon(Icons.local_hospital, size: 60, color: Colors.grey[400]),
                  const SizedBox(height: 8),
                  const Text(
                    'Go to the nearest Health Facility',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _UnifiedSymptomCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Color color;
  final IconData icon;
  final List<String> symptoms;

  const _UnifiedSymptomCard({
    required this.title,
    this.subtitle,
    required this.color,
    required this.icon,
    required this.symptoms,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
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
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
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
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          style: TextStyle(
                            color: color.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Symptoms List
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: symptoms
                  .map((symptom) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                size: 18, color: Colors.grey[600]),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                symptom,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
