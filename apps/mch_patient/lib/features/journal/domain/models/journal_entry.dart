import 'package:uuid/uuid.dart';

/// Available moods for journal entries
enum JournalMood {
  happy('Happy', '😊'),
  excited('Excited', '🤩'),
  grateful('Grateful', '🙏'),
  calm('Calm', '😌'),
  tired('Tired', '😴'),
  anxious('Anxious', '😰'),
  sad('Sad', '😢'),
  sick('Sick', '🤒');

  final String label;
  final String emoji;

  const JournalMood(this.label, this.emoji);

  static JournalMood? fromString(String? value) {
    if (value == null) return null;
    try {
      return JournalMood.values.firstWhere((m) => m.name == value);
    } catch (_) {
      return null;
    }
  }
}

class JournalEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final String? category;
  final JournalMood? mood;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    this.category,
    this.mood,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntry.create({
    required String title,
    required String content,
    String? category,
    JournalMood? mood,
    DateTime? date,
  }) {
    final now = DateTime.now();
    return JournalEntry(
      id: const Uuid().v4(),
      date: date ?? now,
      title: title,
      content: content,
      category: category,
      mood: mood,
      createdAt: now,
      updatedAt: now,
    );
  }

  JournalEntry copyWith({
    String? title,
    String? content,
    String? category,
    JournalMood? mood,
    DateTime? date,
    bool clearMood = false,
  }) {
    return JournalEntry(
      id: id,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
      mood: clearMood ? null : (mood ?? this.mood),
      createdAt: createdAt,
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date.toIso8601String(),
      'title': title,
      'content': content,
      'category': category,
      'mood': mood?.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory JournalEntry.fromJson(Map<String, dynamic> json) {
    return JournalEntry(
      id: json['id'],
      date: DateTime.parse(json['date']),
      title: json['title'],
      content: json['content'],
      category: json['category'],
      mood: JournalMood.fromString(json['mood']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
