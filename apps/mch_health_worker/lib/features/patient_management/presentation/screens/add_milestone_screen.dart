import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/developmental_milestone_providers.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/utils/error_helper.dart';

class AddMilestoneScreen extends ConsumerStatefulWidget {
  final ChildProfile child;

  const AddMilestoneScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<AddMilestoneScreen> createState() => _AddMilestoneScreenState();
}

class _AddMilestoneScreenState extends ConsumerState<AddMilestoneScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime _assessmentDate = DateTime.now();

  // Motor Skills
  bool _motorGrossAppropriate = true;
  String _motorGrossNotes = '';
  bool _motorFineAppropriate = true;
  String _motorFineNotes = '';

  // Language
  bool _languageAppropriate = true;
  String _languageNotes = '';

  // Social/Emotional
  bool _socialAppropriate = true;
  String _socialNotes = '';

  // Cognitive
  bool _cognitiveAppropriate = true;
  String _cognitiveNotes = '';

  // Red Flags
  bool _redFlagsPresent = false;
  String _redFlagsDescription = '';

  // Intervention
  bool _interventionNeeded = false;
  String _interventionPlan = '';
  bool _referralMade = false;
  String _referralTo = '';

  // Overall
  String _overallStatus = 'On Track';
  String _generalNotes = '';

  bool _isLoading = false;

  int get _ageInMonths {
    return DateTime.now().difference(widget.child.dateOfBirth).inDays ~/ 30;
  }

  int get _ageInWeeks {
    return DateTime.now().difference(widget.child.dateOfBirth).inDays ~/ 7;
  }

  Future<void> _saveAssessment() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final userProfile = ref.read(currentUserProfileProvider).value;

      // Calculate next assessment date (based on age)
      DateTime? nextAssessmentDate;
      if (_ageInMonths < 3) {
        // Next assessment in 1 month for young infants
        nextAssessmentDate = DateTime(_assessmentDate.year,
            _assessmentDate.month + 1, _assessmentDate.day);
      } else if (_ageInMonths < 12) {
        // Next assessment in 3 months
        nextAssessmentDate = DateTime(_assessmentDate.year,
            _assessmentDate.month + 3, _assessmentDate.day);
      } else if (_ageInMonths < 24) {
        // Next assessment in 6 months
        nextAssessmentDate = DateTime(_assessmentDate.year,
            _assessmentDate.month + 6, _assessmentDate.day);
      } else {
        // Next assessment in 12 months for older children
        nextAssessmentDate = DateTime(_assessmentDate.year + 1,
            _assessmentDate.month, _assessmentDate.day);
      }

      final milestone = DevelopmentalMilestone(
        childProfileId: widget.child.id,
        assessmentDate: _assessmentDate,
        ageAtAssessmentWeeks: _ageInWeeks,
        ageAtAssessmentMonths: _ageInMonths,
        assessedBy: userProfile?.fullName,
        motorGrossAppropriate: _motorGrossAppropriate,
        motorGrossNotes: _motorGrossNotes.isNotEmpty ? _motorGrossNotes : null,
        motorFineAppropriate: _motorFineAppropriate,
        motorFineNotes: _motorFineNotes.isNotEmpty ? _motorFineNotes : null,
        languageAppropriate: _languageAppropriate,
        languageNotes: _languageNotes.isNotEmpty ? _languageNotes : null,
        socialAppropriate: _socialAppropriate,
        socialNotes: _socialNotes.isNotEmpty ? _socialNotes : null,
        cognitiveAppropriate: _cognitiveAppropriate,
        cognitiveNotes: _cognitiveNotes.isNotEmpty ? _cognitiveNotes : null,
        redFlagsPresent: _redFlagsPresent,
        redFlagsDescription: _redFlagsPresent && _redFlagsDescription.isNotEmpty
            ? _redFlagsDescription
            : null,
        interventionNeeded: _interventionNeeded,
        interventionPlan: _interventionNeeded && _interventionPlan.isNotEmpty
            ? _interventionPlan
            : null,
        referralMade: _referralMade,
        referralTo:
            _referralMade && _referralTo.isNotEmpty ? _referralTo : null,
        nextAssessmentDate: nextAssessmentDate,
        overallStatus: _overallStatus,
        generalNotes: _generalNotes.isNotEmpty ? _generalNotes : null,
      );

      final createMilestone = ref.read(createMilestoneProvider);
      await createMilestone(milestone);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Developmental assessment saved successfully!'),
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
        title: const Text('Developmental Assessment'),
        backgroundColor: Colors.purple[700],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Child Info Card
            Card(
              color: Colors.purple[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.child.childName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                        'DOB: ${DateFormat('dd/MM/yyyy').format(widget.child.dateOfBirth)}'),
                    Text('Age: $_ageInMonths months ($_ageInWeeks weeks)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Assessment Date
            Card(
              child: ListTile(
                leading: Icon(Icons.calendar_today, color: Colors.purple[700]),
                title: const Text('Assessment Date'),
                subtitle:
                    Text(DateFormat('dd/MM/yyyy').format(_assessmentDate)),
                trailing: const Icon(Icons.edit),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _assessmentDate,
                    firstDate: widget.child.dateOfBirth,
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() => _assessmentDate = date);
                  }
                },
              ),
            ),
            const SizedBox(height: 24),

            // Motor Skills - Gross
            _buildDevelopmentSection(
              'Gross Motor Skills',
              'Large muscle movements (rolling, sitting, walking, running)',
              _motorGrossAppropriate,
              _motorGrossNotes,
              (value) => setState(() => _motorGrossAppropriate = value),
              (value) => _motorGrossNotes = value,
            ),
            const SizedBox(height: 16),

            // Motor Skills - Fine
            _buildDevelopmentSection(
              'Fine Motor Skills',
              'Small muscle movements (grasping, drawing, buttoning)',
              _motorFineAppropriate,
              _motorFineNotes,
              (value) => setState(() => _motorFineAppropriate = value),
              (value) => _motorFineNotes = value,
            ),
            const SizedBox(height: 16),

            // Language
            _buildDevelopmentSection(
              'Language & Communication',
              'Speaking, understanding, expressing needs',
              _languageAppropriate,
              _languageNotes,
              (value) => setState(() => _languageAppropriate = value),
              (value) => _languageNotes = value,
            ),
            const SizedBox(height: 16),

            // Social/Emotional
            _buildDevelopmentSection(
              'Social & Emotional',
              'Interacting with others, expressing emotions',
              _socialAppropriate,
              _socialNotes,
              (value) => setState(() => _socialAppropriate = value),
              (value) => _socialNotes = value,
            ),
            const SizedBox(height: 16),

            // Cognitive
            _buildDevelopmentSection(
              'Cognitive Development',
              'Learning, thinking, problem-solving',
              _cognitiveAppropriate,
              _cognitiveNotes,
              (value) => setState(() => _cognitiveAppropriate = value),
              (value) => _cognitiveNotes = value,
            ),
            const SizedBox(height: 24),

            // Red Flags Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.warning, color: Colors.red[700]),
                        const SizedBox(width: 8),
                        const Text(
                          'Red Flags / Concerns',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text('Red flags present'),
                      value: _redFlagsPresent,
                      onChanged: (value) {
                        setState(() => _redFlagsPresent = value ?? false);
                      },
                      activeColor: Colors.red[700],
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_redFlagsPresent) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Describe Red Flags',
                          hintText: 'Describe any developmental concerns...',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _redFlagsDescription = value ?? '',
                        validator: _redFlagsPresent
                            ? (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please describe the red flags';
                                }
                                return null;
                              }
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Intervention Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Intervention & Referral',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text('Intervention needed'),
                      value: _interventionNeeded,
                      onChanged: (value) {
                        setState(() => _interventionNeeded = value ?? false);
                      },
                      activeColor: Colors.purple[700],
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_interventionNeeded) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Intervention Plan',
                          hintText: 'Describe the intervention plan...',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _interventionPlan = value ?? '',
                      ),
                    ],
                    const SizedBox(height: 12),
                    CheckboxListTile(
                      title: const Text('Referral made'),
                      value: _referralMade,
                      onChanged: (value) {
                        setState(() => _referralMade = value ?? false);
                      },
                      activeColor: Colors.purple[700],
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_referralMade) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Referred To',
                          hintText: 'e.g., Pediatrician, Speech Therapist',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _referralTo = value ?? '',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Overall Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Overall Status',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _overallStatus,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: 'On Track', child: Text('On Track')),
                        DropdownMenuItem(
                            value: 'Needs Monitoring',
                            child: Text('Needs Monitoring')),
                        DropdownMenuItem(
                            value: 'Needs Intervention',
                            child: Text('Needs Intervention')),
                      ],
                      onChanged: (value) {
                        setState(() => _overallStatus = value!);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // General Notes
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'General Notes',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      maxLines: 4,
                      decoration: const InputDecoration(
                        hintText: 'Add any additional observations...',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => _generalNotes = value ?? '',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveAssessment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple[700],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                textStyle: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Save Assessment'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildDevelopmentSection(
    String title,
    String description,
    bool isAppropriate,
    String notes,
    Function(bool) onAppropriateChanged,
    Function(String) onNotesChanged,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Appropriate'),
                    value: true,
                    groupValue: isAppropriate,
                    onChanged: (value) => onAppropriateChanged(value!),
                    activeColor: Colors.green,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
                Expanded(
                  child: RadioListTile<bool>(
                    title: const Text('Concern'),
                    value: false,
                    groupValue: isAppropriate,
                    onChanged: (value) => onAppropriateChanged(value!),
                    activeColor: Colors.orange,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            TextFormField(
              maxLines: 2,
              decoration: const InputDecoration(
                labelText: 'Notes (Optional)',
                hintText: 'Add observations...',
                border: OutlineInputBorder(),
              ),
              onSaved: (value) => onNotesChanged(value ?? ''),
            ),
          ],
        ),
      ),
    );
  }
}
