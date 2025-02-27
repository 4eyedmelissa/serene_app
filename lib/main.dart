import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:serene_app/constants/theme.dart';
import 'package:serene_app/models/breathing_exercise.dart';
import 'package:serene_app/models/chat_message.dart';
import 'package:serene_app/models/journal_entry.dart';
import 'package:serene_app/models/meditation.dart';
import 'package:serene_app/models/mood_entry.dart';
import 'package:serene_app/models/support_group.dart';
import 'package:serene_app/models/user.dart';
import 'package:serene_app/screens/login_screen.dart';
import 'package:serene_app/services/database_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serene_app/main_navigator.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register adapters
  Hive.registerAdapter(BreathingExerciseAdapter());
  Hive.registerAdapter(ChatMessageAdapter());
  Hive.registerAdapter(JournalEntryAdapter());
  Hive.registerAdapter(MeditationAdapter());
  Hive.registerAdapter(MoodEntryAdapter());
  Hive.registerAdapter(SupportGroupAdapter());
  Hive.registerAdapter(UserAdapter());

  // Initialize DatabaseService
  final databaseService = DatabaseService();
  await databaseService.init(); // Open all Hive boxes
  await databaseService.seedInitialData(); // Seed initial data

  // Check if the user is logged in
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  // Run the app
  runApp(SereneApp(isLoggedIn: isLoggedIn, databaseService: databaseService));
}

class SereneApp extends StatelessWidget {
  final bool isLoggedIn;
  final DatabaseService databaseService;

  const SereneApp({super.key, required this.isLoggedIn, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Serene',
      theme: AppTheme.lightTheme,
      home: isLoggedIn
          ? MainNavigator(databaseService: databaseService)
          : LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

