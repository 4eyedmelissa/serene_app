
// lib/models/support_group.dart

import 'package:hive/hive.dart';

part 'support_group.g.dart'; // Adapter file

@HiveType(typeId: 5)
class SupportGroup {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final int memberCount;

  @HiveField(4)
  final String? imageUrl;

  SupportGroup({
    required this.id,
    required this.name,
    required this.description,
    this.memberCount = 0,
    this.imageUrl,
  });
}

