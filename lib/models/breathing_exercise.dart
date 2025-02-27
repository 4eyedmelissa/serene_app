// lib/models/breathing_exercise.dart
import 'package:hive/hive.dart';

part 'breathing_exercise.g.dart'; // Adapter file

@HiveType(typeId: 0) // Unique typeId for each model
class BreathingExercise {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int inhaleDuration;

  @HiveField(4)
  final int holdDuration;

  @HiveField(5)
  final int exhaleDuration;

  @HiveField(6)
  final int cycles;

  @HiveField(7)
  final String? imageAsset;

  BreathingExercise({
    required this.id,
    required this.title,
    required this.description,
    required this.inhaleDuration,
    this.holdDuration = 0,
    required this.exhaleDuration,
    required this.cycles,
    this.imageAsset,
  });
}


