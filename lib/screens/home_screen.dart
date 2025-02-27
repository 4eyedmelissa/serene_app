
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import for custom fonts
import 'package:serene_app/screens/emergency_contacts_screen.dart';
import 'package:serene_app/screens/journal_editor_screen.dart';
import 'package:serene_app/screens/notifications_screen.dart';
import 'package:serene_app/screens/settings_screen.dart';
import 'package:serene_app/screens/self_care_screen.dart';
import 'package:serene_app/screens/progress_screen.dart';
import 'package:serene_app/screens/breathing_exercise_screen.dart';
import 'package:serene_app/screens/chat_screen.dart';
import 'package:serene_app/widgets/breathing_exercise_card.dart';
import 'package:serene_app/widgets/mood_tracker_card.dart';
import 'package:serene_app/widgets/daily_quote_card.dart';
import 'package:serene_app/services/database_service.dart';

class HomeScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const HomeScreen({super.key, required this.databaseService});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String _username = "Melissa";
  int _currentIndex = 0; // Track the selected index for BottomNavigationBar

  // Handle BottomNavigationBar item taps
  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Add navigation logic for each tab
    switch (index) {
      case 0:
        // Home tab is already active
        break;
      case 1:
        // Navigate to Self-care screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SelfCareScreen(databaseService: widget.databaseService),
          ),
        );
        break;
      case 2:
        // Navigate to Journal screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => JournalEditorScreen(),
          ),
        );
        break;
      case 3:
        // Navigate to Chat screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              groupId: 'default_group_id',
            ),
          ),
        );
        break;
      case 4:
        // Navigate to Progress screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProgressScreen(databaseService: widget.databaseService),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryPurple = Color(0xFFAA84E3); // Light purple color for theme
    
    return Theme(
      data: ThemeData(
        primaryColor: primaryPurple,
        colorScheme: ColorScheme.light(
          primary: primaryPurple,
          secondary: primaryPurple.withOpacity(0.8),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryPurple,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryPurple,
          elevation: 0,
          title: Text(
            'Serene',
            style: GoogleFonts.quicksand(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
              color: Colors.white,
            ),
          ),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.notifications_outlined, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(databaseService: widget.databaseService),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.settings_outlined, color: Colors.white),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(databaseService: widget.databaseService),
                  ),
                );
              },
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Greeting section
                Padding(
                  padding: EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Hi $_username,\nHow are you feeling today?',
                    style: GoogleFonts.quicksand(
                      fontSize: 22,
                      fontWeight: FontWeight.w500,
                      color: Colors.deepPurple[800],
                    ),
                  ),
                ),
                
                // Mood tracker card
                MoodTrackerCard(databaseService: widget.databaseService),
                SizedBox(height: 16),
                
                // Breathing exercise card
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BreathingExerciseScreen(databaseService: widget.databaseService),
                      ),
                    );
                  },
                  child: BreathingExerciseCard(),
                ),
                SizedBox(height: 16),

                // Emergency Contact Card
                Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  child: ListTile(
                    leading: Icon(Icons.phone, color: primaryPurple),
                    title: Text(
                      'Emergency Contacts',
                      style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('Get help from professionals'),
                    trailing: Icon(Icons.arrow_forward_ios, size: 16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const EmergencyContactsScreen()),
                      );
                    },
                  ),
                ),
                SizedBox(height: 16),
                
                // Daily quote
                DailyQuoteCard(),
                SizedBox(height: 16),
                
                // Journal prompt section
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.edit_outlined, color: primaryPurple),
                            SizedBox(width: 8),
                            Text(
                              'Journal Prompt',
                              style: GoogleFonts.quicksand(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Text(
                          'What made you smile today? Take a moment to reflect on a positive moment.',
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => const JournalEditorScreen()),
                            );
                          },
                          child: Text('Write in Journal'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: primaryPurple,
          unselectedItemColor: Colors.grey[600],
          currentIndex: _currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_outline),
              activeIcon: Icon(Icons.favorite),
              label: 'Self-care',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined),
              activeIcon: Icon(Icons.book),
              label: 'Journal',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_outlined),
              activeIcon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insert_chart_outlined),
              activeIcon: Icon(Icons.insert_chart),
              label: 'Progress',
            ),
          ],
        ),
      ),
    );
  }
}

