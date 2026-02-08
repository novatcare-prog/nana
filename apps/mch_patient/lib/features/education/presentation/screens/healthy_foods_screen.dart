import 'package:flutter/material.dart';

class HealthyFoodsScreen extends StatelessWidget {
  const HealthyFoodsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Healthy Foods'),
      ),
      body: CustomScrollView(
        slivers: [
          // Header / Key Guidelines
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                Container(
                  margin: const EdgeInsets.only(bottom: 24),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.teal.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Variety is Key! 🥗',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      _HeaderCheckItem(
                          'Eat at least 5 of the 10 food groups daily'),
                      _HeaderCheckItem(
                          'Mix different colors across food groups'),
                      _HeaderCheckItem('Take one extra meal per day'),
                    ],
                  ),
                ),
              ]),
            ),
          ),

          // The 10 Food Groups Title
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16, left: 4),
                child: Text(
                  'The 10 Food Groups',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
              ),
            ),
          ),

          // Grid of Food Groups
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.85,
              ),
              delegate: SliverChildListDelegate([
                _FoodGroupCard(
                  title: 'Starchy Foods',
                  subtitle: 'Grains, Roots, Tubers',
                  icon: Icons.bakery_dining,
                  color: Colors.brown.shade300,
                  foods: 'Maize, Rice, Potatoes, Cassava',
                ),
                _FoodGroupCard(
                  title: 'Legumes & Pulses',
                  subtitle: 'Beans, Peas, Lentils',
                  icon: Icons.soup_kitchen,
                  color: Colors.green.shade700,
                  foods: 'Beans, Green Grams, Peas',
                ),
                _FoodGroupCard(
                  title: 'Nuts & Seeds',
                  subtitle: 'Energy & Good Fats',
                  icon: Icons.spa,
                  color: Colors.amber.shade700,
                  foods: 'Peanuts, Cashews, Simsim',
                ),
                _FoodGroupCard(
                  title: 'Dairy Products',
                  subtitle: 'Milk, Yoghurt',
                  icon: Icons.local_drink,
                  color: Colors.blue.shade300,
                  foods: 'Fresh Milk, Fermented Milk',
                ),
                _FoodGroupCard(
                  title: 'Eggs',
                  subtitle: 'Protein Power',
                  icon: Icons.egg,
                  color: Colors.orange.shade300,
                  foods: 'Chicken Eggs, Quail Eggs',
                ),
                _FoodGroupCard(
                  title: 'Flesh Foods',
                  subtitle: 'Meat, Fish, Poultry',
                  icon: Icons.set_meal,
                  color: Colors.red.shade400,
                  foods: 'Beef, Chicken, Fish, Liver',
                ),
                _FoodGroupCard(
                  title: 'Orange Fruits/Veg',
                  subtitle: 'Vitamin A Rich',
                  icon: Icons.emoji_nature,
                  color: Colors.deepOrange.shade400,
                  foods: 'Carrots, Pumpkin, Mango, Papaya',
                ),
                _FoodGroupCard(
                  title: 'Dark Green Veg',
                  subtitle: 'Leafy Vegetables',
                  icon: Icons.grass,
                  color: Colors.green.shade900,
                  foods: 'Spinach, Kale, Managu',
                ),
                _FoodGroupCard(
                  title: 'Other Vegetables',
                  subtitle: 'Vitamins & Fiber',
                  icon: Icons.local_florist,
                  color: Colors.lightGreen.shade600,
                  foods: 'Tomato, Onion, Cabbage',
                ),
                _FoodGroupCard(
                  title: 'Other Fruits',
                  subtitle: 'Fresh & Juicy',
                  icon: Icons.apple,
                  color: Colors.pink.shade300,
                  foods: 'Banana, Pineapple, Avocado',
                ),
              ]),
            ),
          ),

          // Water Section (Center of the wheel)
          SliverPadding(
            padding: const EdgeInsets.all(16),
            sliver: SliverToBoxAdapter(
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Colors.blue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.water_drop,
                          color: Colors.white, size: 30),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Hydration is Crucial',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Consume plenty of safe water throughout the day. Take lots of nutritious fluids like porridge, soup, and fresh juice.',
                            style: TextStyle(color: Colors.blue.shade900),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderCheckItem extends StatelessWidget {
  final String text;
  const _HeaderCheckItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.check_circle, color: Colors.white70, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}

class _FoodGroupCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String foods;
  final IconData icon;
  final Color color;

  const _FoodGroupCard({
    required this.title,
    required this.subtitle,
    required this.foods,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colored Header
            Container(
              height: 60,
              width: double.infinity,
              color: color.withOpacity(0.15),
              child: Center(
                child: Icon(icon, color: color, size: 32),
              ),
            ),

            // Content
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.grey.shade900,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        fontSize: 11,
                        color: color,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(6),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        foods,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
