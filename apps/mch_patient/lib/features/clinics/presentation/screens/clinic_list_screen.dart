import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/clinic_provider.dart';
import '../widgets/clinic_card.dart';
import '../widgets/clinic_map_view.dart';
import '../../../../core/utils/error_helper.dart';
import 'package:go_router/go_router.dart';

class ClinicListScreen extends ConsumerStatefulWidget {
  const ClinicListScreen({super.key});

  @override
  ConsumerState<ClinicListScreen> createState() => _ClinicListScreenState();
}

class _ClinicListScreenState extends ConsumerState<ClinicListScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clinicsAsync = ref.watch(nearbyClinicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Find a Clinic'),
        bottom: TabBar(
          controller: _tabController,
          labelColor: const Color(0xFFE91E63),
          indicatorColor: const Color(0xFFE91E63),
          unselectedLabelColor: Colors.grey,
          tabs: const [
            Tab(text: 'List View', icon: Icon(Icons.list)),
            Tab(text: 'Map View', icon: Icon(Icons.map)),
          ],
        ),
      ),
      body: clinicsAsync.when(
        data: (clinics) {
          if (clinics.isEmpty) {
            return const Center(child: Text('No clinics found nearby.'));
          }
          return TabBarView(
            controller: _tabController,
            physics:
                const NeverScrollableScrollPhysics(), // Important for map handling
            children: [
              // List View
              ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: clinics.length,
                itemBuilder: (context, index) {
                  return ClinicCard(
                    clinic: clinics[index],
                    onTap: () {
                      context.pushNamed(
                        'clinic-details',
                        pathParameters: {'id': clinics[index].id},
                        extra: clinics[index],
                      );
                    },
                    onDirectionsTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Directions feature coming soon')),
                      );
                    },
                  );
                },
              ),
              // Map View
              ClinicMapView(clinics: clinics),
            ],
          );
        },
        loading: () => const Center(
          child: CircularProgressIndicator(color: Color(0xFFE91E63)),
        ),
        error: (error, _) => ErrorHelper.buildErrorWidget(
          error,
          onRetry: () => ref.invalidate(nearbyClinicsProvider),
        ),
      ),
    );
  }
}
