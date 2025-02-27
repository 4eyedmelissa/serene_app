
// lib/models/journal_entry.dart

import 'package:hive/hive.dart';

part 'journal_entry.g.dart'; // Adapter file

@HiveType(typeId: 2)
class JournalEntry {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final String title;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final String? prompt;

  @HiveField(5)
  final List<String>? tags;

  JournalEntry({
    this.id,
    required this.date,
    required this.title,
    required this.content,
    this.prompt,
    this.tags,
  });
}

