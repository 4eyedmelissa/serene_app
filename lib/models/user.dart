// lib/models/user.dart
import 'package:hive/hive.dart';

part 'user.g.dart'; // Adapter file

@HiveType(typeId: 6)
class User {
  @HiveField(0)
  final int? id;

  @HiveField(1)
  final String email;

  @HiveField(2)
  final String name;

  User({
    this.id,
    required this.email,
    required this.name,
  });
}

