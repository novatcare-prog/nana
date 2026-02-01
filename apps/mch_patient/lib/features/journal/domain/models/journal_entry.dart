import 'package:uuid/uuid.dart';

class JournalEntry {
  final String id;
  final DateTime date;
  final String title;
  final String content;
  final String? category;
  final DateTime createdAt;
  final DateTime updatedAt;

  JournalEntry({
    required this.id,
    required this.date,
    required this.title,
    required this.content,
    this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory JournalEntry.create({
    required String title,
    required String content,
    String? category,
    DateTime? date,
  }) {
    final now = DateTime.now();
    return JournalEntry(
      id: const Uuid().v4(),
      date: date ?? now,
      title: title,
      content: content,
      category: category,
      createdAt: now,
      updatedAt: now,
    );
  }

  JournalEntry copyWith({
    String? title,
    String? content,
    String? category,
    DateTime? date,
  }) {
    return JournalEntry(
      id: id,
      date: date ?? this.date,
      title: title ?? this.title,
      content: content ?? this.content,
      category: category ?? this.category,
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
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
