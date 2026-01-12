import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Dialog to request a new facility when user can't find theirs
class RequestFacilityDialog extends ConsumerStatefulWidget {
  const RequestFacilityDialog({super.key});

  @override
  ConsumerState<RequestFacilityDialog> createState() => _RequestFacilityDialogState();
}

class _RequestFacilityDialogState extends ConsumerState<RequestFacilityDialog> {
  final _formKey = GlobalKey<FormState>();
  final _facilityNameController = TextEditingController();
  final _kmhflCodeController = TextEditingController();
  final _countyController = TextEditingController();
  final _subCountyController = TextEditingController();
  
  bool _isLoading = false;

  // Kenya counties for dropdown
  final List<String> _counties = [
    'Baringo', 'Bomet', 'Bungoma', 'Busia', 'Elgeyo-Marakwet',
    'Embu', 'Garissa', 'Homa Bay', 'Isiolo', 'Kajiado',
    'Kakamega', 'Kericho', 'Kiambu', 'Kilifi', 'Kirinyaga',
    'Kisii', 'Kisumu', 'Kitui', 'Kwale', 'Laikipia',
    'Lamu', 'Machakos', 'Makueni', 'Mandera', 'Marsabit',
    'Meru', 'Migori', 'Mombasa', 'Murang\'a', 'Nairobi',
    'Nakuru', 'Nandi', 'Narok', 'Nyamira', 'Nyandarua',
    'Nyeri', 'Samburu', 'Siaya', 'Taita-Taveta', 'Tana River',
    'Tharaka-Nithi', 'Trans Nzoia', 'Turkana', 'Uasin Gishu',
    'Vihiga', 'Wajir', 'West Pokot',
  ];

  @override
  void dispose() {
    _facilityNameController.dispose();
    _kmhflCodeController.dispose();
    _countyController.dispose();
    _subCountyController.dispose();
    super.dispose();
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final supabase = Supabase.instance.client;
      final user = supabase.auth.currentUser;
      
      await supabase.from('facility_requests').insert({
        'facility_name': _facilityNameController.text.trim(),
        'kmhfl_code': _kmhflCodeController.text.trim().isEmpty 
            ? null 
            : _kmhflCodeController.text.trim(),
        'county': _countyController.text.trim(),
        'sub_county': _subCountyController.text.trim().isEmpty 
            ? null 
            : _subCountyController.text.trim(),
        'requested_by': user?.id,
        'status': 'pending',
      });

      if (mounted) {
        Navigator.pop(context, true);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Facility request submitted! Admin will review it.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Row(
                  children: [
                    Icon(
                      Icons.add_business,
                      color: theme.colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Request New Facility',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Can\'t find your facility? Request to add it.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 24),

                // Facility Name
                TextFormField(
                  controller: _facilityNameController,
                  decoration: const InputDecoration(
                    labelText: 'Facility Name *',
                    hintText: 'e.g., Juja Modern Hospital',
                    prefixIcon: Icon(Icons.local_hospital),
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter facility name';
                    }
                    if (value.length < 3) {
                      return 'Name must be at least 3 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // KMHFL Code (optional)
                TextFormField(
                  controller: _kmhflCodeController,
                  decoration: const InputDecoration(
                    labelText: 'KMHFL Code (if known)',
                    hintText: 'e.g., 12345',
                    prefixIcon: Icon(Icons.tag),
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // County Dropdown
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: 'County *',
                    prefixIcon: Icon(Icons.location_city),
                    border: OutlineInputBorder(),
                  ),
                  items: _counties.map((county) => DropdownMenuItem(
                    value: county,
                    child: Text(county),
                  )).toList(),
                  onChanged: (value) {
                    _countyController.text = value ?? '';
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select a county';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Sub-County
                TextFormField(
                  controller: _subCountyController,
                  decoration: const InputDecoration(
                    labelText: 'Sub-County (Optional)',
                    hintText: 'e.g., Juja',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),

                // Info Box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: theme.colorScheme.primary.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.info_outline,
                        size: 20,
                        color: theme.colorScheme.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Your request will be reviewed by an admin. You\'ll be notified when it\'s approved.',
                          style: theme.textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: _isLoading ? null : () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    FilledButton.icon(
                      onPressed: _isLoading ? null : _submitRequest,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.send),
                      label: Text(_isLoading ? 'Submitting...' : 'Submit Request'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper function to show the dialog
Future<bool?> showRequestFacilityDialog(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) => const RequestFacilityDialog(),
  );
}
