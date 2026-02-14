import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mch_core/mch_core.dart';
import '../../../../core/providers/maternal_profile_provider.dart';
import '../../../../core/providers/child_provider.dart';
import '../../data/tips_data.dart';

/// Provider that returns the "Tip of the Day" based on the user's current status
final dailyTipProvider = FutureProvider<Tip?>((ref) async {
  // 1. Gather User Context
  final isPregnant = ref.watch(hasActivePregnancyProvider);
  final pregnancyWeek = ref.watch(pregnancyWeekProvider);

  // We await the future of the children provider to ensure we have the data
  // Using .future allows us to await the result rather than just checking the current state
  final children = await ref
      .watch(patientChildrenProvider.future)
      .catchError((_) => <ChildProfile>[]);

  // 2. Filter Tips
  final relevantTips = TipsRepository.allTips.where((tip) {
    bool matchesPregnancy = false;
    bool matchesChild = false;
    bool matchesGeneral = tip.category == TipCategory.general;

    // A. Pregnancy Logic
    if (isPregnant &&
        (tip.category == TipCategory.pregnancy ||
            tip.category == TipCategory.nutrition)) {
      if (tip.minPregnancyWeek != null && tip.maxPregnancyWeek != null) {
        // specific week range
        if (pregnancyWeek != null &&
            pregnancyWeek >= tip.minPregnancyWeek! &&
            pregnancyWeek <= tip.maxPregnancyWeek!) {
          matchesPregnancy = true;
        }
      } else if (tip.minPregnancyWeek == null && tip.maxPregnancyWeek == null) {
        // general pregnancy tip
        matchesPregnancy = true;
      }
    }

    // B. Child Logic
    // If the user has children, we check if the tip is relevant for ANY of them
    if (children.isNotEmpty &&
        (tip.category == TipCategory.baby ||
            tip.category == TipCategory.development ||
            tip.category == TipCategory.nutrition ||
            tip.category == TipCategory.health)) {
      for (final child in children) {
        // Calculate child age in months
        final dob = child.dateOfBirth;
        final ageMonths = DateTime.now().difference(dob).inDays ~/ 30; // approx

        if (tip.minChildAgeMonths != null && tip.maxChildAgeMonths != null) {
          if (ageMonths >= tip.minChildAgeMonths! &&
              ageMonths <= tip.maxChildAgeMonths!) {
            matchesChild = true;
            break; // Found a matching child
          }
        } else if (tip.minChildAgeMonths == null &&
            tip.maxChildAgeMonths == null) {
          // general child tip
          matchesChild = true;
          break;
        }
      }
    }

    // C. General Health Logic
    return matchesPregnancy || matchesChild || matchesGeneral;
  }).toList();

  if (relevantTips.isEmpty) {
    // Fallback to general tips if nothing specific matches
    return TipsRepository.allTips
            .where((t) => t.category == TipCategory.general)
            .firstOrNull ??
        TipsRepository.allTips.first;
  }

  // 3. Select Daily Tip
  // Use day of year to rotate through the filtered list
  final dayOfYear = int.parse(
      "${DateTime.now().year}${DateTime.now().difference(DateTime(DateTime.now().year, 1, 1)).inDays.toString().padLeft(3, '0')}");

  final index = dayOfYear % relevantTips.length;

  return relevantTips[index];
});
