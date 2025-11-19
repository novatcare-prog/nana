import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import 'patient_registration_screen.dart';
import 'patient_detail_screen.dart';

/// Patient List Screen - Shows all registered patients with search and filter
/// IMPROVED VERSION with UX fixes based on clinical workflow
class PatientListScreen extends ConsumerStatefulWidget {
  final Widget? drawer;

  const PatientListScreen({super.key, this.drawer});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _filterBy = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Helper method to get high risk reasons for a patient
  /// Based on MOH MCH Handbook 2020 - Page 26
  List<String> _getHighRiskReasons(MaternalProfile patient) {
    List<String> reasons = [];
    
    if (patient.diabetes == true) reasons.add('Diabetes');
    if (patient.hypertension == true) reasons.add('Hypertension');
    if (patient.previousCs == true) reasons.add('Previous CS');
    if (patient.age > 35) reasons.add('Age >35');
    if (patient.age < 18) reasons.add('Age <18');
    
    return reasons;
  }

  bool _isHighRisk(MaternalProfile patient) {
    return patient.diabetes == true ||
        patient.hypertension == true ||
        patient.previousCs == true ||
        patient.age > 35 ||
        patient.age < 18;
  }

  @override
  Widget build(BuildContext context) {
    final profilesAsync = ref.watch(maternalProfilesProvider);

    return Scaffold(
      drawer: widget.drawer,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search patients...',
            hintStyle: TextStyle(color: Colors.white.withOpacity(0.7)),
            border: InputBorder.none,
            prefixIcon: const Icon(Icons.search, color: Colors.white),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  )
                : null,
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value.toLowerCase();
            });
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(maternalProfilesProvider),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter patients',
            onSelected: (value) {
              setState(() {
                _filterBy = value;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'All', child: Text('All Patients')),
              const PopupMenuItem(value: 'High Risk', child: Text('High Risk')),
              const PopupMenuItem(value: 'Due Soon', child: Text('Due Soon')),
              const PopupMenuItem(value: 'Active', child: Text('Active')),
            ],
          ),
        ],
      ),
      body: profilesAsync.when(
        data: (profiles) {
          // Filter profiles
          var filteredProfiles = profiles.where((profile) {
            // Search filter
            if (_searchQuery.isNotEmpty) {
              final matchesSearch = profile.clientName.toLowerCase().contains(_searchQuery) ||
                  profile.ancNumber.toLowerCase().contains(_searchQuery);
              if (!matchesSearch) return false;
            }

            // Category filter
            switch (_filterBy) {
              case 'High Risk':
                return _isHighRisk(profile);
              case 'Due Soon':
                if (profile.edd == null) return false;
                final daysUntilDue = profile.edd!.difference(DateTime.now()).inDays;
                return daysUntilDue >= 0 && daysUntilDue <= 30;
              case 'Active':
                return profile.edd?.isAfter(DateTime.now()) ?? false;
              default:
                return true;
            }
          }).toList();

          if (filteredProfiles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _searchQuery.isEmpty ? Icons.people_outline : Icons.search_off,
                    size: 64,
                    color: Colors.grey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _searchQuery.isEmpty
                        ? 'No patients registered yet'
                        : 'No patients found',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _searchQuery.isEmpty
                        ? 'Register your first patient to get started'
                        : 'Try a different search term',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          // Calculate summary stats
          final highRiskCount = filteredProfiles.where(_isHighRisk).length;
          final dueSoonCount = filteredProfiles.where((p) {
            if (p.edd == null) return false;
            final days = p.edd!.difference(DateTime.now()).inDays;
            return days >= 0 && days <= 30;
          }).length;

          return Column(
            children: [
              // COMPRESSED Summary Bar (single row of chips)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: Row(
                  children: [
                    _buildCompactSummaryChip(
                      context,
                      'Total',
                      filteredProfiles.length,
                      Colors.blue,
                      Icons.people,
                    ),
                    const SizedBox(width: 8),
                    _buildCompactSummaryChip(
                      context,
                      'High Risk',
                      highRiskCount,
                      Colors.red,
                      Icons.warning,
                    ),
                    const SizedBox(width: 8),
                    _buildCompactSummaryChip(
                      context,
                      'Due Soon',
                      dueSoonCount,
                      Colors.orange,
                      Icons.calendar_today,
                    ),
                    const Spacer(),
                    // Filter indicator
                    if (_filterBy != 'All')
                      Chip(
                        label: Text(
                          _filterBy,
                          style: const TextStyle(fontSize: 12),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _filterBy = 'All';
                          });
                        },
                      ),
                  ],
                ),
              ),

              // Patient List - More space for cards
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: filteredProfiles.length,
                  itemBuilder: (context, index) {
                    final patient = filteredProfiles[index];
                    return _buildPatientCard(context, patient);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(maternalProfilesProvider),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const PatientRegistrationScreen(),
            ),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('New Patient'),
      ),
    );
  }

  /// Compact summary chip (replaces large cards)
  Widget _buildCompactSummaryChip(
    BuildContext context,
    String label,
    int value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            '$value',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(BuildContext context, MaternalProfile patient) {
    final daysUntilDue = patient.edd?.difference(DateTime.now()).inDays;
    final isHighRisk = _isHighRisk(patient);
    final highRiskReasons = _getHighRiskReasons(patient);
    final isDueSoon = daysUntilDue != null && daysUntilDue >= 0 && daysUntilDue <= 30;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      elevation: isHighRisk ? 2 : 1,
      child: ListTile(
        // IMPROVED AVATAR - Neutral colors for default, red only for high risk
        leading: CircleAvatar(
          backgroundColor: isHighRisk
              ? Colors.red
              : isDueSoon
                  ? Colors.orange
                  : Colors.grey[400], // Neutral grey instead of blue
          child: Text(
            patient.clientName.isNotEmpty 
                ? patient.clientName.substring(0, 1).toUpperCase()
                : '?',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          patient.clientName,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // IMPROVED ANC DISPLAY - Show "Not Assigned" if empty
            Text(
              patient.ancNumber.isNotEmpty 
                  ? 'ANC: ${patient.ancNumber} • Age: ${patient.age}'
                  : 'ANC: Not Assigned • Age: ${patient.age}',
            ),
            Text(
              patient.edd != null
                  ? 'EDD: ${_formatDate(patient.edd!)} (${daysUntilDue ?? 0} days)'
                  : 'EDD: Not set',
            ),
            // IMPROVED HIGH RISK DISPLAY - Show specific reasons
            if (isHighRisk && highRiskReasons.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Row(
                  children: [
                    const Icon(Icons.warning, size: 16, color: Colors.red),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        'High Risk: ${highRiskReasons.join(", ")}',
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                // ✅ FIXED: Navigate to patient detail screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PatientDetailScreen(
                      patientId: patient.id,
                    ),
                  ),
                );
                break;
              case 'visit':
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Record visit for ${patient.clientName} - Coming soon'),
                  ),
                );
                break;
              case 'edit':
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit patient - Coming soon')),
                );
                break;
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility),
                  SizedBox(width: 8),
                  Text('View Details'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'visit',
              child: Row(
                children: [
                  Icon(Icons.add_circle),
                  SizedBox(width: 8),
                  Text('Record Visit'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'edit',
              child: Row(
                children: [
                  Icon(Icons.edit),
                  SizedBox(width: 8),
                  Text('Edit'),
                ],
              ),
            ),
          ],
        ),
        // ✅ FIXED: Navigate to patient detail screen on tap
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PatientDetailScreen(
                patientId: patient.id,
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}