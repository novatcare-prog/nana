import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/postnatal_visit_providers.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/utils/error_helper.dart';

class AddPostnatalVisitScreen extends ConsumerStatefulWidget {
  final MaternalProfile maternalProfile;

  const AddPostnatalVisitScreen({
    super.key,
    required this.maternalProfile,
  });

  @override
  ConsumerState<AddPostnatalVisitScreen> createState() => _AddPostnatalVisitScreenState();
}

class _AddPostnatalVisitScreenState extends ConsumerState<AddPostnatalVisitScreen> {
  final _formKey = GlobalKey<FormState>();
  
  DateTime _visitDate = DateTime.now();
  String _visitType = '48 hours';
  final TextEditingController _daysPostpartumController = TextEditingController();
  
  // Mother's Health
  final TextEditingController _motherTempController = TextEditingController();
  final TextEditingController _motherBPController = TextEditingController();
  final TextEditingController _motherPulseController = TextEditingController();
  final TextEditingController _motherWeightController = TextEditingController();
  
  // Complications
  bool _excessiveBleeding = false;
  bool _foulDischarge = false;
  bool _breastProblems = false;
  String _breastProblemsDesc = '';
  bool _perinealInfection = false;
  bool _csectionInfection = false;
  bool _urinaryProblems = false;
  
  // Maternal Danger Signs
  final List<String> _selectedMaternalDangerSigns = [];
  final List<String> _maternalDangerSignsOptions = [
    'Heavy bleeding',
    'Severe headache',
    'Blurred vision',
    'High fever',
    'Severe abdominal pain',
    'Foul-smelling discharge',
    'Convulsions',
  ];
  
  // Mental Health
  String? _moodAssessment = 'Good';
  String _mentalHealthNotes = '';
  
  // Baby's Health
  final TextEditingController _babyWeightController = TextEditingController();
  final TextEditingController _babyTempController = TextEditingController();
  bool _babyFeedingWell = true;
  String _babyFeedingNotes = '';
  
  // Cord Care
  String? _cordStatus = 'Normal';
  bool _cordCareAdviceGiven = true;
  
  // Jaundice
  bool _jaundicePresent = false;
  String? _jaundiceSeverity;
  
  // Baby Danger Signs
  final List<String> _selectedBabyDangerSigns = [];
  final List<String> _babyDangerSignsOptions = [
    'Fever (>37.5°C)',
    'Hypothermia (<36.5°C)',
    'Difficulty breathing',
    'Poor feeding',
    'Lethargy',
    'Convulsions',
    'Yellow eyes/skin',
    'Umbilical redness/discharge',
  ];
  String _babyDangerSignsNotes = '';
  
  // Breastfeeding
  String? _breastfeedingStatus = 'Exclusive';
  String _breastfeedingFrequency = '';
  String? _latchQuality = 'Good';
  String _breastfeedingChallenges = '';
  bool _breastfeedingSupportGiven = false;
  String _breastfeedingSupportDetails = '';
  
  // Family Planning
  bool _familyPlanningDiscussed = false;
  String _familyPlanningMethod = '';
  bool _familyPlanningProvided = false;
  String _familyPlanningNotes = '';
  
  // Immunizations
  final List<String> _selectedImmunizations = [];
  final List<String> _immunizationOptions = [
    'BCG',
    'Polio 0',
    'Polio 1',
    'Polio 2',
    'Polio 3',
    'DPT-HepB-Hib 1',
    'DPT-HepB-Hib 2',
    'DPT-HepB-Hib 3',
    'PCV 1',
    'PCV 2',
    'PCV 3',
    'Rota 1',
    'Rota 2',
  ];
  
  // Referrals
  bool _referralMade = false;
  String _referralTo = '';
  String _referralReason = '';
  
  // Follow-up
  DateTime? _nextVisitDate;
  String _followUpInstructions = '';
  String _generalNotes = '';
  
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _calculateDaysPostpartum();
  }

  void _calculateDaysPostpartum() {
    final deliveryDate = widget.maternalProfile.edd;
    if (deliveryDate != null) {
      final days = _visitDate.difference(deliveryDate).inDays;
      _daysPostpartumController.text = days.toString();
    }
  }

  Future<void> _saveVisit() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() => _isLoading = true);

    try {
      final userProfile = ref.read(currentUserProfileProvider).value;
      
      final visit = PostnatalVisit(
        maternalProfileId: widget.maternalProfile.id!,
        visitDate: _visitDate,
        visitType: _visitType,
        daysPostpartum: int.parse(_daysPostpartumController.text),
        healthFacility: widget.maternalProfile.facilityName,
        attendedBy: userProfile?.fullName,
        
        // Mother's Health
        motherTemperature: _motherTempController.text.isNotEmpty 
            ? double.tryParse(_motherTempController.text) : null,
        motherBloodPressure: _motherBPController.text.isNotEmpty 
            ? _motherBPController.text : null,
        motherPulse: _motherPulseController.text.isNotEmpty 
            ? int.tryParse(_motherPulseController.text) : null,
        motherWeight: _motherWeightController.text.isNotEmpty 
            ? double.tryParse(_motherWeightController.text) : null,
        
        // Complications
        excessiveBleeding: _excessiveBleeding,
        foulDischarge: _foulDischarge,
        breastProblems: _breastProblems,
        breastProblemsDescription: _breastProblems && _breastProblemsDesc.isNotEmpty 
            ? _breastProblemsDesc : null,
        perinealWoundInfection: _perinealInfection,
        cSectionWoundInfection: _csectionInfection,
        urinaryProblems: _urinaryProblems,
        maternalDangerSigns: _selectedMaternalDangerSigns.isNotEmpty 
            ? _selectedMaternalDangerSigns.join(', ') : null,
        
        // Mental Health
        moodAssessment: _moodAssessment,
        mentalHealthNotes: _mentalHealthNotes.isNotEmpty ? _mentalHealthNotes : null,
        
        // Baby's Health
        babyWeight: _babyWeightController.text.isNotEmpty 
            ? double.tryParse(_babyWeightController.text) : null,
        babyTemperature: _babyTempController.text.isNotEmpty 
            ? double.tryParse(_babyTempController.text) : null,
        babyFeedingWell: _babyFeedingWell,
        babyFeedingNotes: _babyFeedingNotes.isNotEmpty ? _babyFeedingNotes : null,
        
        // Cord Care
        cordStatus: _cordStatus,
        cordCareAdviceGiven: _cordCareAdviceGiven,
        
        // Jaundice
        jaundicePresent: _jaundicePresent,
        jaundiceSeverity: _jaundicePresent ? _jaundiceSeverity : null,
        
        // Baby Danger Signs
        babyDangerSigns: _selectedBabyDangerSigns.isNotEmpty 
            ? _selectedBabyDangerSigns.join(', ') : null,
        babyDangerSignsNotes: _babyDangerSignsNotes.isNotEmpty 
            ? _babyDangerSignsNotes : null,
        
        // Breastfeeding
        breastfeedingStatus: _breastfeedingStatus,
        breastfeedingFrequency: _breastfeedingFrequency.isNotEmpty 
            ? _breastfeedingFrequency : null,
        latchQuality: _latchQuality,
        breastfeedingChallenges: _breastfeedingChallenges.isNotEmpty 
            ? _breastfeedingChallenges : null,
        breastfeedingSupportGiven: _breastfeedingSupportGiven,
        breastfeedingSupportDetails: _breastfeedingSupportGiven && _breastfeedingSupportDetails.isNotEmpty 
            ? _breastfeedingSupportDetails : null,
        
        // Family Planning
        familyPlanningDiscussed: _familyPlanningDiscussed,
        familyPlanningMethodChosen: _familyPlanningDiscussed && _familyPlanningMethod.isNotEmpty 
            ? _familyPlanningMethod : null,
        familyPlanningMethodProvided: _familyPlanningProvided,
        familyPlanningNotes: _familyPlanningNotes.isNotEmpty 
            ? _familyPlanningNotes : null,
        
        // Immunizations
        immunizationsGiven: _selectedImmunizations.isNotEmpty 
            ? _selectedImmunizations.join(', ') : null,
        
        // Referrals
        referralMade: _referralMade,
        referralTo: _referralMade && _referralTo.isNotEmpty ? _referralTo : null,
        referralReason: _referralMade && _referralReason.isNotEmpty ? _referralReason : null,
        
        // Follow-up
        nextVisitDate: _nextVisitDate,
        followUpInstructions: _followUpInstructions.isNotEmpty 
            ? _followUpInstructions : null,
        generalNotes: _generalNotes.isNotEmpty ? _generalNotes : null,
      );

      final createVisit = ref.read(createPostnatalVisitProvider);
      await createVisit(visit);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Postnatal visit recorded successfully!'),
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
        title: const Text('Record Postnatal Visit'),
        backgroundColor: Colors.teal[700],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Mother Info Card
            Card(
              color: Colors.teal[50],
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.maternalProfile.clientName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.maternalProfile.edd != null)
                      Text('Delivery Date: ${DateFormat('dd/MM/yyyy').format(widget.maternalProfile.edd!)}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Visit Details
            _buildSectionTitle('Visit Details'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.calendar_today, color: Colors.teal[700]),
                      title: const Text('Visit Date'),
                      subtitle: Text(DateFormat('dd/MM/yyyy').format(_visitDate)),
                      trailing: const Icon(Icons.edit),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: _visitDate,
                          firstDate: widget.maternalProfile.edd ?? DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (date != null) {
                          setState(() {
                            _visitDate = date;
                            _calculateDaysPostpartum();
                          });
                        }
                      },
                    ),
                    DropdownButtonFormField<String>(
                      value: _visitType,
                      decoration: const InputDecoration(
                        labelText: 'Visit Type',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: '48 hours', child: Text('48 hours (2 days)')),
                        DropdownMenuItem(value: '6 days', child: Text('6 days')),
                        DropdownMenuItem(value: '6 weeks', child: Text('6 weeks')),
                        DropdownMenuItem(value: '6 months', child: Text('6 months')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) {
                        setState(() => _visitType = value!);
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _daysPostpartumController,
                      decoration: const InputDecoration(
                        labelText: 'Days Postpartum',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mother's Health Assessment
            _buildSectionTitle('Mother\'s Health Assessment'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextFormField(
                      controller: _motherTempController,
                      decoration: const InputDecoration(
                        labelText: 'Temperature (°C)',
                        hintText: 'e.g., 37.0',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _motherBPController,
                      decoration: const InputDecoration(
                        labelText: 'Blood Pressure',
                        hintText: 'e.g., 120/80',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _motherPulseController,
                            decoration: const InputDecoration(
                              labelText: 'Pulse (bpm)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _motherWeightController,
                            decoration: const InputDecoration(
                              labelText: 'Weight (kg)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Postpartum Complications
            _buildSectionTitle('Postpartum Complications'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Excessive bleeding'),
                      value: _excessiveBleeding,
                      onChanged: (value) => setState(() => _excessiveBleeding = value!),
                      activeColor: Colors.red[700],
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('Foul-smelling discharge'),
                      value: _foulDischarge,
                      onChanged: (value) => setState(() => _foulDischarge = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('Breast problems'),
                      value: _breastProblems,
                      onChanged: (value) => setState(() => _breastProblems = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_breastProblems) ...[
                      const SizedBox(height: 8),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Describe breast problems',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onSaved: (value) => _breastProblemsDesc = value ?? '',
                      ),
                    ],
                    CheckboxListTile(
                      title: const Text('Perineal wound infection'),
                      value: _perinealInfection,
                      onChanged: (value) => setState(() => _perinealInfection = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('C-section wound infection'),
                      value: _csectionInfection,
                      onChanged: (value) => setState(() => _csectionInfection = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                    CheckboxListTile(
                      title: const Text('Urinary problems'),
                      value: _urinaryProblems,
                      onChanged: (value) => setState(() => _urinaryProblems = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Maternal Danger Signs
            _buildSectionTitle('Maternal Danger Signs'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._maternalDangerSignsOptions.map((sign) => CheckboxListTile(
                          title: Text(sign),
                          value: _selectedMaternalDangerSigns.contains(sign),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedMaternalDangerSigns.add(sign);
                              } else {
                                _selectedMaternalDangerSigns.remove(sign);
                              }
                            });
                          },
                          activeColor: Colors.red[700],
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        )),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Mental Health
            _buildSectionTitle('Mental Health'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _moodAssessment,
                      decoration: const InputDecoration(
                        labelText: 'Mood Assessment',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Good', child: Text('Good')),
                        DropdownMenuItem(value: 'Anxious', child: Text('Anxious')),
                        DropdownMenuItem(value: 'Depressed', child: Text('Depressed')),
                        DropdownMenuItem(value: 'Other', child: Text('Other')),
                      ],
                      onChanged: (value) => setState(() => _moodAssessment = value),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Mental Health Notes',
                        hintText: 'Any concerns or observations...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onSaved: (value) => _mentalHealthNotes = value ?? '',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Baby's Health Assessment - Continue in next message due to length...
            
            _buildSectionTitle('Baby\'s Health Assessment'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _babyWeightController,
                            decoration: const InputDecoration(
                              labelText: 'Baby Weight (kg)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: TextFormField(
                            controller: _babyTempController,
                            decoration: const InputDecoration(
                              labelText: 'Temperature (°C)',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: const Text('Baby feeding well'),
                      value: _babyFeedingWell,
                      onChanged: (value) => setState(() => _babyFeedingWell = value),
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (!_babyFeedingWell) ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Feeding concerns',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onSaved: (value) => _babyFeedingNotes = value ?? '',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Cord Care
            _buildSectionTitle('Cord Care'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _cordStatus,
                      decoration: const InputDecoration(
                        labelText: 'Cord Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Normal', child: Text('Normal')),
                        DropdownMenuItem(value: 'Infected', child: Text('Infected')),
                        DropdownMenuItem(value: 'Bleeding', child: Text('Bleeding')),
                        DropdownMenuItem(value: 'Fallen off', child: Text('Fallen off')),
                      ],
                      onChanged: (value) => setState(() => _cordStatus = value),
                    ),
                    CheckboxListTile(
                      title: const Text('Cord care advice given'),
                      value: _cordCareAdviceGiven,
                      onChanged: (value) => setState(() => _cordCareAdviceGiven = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Jaundice
            _buildSectionTitle('Jaundice Assessment'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Jaundice present'),
                      value: _jaundicePresent,
                      onChanged: (value) => setState(() => _jaundicePresent = value!),
                      activeColor: Colors.orange[700],
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_jaundicePresent) ...[
                      DropdownButtonFormField<String>(
                        value: _jaundiceSeverity,
                        decoration: const InputDecoration(
                          labelText: 'Jaundice Severity',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Mild', child: Text('Mild')),
                          DropdownMenuItem(value: 'Moderate', child: Text('Moderate')),
                          DropdownMenuItem(value: 'Severe', child: Text('Severe')),
                        ],
                        onChanged: (value) => setState(() => _jaundiceSeverity = value),
                        validator: _jaundicePresent
                            ? (value) => value == null ? 'Please select severity' : null
                            : null,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Baby Danger Signs
            _buildSectionTitle('Baby Danger Signs'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ..._babyDangerSignsOptions.map((sign) => CheckboxListTile(
                          title: Text(sign),
                          value: _selectedBabyDangerSigns.contains(sign),
                          onChanged: (value) {
                            setState(() {
                              if (value!) {
                                _selectedBabyDangerSigns.add(sign);
                              } else {
                                _selectedBabyDangerSigns.remove(sign);
                              }
                            });
                          },
                          activeColor: Colors.red[700],
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                        )),
                    if (_selectedBabyDangerSigns.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Additional notes on danger signs',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onSaved: (value) => _babyDangerSignsNotes = value ?? '',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Breastfeeding Support
            _buildSectionTitle('Breastfeeding Support'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _breastfeedingStatus,
                      decoration: const InputDecoration(
                        labelText: 'Breastfeeding Status',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Exclusive', child: Text('Exclusive breastfeeding')),
                        DropdownMenuItem(value: 'Mixed', child: Text('Mixed feeding')),
                        DropdownMenuItem(value: 'Formula only', child: Text('Formula only')),
                        DropdownMenuItem(value: 'Not feeding', child: Text('Not feeding')),
                      ],
                      onChanged: (value) => setState(() => _breastfeedingStatus = value),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Feeding Frequency',
                        hintText: 'e.g., 8-12 times/day',
                        border: OutlineInputBorder(),
                      ),
                      onSaved: (value) => _breastfeedingFrequency = value ?? '',
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _latchQuality,
                      decoration: const InputDecoration(
                        labelText: 'Latch Quality',
                        border: OutlineInputBorder(),
                      ),
                      items: const [
                        DropdownMenuItem(value: 'Good', child: Text('Good')),
                        DropdownMenuItem(value: 'Poor', child: Text('Poor')),
                        DropdownMenuItem(value: 'Needs support', child: Text('Needs support')),
                      ],
                      onChanged: (value) => setState(() => _latchQuality = value),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Breastfeeding Challenges',
                        hintText: 'Any difficulties or concerns...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 2,
                      onSaved: (value) => _breastfeedingChallenges = value ?? '',
                    ),
                    CheckboxListTile(
                      title: const Text('Breastfeeding support given'),
                      value: _breastfeedingSupportGiven,
                      onChanged: (value) => setState(() => _breastfeedingSupportGiven = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_breastfeedingSupportGiven) ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Support details',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onSaved: (value) => _breastfeedingSupportDetails = value ?? '',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Family Planning
            _buildSectionTitle('Family Planning'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Family planning discussed'),
                      value: _familyPlanningDiscussed,
                      onChanged: (value) => setState(() => _familyPlanningDiscussed = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_familyPlanningDiscussed) ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Method chosen',
                          hintText: 'e.g., Pills, Implant, IUD, Condoms',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _familyPlanningMethod = value ?? '',
                      ),
                      const SizedBox(height: 12),
                      CheckboxListTile(
                        title: const Text('Method provided'),
                        value: _familyPlanningProvided,
                        onChanged: (value) => setState(() => _familyPlanningProvided = value!),
                        contentPadding: EdgeInsets.zero,
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Family planning notes',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onSaved: (value) => _familyPlanningNotes = value ?? '',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Immunizations
            _buildSectionTitle('Immunizations Given'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _immunizationOptions.map((immunization) {
                    final isSelected = _selectedImmunizations.contains(immunization);
                    return FilterChip(
                      label: Text(immunization),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedImmunizations.add(immunization);
                          } else {
                            _selectedImmunizations.remove(immunization);
                          }
                        });
                      },
                      selectedColor: Colors.teal[100],
                      checkmarkColor: Colors.teal[700],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Referrals
            _buildSectionTitle('Referrals'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    CheckboxListTile(
                      title: const Text('Referral made'),
                      value: _referralMade,
                      onChanged: (value) => setState(() => _referralMade = value!),
                      contentPadding: EdgeInsets.zero,
                    ),
                    if (_referralMade) ...[
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Referred to',
                          hintText: 'e.g., Hospital, Specialist',
                          border: OutlineInputBorder(),
                        ),
                        onSaved: (value) => _referralTo = value ?? '',
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        decoration: const InputDecoration(
                          labelText: 'Referral reason',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 2,
                        onSaved: (value) => _referralReason = value ?? '',
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Follow-up
            _buildSectionTitle('Follow-up'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.event, color: Colors.teal[700]),
                      title: const Text('Next Visit Date'),
                      subtitle: Text(_nextVisitDate != null
                          ? DateFormat('dd/MM/yyyy').format(_nextVisitDate!)
                          : 'Not set'),
                      trailing: const Icon(Icons.edit),
                      onTap: () async {
                        final date = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now().add(const Duration(days: 7)),
                          firstDate: DateTime.now(),
                          lastDate: DateTime.now().add(const Duration(days: 365)),
                        );
                        if (date != null) {
                          setState(() => _nextVisitDate = date);
                        }
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Follow-up Instructions',
                        hintText: 'Instructions for mother...',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                      onSaved: (value) => _followUpInstructions = value ?? '',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // General Notes
            _buildSectionTitle('General Notes'),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextFormField(
                  decoration: const InputDecoration(
                    hintText: 'Any additional observations or notes...',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 4,
                  onSaved: (value) => _generalNotes = value ?? '',
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Save Button
            ElevatedButton(
              onPressed: _isLoading ? null : _saveVisit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal[700],
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
                  : const Text('Save Visit'),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.teal[700],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _daysPostpartumController.dispose();
    _motherTempController.dispose();
    _motherBPController.dispose();
    _motherPulseController.dispose();
    _motherWeightController.dispose();
    _babyWeightController.dispose();
    _babyTempController.dispose();
    super.dispose();
  }
}