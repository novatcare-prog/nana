import 'package:flutter/material.dart';

class ImmunizationScheduleScreen extends StatelessWidget {
  const ImmunizationScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Immunization Schedule'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey.shade100),
              ),
              child: Column(children: [
                const Text(
                  'Immunisation Summary',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Ensure your child gets the right vaccines at the right time.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                  textAlign: TextAlign.center,
                ),
              ]),
            ),
            const SizedBox(height: 24),

            // Milestone Cards
            const _MilestoneCard(
              age: 'At Birth',
              color: Colors.orange,
              icon: Icons.child_friendly,
              vaccines: [
                {'name': 'TB (BCG)', 'desc': 'Prevents Tuberculosis'},
                {'name': 'Polio 0', 'desc': 'Prevents Polio (Oral)'},
              ],
            ),
            const _MilestoneCard(
              age: '1½ Months (6 Weeks)',
              color: Color(0xFFF06292), // Pink
              icon: Icons.baby_changing_station,
              vaccines: [
                {'name': 'Polio 1', 'desc': 'Oral Polio Vaccine'},
                {'name': 'Diphtheria', 'desc': 'Part of Pentavalent'},
                {'name': 'Pertussis', 'desc': 'Whooping Cough'},
                {'name': 'Tetanus', 'desc': 'Part of Pentavalent'},
                {'name': 'Hepatitis B', 'desc': 'Part of Pentavalent'},
                {
                  'name': 'Haemophilus Influenza B',
                  'desc': 'Prevents Meningitis/Pneumonia'
                },
                {'name': 'Pneumonia 1', 'desc': 'PCV Vaccine'},
                {'name': 'Diarrhoea 1', 'desc': 'Rotavirus Vaccine'},
              ],
            ),
            const _MilestoneCard(
              age: '2½ Months (10 Weeks)',
              color: Color(0xFFBA68C8), // Purple
              icon: Icons.toys,
              vaccines: [
                {'name': 'Polio 2', 'desc': 'Oral Polio Vaccine'},
                {'name': 'Diphtheria', 'desc': '2nd Dose'},
                {'name': 'Pertussis', 'desc': '2nd Dose'},
                {'name': 'Tetanus', 'desc': '2nd Dose'},
                {'name': 'Hepatitis B', 'desc': '2nd Dose'},
                {'name': 'Hib', 'desc': '2nd Dose'},
                {'name': 'Pneumonia 2', 'desc': '2nd Dose'},
                {'name': 'Diarrhoea 2', 'desc': '2nd Dose'},
              ],
            ),
            const _MilestoneCard(
              age: '3½ Months (14 Weeks)',
              color: Color(0xFFAED581), // Light Green
              icon: Icons.medical_services,
              vaccines: [
                {'name': 'Polio 3', 'desc': 'Oral Polio Vaccine'},
                {'name': 'Diphtheria', 'desc': '3rd Dose'},
                {'name': 'Pertussis', 'desc': '3rd Dose'},
                {'name': 'Tetanus', 'desc': '3rd Dose'},
                {'name': 'Hepatitis B', 'desc': '3rd Dose'},
                {'name': 'Hib', 'desc': '3rd Dose'},
                {'name': 'Pneumonia 3', 'desc': '3rd Dose'},
              ],
            ),
            const _MilestoneCard(
              age: '9 Months',
              color: Color(0xFF64B5F6), // Blue
              icon: Icons.accessibility_new,
              vaccines: [
                {'name': 'Measles 1', 'desc': 'Measles Vaccine'},
                {'name': 'Rubella', 'desc': 'Rubella Vaccine'},
              ],
            ),
            const _MilestoneCard(
              age: '18 Months',
              color: Color(0xFFE57373), // Red
              icon: Icons.directions_walk,
              vaccines: [
                {'name': 'Measles 2', 'desc': '2nd Dose'},
                {'name': 'Rubella 2', 'desc': '2nd Dose'},
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  final String age;
  final Color color;
  final IconData icon;
  final List<Map<String, String>> vaccines;

  const _MilestoneCard({
    required this.age,
    required this.color,
    required this.icon,
    required this.vaccines,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            decoration: BoxDecoration(
              color: color,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                Text(
                  age,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          // Content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: vaccines
                  .map((v) => _VaccineRow(
                        name: v['name']!,
                        desc: v['desc']!,
                        color: color,
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _VaccineRow extends StatelessWidget {
  final String name;
  final String desc;
  final Color color;

  const _VaccineRow({
    required this.name,
    required this.desc,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: color, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                if (desc.isNotEmpty)
                  Text(
                    desc,
                    style: TextStyle(
                      fontSize: 12,
                      color: Theme.of(context).textTheme.bodySmall?.color,
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
