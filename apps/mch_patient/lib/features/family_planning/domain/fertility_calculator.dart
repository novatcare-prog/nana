import 'package:flutter/material.dart';

/// Utilities for calculating fertility windows based on the Rhythm Method.
///
/// DISCLAIMER: The rhythm method is not 100% accurate and should not be relied upon
/// as a sole method of contraception.
class FertilityCalculator {
  /// Predict next period start date
  /// [lastPeriodStart]: The start date of the last period
  /// [cycleLength]: Average cycle length (default 28 days)
  static DateTime predictNextPeriod(DateTime lastPeriodStart,
      {int cycleLength = 28}) {
    return lastPeriodStart.add(Duration(days: cycleLength));
  }

  /// Predict ovulation date
  /// Ovulation typically occurs ~14 days before the NEXT period starts.
  static DateTime predictOvulation(DateTime lastPeriodStart,
      {int cycleLength = 28}) {
    final nextPeriod =
        predictNextPeriod(lastPeriodStart, cycleLength: cycleLength);
    return nextPeriod.subtract(const Duration(days: 14));
  }

  /// Calculate the fertile window
  /// Standard calculation: 5 days before ovulation + day of ovulation (6 days total).
  /// Some methods include 1-2 days after ovulation, but we will stick to the 6-day window for now.
  static DateTimeRange getFertileWindow(DateTime ovulationDate) {
    return DateTimeRange(
      start: ovulationDate.subtract(const Duration(days: 5)),
      end: ovulationDate, // Inclusive of ovulation day
    );
  }

  /// Check if a specific date is within the fertile window
  static bool isFertileDate(DateTime date, DateTime ovulationDate) {
    final window = getFertileWindow(ovulationDate);
    // DateTimeRange 'end' is exclusive in some contexts but inclusive for logic usually.
    // We'll compare manually to be safe and precise with dates (ignoring time).
    final check = DateUtils.dateOnly(date);
    final start = DateUtils.dateOnly(window.start);
    final end = DateUtils.dateOnly(window.end);

    return (check.isAfter(start) || check.isAtSameMomentAs(start)) &&
        (check.isBefore(end) || check.isAtSameMomentAs(end));
  }

  /// Check if a date is predicted ovulation day
  static bool isOvulationDate(DateTime date, DateTime ovulationDate) {
    return DateUtils.isSameDay(date, ovulationDate);
  }

  /// Check if a date is a probable period day
  static bool isProbablePeriodDay(DateTime date, DateTime lastPeriodStart,
      {int cycleLength = 28, int periodDuration = 5}) {
    // Current cycle period
    if (date.isAfter(lastPeriodStart.subtract(const Duration(days: 1))) &&
        date.isBefore(lastPeriodStart.add(Duration(days: periodDuration)))) {
      return true;
    }

    // Next predicted period
    final nextPeriod =
        predictNextPeriod(lastPeriodStart, cycleLength: cycleLength);
    if (date.isAfter(nextPeriod.subtract(const Duration(days: 1))) &&
        date.isBefore(nextPeriod.add(Duration(days: periodDuration)))) {
      return true;
    }

    return false;
  }
}
