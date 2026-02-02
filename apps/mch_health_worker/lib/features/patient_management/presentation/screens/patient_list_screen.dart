import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/supabase_providers.dart';
import '../../../../core/utils/error_helper.dart';
import 'patient_registration_screen.dart';
import 'patient_detail_screen.dart';
import '/../../core/widgets/offline_indicator.dart';

/// Clean Patient List Screen
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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      drawer: widget.drawer,
      appBar: AppBar(
        title: const Text('Patients'),
        actions: [
          const OfflineIndicator(),
          const SizedBox(width: 4),
          const SyncButton(),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () => ref.invalidate(maternalProfilesProvider),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            tooltip: 'Filter',
            onSelected: (value) => setState(() => _filterBy = value),
            itemBuilder: (context) => const [
              PopupMenuItem(value: 'All', child: Text('All Patients')),
              PopupMenuItem(value: 'High Risk', child: Text('High Risk')),
              PopupMenuItem(value: 'Due Soon', child: Text('Due Soon')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? const Color(0xFF1E1E1E) : Colors.grey[50],
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or ANC number...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onChanged: (value) =>
                  setState(() => _searchQuery = value.toLowerCase()),
            ),
          ),

          // Filter Chip (if active)
          if (_filterBy != 'All')
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerLeft,
              child: Chip(
                label: Text(_filterBy),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () => setState(() => _filterBy = 'All'),
              ),
            ),

          // Patient List
          Expanded(
            child: profilesAsync.when(
              data: (profiles) => _buildPatientList(profiles),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => ErrorHelper.buildErrorWidget(
                error,
                onRetry: () => ref.invalidate(maternalProfilesProvider),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (_) => const PatientRegistrationScreen()),
          );
        },
        icon: const Icon(Icons.person_add),
        label: const Text('New Patient'),
      ),
    );
  }

  Widget _buildPatientList(List<MaternalProfile> profiles) {
    // Apply filters
    var filtered = profiles.where((p) {
      // Search filter
      if (_searchQuery.isNotEmpty) {
        final matchesSearch =
            p.clientName.toLowerCase().contains(_searchQuery) ||
                p.ancNumber.toLowerCase().contains(_searchQuery);
        if (!matchesSearch) return false;
      }

      // Category filter
      switch (_filterBy) {
        case 'High Risk':
          return _isHighRisk(p);
        case 'Due Soon':
          if (p.edd == null) return false;
          final days = p.edd!.difference(DateTime.now()).inDays;
          return days >= 0 && days <= 30;
        default:
          return true;
      }
    }).toList();

    if (filtered.isEmpty) {
      return _buildEmptyState();
    }

    // Stats
    final highRiskCount = filtered.where(_isHighRisk).length;
    final dueSoonCount = filtered.where((p) {
      if (p.edd == null) return false;
      final days = p.edd!.difference(DateTime.now()).inDays;
      return days >= 0 && days <= 30;
    }).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return Column(
          children: [
            // Summary Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  _buildStatChip('${filtered.length}', 'Total', Colors.blue),
                  const SizedBox(width: 12),
                  _buildStatChip('$highRiskCount', 'High Risk', Colors.red),
                  const SizedBox(width: 12),
                  _buildStatChip('$dueSoonCount', 'Due Soon', Colors.orange),
                ],
              ),
            ),

            // List/Grid
            Expanded(
              child: isDesktop
                  ? _buildDesktopPatientGrid(filtered, constraints.maxWidth)
                  : ListView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final patient = filtered[index];
                        return _buildPatientCard(patient);
                      },
                    ),
            ),
          ],
        );
      },
    );
  }

  /// Desktop grid layout for patient cards
  Widget _buildDesktopPatientGrid(
      List<MaternalProfile> patients, double availableWidth) {
    // Calculate optimal card width and column count
    const minCardWidth = 380.0;
    const maxCardWidth = 500.0;
    const spacing = 16.0;
    const horizontalPadding = 24.0;

    final usableWidth = availableWidth - (horizontalPadding * 2);
    final columnCount = (usableWidth / minCardWidth).floor().clamp(1, 3);
    final cardWidth =
        ((usableWidth - (spacing * (columnCount - 1))) / columnCount)
            .clamp(minCardWidth, maxCardWidth);

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 80),
      child: Center(
        child: Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: patients.map((patient) {
            return SizedBox(
              width: cardWidth,
              child: _buildPatientCard(patient),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildStatChip(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: color,
              fontSize: 14,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientCard(MaternalProfile patient) {
    final daysUntilDue = patient.edd?.difference(DateTime.now()).inDays;
    final isHighRisk = _isHighRisk(patient);
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: isHighRisk
              ? Colors.red.shade100
              : theme.colorScheme.primaryContainer,
          child: Text(
            patient.clientName.isNotEmpty
                ? patient.clientName[0].toUpperCase()
                : '?',
            style: TextStyle(
              color: isHighRisk
                  ? Colors.red.shade700
                  : theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                patient.clientName,
                style: const TextStyle(fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            if (isHighRisk)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'HIGH RISK',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'ANC: ${patient.ancNumber.isNotEmpty ? patient.ancNumber : "Not Assigned"}',
              style: theme.textTheme.bodySmall,
              overflow: TextOverflow.ellipsis,
            ),
            if (patient.edd != null) ...[
              const SizedBox(height: 2),
              Row(
                children: [
                  Text(
                    'EDD: ${_formatDate(patient.edd!)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  if (daysUntilDue != null &&
                      daysUntilDue >= 0 &&
                      daysUntilDue <= 30) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        '$daysUntilDue days',
                        style: TextStyle(
                          color: Colors.orange.shade800,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          if (patient.id != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PatientDetailScreen(patientId: patient.id!),
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            _searchQuery.isEmpty ? Icons.people_outline : Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isEmpty
                ? 'No patients registered'
                : 'No patients found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isEmpty
                ? 'Register your first patient to get started'
                : 'Try a different search term',
            style: TextStyle(color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
