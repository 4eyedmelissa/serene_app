// lib/models/chat_message.dart
import 'package:hive/hive.dart';

part 'chat_message.g.dart'; // Adapter file

@HiveType(typeId: 1)
class ChatMessage {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String senderId;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime timestamp;

  @HiveField(4)
  final bool isAnonymous;

  ChatMessage({
    required this.id,
    required this.senderId,
    required this.content,
    required this.timestamp,
    this.isAnonymous = true,
  });
}

