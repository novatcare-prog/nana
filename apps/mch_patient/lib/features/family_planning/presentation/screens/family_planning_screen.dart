import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../providers/period_provider.dart';
import '../widgets/fertility_calendar.dart';
import '../widgets/cycle_info_card.dart';

class FamilyPlanningScreen extends ConsumerStatefulWidget {
  const FamilyPlanningScreen({super.key});

  @override
  ConsumerState<FamilyPlanningScreen> createState() =>
      _FamilyPlanningScreenState();
}

class _FamilyPlanningScreenState extends ConsumerState<FamilyPlanningScreen> {
  DateTime _focusedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    // Watch Providers
    final latestPeriod = ref.watch(latestPeriodProvider);
    final avgCycleLength = ref.watch(averageCycleLengthProvider);
    final fertilityStatus = ref.watch(currentFertilityStatusProvider);
    final daysUntilNext = ref.watch(daysUntilNextPeriodProvider);
    final periodicEntries = ref.watch(periodEntriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('family_planning.title'.tr()), // "Family Planning"
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              // Show disclaimer dialog
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('family_planning.disclaimer_title'.tr()),
                  content: Text('family_planning.disclaimer_body'.tr()),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('common.ok'.tr()),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Status Card
            CycleInfoCard(
              status: fertilityStatus,
              daysUntilPeriod: daysUntilNext,
              onLogPeriod: () => context.push('/family-planning/add-period'),
            ),

            const SizedBox(height: 24),

            // 2. Calendar
            Text(
              'family_planning.calendar_title'.tr(), // "Fertility Calendar"
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),
            FertilityCalendar(
              focusedMonth: _focusedMonth,
              lastPeriod: latestPeriod,
              avgCycleLength: avgCycleLength,
              onMonthChanged: (newMonth) {
                setState(() {
                  _focusedMonth = newMonth;
                });
              },
            ),

            const SizedBox(height: 24),

            // 3. Resources Button
            FilledButton.tonalIcon(
              onPressed: () => context.push('/family-planning/resources'),
              icon: const Icon(Icons.menu_book),
              label: Text('family_planning.view_resources'.tr()),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),

            const SizedBox(height: 32),

            // 4. Recent History List (Mini)
            Text(
              'family_planning.history_title'.tr(), // "Cycle History"
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 8),

            periodicEntries.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Text('Error: $err'),
              data: (entries) {
                if (entries.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'family_planning.no_history'.tr(),
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                    ),
                  );
                }

                // Show last 3 entries
                final recent = entries.take(3).toList();

                return Card(
                  elevation: 0,
                  color: Theme.of(context).cardColor,
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: Colors.grey.shade200),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: recent.length,
                    separatorBuilder: (c, i) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final entry = recent[index];
                      return ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xFFFFEBEE),
                          child: Icon(Icons.water_drop,
                              color: Color(0xFFEF5350), size: 20),
                        ),
                        title: Text(
                          DateFormat.yMMMMd().format(entry.startDate),
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          entry.notes ??
                              (entry.symptoms.isNotEmpty
                                  ? entry.symptoms.join(', ')
                                  : 'No notes'),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        trailing: Text(
                          '${entry.periodLength} days', // "5 days"
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/family-planning/add-period'),
        tooltip: 'family_planning.log_period'.tr(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
