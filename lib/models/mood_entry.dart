// lib/models/mood_entry.dart
import 'package:hive/hive.dart';

part 'mood_entry.g.dart'; // Adapter file

@HiveType(typeId: 4)
class MoodEntry {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final DateTime date;

  @HiveField(2)
  final int moodScore;

  @HiveField(3)
  final String? note;

  MoodEntry({
    this.id,
    required this.date,
    required this.moodScore,
    this.note,
  });
}

