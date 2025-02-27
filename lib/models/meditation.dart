// lib/models/meditation.dart

import 'package:hive/hive.dart';

part 'meditation.g.dart'; // Adapter file

@HiveType(typeId: 3)
class Meditation {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int durationMinutes;

  @HiveField(4)
  final String? imageAsset;

  @HiveField(5)
  final String audioAsset;

  @HiveField(6)
  final List<String> tags;

  @HiveField(7)
  final bool isFavorite;

  Meditation({
    required this.id,
    required this.title,
    required this.description,
    required this.durationMinutes,
    this.imageAsset,
    required this.audioAsset,
    this.tags = const [],
    this.isFavorite = false,
  });
}
