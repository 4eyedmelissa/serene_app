import 'package:flutter/material.dart';
import 'package:serene_app/screens/home_screen.dart';
import 'package:serene_app/screens/journal_list_screen.dart';
import 'package:serene_app/screens/mood_tracking_screen.dart';
import 'package:serene_app/screens/peer_support_screen.dart';
import 'package:serene_app/services/database_service.dart'; // Import DatabaseService

class MainNavigator extends StatefulWidget {
  final DatabaseService databaseService; // Add this parameter

  const MainNavigator({super.key, required this.databaseService}); // Update constructor

  @override
  State<MainNavigator> createState() => _MainNavigatorState();
}

class _MainNavigatorState extends State<MainNavigator> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // Initialize screens with the required databaseService
    _screens = [
      HomeScreen(databaseService: widget.databaseService), // Pass databaseService here
      const JournalListScreen(),
      const MoodTrackingScreen(),
      const PeerSupportScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.secondary,
        unselectedItemColor: Colors.grey[600],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book_outlined),
            activeIcon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.track_changes_outlined),
            activeIcon: Icon(Icons.track_changes),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_outlined),
            activeIcon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}

