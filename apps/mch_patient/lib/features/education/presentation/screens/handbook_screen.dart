import 'package:flutter/material.dart';

class HandbookScreen extends StatelessWidget {
  const HandbookScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MCH Handbook'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HandbookCard(
            title: 'Pregnancy',
            description:
                'Antenatal care, nutrition, and preparation for birth.',
            icon: Icons.pregnant_woman,
            color: Colors.pink,
            onTap: () => _showContent(
                context,
                'Pregnancy',
                'Regular antenatal care visits are important...\n\n'
                    '• Attend at least 8 ANC visits\n'
                    '• Eat a balanced diet\n'
                    '• Take IFAS supplements daily\n'
                    '• Sleep under a treated mosquito net'),
          ),
          _HandbookCard(
            title: 'Birth & Newborn',
            description: 'Labor signs, delivery, and immediate newborn care.',
            icon: Icons.baby_changing_station,
            color: Colors.purple,
            onTap: () => _showContent(
                context,
                'Birth & Newborn',
                'Signs of Labor:\n'
                    '• Regular painful contractions\n'
                    '• Water breaking\n'
                    '• Bloody show\n\n'
                    'Go to the health facility immediately when labor starts.'),
          ),
          _HandbookCard(
            title: 'Child Health',
            description:
                'Immunization schedule, growth monitoring, and nutrition.',
            icon: Icons.child_care,
            color: Colors.blue,
            onTap: () => _showContent(
                context,
                'Child Health',
                'Immunization Schedule:\n'
                    '• Birth: BCG, Polio\n'
                    '• 6 weeks: DPT, Polio, Pneumococcal, Rotavirus\n'
                    '• 10 weeks: DPT, Polio, Pneumococcal, Rotavirus\n'
                    '• 14 weeks: DPT, Polio, Pneumococcal, IPV\n'
                    '• 6 months: Vitamin A\n'
                    '• 9 months: Measles, Yellow Fever\n'
                    '• 18 months: Measles'),
          ),
          _HandbookCard(
            title: 'Family Planning',
            description: 'Methods and benefits of family planning.',
            icon: Icons.people,
            color: Colors.orange,
            onTap: () => _showContent(
                context,
                'Family Planning',
                'Family planning helps you decide the number and spacing of your children.\n\n'
                    'Methods available:\n'
                    '• Implants\n'
                    '• Pills\n'
                    '• Injectables\n'
                    '• IUCD (Coil)\n'
                    '• Condoms\n\n'
                    'Visit your health provider to choose the best method for you.'),
          ),
        ],
      ),
    );
  }

  void _showContent(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        builder: (context, scrollController) => SingleChildScrollView(
          controller: scrollController,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 16,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HandbookCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _HandbookCard({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
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
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Colors.grey),
            ],
          ),
        ),
      ),
    );
  }
}
