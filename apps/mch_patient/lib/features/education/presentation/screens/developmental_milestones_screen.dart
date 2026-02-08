import 'package:flutter/material.dart';

class DevelopmentalMilestonesScreen extends StatelessWidget {
  const DevelopmentalMilestonesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Developmental Milestones'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Improved Tip Card
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.amber.shade200),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.amber.shade300),
                    ),
                    child: const Icon(Icons.lightbulb,
                        color: Colors.amber, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Important Note',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber.shade900,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Milestones might occur within a range or be slightly delayed. If you notice a significant delay, please seek further assessment at a health facility.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.brown.shade800,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Timeline UI
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Column(
                children: [
                  _TimelineItem(
                    isFirst: true,
                    ageRange: '0 - 2 Months',
                    color: Colors.pinkAccent,
                    icon: Icons.child_care,
                    milestones: [
                      'Social smile',
                      'Follows a colorful object dangled before their eyes',
                    ],
                  ),
                  _TimelineItem(
                    ageRange: '2 - 4 Months',
                    color: Colors.purpleAccent,
                    icon: Icons.face,
                    milestones: [
                      'Holds the head upright',
                      'Follows the object or face with their eyes',
                      'Turns head to sounds',
                      'Smiles when you speak',
                    ],
                  ),
                  _TimelineItem(
                    ageRange: '4 - 6 Months',
                    color: Colors.deepPurpleAccent,
                    icon: Icons.toys,
                    milestones: [
                      'Rolls over',
                      'Reaches for and grasps objects',
                      'Takes objects to mouth',
                      'Babbles (makes sounds)',
                    ],
                  ),
                  _TimelineItem(
                    ageRange: '6 - 9 Months',
                    color: Colors.indigoAccent,
                    icon: Icons.airline_seat_recline_normal,
                    milestones: [
                      'Sits without support',
                      'Transfers object hand-to-hand',
                      'Repeats syllables (bababa, mamama)',
                    ],
                  ),
                  _TimelineItem(
                    ageRange: '9 - 12 Months',
                    color: Colors.blueAccent,
                    icon: Icons.directions_walk,
                    milestones: [
                      'Takes steps with support',
                      'Picks up small object with 2 fingers',
                      'Says 2-3 words',
                      'Imitates simple gestures (claps, bye)',
                    ],
                  ),
                  _TimelineItem(
                    ageRange: '12 - 18 Months',
                    color: Colors.teal,
                    icon: Icons.emoji_people,
                    milestones: [
                      'Walks without support',
                      'Drinks from a cup',
                      'Says 7-10 words',
                      'Points to body parts on request',
                    ],
                  ),
                  _TimelineItem(
                    ageRange: '18 - 24 Months',
                    color: Colors.green,
                    icon: Icons.sports_soccer,
                    milestones: [
                      'Kicks a ball',
                      'Builds tower with 3 blocks',
                      'Points at pictures on request',
                      'Speaks in short sentences',
                    ],
                  ),
                  _TimelineItem(
                    isLast: true,
                    ageRange: '24 Months +',
                    color: Colors.orange,
                    icon: Icons.school,
                    milestones: [
                      'Jumps',
                      'Dresses/undresses self',
                      'Says name, tells short story',
                      'Plays with other children',
                    ],
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

class _TimelineItem extends StatelessWidget {
  final String ageRange;
  final Color color;
  final IconData icon;
  final List<String> milestones;
  final bool isFirst;
  final bool isLast;

  const _TimelineItem({
    required this.ageRange,
    required this.color,
    required this.icon,
    required this.milestones,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line & Connector
          SizedBox(
            width: 40,
            child: Column(
              children: [
                // Top Line
                Expanded(
                  flex: 1,
                  child: Container(
                    width: 2,
                    color: isFirst
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
                // Dot
                Container(
                  width: 16,
                  height: 16,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: color.withOpacity(0.4),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                ),
                // Bottom Line
                Expanded(
                  flex: 10,
                  child: Container(
                    width: 2,
                    color: isLast
                        ? Colors.transparent
                        : Colors.grey.withOpacity(0.3),
                  ),
                ),
              ],
            ),
          ),

          // Content Card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: color.withOpacity(0.1),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(icon, color: color, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            ageRange,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: color,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Body
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: milestones
                            .map((m) => Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Icon(Icons.check,
                                            size: 16,
                                            color: color.withOpacity(0.8)),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: Text(
                                          m,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.color,
                                            height: 1.3,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
