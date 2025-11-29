import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/childbirth_providers.dart';

/// Record Delivery Screen - MCH Handbook Page 15
class RecordDeliveryScreen extends ConsumerStatefulWidget {
  final String patientId;
  final MaternalProfile patient;

  const RecordDeliveryScreen({
    super.key,
    required this.patientId,
    required this.patient,
  });

  @override
  ConsumerState<RecordDeliveryScreen> createState() => _RecordDeliveryScreenState();
}

class _RecordDeliveryScreenState extends ConsumerState<RecordDeliveryScreen> {
  final _formKey = GlobalKey<FormState>();
  int _currentStep = 0;
  bool _isSubmitting = false;

  // Step 1: Delivery Information
  DateTime _deliveryDate = DateTime.now();
  final _deliveryTimeController = TextEditingController();
  final _durationOfPregnancyController = TextEditingController();
  String _placeOfDelivery = 'Health facility';
  final _facilityNameController = TextEditingController();
  String? _attendant;
  String _modeOfDelivery = 'SVD';

  // Step 2: Mother's Condition
  bool _skinToSkin = false;
  final _apgar1Controller = TextEditingController();
  final _apgar5Controller = TextEditingController();
  final _apgar10Controller = TextEditingController();
  bool _resuscitation = false;
  final _bloodLossController = TextEditingController();

  // Complications
  bool _preEclampsia = false;
  bool _eclampsia = false;
  bool _pph = false;
  bool _obstructedLabour = false;
  String? _meconiumGrade;

  // Drugs to Mother
  bool _oxytocin = false;
  bool _misoprostol = false;
  bool _carbetocin = false;
  bool _haart = false;
  final _haartRegimenController = TextEditingController();

  // Step 3: Baby Information
  final _childNameController = TextEditingController();
  String _babySex = 'Male';
  final _birthWeightController = TextEditingController();
  final _birthLengthController = TextEditingController();
  final _headCircumferenceController = TextEditingController();
  String? _babyCondition;

  // Drugs to Baby
  bool _chx = false;
  bool _vitaminK = false;
  bool _teo = false;
  bool _hivExposed = false;
  String? _arvProphylaxis;
  bool _earlyBreastfeeding = false;

  // Notes
  final _notesController = TextEditingController();
  final _conductedByController = TextEditingController();

  @override
  void dispose() {
    _deliveryTimeController.dispose();
    _durationOfPregnancyController.dispose();
    _facilityNameController.dispose();
    _apgar1Controller.dispose();
    _apgar5Controller.dispose();
    _apgar10Controller.dispose();
    _bloodLossController.dispose();
    _haartRegimenController.dispose();
    _childNameController.dispose();
    _birthWeightController.dispose();
    _birthLengthController.dispose();
    _headCircumferenceController.dispose();
    _notesController.dispose();
    _conductedByController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    print('🔥 STEP 1: Submit button clicked');
    
    if (!_formKey.currentState!.validate()) {
      print('❌ STEP 2: Form validation FAILED');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all required fields'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }
    
    print('✅ STEP 2: Form validation PASSED');

    setState(() => _isSubmitting = true);
    print('🔄 STEP 3: isSubmitting set to true');

    try {
      print('📝 STEP 4: Creating childbirth record...');
      
      // Create Childbirth Record
      final childbirthRecord = ChildbirthRecord(
        id: null,
        maternalProfileId: widget.patientId,
        deliveryDate: _deliveryDate,
        deliveryTime: _deliveryTimeController.text,
        durationOfPregnancyWeeks: int.parse(_durationOfPregnancyController.text),
        placeOfDelivery: _placeOfDelivery,
        healthFacilityName: _facilityNameController.text.isEmpty ? null : _facilityNameController.text,
        attendant: _attendant,
        modeOfDelivery: _modeOfDelivery,
        skinToSkinImmediate: _skinToSkin,
        apgarScore1Min: _apgar1Controller.text.isEmpty ? null : _apgar1Controller.text,
        apgarScore5Min: _apgar5Controller.text.isEmpty ? null : _apgar5Controller.text,
        apgarScore10Min: _apgar10Controller.text.isEmpty ? null : _apgar10Controller.text,
        resuscitationDone: _resuscitation,
        bloodLossMl: _bloodLossController.text.isEmpty ? null : double.parse(_bloodLossController.text),
        preEclampsia: _preEclampsia,
        eclampsia: _eclampsia,
        pph: _pph,
        obstructedLabour: _obstructedLabour,
        meconiumGrade: _meconiumGrade,
        motherCondition: null,
        oxytocinGiven: _oxytocin,
        misoprostolGiven: _misoprostol,
        heatStableCarbetocin: _carbetocin,
        haartGiven: _haart,
        haartRegimen: _haartRegimenController.text.isEmpty ? null : _haartRegimenController.text,
        otherDrugs: null,
        birthWeightGrams: double.parse(_birthWeightController.text),
        birthLengthCm: double.parse(_birthLengthController.text),
        headCircumferenceCm: _headCircumferenceController.text.isEmpty ? null : double.parse(_headCircumferenceController.text),
        babyCondition: _babyCondition,
        chxGiven: _chx,
        vitaminKGiven: _vitaminK,
        teoGiven: _teo,
        babyHivExposed: _hivExposed,
        arvProphylaxisGiven: _arvProphylaxis,
        earlyInitiationBreastfeeding: _earlyBreastfeeding,
        notes: _notesController.text.isEmpty ? null : _notesController.text,
        conductedBy: _conductedByController.text.isEmpty ? null : _conductedByController.text,
        createdAt: null,
        updatedAt: null,
      );

      print('✅ STEP 5: Childbirth record created successfully');
      print('👶 STEP 6: Creating child profile...');

      // Create Child Profile
      final childProfile = ChildProfile(
        id: '',
        maternalProfileId: widget.patientId,
        childName: _childNameController.text,
        sex: _babySex,
        dateOfBirth: _deliveryDate,
        dateFirstSeen: _deliveryDate,
        gestationAtBirthWeeks: int.parse(_durationOfPregnancyController.text),
        birthWeightGrams: double.parse(_birthWeightController.text),
        birthLengthCm: double.parse(_birthLengthController.text),
        headCircumferenceCm: _headCircumferenceController.text.isEmpty 
            ? null 
            : double.parse(_headCircumferenceController.text),
        placeOfBirth: _placeOfDelivery,
        healthFacilityName: _facilityNameController.text.isEmpty ? null : _facilityNameController.text,
        otherBirthCharacteristics: null,
        birthOrder: null,
        birthNotificationNumber: null,
        birthNotificationDate: null,
        immunizationRegNumber: null,
        cwcNumber: null,
        kmhflCode: null,
        birthCertificateNumber: null,
        birthRegistrationDate: null,
        birthRegistrationPlace: null,
        fatherName: null,
        fatherPhone: null,
        motherName: widget.patient.clientName,
        motherPhone: widget.patient.telephone,
        guardianName: null,
        guardianPhone: null,
        county: widget.patient.county,
        subCounty: widget.patient.subCounty,
        ward: widget.patient.ward,
        village: widget.patient.village,
        physicalAddress: null,
        weightAtFirstContact: double.parse(_birthWeightController.text),
        lengthAtFirstContact: double.parse(_birthLengthController.text),
        zScore: null,
        hivExposed: _hivExposed,
        hivStatus: _hivExposed ? 'Exposed' : 'Unknown',
        hivTestDate: _hivExposed ? _deliveryDate : null,
        haemoglobin: null,
        colouration: null,
        eyes: null,
        ears: null,
        mouth: null,
        chest: null,
        heart: null,
        abdomen: null,
        umbilicalCord: null,
        spine: null,
        armsHands: null,
        legsFeet: null,
        genitalia: null,
        anus: null,
        tbScreened: false,
        tbScreeningResult: null,
        breastfeedingWell: _earlyBreastfeeding,
        breastfeedingPoorly: false,
        unableToBreastfeed: false,
        otherFoodsIntroducedBelow6Months: false,
        ageOtherFoodsIntroduced: null,
        complementaryFoodFrom6Months: false,
        sleepProblems: null,
        irritability: false,
        otherProblems: null,
        birthWeightLessThan2500g: double.parse(_birthWeightController.text) < 2500,
        birthLessThan2YearsAfterLast: false,
        fifthChildOrMore: false,
        bornOfTeenageMother: widget.patient.age < 20,
        bornOfMentallyIllMother: false,
        developmentalDelays: false,
        siblingUndernourished: false,
        multipleBirth: false,
        childWithSpecialNeeds: false,
        orphanVulnerableChild: false,
        childWithDisability: false,
        historyOfChildAbuse: false,
        cleftLipPalate: false,
        otherSpecialCareReason: null,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      print('✅ STEP 7: Child profile created successfully');
      print('💾 STEP 8: Getting createDelivery provider...');

      // Save to database
      final createDelivery = ref.read(createDeliveryRecordProvider);
      
      print('📤 STEP 9: Calling createDelivery function...');
      
      await createDelivery(
        childbirthRecord: childbirthRecord,
        childProfile: childProfile,
      );

      print('🎉 STEP 10: Database save successful!');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Delivery recorded successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 3),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e, stackTrace) {
      print('❌❌❌ ERROR OCCURRED!');
      print('Error: $e');
      print('StackTrace: $stackTrace');
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Error: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 8),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
        print('🔄 isSubmitting set back to false');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Record Delivery - ${widget.patient.clientName}'),
      ),
      body: Form(
        key: _formKey,
        child: Stepper(
          currentStep: _currentStep,
          onStepContinue: () {
            print('📍 Continue button pressed on step $_currentStep');
            if (_currentStep < 2) {
              setState(() => _currentStep++);
              print('📍 Moved to step $_currentStep');
            } else {
              print('📍 On final step - calling _handleSubmit');
              _handleSubmit();
            }
          },
          onStepCancel: () {
            if (_currentStep > 0) {
              setState(() => _currentStep--);
            } else {
              Navigator.pop(context);
            }
          },
          controlsBuilder: (context, details) {
            return Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : details.onStepContinue,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(_currentStep == 2 ? 'Submit' : 'Continue'),
                  ),
                  const SizedBox(width: 12),
                  TextButton(
                    onPressed: _isSubmitting ? null : details.onStepCancel,
                    child: Text(_currentStep == 0 ? 'Cancel' : 'Back'),
                  ),
                ],
              ),
            );
          },
          steps: [
            _buildStep1DeliveryInfo(),
            _buildStep2MotherCondition(),
            _buildStep3BabyInfo(),
          ],
        ),
      ),
    );
  }

  Step _buildStep1DeliveryInfo() {
    return Step(
      title: const Text('Delivery Information'),
      content: Column(
        children: [
          ListTile(
            title: const Text('Delivery Date *'),
            subtitle: Text("${_deliveryDate.day}/${_deliveryDate.month}/${_deliveryDate.year}"),
            trailing: const Icon(Icons.calendar_today),
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: _deliveryDate,
                firstDate: DateTime.now().subtract(const Duration(days: 7)),
                lastDate: DateTime.now(),
              );
              if (date != null) {
                setState(() => _deliveryDate = date);
              }
            },
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _deliveryTimeController,
            decoration: const InputDecoration(
              labelText: 'Delivery Time (HH:MM) *',
              border: OutlineInputBorder(),
              hintText: '14:30',
            ),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _durationOfPregnancyController,
            decoration: const InputDecoration(
              labelText: 'Duration of Pregnancy (Weeks) *',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _placeOfDelivery,
            decoration: const InputDecoration(
              labelText: 'Place of Delivery *',
              border: OutlineInputBorder(),
            ),
            items: ['Health facility', 'Home', 'Other']
                .map((place) => DropdownMenuItem(value: place, child: Text(place)))
                .toList(),
            onChanged: (value) => setState(() => _placeOfDelivery = value!),
          ),
          const SizedBox(height: 16),
          if (_placeOfDelivery == 'Health facility')
            TextFormField(
              controller: _facilityNameController,
              decoration: const InputDecoration(
                labelText: 'Facility Name',
                border: OutlineInputBorder(),
              ),
            ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _attendant,
            decoration: const InputDecoration(
              labelText: 'Attendant',
              border: OutlineInputBorder(),
            ),
            items: ['Nurse', 'Midwife', 'Clinical Officer', 'Doctor', 'TBA']
                .map((att) => DropdownMenuItem(value: att, child: Text(att)))
                .toList(),
            onChanged: (value) => setState(() => _attendant = value),
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _modeOfDelivery,
            decoration: const InputDecoration(
              labelText: 'Mode of Delivery *',
              border: OutlineInputBorder(),
            ),
            items: ['SVD', 'Caesarean', 'Assisted (Vacuum/Forceps)']
                .map((mode) => DropdownMenuItem(value: mode, child: Text(mode)))
                .toList(),
            onChanged: (value) => setState(() => _modeOfDelivery = value!),
          ),
        ],
      ),
      isActive: _currentStep >= 0,
    );
  }

  Step _buildStep2MotherCondition() {
    return Step(
      title: const Text("Mother's Condition"),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CheckboxListTile(
            title: const Text('Skin-to-Skin Immediate'),
            value: _skinToSkin,
            onChanged: (value) => setState(() => _skinToSkin = value ?? false),
          ),
          const SizedBox(height: 16),
          const Text('APGAR Scores:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _apgar1Controller,
                  decoration: const InputDecoration(labelText: '1 Min', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _apgar5Controller,
                  decoration: const InputDecoration(labelText: '5 Min', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: _apgar10Controller,
                  decoration: const InputDecoration(labelText: '10 Min', border: OutlineInputBorder()),
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Resuscitation Done'),
            value: _resuscitation,
            onChanged: (value) => setState(() => _resuscitation = value ?? false),
          ),
          TextFormField(
            controller: _bloodLossController,
            decoration: const InputDecoration(labelText: 'Blood Loss (ml)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const Text('Complications:', style: TextStyle(fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: const Text('Pre-eclampsia'),
            value: _preEclampsia,
            onChanged: (value) => setState(() => _preEclampsia = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Eclampsia'),
            value: _eclampsia,
            onChanged: (value) => setState(() => _eclampsia = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('PPH (Post-partum Hemorrhage)'),
            value: _pph,
            onChanged: (value) => setState(() => _pph = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Obstructed Labour'),
            value: _obstructedLabour,
            onChanged: (value) => setState(() => _obstructedLabour = value ?? false),
          ),
          const SizedBox(height: 16),
          const Text('Drugs Administered:', style: TextStyle(fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: const Text('Oxytocin'),
            value: _oxytocin,
            onChanged: (value) => setState(() => _oxytocin = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Misoprostol'),
            value: _misoprostol,
            onChanged: (value) => setState(() => _misoprostol = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Heat Stable Carbetocin'),
            value: _carbetocin,
            onChanged: (value) => setState(() => _carbetocin = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('HAART (if HIV+)'),
            value: _haart,
            onChanged: (value) => setState(() => _haart = value ?? false),
          ),
          if (_haart)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                controller: _haartRegimenController,
                decoration: const InputDecoration(labelText: 'HAART Regimen', border: OutlineInputBorder()),
              ),
            ),
        ],
      ),
      isActive: _currentStep >= 1,
    );
  }

  Step _buildStep3BabyInfo() {
    return Step(
      title: const Text('Baby Information'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _childNameController,
            decoration: const InputDecoration(labelText: 'Baby Name *', border: OutlineInputBorder()),
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          DropdownButtonFormField<String>(
            value: _babySex,
            decoration: const InputDecoration(labelText: 'Sex *', border: OutlineInputBorder()),
            items: ['Male', 'Female'].map((sex) => DropdownMenuItem(value: sex, child: Text(sex))).toList(),
            onChanged: (value) => setState(() => _babySex = value!),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _birthWeightController,
            decoration: const InputDecoration(labelText: 'Birth Weight (grams) *', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _birthLengthController,
            decoration: const InputDecoration(labelText: 'Birth Length (cm) *', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
            validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _headCircumferenceController,
            decoration: const InputDecoration(labelText: 'Head Circumference (cm)', border: OutlineInputBorder()),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          const Text('Drugs Given to Baby:', style: TextStyle(fontWeight: FontWeight.bold)),
          CheckboxListTile(
            title: const Text('CHX (Chlorhexidine 7.1%)'),
            value: _chx,
            onChanged: (value) => setState(() => _chx = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Vitamin K'),
            value: _vitaminK,
            onChanged: (value) => setState(() => _vitaminK = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('TEO (Tetracycline Eye Ointment)'),
            value: _teo,
            onChanged: (value) => setState(() => _teo = value ?? false),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('HIV Exposed Infant'),
            value: _hivExposed,
            onChanged: (value) => setState(() => _hivExposed = value ?? false),
          ),
          CheckboxListTile(
            title: const Text('Early Breastfeeding (Within 1 hour)'),
            value: _earlyBreastfeeding,
            onChanged: (value) => setState(() => _earlyBreastfeeding = value ?? false),
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _notesController,
            decoration: const InputDecoration(labelText: 'Notes', border: OutlineInputBorder()),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _conductedByController,
            decoration: const InputDecoration(labelText: 'Conducted By', border: OutlineInputBorder()),
          ),
        ],
      ),
      isActive: _currentStep >= 2,
    );
  }
}