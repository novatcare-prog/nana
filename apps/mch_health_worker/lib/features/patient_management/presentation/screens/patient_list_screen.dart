import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/utils/error_helper.dart';
import 'patient_registration_screen.dart';

import '/../../core/widgets/offline_indicator.dart';
import '../widgets/patient_card.dart';

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
          style: const TextStyle(color: Color.fromARGB(255, 7, 0, 0)),
          decoration: InputDecoration(
            hintText: 'Search patients...',
            hintStyle: TextStyle(
                color: const Color.fromARGB(255, 4, 104, 186)
                    .withValues(alpha: 0.7)),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(22), // Rounded corners
                borderSide: BorderSide(width: 1, color: Color(0xFF2196F3))),
            prefixIcon: const Icon(Icons.search, color: Color(0xFF2196F3)),
            suffixIcon: _searchQuery.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear,
                        color: Color.fromARGB(255, 45, 4, 169)),
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
          const OfflineIndicator(),
          const SizedBox(width: 8),
          const SyncButton(),
          const SizedBox(width: 8),
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
              final matchesSearch =
                  profile.clientName.toLowerCase().contains(_searchQuery) ||
                      profile.ancNumber.toLowerCase().contains(_searchQuery);
              if (!matchesSearch) return false;
            }

            // Category filter
            switch (_filterBy) {
              case 'High Risk':
                return _isHighRisk(profile);
              case 'Due Soon':
                if (profile.edd == null) return false;
                final daysUntilDue =
                    profile.edd!.difference(DateTime.now()).inDays;
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
                    _searchQuery.isEmpty
                        ? Icons.people_outline
                        : Icons.search_off,
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
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    return PatientCard(patient: patient);
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => ErrorHelper.buildErrorWidget(
          error,
          onRetry: () => ref.invalidate(maternalProfilesProvider),
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
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
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
}
