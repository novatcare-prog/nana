import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers/auth_provider.dart';
import '../../../../core/providers/maternal_profile_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. DATA LAYER - Auth Provider
    final user = ref.watch(currentUserProvider);
    final userName = user?.userMetadata?['full_name'] as String? ?? 'Mama';
    final userIdNumber = user?.userMetadata?['id_number'] as String?;

    // 2. MATERNAL PROFILE DATA - Real data from Supabase
    final maternalProfileAsync = ref.watch(currentMaternalProfileProvider);
    final isPregnant = ref.watch(hasActivePregnancyProvider);
    final pregnancyWeek = ref.watch(pregnancyWeekProvider);
    final daysUntilDue = ref.watch(daysUntilDueDateProvider);
    final facilityName = maternalProfileAsync.value?.facilityName;

    // 3. Get ID for SHA card (use ID number from user metadata)
    final shaNumber = userIdNumber != null ? "ID: $userIdNumber" : "No ID";

    // --- MOCK DATA (Connect to Hive/Riverpod in Phase 2) ---
    const bool isOffline = false;
    const bool hasUrgentAlert = true; // Simulating an overdue vaccine

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            // TODO: Trigger Sync Manager
            await Future.delayed(const Duration(seconds: 1));
          },
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // 2. APP BAR (Identity & Sync Status)
              SliverAppBar(
                floating: true,
                pinned: true,
                backgroundColor: Theme.of(context).cardTheme.color ??
                    Theme.of(context).scaffoldBackgroundColor,
                elevation: 0,
                title: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: const Color(0xFFE91E63), // Primary Pink
                      radius: 18,
                      child: Text(
                        userName.isNotEmpty ? userName[0].toUpperCase() : "M",
                        style: const TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getTimeGreeting(),
                          style:
                              TextStyle(fontSize: 10, color: Colors.grey[600]),
                        ),
                        Text(
                          userName,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                actions: [
                  // SYNC INDICATOR (Vital for Offline Trust)
                  Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: isOffline ? Colors.orange[50] : Colors.green[50],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isOffline ? Colors.orange : Colors.green,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          isOffline ? Icons.cloud_off : Icons.cloud_done,
                          size: 14,
                          color: isOffline
                              ? Colors.orange[800]
                              : Colors.green[800],
                        ),
                        const SizedBox(width: 6),
                        Text(
                          isOffline ? "Offline" : "Synced",
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: isOffline
                                ? Colors.orange[800]
                                : Colors.green[800],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // NOTIFICATIONS
                  IconButton(
                    icon: Icon(Icons.notifications_outlined,
                        color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () {}, // TODO: Open Notifications
                  ),
                ],
              ),

              // 3. MAIN DASHBOARD CONTENT
              SliverPadding(
                padding: const EdgeInsets.all(16.0),
                sliver: SliverList(
                  delegate: SliverChildListDelegate([
                    // A. SHA IDENTITY CARD (The "Legal" Wallet)
                    _ShaCard(
                      name: userName,
                      shaNumber: shaNumber,
                      isPregnant: isPregnant,
                      pregnancyWeek: pregnancyWeek,
                      daysUntilDue: daysUntilDue,
                      facilityName: facilityName,
                    ),

                    const SizedBox(height: 24),

                    // B. URGENT ALERT (Only visible if needed)
                    if (hasUrgentAlert) ...[
                      _UrgentActionAlert(
                        title: "Action Required",
                        message: "Baby John missed 6-week Polio vaccine.",
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Missed Vaccine'),
                              content: const Text(
                                  'Baby John missed the Polio vaccine due at 6 weeks. Please book an appointment immediately to catch up.'),
                              actions: [
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('Later')),
                                FilledButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      context.go('/appointments');
                                    },
                                    style: FilledButton.styleFrom(
                                        backgroundColor: Colors.red),
                                    child: const Text('Book Now')),
                              ],
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                    ],

                    // C. CHILDREN QUICK VIEW (Horizontal Scroll)
                    // Matches "Phase 1: Children List" requirement
                    _ChildrenCarousel(),

                    const SizedBox(height: 24),

                    // D. QUICK ACTIONS GRID
                    Text(
                      "Quick Actions",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                    const SizedBox(height: 12),

                    _QuickActionsGrid(),

                    const SizedBox(height: 24),

                    // E. HEALTH TIP (Education)
                    _HealthTipOfTheDay(),

                    const SizedBox(height: 40),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getTimeGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Habari ya Asubuhi';
    if (hour < 16) return 'Habari ya Mchana';
    return 'Habari ya Jioni';
  }
}

// ==========================================
//               CUSTOM WIDGETS
// ==========================================

/// The Official Digital Identity Card
/// Uses Teal/Gold to signify "Government Authority" vs the Pink App Theme
class _ShaCard extends StatelessWidget {
  final String name;
  final String shaNumber;
  final bool isPregnant;
  final int? pregnancyWeek;
  final int? daysUntilDue;
  final String? facilityName;

  const _ShaCard({
    required this.name,
    required this.shaNumber,
    required this.isPregnant,
    this.pregnancyWeek,
    this.daysUntilDue,
    this.facilityName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220, // Increased height to accommodate facility
      width: double.infinity,
      decoration: BoxDecoration(
        // Official Teal Gradient
        gradient: const LinearGradient(
          colors: [Color(0xFF00695C), Color(0xFF004D40)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.teal.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background Watermark (Shield)
          Positioned(
            right: -40,
            top: -40,
            child: Icon(Icons.shield_outlined,
                size: 220, color: Colors.white.withValues(alpha: 0.05)),
          ),

          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // CARD HEADER
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        // Flag Placeholder
                        Container(
                          width: 24,
                          height: 24,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Text("🇰🇪",
                              style: TextStyle(fontSize: 14)),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "SOCIAL HEALTH AUTHORITY",
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.2,
                              ),
                            ),
                            const Text(
                              "Universal Coverage",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Icon(Icons.qr_code, color: Colors.white, size: 28),
                  ],
                ),

                const SizedBox(height: 16),

                // COVERAGE BADGE (PHF vs SHIF)
                if (isPregnant)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle,
                            color: Color(0xFF69F0AE), size: 14),
                        SizedBox(width: 8),
                        Text(
                          "Primary Healthcare Fund (PHF)", // Correct Legal Term
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 11),
                        ),
                      ],
                    ),
                  ),

                const Spacer(),

                // FACILITY DISPLAY
                if (facilityName != null && facilityName!.isNotEmpty) ...[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "REGISTERED FACILITY",
                        style: TextStyle(color: Colors.white60, fontSize: 9),
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.local_hospital,
                              color: Colors.white70, size: 14),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              facilityName!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                ],

                // BOTTOM DETAILS
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "MEMBER NAME",
                          style: TextStyle(color: Colors.white60, fontSize: 9),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "SHA / ID NUMBER",
                          style: TextStyle(color: Colors.white60, fontSize: 9),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          shaNumber,
                          style: const TextStyle(
                            color: Color(0xFFFFD740), // Gold
                            fontSize: 16,
                            fontFamily: 'Monospace',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal Carousel for Children (Phase 1 Requirement)
class _ChildrenCarousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MY CHILDREN',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                  letterSpacing: 1.2,
                ),
              ),
              TextButton(
                onPressed: () => context.go('/children'),
                child: const Text('View All',
                    style: TextStyle(color: Color(0xFFE91E63))),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 130,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              const _ChildSummaryCard(
                name: 'Grace',
                status: 'Healthy',
                color: Colors.blue,
                icon: Icons.face_3,
              ),
              const _ChildSummaryCard(
                name: 'John',
                status: 'Vaccine Due',
                color: Colors.orange,
                icon: Icons.face_6,
                isAlert: true,
              ),
              // "Add Child" Placeholder
              InkWell(
                onTap: () => context.push('/children/add'),
                child: Container(
                  width: 100,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: Colors.grey[300]!, style: BorderStyle.solid),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add, color: Colors.grey[600]),
                      const SizedBox(height: 4),
                      Text("Add Child",
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ChildSummaryCard extends StatelessWidget {
  final String name;
  final String status;
  final Color color;
  final IconData icon;
  final bool isAlert;

  const _ChildSummaryCard({
    required this.name,
    required this.status,
    required this.color,
    required this.icon,
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ??
            (isDark ? const Color(0xFF1E1E1E) : Colors.white),
        borderRadius: BorderRadius.circular(16),
        border: isAlert
            ? Border.all(color: Colors.orange.withValues(alpha: 0.5), width: 2)
            : null,
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: color.withValues(alpha: 0.1),
            radius: 20,
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            status,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 10,
              color: isAlert ? Colors.orange[800] : Colors.grey[600],
              fontWeight: isAlert ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 0.95,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      children: [
        _QuickActionBtn(
          icon: Icons.calendar_month,
          label: 'My Visits',
          color: Colors.blue,
          onTap: () => context.push('/anc-visits'),
        ),
        _QuickActionBtn(
          icon: Icons.edit_note,
          label: 'Journal',
          color: Colors.pink,
          onTap: () => context.push('/journal'),
        ),
        _QuickActionBtn(
          icon: Icons.local_hospital,
          label: 'Clinics',
          color: Colors.teal,
          onTap: () => context.push('/clinics'),
        ),
        _QuickActionBtn(
          icon: Icons.menu_book,
          label: 'Resources',
          color: Colors.purple,
          onTap: () => context.push('/handbook'),
        ),
        _QuickActionBtn(
          icon: Icons.emergency,
          label: 'Emergency',
          color: Colors.red,
          onTap: () => context.push('/help'),
        ),
        _QuickActionBtn(
          icon: Icons.settings,
          label: 'Settings',
          color: Colors.grey,
          onTap: () => context.push('/settings'),
        ),
      ],
    );
  }
}

class _QuickActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _QuickActionBtn(
      {required this.icon,
      required this.label,
      required this.color,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).cardTheme.color ??
              (isDark ? const Color(0xFF1E1E1E) : Colors.white),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
              color: isDark ? Colors.grey.shade700 : Colors.grey.shade200),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.grey.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 22),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 11),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

class _UrgentActionAlert extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onTap;

  const _UrgentActionAlert({
    required this.title,
    required this.message,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.red[100]!),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[100],
                shape: BoxShape.circle,
              ),
              child:
                  const Icon(Icons.priority_high, color: Colors.red, size: 20),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    message,
                    style: TextStyle(color: Colors.red[900], fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.red),
          ],
        ),
      ),
    );
  }
}

class _HealthTipOfTheDay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE3F2FD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lightbulb, color: Color(0xFF1976D2), size: 28),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "DID YOU KNOW?",
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1976D2),
                    letterSpacing: 1.5,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Iron-rich foods like spinach and beans help prevent anemia during pregnancy.",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0D47A1),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
