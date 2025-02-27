// lib/services/database_service.dart

import 'package:hive/hive.dart';
import 'package:serene_app/models/breathing_exercise.dart';
import 'package:serene_app/models/chat_message.dart';
import 'package:serene_app/models/journal_entry.dart';
import 'package:serene_app/models/meditation.dart';
import 'package:serene_app/models/mood_entry.dart';
import 'package:serene_app/models/support_group.dart';

class DatabaseService {
  // Singleton instance
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  // Hive boxes
  late Box<MoodEntry> moodEntriesBox;
  late Box<JournalEntry> journalEntriesBox;
  late Box<SupportGroup> supportGroupsBox;
  late Box<ChatMessage> chatMessagesBox;
  late Box<Meditation> meditationsBox;
  late Box<BreathingExercise> breathingExercisesBox;

  // Initialize Hive boxes
  Future<void> init() async {
    moodEntriesBox = await Hive.openBox('moodEntries');
    journalEntriesBox = await Hive.openBox('journalEntries');
    supportGroupsBox = await Hive.openBox('supportGroups');
    chatMessagesBox = await Hive.openBox('chatMessages');
    meditationsBox = await Hive.openBox('meditations');
    breathingExercisesBox = await Hive.openBox('breathingExercises');
  }

  // Seed initial data
  Future<void> seedInitialData() async {
    await seedSupportGroups();
    await seedMeditations();
    await seedBreathingExercises();
  }

  // Seed support groups
  Future<void> seedSupportGroups() async {
    if (supportGroupsBox.isEmpty) {
      final supportGroups = [
        SupportGroup(
          id: 'group_anxiety',
          name: 'Anxiety Support',
          description: 'A safe space to discuss and share coping strategies for anxiety.',
          memberCount: 24,
        ),
        SupportGroup(
          id: 'group_academic',
          name: 'Academic Stress',
          description: 'Support for managing deadlines, exams, and academic pressure.',
          memberCount: 18,
        ),
        SupportGroup(
          id: 'group_mindfulness',
          name: 'Mindfulness Practice',
          description: 'Group focused on sharing mindfulness and meditation experiences.',
          memberCount: 15,
        ),
      ];

      for (var group in supportGroups) {
        await supportGroupsBox.put(group.id, group);
      }
    }
  }

  // Seed meditations
  Future<void> seedMeditations() async {
    if (meditationsBox.isEmpty) {
      final meditations = [
        Meditation(
          id: 'meditation_1',
          title: 'Morning Calm',
          description: 'Start your day with peace and clarity.',
          durationMinutes: 10,
          audioAsset: 'assets/audio/morning_calm.mp3',
        ),
        Meditation(
          id: 'meditation_2',
          title: 'Evening Relaxation',
          description: 'Unwind and release the stress of the day.',
          durationMinutes: 15,
          audioAsset: 'assets/audio/evening_relaxation.mp3',
        ),
      ];

      for (var meditation in meditations) {
        await meditationsBox.put(meditation.id, meditation);
      }
    }
  }

  // Seed breathing exercises
  Future<void> seedBreathingExercises() async {
    if (breathingExercisesBox.isEmpty) {
      final exercises = [
        BreathingExercise(
          id: 'exercise_1',
          title: 'Box Breathing',
          description: 'A simple technique to calm your mind.',
          inhaleDuration: 4,
          holdDuration: 4,
          exhaleDuration: 4,
          cycles: 5,
        ),
        BreathingExercise(
          id: 'exercise_2',
          title: '4-7-8 Breathing',
          description: 'A relaxing technique to reduce anxiety.',
          inhaleDuration: 4,
          holdDuration: 7,
          exhaleDuration: 8,
          cycles: 4,
        ),
      ];

      for (var exercise in exercises) {
        await breathingExercisesBox.put(exercise.id, exercise);
      }
    }
  }

  // Mood Entry CRUD Operations
  Future<void> insertMoodEntry(MoodEntry entry) async {
    await moodEntriesBox.add(entry);
  }

  List<MoodEntry> getMoodEntries() {
    return moodEntriesBox.values.toList();
  }

  List<MoodEntry> getMoodEntriesForRange(DateTime start, DateTime end) {
    return moodEntriesBox.values
        .where((entry) => entry.date.isAfter(start) && entry.date.isBefore(end))
        .toList();
  }

  Future<void> updateMoodEntry(int index, MoodEntry entry) async {
    await moodEntriesBox.putAt(index, entry);
  }

  Future<void> deleteMoodEntry(int index) async {
    await moodEntriesBox.deleteAt(index);
  }

  // Journal Entry CRUD Operations
  Future<void> insertJournalEntry(JournalEntry entry) async {
    await journalEntriesBox.add(entry);
  }

  List<JournalEntry> getJournalEntries() {
    return journalEntriesBox.values.toList();
  }

  Future<JournalEntry?> getJournalEntryById(int id) async {
    try {
      return journalEntriesBox.getAt(id);
    } catch (e) {
      return null;
    }
  }

  Future<void> updateJournalEntry(int index, JournalEntry entry) async {
    await journalEntriesBox.putAt(index, entry);
  }

  Future<void> deleteJournalEntry(int index) async {
    await journalEntriesBox.deleteAt(index);
  }

  // Support Group CRUD Operations
  Future<void> insertSupportGroup(SupportGroup group) async {
    await supportGroupsBox.put(group.id, group);
  }

  List<SupportGroup> getSupportGroups() {
    return supportGroupsBox.values.toList();
  }

  Future<SupportGroup?> getSupportGroupById(String id) async {
    return supportGroupsBox.get(id);
  }

  Future<void> updateSupportGroup(String id, SupportGroup group) async {
    await supportGroupsBox.put(id, group);
  }

  Future<void> deleteSupportGroup(String id) async {
    await supportGroupsBox.delete(id);
  }

  // Chat Message CRUD Operations
  Future<void> insertChatMessage(ChatMessage message) async {
    await chatMessagesBox.add(message);
  }

  Future<void> saveMessage(ChatMessage message, String groupId) async {
    await chatMessagesBox.add(message);
  }

  List<ChatMessage> getChatMessages() {
    return chatMessagesBox.values.toList();
  }

  Future<void> updateChatMessage(int index, ChatMessage message) async {
    await chatMessagesBox.putAt(index, message);
  }

  Future<void> deleteChatMessage(int index) async {
    await chatMessagesBox.deleteAt(index);
  }

  // Meditation CRUD Operations
  Future<void> insertMeditation(Meditation meditation) async {
    await meditationsBox.put(meditation.id, meditation);
  }

  List<Meditation> getMeditations() {
    return meditationsBox.values.toList();
  }

  Future<void> updateMeditation(String id, Meditation meditation) async {
    await meditationsBox.put(id, meditation);
  }

  Future<void> deleteMeditation(String id) async {
    await meditationsBox.delete(id);
  }

  // Breathing Exercise CRUD Operations
  Future<void> insertBreathingExercise(BreathingExercise exercise) async {
    await breathingExercisesBox.put(exercise.id, exercise);
  }

  List<BreathingExercise> getBreathingExercises() {
    return breathingExercisesBox.values.toList();
  }

  Future<void> updateBreathingExercise(String id, BreathingExercise exercise) async {
    await breathingExercisesBox.put(id, exercise);
  }

  Future<void> deleteBreathingExercise(String id) async {
    await breathingExercisesBox.delete(id);
  }
}

