import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '/../../core/providers/child_immunization_providers.dart';
import '/../../../core/providers/auth_providers.dart';
import '../../../../core/utils/error_helper.dart';

class AddImmunizationScreen extends ConsumerStatefulWidget {
  final ChildProfile child;

  const AddImmunizationScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AddImmunizationScreen> createState() =>
      _AddImmunizationScreenState();
}

class _AddImmunizationScreenState extends ConsumerState<AddImmunizationScreen> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  ImmunizationType? _selectedVaccine;
  DateTime _dateGiven = DateTime.now();
  int? _doseNumber;

  DateTime? _expiryDate;
  String? _route;
  String? _site;
  bool _adverseReaction = false;

  String? _reactionSeverity;

  bool _bcgScarChecked = false;
  bool? _bcgScarPresent;

  final _batchNumberController = TextEditingController();
  final _notesController = TextEditingController();
  final _reactionDetailsController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _batchNumberController.dispose();
    _notesController.dispose();
    _reactionDetailsController.dispose();
    super.dispose();
  }

  Future<void> _saveImmunization() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedVaccine == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a vaccine')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final userProfile = ref.read(currentUserProfileProvider).value;
      final ageInDays = _dateGiven.difference(widget.child.dateOfBirth).inDays;
      final ageInWeeks = ageInDays ~/ 7;
      final ageInMonths = ageInDays ~/ 30;

      final immunization = ImmunizationRecord(
        childId: widget.child.id,
        vaccineType: _selectedVaccine!,
        vaccineName: _selectedVaccine!.label,
        dateGiven: _dateGiven,
        ageInWeeks: ageInWeeks,
        ageAtVaccinationWeeks: ageInWeeks,
        ageAtVaccinationMonths: ageInMonths,
        doseNumber: _doseNumber,
        batchNumber: _batchNumberController.text.isNotEmpty
            ? _batchNumberController.text
            : null,
        expiryDate: _expiryDate,
        administrationRoute: _route,
        administrationSite: _site,
        adverseEventReported: _adverseReaction,
        adverseEventDescription:
            _adverseReaction ? _reactionDetailsController.text : null,
        reactionSeverity: _adverseReaction ? _reactionSeverity : null,
        bcgScarChecked:
            _selectedVaccine == ImmunizationType.bcg ? _bcgScarChecked : null,
        bcgScarPresent:
            _selectedVaccine == ImmunizationType.bcg ? _bcgScarPresent : null,
        givenBy: userProfile?.fullName,
        healthFacilityName: userProfile?.fullName,
        notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      final createImmunization = ref.read(createImmunizationProvider);
      await createImmunization(immunization);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Immunization record saved successfully!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ErrorHelper.showErrorSnackbar(context, e);
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Immunization - ${widget.child.childName}'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Form(
              key: _formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Child Info
                    _buildChildInfoCard(),
                    const SizedBox(height: 24),

                    // Vaccine Selection
                    Text(
                      'Vaccine Information',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<ImmunizationType>(
                      value: _selectedVaccine,
                      decoration: const InputDecoration(
                        labelText: 'Vaccine *',
                        border: OutlineInputBorder(),
                      ),
                      items: ImmunizationType.values.map((vaccine) {
                        return DropdownMenuItem(
                          value: vaccine,
                          child: Text(vaccine.label),
                        );
                      }).toList(),
                      onChanged: (value) =>
                          setState(() => _selectedVaccine = value),
                      validator: (value) =>
                          value == null ? 'Please select a vaccine' : null,
                    ),
                    const SizedBox(height: 16),

                    // Date Given
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Date Given *'),
                      subtitle: Text(_formatDate(_dateGiven)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _dateGiven,
                          firstDate: widget.child.dateOfBirth,
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() => _dateGiven = date);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Dose Number
                    DropdownButtonFormField<int>(
                      value: _doseNumber,
                      decoration: const InputDecoration(
                        labelText: 'Dose Number',
                        border: OutlineInputBorder(),
                      ),
                      items: [1, 2, 3, 4].map((dose) {
                        return DropdownMenuItem(
                          value: dose,
                          child: Text('Dose $dose'),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _doseNumber = value),
                    ),
                    const SizedBox(height: 24),

                    // Administration Details
                    Text(
                      'Administration Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),

                    DropdownButtonFormField<String>(
                      value: _route,
                      decoration: const InputDecoration(
                        labelText: 'Route',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Oral', child: Text('Oral')),
                        DropdownMenuItem(
                            value: 'IM', child: Text('Intramuscular (IM)')),
                        DropdownMenuItem(
                            value: 'SC', child: Text('Subcutaneous (SC)')),
                        DropdownMenuItem(
                            value: 'ID', child: Text('Intradermal (ID)')),
                      ],
                      onChanged: (value) => setState(() => _route = value),
                    ),
                    const SizedBox(height: 16),

                    DropdownButtonFormField<String>(
                      value: _site,
                      decoration: const InputDecoration(
                        labelText: 'Site',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'Left arm', child: Text('Left arm')),
                        DropdownMenuItem(
                            value: 'Right arm', child: Text('Right arm')),
                        DropdownMenuItem(
                            value: 'Left thigh', child: Text('Left thigh')),
                        DropdownMenuItem(
                            value: 'Right thigh', child: Text('Right thigh')),
                        DropdownMenuItem(
                            value: 'Mouth', child: Text('Mouth (Oral)')),
                      ],
                      onChanged: (value) => setState(() => _site = value),
                    ),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: _batchNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Batch Number',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),

                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Expiry Date'),
                      subtitle: Text(_expiryDate == null
                          ? 'Not set'
                          : _formatDate(_expiryDate!)),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().add(const Duration(days: 365)),
                          firstDate: DateTime.now(),
                          lastDate:
                              DateTime.now().add(const Duration(days: 3650)),
                        );
                        if (date != null) {
                          setState(() => _expiryDate = date);
                        }
                      },
                    ),
                    const SizedBox(height: 24),

                    // BCG Specific
                    if (_selectedVaccine == ImmunizationType.bcg) ...[
                      Text(
                        'BCG Scar Check',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('BCG Scar Checked'),
                        value: _bcgScarChecked,
                        onChanged: (value) =>
                            setState(() => _bcgScarChecked = value ?? false),
                      ),
                      if (_bcgScarChecked) ...[
                        RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Scar Present'),
                          value: true,
                          groupValue: _bcgScarPresent,
                          onChanged: (value) =>
                              setState(() => _bcgScarPresent = value),
                        ),
                        RadioListTile<bool>(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Scar Not Present'),
                          value: false,
                          groupValue: _bcgScarPresent,
                          onChanged: (value) =>
                              setState(() => _bcgScarPresent = value),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],

                    // Adverse Reactions
                    Text(
                      'Adverse Events Following Immunization (AEFI)',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 12),

                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Adverse Reaction Reported'),
                      value: _adverseReaction,
                      onChanged: (value) => setState(() {
                        _adverseReaction = value ?? false;
                        if (!_adverseReaction) {
                          _reactionDetailsController.clear();
                          _reactionSeverity = null;
                        }
                      }),
                    ),

                    if (_adverseReaction) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _reactionDetailsController,
                        decoration: const InputDecoration(
                          labelText: 'Reaction Details',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: _reactionSeverity,
                        decoration: const InputDecoration(
                          labelText: 'Severity',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Mild', child: Text('Mild')),
                          DropdownMenuItem(
                              value: 'Moderate', child: Text('Moderate')),
                          DropdownMenuItem(
                              value: 'Severe', child: Text('Severe')),
                        ],
                        onChanged: (value) =>
                            setState(() => _reactionSeverity = value),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Notes
                    TextFormField(
                      controller: _notesController,
                      decoration: const InputDecoration(
                        labelText: 'Notes',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Save Button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _saveImmunization,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text(
                          'Save Immunization Record',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildChildInfoCard() {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor:
                  widget.child.sex == 'Male' ? Colors.blue : Colors.pink,
              child: Icon(
                widget.child.sex == 'Male' ? Icons.boy : Icons.girl,
                size: 28,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${widget.child.childName}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text('DOB: ${_formatDate(widget.child.dateOfBirth)}'),
                  Text('Age: ${_calculateAge()}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _calculateAge() {
    final age = DateTime.now().difference(widget.child.dateOfBirth);
    final weeks = age.inDays ~/ 7;
    final months = age.inDays ~/ 30;

    if (months < 12) {
      return '$weeks weeks ($months months)';
    } else {
      final years = months ~/ 12;
      final remainingMonths = months % 12;
      return '$years year${years > 1 ? 's' : ''} $remainingMonths month${remainingMonths != 1 ? 's' : ''}';
    }
  }
}
