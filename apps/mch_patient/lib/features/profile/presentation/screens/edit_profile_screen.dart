import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/maternal_profile_provider.dart';

/// Edit Profile Screen
/// Allows patients to update their contact information and emergency contacts
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _hasChanges = false;

  // Form controllers
  late TextEditingController _phoneController;
  late TextEditingController _countyController;
  late TextEditingController _subCountyController;
  late TextEditingController _wardController;
  late TextEditingController _villageController;
  late TextEditingController _nextOfKinNameController;
  late TextEditingController _nextOfKinPhoneController;
  late TextEditingController _nextOfKinRelationshipController;

  MaternalProfile? _originalProfile;

  @override
  void initState() {
    super.initState();
    _phoneController = TextEditingController();
    _countyController = TextEditingController();
    _subCountyController = TextEditingController();
    _wardController = TextEditingController();
    _villageController = TextEditingController();
    _nextOfKinNameController = TextEditingController();
    _nextOfKinPhoneController = TextEditingController();
    _nextOfKinRelationshipController = TextEditingController();
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _countyController.dispose();
    _subCountyController.dispose();
    _wardController.dispose();
    _villageController.dispose();
    _nextOfKinNameController.dispose();
    _nextOfKinPhoneController.dispose();
    _nextOfKinRelationshipController.dispose();
    super.dispose();
  }

  void _initializeControllers(MaternalProfile profile) {
    if (_originalProfile?.id == profile.id) return; // Already initialized
    
    _originalProfile = profile;
    _phoneController.text = profile.telephone ?? '';
    _countyController.text = profile.county ?? '';
    _subCountyController.text = profile.subCounty ?? '';
    _wardController.text = profile.ward ?? '';
    _villageController.text = profile.village ?? '';
    _nextOfKinNameController.text = profile.nextOfKinName ?? '';
    _nextOfKinPhoneController.text = profile.nextOfKinPhone ?? '';
    _nextOfKinRelationshipController.text = profile.nextOfKinRelationship ?? '';
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final updatedProfile = _originalProfile!.copyWith(
        telephone: _phoneController.text.trim(),
        county: _countyController.text.trim(),
        subCounty: _subCountyController.text.trim(),
        ward: _wardController.text.trim(),
        village: _villageController.text.trim(),
        nextOfKinName: _nextOfKinNameController.text.trim(),
        nextOfKinPhone: _nextOfKinPhoneController.text.trim(),
        nextOfKinRelationship: _nextOfKinRelationshipController.text.trim(),
      );

      await ref.read(updateMaternalProfileProvider(updatedProfile).future);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✅ Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('❌ Failed to update: $e'),
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
    final profileAsync = ref.watch(currentMaternalProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveChanges,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Save', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }
          
          _initializeControllers(profile);
          
          return Form(
            key: _formKey,
            onChanged: () {
              if (!_hasChanges) {
                setState(() => _hasChanges = true);
              }
            },
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Info Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.info_outline, color: Colors.blue.shade700),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Medical information can only be updated by your healthcare provider.',
                          style: TextStyle(color: Colors.blue.shade700, fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Contact Information Section
                _buildSectionHeader(context, 'Contact Information', Icons.phone),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  isDark,
                  children: [
                    _buildTextField(
                      controller: _phoneController,
                      label: 'Phone Number',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Phone number is required';
                        }
                        return null;
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Location Section
                _buildSectionHeader(context, 'Location', Icons.location_on),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  isDark,
                  children: [
                    _buildTextField(
                      controller: _countyController,
                      label: 'County',
                      icon: Icons.map,
                    ),
                    const Divider(height: 24),
                    _buildTextField(
                      controller: _subCountyController,
                      label: 'Sub-County',
                      icon: Icons.location_city,
                    ),
                    const Divider(height: 24),
                    _buildTextField(
                      controller: _wardController,
                      label: 'Ward',
                      icon: Icons.local_hospital,
                    ),
                    const Divider(height: 24),
                    _buildTextField(
                      controller: _villageController,
                      label: 'Village',
                      icon: Icons.home,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Emergency Contact Section
                _buildSectionHeader(context, 'Emergency Contact', Icons.emergency),
                const SizedBox(height: 12),
                _buildCard(
                  context,
                  isDark,
                  children: [
                    _buildTextField(
                      controller: _nextOfKinNameController,
                      label: 'Next of Kin Name',
                      icon: Icons.person,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Emergency contact name is required';
                        }
                        return null;
                      },
                    ),
                    const Divider(height: 24),
                    _buildTextField(
                      controller: _nextOfKinPhoneController,
                      label: 'Next of Kin Phone',
                      icon: Icons.phone,
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Emergency contact phone is required';
                        }
                        return null;
                      },
                    ),
                    const Divider(height: 24),
                    _buildDropdownField(
                      controller: _nextOfKinRelationshipController,
                      label: 'Relationship',
                      icon: Icons.family_restroom,
                      options: ['Spouse', 'Parent', 'Sibling', 'Child', 'Friend', 'Other'],
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Save Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: _isLoading || !_hasChanges ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFE91E63),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    icon: _isLoading 
                        ? const SizedBox(
                            width: 20, 
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                          )
                        : const Icon(Icons.save),
                    label: Text(_isLoading ? 'Saving...' : 'Save Changes'),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE91E63)),
        ),
        error: (error, _) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFE91E63), size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildCard(BuildContext context, bool isDark, {required List<Widget> children}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(12),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE91E63)),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE91E63)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required List<String> options,
  }) {
    return DropdownButtonFormField<String>(
      value: options.contains(controller.text) ? controller.text : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFE91E63)),
        border: const OutlineInputBorder(),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFE91E63)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      items: options.map((option) => DropdownMenuItem(
        value: option,
        child: Text(option),
      )).toList(),
      onChanged: (value) {
        controller.text = value ?? '';
        if (!_hasChanges) {
          setState(() => _hasChanges = true);
        }
      },
    );
  }
}
