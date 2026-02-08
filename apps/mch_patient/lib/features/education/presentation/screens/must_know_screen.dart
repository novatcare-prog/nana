import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MustKnowScreen extends StatelessWidget {
  const MustKnowScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Must Know'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _MustKnowItem(
            title: 'Immunization Schedule',
            description: 'Essential vaccination timeline for your child',
            icon: Icons.vaccines,
            color: Colors.blue,
            onTap: () => context.push('/must-know/immunization'),
          ),
          const SizedBox(height: 12),
          _MustKnowItem(
            title: 'When to Return',
            description: 'Danger signs requiring immediate medical attention',
            icon: Icons.medical_services_outlined,
            color: Colors.red,
            onTap: () => context.push('/must-know/return-to-clinic'),
          ),
          const SizedBox(height: 12),
          _MustKnowItem(
            title: 'Fluids',
            description: 'Feeding advice for sick children & diarrhoea',
            icon: Icons.water_drop_outlined,
            color: Colors.blue,
            onTap: () => context.push('/must-know/fluids'),
          ),
          const SizedBox(height: 12),
          _MustKnowItem(
            title: 'Feeding',
            description: 'Breastfeeding, solid foods & nutrition guide',
            icon: Icons.restaurant_menu,
            color: Colors.green,
            onTap: () => context.push('/must-know/feeding'),
          ),
          const SizedBox(height: 12),
          _MustKnowItem(
            title: 'Developmental Milestones',
            description: 'Track your child\'s growth progress',
            icon: Icons.show_chart,
            color: Colors.purple,
            onTap: () => context.push('/must-know/milestones'),
          ),
          const SizedBox(height: 12),
          _MustKnowItem(
            title: 'Healthy Foods',
            description: 'Nutrition guide & 10 food groups',
            icon: Icons.local_dining,
            color: Colors.orange,
            onTap: () => context.push('/must-know/healthy-foods'),
          ),
          // Placeholder for future items
        ],
      ),
    );
  }
}

class _MustKnowItem extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _MustKnowItem({
    required this.title,
    required this.description,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Card(
      color: Theme.of(context).cardTheme.color ??
          (isDark ? const Color(0xFF1E1E1E) : Colors.white),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 30),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).textTheme.bodyLarge?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400]),
            ],
          ),
        ),
      ),
    );
  }
}
