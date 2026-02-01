import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '/../core/providers/growth_monitoring_providers.dart';
import 'growth_record_screen.dart';
import 'growth_history_screen.dart';
import 'immunization_card_screen.dart';
import 'vit_a_deworming_screen.dart';
import 'developmental_milestone_screen.dart';

class ChildDetailScreen extends ConsumerStatefulWidget {
  final ChildProfile child;

  const ChildDetailScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ChildDetailScreen> createState() => _ChildDetailScreenState();
}

class _ChildDetailScreenState extends ConsumerState<ChildDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final latestGrowthAsync =
        ref.watch(latestGrowthRecordProvider(widget.child.id));

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.child.childName),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [
            Tab(text: 'Profile'),
            Tab(text: 'Growth'),
            Tab(text: 'Immunizations'),
            Tab(text: 'Vit A & Deworming'),
            Tab(text: 'Milestones')
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildProfileTab(),
          _buildGrowthTab(latestGrowthAsync),
          _buildImmunizationsTab(),
          VitaminADewormingCardScreen(child: widget.child),
          DevelopmentalMilestonesScreen(child: widget.child),
        ],
      ),
    );
  }

  Widget _buildProfileTab() {
    final child = widget.child;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Card
          Card(
            color: Colors.blue.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor:
                        child.sex == 'Male' ? Colors.blue : Colors.pink,
                    child: Icon(
                      child.sex == 'Male' ? Icons.boy : Icons.girl,
                      size: 48,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          child.childName,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Sex: ${child.sex}',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        Text(
                          'Age: ${_calculateAge(child.dateOfBirth)}',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.blue.shade900,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Birth Information Section
          _buildSectionHeader(context, 'Birth Information'),
          const SizedBox(height: 12),
          _buildInfoCard(context, [
            _buildInfoRow('Date of Birth', _formatDate(child.dateOfBirth)),
            _buildInfoRow(
                'Birth Weight', '${child.birthWeightGrams / 1000} kg'),
            _buildInfoRow('Birth Length', '${child.birthLengthCm} cm'),
            if (child.headCircumferenceCm != null)
              _buildInfoRow(
                  'Head Circumference', '${child.headCircumferenceCm} cm'),
            _buildInfoRow('Place of Birth', child.placeOfBirth),
            if (child.healthFacilityName != null)
              _buildInfoRow('Health Facility', child.healthFacilityName!),
            _buildInfoRow(
                'Gestational Age', '${child.gestationAtBirthWeeks} weeks'),
          ]),
          const SizedBox(height: 24),

          // Family Information Section
          _buildSectionHeader(context, 'Family Information'),
          const SizedBox(height: 12),
          _buildInfoCard(context, [
            _buildInfoRow('Mother', child.motherName ?? 'N/A'),
            if (child.motherPhone != null)
              _buildInfoRow('Mother\'s Phone', child.motherPhone!),
            if (child.fatherName != null)
              _buildInfoRow('Father', child.fatherName!),
          ]),
          const SizedBox(height: 24),

          // Special Care Required Section
          if (child.hivExposed == true ||
              child.birthWeightGrams < 2500 ||
              (child.bornOfTeenageMother == true)) ...[
            _buildSectionHeader(context, 'Special Care Required'),
            const SizedBox(height: 12),
            _buildInfoCard(context, [
              if (child.hivExposed == true)
                _buildAlertRow(
                  'HIV Exposed',
                  'Special monitoring required',
                  Colors.red,
                ),
              if (child.birthWeightGrams < 2500)
                _buildAlertRow(
                  'Low Birth Weight',
                  'Birth weight: ${child.birthWeightGrams / 1000} kg',
                  Colors.orange,
                ),
              if (child.bornOfTeenageMother == true)
                _buildAlertRow(
                  'Teenage Mother',
                  'Additional support needed',
                  Colors.blue,
                ),
            ]),
          ],
        ],
      ),
    );
  }

  Widget _buildGrowthTab(AsyncValue<GrowthRecord?> latestGrowthAsync) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Latest Measurement Card
          Text(
            'Latest Measurement',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 12),

          latestGrowthAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Card(
              color: Colors.red.shade50,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('Error: $error'),
              ),
            ),
            data: (latestGrowth) {
              if (latestGrowth == null) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(
                      child: Column(
                        children: [
                          Icon(Icons.height,
                              size: 48, color: Colors.grey.shade400),
                          const SizedBox(height: 8),
                          Text(
                            'No measurements recorded yet',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }

              return Card(
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(latestGrowth.measurementDate),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '${latestGrowth.ageInMonths} months',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMeasurementTile(
                              'Weight',
                              '${latestGrowth.weightKg} kg',
                              Icons.monitor_weight,
                              Colors.green,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMeasurementTile(
                              latestGrowth.lengthCm != null
                                  ? 'Length'
                                  : 'Height',
                              '${latestGrowth.lengthCm ?? latestGrowth.heightCm ?? 'N/A'} cm',
                              Icons.height,
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // Action Buttons
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddGrowthRecordScreen(
                      childId: widget.child.id,
                      child: widget.child,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
              label: const Text('Add New Measurement'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GrowthHistoryScreen(
                      childId: widget.child.id,
                      child: widget.child,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.history),
              label: const Text('View Full History & Chart'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Growth Chart Placeholder
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.show_chart, size: 48, color: Colors.grey.shade400),
                  const SizedBox(height: 8),
                  Text(
                    'Growth Chart',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Coming Soon',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImmunizationsTab() {
    return ImmunizationCardScreen(child: widget.child);
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade900,
          ),
    );
  }

  Widget _buildInfoCard(BuildContext context, List<Widget> children) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertRow(String label, String description, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: color,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMeasurementTile(
    String label,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    final age = now.difference(dateOfBirth);
    final years = age.inDays ~/ 365;
    final months = (age.inDays % 365) ~/ 30;
    final days = (age.inDays % 365) % 30;

    if (years > 0) {
      return '$years year${years > 1 ? 's' : ''} $months month${months != 1 ? 's' : ''}';
    } else if (months > 0) {
      return '$months month${months != 1 ? 's' : ''} $days day${days != 1 ? 's' : ''}';
    } else {
      return '$days day${days != 1 ? 's' : ''}';
    }
  }
}
