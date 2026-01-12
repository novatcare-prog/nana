import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/auth_providers.dart';
import '../../../../core/widgets/searchable_facility_selector.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Controllers
  late TextEditingController _fullNameController;
  late TextEditingController _phoneController;
  
  String? _selectedFacilityId;
  bool _isLoading = false;
  bool _hasChanges = false;

  @override
  void initState() {
    super.initState();
    _fullNameController = TextEditingController();
    _phoneController = TextEditingController();
    
    // Load current profile data
    _loadProfileData();
  }

  void _loadProfileData() {
    final profile = ref.read(currentUserProfileProvider).value;
    if (profile != null) {
      _fullNameController.text = profile.fullName;
      _phoneController.text = profile.phone ?? '';
      _selectedFacilityId = profile.facilityId;
    }
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (!_hasChanges) {
      setState(() => _hasChanges = true);
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final profile = ref.read(currentUserProfileProvider).value;
      if (profile == null) throw Exception('Profile not found');

      // Update profile in Supabase
      final authService = ref.read(authServiceProvider);
      await authService.updateUserProfile(
        userId: profile.id,
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim().isEmpty 
            ? null 
            : _phoneController.text.trim(),
        facilityId: _selectedFacilityId,
      );

      // Refresh profile
      ref.invalidate(currentUserProfileProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('✓ Profile updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
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
    final profileAsync = ref.watch(currentUserProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        elevation: 0,
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isLoading ? null : _saveProfile,
              child: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Save'),
            ),
        ],
      ),
      body: profileAsync.when(
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('Profile not found'));
          }

          return SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Avatar Section
                  _buildAvatarSection(profile),
                  const SizedBox(height: 24),

                  // Form Fields
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Full Name
                        TextFormField(
                          controller: _fullNameController,
                          decoration: const InputDecoration(
                            labelText: 'Full Name',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            if (value.length < 3) {
                              return 'Name must be at least 3 characters';
                            }
                            return null;
                          },
                          onChanged: (_) => _onFieldChanged(),
                        ),
                        const SizedBox(height: 16),

                        // Email (read-only)
                        TextFormField(
                          initialValue: profile.email,
                          decoration: const InputDecoration(
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(),
                            enabled: false,
                            helperText: 'Email cannot be changed',
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Phone
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(
                            labelText: 'Phone Number',
                            prefixIcon: Icon(Icons.phone),
                            border: OutlineInputBorder(),
                            hintText: 'e.g., +254 712 345 678',
                          ),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value != null && value.isNotEmpty) {
                              if (value.length < 10) {
                                return 'Please enter a valid phone number';
                              }
                            }
                            return null;
                          },
                          onChanged: (_) => _onFieldChanged(),
                        ),
                        const SizedBox(height: 16),

                        // Facility Selector (Searchable)
                        SearchableFacilitySelector(
                          selectedFacilityId: _selectedFacilityId,
                          onSelected: (facility) {
                            setState(() => _selectedFacilityId = facility?.id);
                            _onFieldChanged();
                          },
                          validator: (value) {
                            if (_selectedFacilityId == null || _selectedFacilityId!.isEmpty) {
                              return 'Please select a facility';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        // Role (read-only)
                        TextFormField(
                          initialValue: profile.role.toUpperCase(),
                          decoration: const InputDecoration(
                            labelText: 'Role',
                            prefixIcon: Icon(Icons.badge),
                            border: OutlineInputBorder(),
                            enabled: false,
                            helperText: 'Contact admin to change role',
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Divider
                        const Divider(),
                        const SizedBox(height: 16),

                        // Security Section
                        Text(
                          'Security',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),

                        // Change Password Button
                        OutlinedButton.icon(
                          onPressed: () {
                            Navigator.pushNamed(context, '/reset-password');
                          },
                          icon: const Icon(Icons.lock_reset),
                          label: const Text('Change Password'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Save Button
                        FilledButton(
                          onPressed: _isLoading ? null : _saveProfile,
                          style: FilledButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Save Changes'),
                        ),
                        const SizedBox(height: 16),

                        // Cancel Button
                        OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size(double.infinity, 50),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading profile: $error'),
        ),
      ),
    );
  }

  Widget _buildAvatarSection(dynamic profile) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: isDark 
              ? [
                  theme.colorScheme.primary.withOpacity(0.3),
                  theme.colorScheme.surface,
                ]
              : [
                  theme.colorScheme.primary,
                  theme.colorScheme.primary.withOpacity(0.8),
                ],
        ),
      ),
      child: Column(
        children: [
          // Avatar with camera button
          Stack(
            alignment: Alignment.center,
            children: [
              // Avatar Circle
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.5),
                    width: 3,
                  ),
                ),
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: isDark 
                      ? theme.colorScheme.primary 
                      : Colors.white,
                  child: Text(
                    profile.fullName.isNotEmpty
                        ? profile.fullName[0].toUpperCase()
                        : 'U',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: isDark 
                          ? Colors.white 
                          : theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              
              // Camera Button
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Photo upload coming soon'),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isDark ? theme.colorScheme.surface : Colors.white,
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 16),
          
          // Name
          Text(
            profile.fullName,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: isDark ? theme.colorScheme.onSurface : Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 8),
          
          // Role Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: isDark 
                  ? theme.colorScheme.primaryContainer 
                  : Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark 
                    ? theme.colorScheme.primary.withOpacity(0.5)
                    : Colors.white.withOpacity(0.3),
              ),
            ),
            child: Text(
              profile.role.toUpperCase(),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: isDark 
                    ? theme.colorScheme.primary 
                    : Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}