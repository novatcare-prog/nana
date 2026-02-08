import 'package:flutter/material.dart';

class FeedingGuideScreen extends StatelessWidget {
  const FeedingGuideScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Feeding Guide'),
          bottom: const TabBar(
            isScrollable: true,
            labelColor: Colors.pink,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.pink,
            tabs: [
              Tab(text: 'Positioning'),
              Tab(text: 'By Age'),
              Tab(text: 'Sick Child'),
              Tab(text: 'Tips'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _BreastfeedingPositioningTab(),
            _AgeBasedFeedingTab(),
            _SickChildFeedingTab(),
            _GeneralNutritionTipsTab(),
          ],
        ),
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 1: BREASTFEEDING POSITIONING
// -----------------------------------------------------------------------------

class _BreastfeedingPositioningTab extends StatelessWidget {
  const _BreastfeedingPositioningTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header Image
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              borderRadius: BorderRadius.circular(16),
              image: const DecorationImage(
                image:
                    AssetImage('assets/images/breastfeeding_positioning.png'),
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // POSITIONING SECTION
          const _SectionHeader('Correct Positioning'),
          const _InfoNote('All 4 signs of correct positioning must be present'),
          const SizedBox(height: 12),
          const _ChecklistItem('Baby\'s head and body are straight'),
          const _ChecklistItem(
              'Baby facing the mother with nose opposite the nipple'),
          const _ChecklistItem(
              'Baby\'s body close to mother\'s body (Tummy to Tummy)'),
          const _ChecklistItem(
              'Mother supporting infant\'s whole body (not just neck/shoulders)'),

          const SizedBox(height: 12),
          const Text('Is the infant correctly positioned?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              _CheckboxLabel('Yes'),
              const SizedBox(width: 16),
              _CheckboxLabel('No'),
            ],
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // ATTACHMENT SECTION
          Row(
            children: [
              Icon(Icons.face, size: 28, color: Colors.pink.shade300),
              const SizedBox(width: 8),
              const Text('Good Attachment',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
            ],
          ),
          const SizedBox(height: 8),
          const _InfoNote('All 4 signs of good attachment must be present'),
          const SizedBox(height: 12),
          const _ChecklistItem('Chin touching the breast'),
          const _ChecklistItem('Mouth wide open'),
          const _ChecklistItem('Lower lip turned outward'),
          const _ChecklistItem('More areola seen above than below the mouth'),

          const SizedBox(height: 12),
          const Text('Is the infant well attached?',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              _CheckboxLabel('Yes'),
              const SizedBox(width: 16),
              _CheckboxLabel('No'),
            ],
          ),

          const SizedBox(height: 24),

          // HOW TO ATTACH
          Card(
            elevation: 0,
            color: Colors.grey.shade100,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: const Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('How to attach:',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  SizedBox(height: 12),
                  _NumberedItem(
                      '1', 'Touch the baby\'s upper lip with your nipple'),
                  _NumberedItem(
                      '2', 'Wait until the baby\'s mouth is open wide'),
                  _NumberedItem('3',
                      'Move the baby quickly onto your breast, aiming the baby\'s lower lip well below the nipple'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          // EFFECTIVE SUCKLING
          Card(
            elevation: 0,
            color: Colors.blue.shade50,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Signs of effective suckling:',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue.shade900)),
                  const SizedBox(height: 12),
                  const _NumberedItem(
                      '1', 'Slow deep sucks, sometimes pausing'),
                  const _NumberedItem('2', 'Cheeks round when suckling'),
                  const _NumberedItem('3',
                      'Baby releases breast when milk is finished or satisfied'),
                  const _NumberedItem('4', 'Mother feels relaxed'),
                ],
              ),
            ),
          ),

          const SizedBox(height: 24),

          // WARNING
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.lightBlue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                    'NB: During breastfeeding, show the mother correct positioning and good attachment.',
                    style: TextStyle(fontStyle: FontStyle.italic)),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade800),
                    const SizedBox(width: 8),
                    Expanded(
                        child: Text(
                            'If breast milk is not enough, immediately visit a health facility.',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900))),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  final String text;
  const _ChecklistItem(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.check_box_outlined, color: Colors.pink.shade300, size: 22),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

class _NumberedItem extends StatelessWidget {
  final String number;
  final String text;
  const _NumberedItem(this.number, this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$number. ',
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 15))),
        ],
      ),
    );
  }
}

class _CheckboxLabel extends StatelessWidget {
  final String label;
  const _CheckboxLabel(this.label);
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(border: Border.all(color: Colors.grey))),
      const SizedBox(width: 8),
      Text(label),
    ]);
  }
}

// -----------------------------------------------------------------------------
// TAB 2: AGE BASED FEEDING
// -----------------------------------------------------------------------------

class _AgeBasedFeedingTab extends StatelessWidget {
  const _AgeBasedFeedingTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Text(
            'Select your child\'s age to see recommendations.',
            style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
          ),
          SizedBox(height: 16),
          // 0 - 6 Months
          _AgeGroupCard(
            ageLabel: '0 - 6 Months',
            title: 'Exclusive Breastfeeding',
            color: Colors.pink,
            icon: Icons.baby_changing_station,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SectionHeader('Newborn to 1 Week'),
                _BulletPoint('Skin-to-skin contact immediately after birth.'),
                _BulletPoint(
                    'Start breastfeeding within the first hour (give Colostrum).'),
                _BulletPoint('Feed on demand (day & night, 8+ times in 24h).'),
                _BulletPoint('Do NOT give other foods or water.'),
                SizedBox(height: 12),
                _SectionHeader('1 Week to 6 Months'),
                _BulletPoint('Breastfeed as often as the child wants.'),
                _BulletPoint(
                    'Look for hunger signs (sucking lips, moving mouth).'),
                _BulletPoint('Feed on demand (8+ times/day).'),
                _BulletPoint('Breast milk is ALL your baby needs.'),
              ],
            ),
          ),
          // 6 Months
          _AgeGroupCard(
            ageLabel: '6 Months',
            title: 'Start Complementary Feeding',
            color: Colors.orange,
            icon: Icons.rice_bowl,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelValueRow(
                    'Texture', 'Thick porridge or well mashed/pureed foods.'),
                _LabelValueRow('Frequency',
                    '2 times a day (plus frequent breastfeeding).'),
                _LabelValueRow('Amount',
                    '2-3 tablespoons per meal. Increase to 3-4 tbsp by 4th week.'),
                SizedBox(height: 8),
                _InfoNote('Add simple, mashed variations of food groups.'),
              ],
            ),
          ),
          // 7-8 Months
          _AgeGroupCard(
            ageLabel: '7 - 8 Months',
            title: 'More Texture & Variety',
            color: Colors.green,
            icon: Icons.dinner_dining,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelValueRow('Texture',
                    'Mashed family foods. Baby can start eating finger foods.'),
                _LabelValueRow('Frequency',
                    '3 times a day (plus frequent breastfeeding).'),
                _LabelValueRow(
                    'Amount', 'Increase to half (½) cup (250ml cup).'),
              ],
            ),
          ),
          // 9-11 Months
          _AgeGroupCard(
            ageLabel: '9 - 11 Months',
            title: 'Finely Chopped Foods',
            color: Colors.teal,
            icon: Icons.restaurant,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelValueRow('Texture',
                    'Finely chopped or mashed foods. Foods baby can pick up.'),
                _LabelValueRow(
                    'Frequency', '4 times a day (3 meals, 1 snack).'),
                _LabelValueRow('Amount', '¾ of a cup/bowl (250 ml).'),
              ],
            ),
          ),
          // 1-2 Years
          _AgeGroupCard(
            ageLabel: '1 - 2 Years',
            title: 'Family Foods',
            color: Colors.purple,
            icon: Icons.emoji_food_beverage,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelValueRow('Texture', 'Cut food into small, soft pieces.'),
                _LabelValueRow('Frequency',
                    '5 times a day (3 meals, 2 snacks). Breastfeed after meals.'),
                _LabelValueRow('Amount', '1 full cup (250 ml).'),
              ],
            ),
          ),
          // 2-5 Years
          _AgeGroupCard(
            ageLabel: '2 - 5 Years',
            title: 'Growing Child',
            color: Colors.deepPurple,
            icon: Icons.face,
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _LabelValueRow('Texture', 'Cut food into small, soft pieces.'),
                _LabelValueRow(
                    'Frequency', '5 times a day (3 meals, 2 snacks).'),
                _LabelValueRow('Amount', '1½ to 2 cups.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// TAB 2: SICK CHILD
// -----------------------------------------------------------------------------

class _SickChildFeedingTab extends StatelessWidget {
  const _SickChildFeedingTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          _SickChildCard(
            title: 'During Illness',
            color: Colors.red,
            icon: Icons.sick,
            items: [
              'Encourage the child to drink and eat with lots of patience.',
              'Feed small amounts frequently.',
              'Give foods that the child likes.',
              'Give a variety of nutrient-rich foods.',
              'Continue to breastfeed – often ill children breastfeed more frequently.',
            ],
          ),
          SizedBox(height: 16),
          _SickChildCard(
            title: 'During Recovery',
            color: Colors.green,
            icon: Icons.healing,
            items: [
              'Give extra breastfeeds.',
              'Feed an extra meal.',
              'Give extra amount of food.',
              'Use extra rich foods.',
              'Feed with extra patience and love.',
            ],
          ),
        ],
      ),
    );
  }
}

class _SickChildCard extends StatelessWidget {
  final String title;
  final Color color;
  final IconData icon;
  final List<String> items;

  const _SickChildCard({
    required this.title,
    required this.color,
    required this.icon,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
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
                Icon(icon, color: color, size: 28),
                const SizedBox(width: 12),
                Text(
                  title.toUpperCase(),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: items
                  .map((item) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.check, size: 20, color: color),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item,
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

// -----------------------------------------------------------------------------
// TAB 3: GENERAL TIPS
// -----------------------------------------------------------------------------

class _GeneralNutritionTipsTab extends StatelessWidget {
  const _GeneralNutritionTipsTab();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hygiene
          const _TipSectionHeader(title: 'Observe Hygiene', icon: Icons.wash),
          const SizedBox(height: 8),
          const Text(
            '• Wash your hands at critical times (after toilet, after cleaning baby, before cooking, before feeding).\n'
            '• Keep cooking surfaces and utensils clean.\n'
            '• Keep play items and areas clean.',
            style: TextStyle(height: 1.5, fontSize: 14),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Food Groups
          const _TipSectionHeader(title: '7 Food Groups', icon: Icons.category),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: const Text(
              'Feed your child at least 4 of these 7 food groups daily.',
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 12),
          const _FoodGroupItem('1', 'Grain, grain products and starchy foods'),
          const _FoodGroupItem('2', 'Legumes, pulses, nuts and seeds'),
          const _FoodGroupItem('3', 'Dairy and dairy products'),
          const _FoodGroupItem('4', 'Eggs'),
          const _FoodGroupItem(
              '5', 'Flesh foods (beef, poultry, fish, insects)'),
          const _FoodGroupItem('6', 'Vitamin A rich fruits and vegetables'),
          const _FoodGroupItem('7', 'Other fruits and vegetables'),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 16),

          // Non-breastfed
          const _TipSectionHeader(
              title: 'For Non-Breastfed Babies', icon: Icons.no_food),
          const SizedBox(height: 8),
          const Text(
              'If infant is < 6 months, consult your health care worker.',
              style: TextStyle(fontStyle: FontStyle.italic)),
          const SizedBox(height: 8),
          const Text('Depending on age, give in addition:'),
          const Padding(
              padding: EdgeInsets.only(left: 16, top: 4),
              child: Text('• 1-2 cups of milk per day')),
          const Padding(
              padding: EdgeInsets.only(left: 16, top: 4),
              child: Text('• 1-2 extra meals per day')),
          const Padding(
              padding: EdgeInsets.only(left: 16, top: 4),
              child: Text('• 2-3 cups water per day')),
        ],
      ),
    );
  }
}

class _FoodGroupItem extends StatelessWidget {
  final String number;
  final String text;

  const _FoodGroupItem(this.number, this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Text(number,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 14))),
        ],
      ),
    );
  }
}

class _TipSectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;

  const _TipSectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.blueGrey),
        const SizedBox(width: 8),
        Text(title,
            style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey)),
      ],
    );
  }
}

// -----------------------------------------------------------------------------
// SHARED WIDGETS
// -----------------------------------------------------------------------------

class _AgeGroupCard extends StatelessWidget {
  final String ageLabel;
  final String title;
  final Color color;
  final IconData icon;
  final Widget content;

  const _AgeGroupCard({
    required this.ageLabel,
    required this.title,
    required this.color,
    required this.icon,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: false,
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color),
          ),
          title: Text(
            ageLabel,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: color,
            ),
          ),
          subtitle: Text(title,
              style: TextStyle(fontSize: 13, color: Colors.grey[700])),
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: content,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            decoration: TextDecoration.underline),
      ),
    );
  }
}

class _BulletPoint extends StatelessWidget {
  final String text;
  const _BulletPoint(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(text,
                  style: const TextStyle(fontSize: 14, height: 1.3))),
        ],
      ),
    );
  }
}

class _LabelValueRow extends StatelessWidget {
  final String label;
  final String value;
  const _LabelValueRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.blueGrey),
            ),
          ),
          Expanded(
            child:
                Text(value, style: const TextStyle(fontSize: 14, height: 1.3)),
          ),
        ],
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  final String text;
  const _InfoNote(this.text);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline, size: 16, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
              child: Text(text,
                  style: const TextStyle(
                      fontSize: 12, fontStyle: FontStyle.italic))),
        ],
      ),
    );
  }
}
