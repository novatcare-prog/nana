import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/maternal_profile_provider.dart';
import '../../../../core/providers/child_provider.dart';
import '../../../../core/services/photo_upload_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
    final authController = ref.read(authControllerProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: maternalProfileAsync.when(
        data: (profile) => _buildContent(context, ref, user, profile, authController),
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE91E63)),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    WidgetRef ref,
    dynamic user,
    MaternalProfile? profile,
    dynamic authController,
  ) {
    // Use profile data if available, fallback to auth user metadata
    final userName = profile?.clientName ?? 
        user?.userMetadata?['full_name'] as String? ?? 
        'Mama';
    final userPhone = profile?.telephone ?? 
        user?.userMetadata?['phone'] as String? ?? 
        '+254 7XX XXX XXX';
    final ancNumber = profile?.ancNumber ?? 'Not registered';
    final facilityName = profile?.facilityName ?? 'No facility';

    return CustomScrollView(
      slivers: [
        // COLLAPSIBLE HEADER
        SliverAppBar(
          expandedHeight: 320.0,
          floating: false,
          pinned: true,
          backgroundColor: const Color(0xFFE91E63),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          actions: [
            IconButton(
              icon: const Icon(Icons.settings, color: Colors.white),
              onPressed: () => context.push('/settings'),
            ),
            IconButton(
              icon: const Icon(Icons.refresh, color: Colors.white),
              onPressed: () {
                ref.invalidate(currentMaternalProfileProvider);
              },
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    
                    // Avatar with Photo Upload
                    _ProfilePhotoWidget(
                      photoUrl: profile?.photoUrl,
                      userName: userName,
                      profileId: profile?.id,
                      onPhotoUpdated: () {
                        ref.invalidate(currentMaternalProfileProvider);
                      },
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Name
                    Text(
                      userName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    
                    // Phone
                    Text(
                      userPhone,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // ANC Number Badge
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.4)),
                      ),
                      child: Text(
                        "ANC: $ancNumber",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Facility
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.local_hospital, 
                          size: 14, 
                          color: Colors.white.withOpacity(0.8)
                        ),
                        const SizedBox(width: 4),
                        Text(
                          facilityName,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        // CONTENT
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 20),
            
            // PERSONAL INFO SECTION
            if (profile != null) ...[
              const _SectionHeader(title: "PERSONAL INFORMATION"),
              _ProfileInfoCard(profile: profile),
              const SizedBox(height: 24),
              
              // PREGNANCY INFO
              const _SectionHeader(title: "PREGNANCY INFORMATION"),
              _PregnancyInfoCard(profile: profile),
              const SizedBox(height: 24),
              
              // EMERGENCY CONTACT
              if (profile.nextOfKinName != null || profile.nextOfKinPhone != null) ...[
                const _SectionHeader(title: "EMERGENCY CONTACT"),
                _EmergencyContactCard(profile: profile),
                const SizedBox(height: 24),
              ],
            ],

            // MY HEALTH RECORDS SECTION
            const _SectionHeader(title: "MY HEALTH RECORDS"),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.pregnant_woman,
                  color: const Color(0xFFE91E63),
                  title: "ANC Visits",
                  subtitle: "Antenatal care history",
                  onTap: () => context.push('/anc-visits'),
                ),
                const _Divider(),
                _SettingsTile(
                  icon: Icons.child_care,
                  color: Colors.teal,
                  title: "My Children",
                  subtitle: "View registered children",
                  onTap: () => context.go('/children'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // ACCOUNT SECTION
            const _SectionHeader(title: "APP SETTINGS"),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.language,
                  color: Colors.blue,
                  title: "Language / Lugha",
                  subtitle: "English",
                  trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Language settings coming soon')),
                    );
                  },
                ),
                const _Divider(),
                _SettingsTile(
                  icon: Icons.notifications_active,
                  color: Colors.orange,
                  title: "Notifications",
                  subtitle: "Vaccines & Appointments",
                  trailing: Switch(
                    value: true,
                    onChanged: (val) {},
                    activeColor: const Color(0xFFE91E63),
                  ),
                ),
                const _Divider(),
                _SettingsTile(
                  icon: Icons.lock,
                  color: Colors.purple,
                  title: "Change Password",
                  onTap: () {
                    context.push('/forgot-password');
                  },
                ),
              ],
            ),

            const SizedBox(height: 24),

            // SUPPORT SECTION
            const _SectionHeader(title: "SUPPORT"),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.help_outline,
                  color: Colors.green,
                  title: "Help & FAQ",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Help coming soon')),
                    );
                  },
                ),
                const _Divider(),
                _SettingsTile(
                  icon: Icons.call,
                  color: Colors.red,
                  title: "Emergency Contacts",
                  subtitle: "Call for urgent help",
                  onTap: () {
                    _showEmergencyContactsDialog(context);
                  },
                ),
              ],
            ),

            const SizedBox(height: 30),

            // LOGOUT BUTTON
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: OutlinedButton.icon(
                onPressed: () async {
                  final confirm = await _showLogoutDialog(context);
                  if (confirm == true) {
                    await authController.signOut();
                    if (context.mounted) context.go('/login');
                  }
                },
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text("Sign Out", style: TextStyle(color: Colors.red)),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                  side: const BorderSide(color: Colors.red),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  backgroundColor: Colors.white,
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            
            // VERSION INFO
            const Center(
              child: Text(
                "MCH Patient App v1.0.0",
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            const SizedBox(height: 40),
          ]),
        ),
      ],
    );
  }

  Future<bool?> _showLogoutDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to sign out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyContactsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.emergency, color: Colors.red[700]),
            const SizedBox(width: 8),
            const Text('Emergency Contacts'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _EmergencyNumber(
              icon: Icons.local_hospital,
              label: 'Ambulance',
              number: '999',
              color: Colors.red,
            ),
            _EmergencyNumber(
              icon: Icons.medical_services,
              label: 'Health Helpline',
              number: '0800 720 720',
              color: Colors.green,
            ),
            _EmergencyNumber(
              icon: Icons.phone,
              label: 'General Emergency',
              number: '112',
              color: Colors.blue,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Emergency Number Row
class _EmergencyNumber extends StatelessWidget {
  final IconData icon;
  final String label;
  final String number;
  final Color color;

  const _EmergencyNumber({
    required this.icon,
    required this.label,
    required this.number,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: color.withOpacity(0.1),
        child: Icon(icon, color: color),
      ),
      title: Text(label),
      subtitle: Text(number, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: IconButton(
        icon: const Icon(Icons.call, color: Colors.green),
        onPressed: () {
          // TODO: Open phone dialer
        },
      ),
    );
  }
}

// Profile Info Card
class _ProfileInfoCard extends StatelessWidget {
  final MaternalProfile profile;

  const _ProfileInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.badge, label: 'ID Number', value: profile.idNumber ?? 'Not provided'),
          const Divider(height: 20),
          _InfoRow(icon: Icons.cake, label: 'Age', value: '${profile.age} years'),
          const Divider(height: 20),
          _InfoRow(icon: Icons.location_on, label: 'County', value: profile.county ?? 'Not provided'),
          const Divider(height: 20),
          _InfoRow(icon: Icons.location_city, label: 'Sub-County', value: profile.subCounty ?? 'Not provided'),
        ],
      ),
    );
  }
}

// Pregnancy Info Card
class _PregnancyInfoCard extends StatelessWidget {
  final MaternalProfile profile;

  const _PregnancyInfoCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(icon: Icons.pregnant_woman, label: 'Gravida', value: '${profile.gravida ?? "--"}'),
          const Divider(height: 20),
          _InfoRow(icon: Icons.child_friendly, label: 'Parity', value: '${profile.parity ?? "--"}'),
          if (profile.lmp != null) ...[
            const Divider(height: 20),
            _InfoRow(icon: Icons.event, label: 'Last Period (LMP)', 
              value: DateFormat('d MMM yyyy').format(profile.lmp!)),
          ],
          if (profile.edd != null) ...[
            const Divider(height: 20),
            _InfoRow(icon: Icons.celebration, label: 'Due Date (EDD)', 
              value: DateFormat('d MMM yyyy').format(profile.edd!)),
          ],
          const Divider(height: 20),
          _InfoRow(icon: Icons.bloodtype, label: 'Blood Group', value: profile.bloodGroup?.label ?? 'Not tested'),
        ],
      ),
    );
  }
}

// Emergency Contact Card
class _EmergencyContactCard extends StatelessWidget {
  final MaternalProfile profile;

  const _EmergencyContactCard({required this.profile});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? Colors.red.shade700 : Colors.red.shade100),
        boxShadow: isDark ? null : [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person, 
            label: 'Next of Kin', 
            value: profile.nextOfKinName ?? 'Not provided',
          ),
          if (profile.nextOfKinPhone != null) ...[
            const Divider(height: 20),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.phone, color: Colors.green, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Phone',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                      Text(
                        profile.nextOfKinPhone!,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.call, color: Colors.green),
                  onPressed: () {
                    // TODO: Make phone call
                  },
                ),
              ],
            ),
          ],
          if (profile.nextOfKinRelationship != null) ...[
            const Divider(height: 20),
            _InfoRow(
              icon: Icons.family_restroom, 
              label: 'Relationship', 
              value: profile.nextOfKinRelationship!,
            ),
          ],
        ],
      ),
    );
  }
}

// Info Row Widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.pink.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: const Color(0xFFE91E63), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey[600]),
              ),
              Text(
                value,
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Theme.of(context).textTheme.bodyLarge?.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// --- HELPER WIDGETS ---

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey[600],
          fontSize: 12,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
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
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.color,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Theme.of(context).textTheme.bodyLarge?.color)),
      subtitle: subtitle != null 
        ? Text(subtitle!, style: TextStyle(fontSize: 12, color: Theme.of(context).textTheme.bodySmall?.color)) 
        : null,
      trailing: trailing ?? const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: Colors.grey[100], indent: 64);
  }
}

/// Profile Photo Widget with upload capability
class _ProfilePhotoWidget extends StatefulWidget {
  final String? photoUrl;
  final String userName;
  final String? profileId;
  final VoidCallback? onPhotoUpdated;

  const _ProfilePhotoWidget({
    required this.photoUrl,
    required this.userName,
    required this.profileId,
    this.onPhotoUpdated,
  });

  @override
  State<_ProfilePhotoWidget> createState() => _ProfilePhotoWidgetState();
}

class _ProfilePhotoWidgetState extends State<_ProfilePhotoWidget> {
  final PhotoUploadService _photoService = PhotoUploadService();
  bool _isUploading = false;
  File? _pendingImage;

  Future<void> _showImageSourceDialog() async {
    if (widget.profileId == null || widget.profileId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile not found. Please try again later.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final source = await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Update Profile Photo',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.photo_library, color: Colors.blue),
              ),
              title: const Text('Choose from Gallery'),
              subtitle: const Text('Select an existing photo'),
              onTap: () => Navigator.pop(context, 'gallery'),
            ),
            ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.camera_alt, color: Colors.green),
              ),
              title: const Text('Take a Photo'),
              subtitle: const Text('Use your camera'),
              onTap: () => Navigator.pop(context, 'camera'),
            ),
            if (widget.photoUrl != null && widget.photoUrl!.isNotEmpty)
              ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.delete, color: Colors.red),
                ),
                title: const Text('Remove Photo'),
                subtitle: const Text('Delete current photo'),
                onTap: () => Navigator.pop(context, 'remove'),
              ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );

    if (source == null) return;

    if (source == 'remove') {
      await _removePhoto();
      return;
    }

    File? imageFile;
    if (source == 'gallery') {
      imageFile = await _photoService.pickFromGallery();
    } else if (source == 'camera') {
      imageFile = await _photoService.takePhoto();
    }

    if (imageFile != null) {
      await _uploadPhoto(imageFile);
    }
  }

  Future<void> _uploadPhoto(File imageFile) async {
    setState(() {
      _isUploading = true;
      _pendingImage = imageFile;
    });

    try {
      // Upload to Supabase Storage
      final photoUrl = await _photoService.uploadProfilePhoto(
        imageFile: imageFile,
        maternalProfileId: widget.profileId!,
      );

      if (photoUrl != null) {
        // Update the database
        final success = await _photoService.updateProfilePhotoUrl(
          maternalProfileId: widget.profileId!,
          photoUrl: photoUrl,
        );

        if (success) {
          // Delete old photo if exists
          if (widget.photoUrl != null && widget.photoUrl!.isNotEmpty) {
            await _photoService.deleteOldPhoto(widget.photoUrl);
          }

          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile photo updated!'),
                backgroundColor: Colors.green,
              ),
            );
          }

          // Refresh the profile
          widget.onPhotoUpdated?.call();
        } else {
          throw Exception('Failed to update database');
        }
      } else {
        throw Exception('Failed to upload photo');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error uploading photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isUploading = false;
          _pendingImage = null;
        });
      }
    }
  }

  Future<void> _removePhoto() async {
    setState(() => _isUploading = true);

    try {
      final success = await _photoService.updateProfilePhotoUrl(
        maternalProfileId: widget.profileId!,
        photoUrl: '',
      );

      if (success && widget.photoUrl != null) {
        await _photoService.deleteOldPhoto(widget.photoUrl);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Profile photo removed'),
              backgroundColor: Colors.orange,
            ),
          );
        }

        widget.onPhotoUpdated?.call();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error removing photo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _isUploading ? null : _showImageSourceDialog,
      child: Stack(
        children: [
          // Main Avatar
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 46,
              backgroundColor: Colors.pink.shade50,
              backgroundImage: _getBackgroundImage(),
              child: _shouldShowInitial()
                  ? Text(
                      widget.userName.isNotEmpty 
                          ? widget.userName[0].toUpperCase() 
                          : "M",
                      style: const TextStyle(
                        fontSize: 36,
                        color: Color(0xFFE91E63),
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
            ),
          ),
          
          // Loading Overlay
          if (_isUploading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 30,
                    height: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          
          // Camera Icon Badge
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: Icon(
                _isUploading ? Icons.hourglass_empty : Icons.camera_alt,
                color: Colors.white,
                size: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  ImageProvider? _getBackgroundImage() {
    // Show pending image first (for immediate feedback)
    if (_pendingImage != null) {
      return FileImage(_pendingImage!);
    }
    
    // Show existing photo from URL
    if (widget.photoUrl != null && widget.photoUrl!.isNotEmpty) {
      return NetworkImage(widget.photoUrl!);
    }
    
    return null;
  }

  bool _shouldShowInitial() {
    return _pendingImage == null && 
           (widget.photoUrl == null || widget.photoUrl!.isEmpty);
  }
}
