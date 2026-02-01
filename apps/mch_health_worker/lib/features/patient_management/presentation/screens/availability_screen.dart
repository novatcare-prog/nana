import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvailabilityScreen extends ConsumerStatefulWidget {
  const AvailabilityScreen({super.key});

  @override
  ConsumerState<AvailabilityScreen> createState() => _AvailabilityScreenState();
}

class _AvailabilityScreenState extends ConsumerState<AvailabilityScreen> {
  bool _isLoading = true;
  bool _isSaving = false;

  // Structure: {1: {enabled: true, start: TimeOfDay(08,00), end: TimeOfDay(17,00)}}
  final Map<int, AvailabilityDay> _availability = {};

  final List<String> _days = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];

  @override
  void initState() {
    super.initState();
    _fetchAvailability();
  }

  Future<void> _fetchAvailability() async {
    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;

      final response = await supabase
          .from('health_worker_availability')
          .select()
          .eq('user_id', userId);

      final data = response as List<dynamic>;

      setState(() {
        // Initialize defaults first
        for (int i = 1; i <= 7; i++) {
          _availability[i] = AvailabilityDay(
            dayOfWeek: i,
            enabled: false,
            startTime: const TimeOfDay(hour: 8, minute: 0),
            endTime: const TimeOfDay(hour: 17, minute: 0),
          );
        }

        // Apply fetched data
        for (var item in data) {
          final day = item['day_of_week'] as int;
          final startParts = (item['start_time'] as String).split(':');
          final endParts = (item['end_time'] as String).split(':');

          _availability[day] = AvailabilityDay(
            dayOfWeek: day,
            enabled: item['is_available'] as bool? ?? true,
            startTime: TimeOfDay(
                hour: int.parse(startParts[0]),
                minute: int.parse(startParts[1])),
            endTime: TimeOfDay(
                hour: int.parse(endParts[0]), minute: int.parse(endParts[1])),
          );
        }

        _isLoading = false;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading availability: $e')),
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _saveAvailability() async {
    setState(() => _isSaving = true);

    try {
      final supabase = Supabase.instance.client;
      final userId = supabase.auth.currentUser!.id;

      // Prepare upserts
      final updates = <Map<String, dynamic>>[];

      _availability.forEach((day, data) {
        // Only save enabled days, OR save all to keep a record of disabled days too?
        // Let's save all so we persist time preferences even when disabled.
        updates.add({
          'user_id': userId,
          'day_of_week': day,
          'is_available': data.enabled,
          'start_time': _formatTime(data.startTime),
          'end_time': _formatTime(data.endTime),
          'updated_at': DateTime.now().toIso8601String(),
        });
      });

      // Upsert
      await supabase.from('health_worker_availability').upsert(
            updates,
            onConflict: 'user_id,day_of_week',
          );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Availability updated successfully'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving availability: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  String _formatTime(TimeOfDay time) {
    // HH:MM:00
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute:00';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Availability'),
        actions: [
          IconButton(
            icon: _isSaving
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.check),
            onPressed: _isSaving || _isLoading ? null : _saveAvailability,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.separated(
              itemCount: 7,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final dayIndex = index + 1; // 1-7
                final dayData = _availability[dayIndex]!;
                final dayName = _days[index];

                return SwitchListTile(
                  title: Text(
                    dayName,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: dayData.enabled
                      ? Row(
                          children: [
                            GestureDetector(
                              onTap: () => _pickTime(dayIndex, true),
                              child: Chip(
                                label: Text(dayData.startTime.format(context)),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Text('to'),
                            const SizedBox(width: 8),
                            GestureDetector(
                              onTap: () => _pickTime(dayIndex, false),
                              child: Chip(
                                label: Text(dayData.endTime.format(context)),
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                          ],
                        )
                      : const Text('Unavailable'),
                  value: dayData.enabled,
                  onChanged: (val) {
                    setState(() {
                      _availability[dayIndex] = dayData.copyWith(enabled: val);
                    });
                  },
                );
              },
            ),
    );
  }

  Future<void> _pickTime(int dayIndex, bool isStart) async {
    final currentData = _availability[dayIndex]!;
    final initial = isStart ? currentData.startTime : currentData.endTime;

    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );

    if (picked != null) {
      setState(() {
        if (isStart) {
          _availability[dayIndex] = currentData.copyWith(startTime: picked);
        } else {
          _availability[dayIndex] = currentData.copyWith(endTime: picked);
        }
      });
    }
  }
}

class AvailabilityDay {
  final int dayOfWeek;
  final bool enabled;
  final TimeOfDay startTime;
  final TimeOfDay endTime;

  AvailabilityDay({
    required this.dayOfWeek,
    required this.enabled,
    required this.startTime,
    required this.endTime,
  });

  AvailabilityDay copyWith({
    bool? enabled,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
  }) {
    return AvailabilityDay(
      dayOfWeek: dayOfWeek,
      enabled: enabled ?? this.enabled,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
