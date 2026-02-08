import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/fertility_calculator.dart';
import '../../domain/models/period_entry.dart';

class FertilityCalendar extends StatelessWidget {
  final DateTime focusedMonth;
  final PeriodEntry? lastPeriod;
  final int avgCycleLength;
  final Function(DateTime) onMonthChanged;

  const FertilityCalendar({
    super.key,
    required this.focusedMonth,
    required this.lastPeriod,
    required this.avgCycleLength,
    required this.onMonthChanged,
  });

  @override
  Widget build(BuildContext context) {
    // Determine the days to display
    final firstDayOfMonth = DateTime(focusedMonth.year, focusedMonth.month, 1);
    final daysInMonth =
        DateUtils.getDaysInMonth(focusedMonth.year, focusedMonth.month);

    // Calculate offset for the first day (0 = Sunday, 1 = Monday, etc.)
    // DateTime.weekday returns 1 for Mon, 7 for Sun.
    // We want Sunday to be 0 (first column).
    final firstWeekday = firstDayOfMonth.weekday % 7;

    final totalCells = firstWeekday + daysInMonth;
    final totalRows = (totalCells / 7).ceil();

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Header: Month Year + Navigation
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.chevron_left),
                  onPressed: () {
                    onMonthChanged(
                        DateTime(focusedMonth.year, focusedMonth.month - 1));
                  },
                ),
                Text(
                  DateFormat.yMMMM().format(focusedMonth),
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
                IconButton(
                  icon: const Icon(Icons.chevron_right),
                  onPressed: () {
                    onMonthChanged(
                        DateTime(focusedMonth.year, focusedMonth.month + 1));
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Weekday Headers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: ['S', 'M', 'T', 'W', 'T', 'F', 'S'].map((day) {
                return SizedBox(
                  width: 32,
                  child: Text(
                    day,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.grey[700]),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 8),

            // Calendar Grid
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: totalRows,
              itemBuilder: (context, rowIndex) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (colIndex) {
                    final dayOffset = (rowIndex * 7) + colIndex - firstWeekday;
                    final day = dayOffset + 1;

                    if (day < 1 || day > daysInMonth) {
                      return const SizedBox(width: 32, height: 32);
                    }

                    final date =
                        DateTime(focusedMonth.year, focusedMonth.month, day);
                    return _DayCell(
                      date: date,
                      lastPeriod: lastPeriod,
                      avgCycleLength: avgCycleLength,
                    );
                  }),
                );
              },
            ),

            const SizedBox(height: 16),

            // Legend
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _LegendItem(color: Color(0xFFEF5350), label: 'Period'),
                _LegendItem(color: Color(0xFF66BB6A), label: 'Fertile'),
                _LegendItem(color: Color(0xFF42A5F5), label: 'Ovulation'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  final DateTime date;
  final PeriodEntry? lastPeriod;
  final int avgCycleLength;

  const _DayCell({
    required this.date,
    required this.lastPeriod,
    required this.avgCycleLength,
  });

  @override
  Widget build(BuildContext context) {
    Color? bgColor;
    Color textColor = Colors.black87;
    BoxBorder? border;

    if (lastPeriod != null) {
      // Logic for determining color
      final ovulationDate = FertilityCalculator.predictOvulation(
          lastPeriod!.startDate,
          cycleLength: avgCycleLength);

      if (FertilityCalculator.isProbablePeriodDay(date, lastPeriod!.startDate,
          cycleLength: avgCycleLength)) {
        bgColor = const Color(0xFFEF5350); // Red
        textColor = Colors.white;
      } else if (FertilityCalculator.isOvulationDate(date, ovulationDate)) {
        bgColor = Colors.transparent;
        border =
            Border.all(color: const Color(0xFF42A5F5), width: 2); // Blue Circle
      } else if (FertilityCalculator.isFertileDate(date, ovulationDate)) {
        bgColor = const Color(0xFF66BB6A).withOpacity(0.3); // Light Green
      }
    }

    // Highlight today
    final isToday = DateUtils.isSameDay(date, DateTime.now());
    if (isToday && border == null) {
      border = Border.all(color: Theme.of(context).primaryColor, width: 1);
    }

    return Container(
      width: 32,
      height: 32,
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: bgColor,
        border: border,
      ),
      alignment: Alignment.center,
      child: Text(
        '${date.day}',
        style: TextStyle(
          color: textColor,
          fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label, // We should translate this eventually
          style: const TextStyle(fontSize: 10, color: Colors.grey),
        ),
      ],
    );
  }
}
