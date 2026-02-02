import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/clinic_provider.dart';
import '../widgets/clinic_card.dart';
import '../../../../core/utils/error_helper.dart';
import 'package:go_router/go_router.dart';

class ClinicListScreen extends ConsumerWidget {
  const ClinicListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final clinicsAsync = ref.watch(nearbyClinicsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('clinics.title'.tr()),
      ),
      body: clinicsAsync.when(
        data: (clinics) {
          if (clinics.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.local_hospital_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'clinics.no_clinics'.tr(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'clinics.check_back'.tr(),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
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
                    SnackBar(content: Text('clinics.directions_coming'.tr())),
                  );
                },
              );
            },
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
