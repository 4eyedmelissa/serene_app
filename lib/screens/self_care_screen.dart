import 'package:flutter/material.dart';
import 'package:serene_app/models/meditation.dart';
import 'package:serene_app/services/database_service.dart';

class SelfCareScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const SelfCareScreen({super.key, required this.databaseService});

  @override
  _SelfCareScreenState createState() => _SelfCareScreenState();
}

class _SelfCareScreenState extends State<SelfCareScreen> {
  List<Meditation> _meditations = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMeditations();
  }

  Future<void> _loadMeditations() async {
    setState(() {
      _isLoading = true;
    });
    
    final meditations = widget.databaseService.getMeditations();
    
    setState(() {
      _meditations = meditations;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Affirmations'),
        backgroundColor: Colors.purple[400],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Notifications action
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Settings action
            },
          ),
        ],
      ),
      backgroundColor: Colors.purple[50],
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.purple,
                ),
              )
            : RefreshIndicator(
                onRefresh: _loadMeditations,
                color: Colors.purple,
                child: _meditations.isEmpty
                    ? _buildEmptyState()
                    : _buildAffirmationList(),
              ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 1, // Self-care tab is selected
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Self-care',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite,
            size: 70,
            color: Colors.purple[300],
          ),
          const SizedBox(height: 16),
          Text(
            'Your self-care journey begins',
            style: TextStyle(
              fontSize: 18,
              color: Colors.purple[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Daily affirmations to nurture your mind and spirit',
            style: TextStyle(
              color: Colors.purple[600],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationList() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _buildDailyInspiration(),
        const SizedBox(height: 20),
        Text(
          'Today\'s Affirmations',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.purple[700],
          ),
        ),
        const SizedBox(height: 16),
        if (_meditations.isEmpty)
          _buildPlaceholderAffirmations()
        else
          ..._meditations.map((meditation) => _buildAffirmationCard(meditation)).toList(),
        const SizedBox(height: 20),
        _buildBreathingExercise(),
        const SizedBox(height: 20),
        _buildPositiveThoughts(),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildPlaceholderAffirmations() {
    final placeholders = [
      {
        'title': 'Self-Compassion',
        'description': 'I am doing the best I can with what I have today.',
        'icon': Icons.favorite,
      },
      {
        'title': 'Inner Peace',
        'description': 'I release all stress and welcome calm into my life.',
        'icon': Icons.spa,
      },
      {
        'title': 'Strength',
        'description': 'I am stronger than my challenges and wiser than my worries.',
        'icon': Icons.emoji_events,
      },
    ];
    
    return Column(
      children: placeholders.map((item) => Card(
        elevation: 3,
        margin: const EdgeInsets.only(bottom: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.purple[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: Colors.purple[700],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                item['description'] as String,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton.icon(
                    icon: const Icon(Icons.favorite_border),
                    label: const Text('Save'),
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.purple[700],
                    ),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.purple[400],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      )).toList(),
    );
  }

  Widget _buildDailyInspiration() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.format_quote, color: Colors.purple[700]),
              const SizedBox(width: 8),
              Text(
                'Daily Inspiration',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '"Happiness can be found even in the darkest of times, if one only remembers to turn on the light."',
            style: TextStyle(
              fontSize: 16,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '- Albus Dumbledore',
              style: TextStyle(
                color: Colors.purple[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAffirmationCard(Meditation meditation) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple[100],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getMeditationIcon(meditation.title),
                    color: Colors.purple[700],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    meditation.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              meditation.description,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton.icon(
                  icon: const Icon(Icons.favorite_border),
                  label: const Text('Save'),
                  onPressed: () {
                    // Save affirmation
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.purple[700],
                  ),
                ),
                const SizedBox(width: 8),
                FilledButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  onPressed: () {
                    // Share affirmation
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.purple[400],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingExercise() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.purple[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.air, color: Colors.purple[700]),
              const SizedBox(width: 8),
              Text(
                'Breathing Exercise',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Take a moment to breathe and center yourself.',
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Center(
            child: FilledButton(
              onPressed: () {
                // Start breathing exercise
              },
              style: FilledButton.styleFrom(
                backgroundColor: Colors.purple[400],
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Start 2-Minute Exercise',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPositiveThoughts() {
    final thoughts = [
      'You are capable of amazing things',
      'Every day is a fresh start',
      'Your potential is endless',
      'Be kind to yourself today',
      'Progress takes time, and that\'s okay'
    ];
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple[200]!, Colors.purple[100]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline, color: Colors.purple[700]),
              const SizedBox(width: 8),
              Text(
                'Positive Thoughts',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.purple[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...thoughts.map((thought) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.star, size: 16, color: Colors.purple[400]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    thought,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          )).toList(),
        ],
      ),
    );
  }

  IconData _getMeditationIcon(String title) {
    final lowercaseTitle = title.toLowerCase();
    
    if (lowercaseTitle.contains('breath') || lowercaseTitle.contains('breathing')) {
      return Icons.air;
    } else if (lowercaseTitle.contains('sleep')) {
      return Icons.nightlight_round;
    } else if (lowercaseTitle.contains('focus')) {
      return Icons.center_focus_strong;
    } else if (lowercaseTitle.contains('stress') || lowercaseTitle.contains('anxiety')) {
      return Icons.spa;
    } else if (lowercaseTitle.contains('morning')) {
      return Icons.wb_sunny;
    } else if (lowercaseTitle.contains('self') || lowercaseTitle.contains('love')) {
      return Icons.favorite;
    } else if (lowercaseTitle.contains('peace') || lowercaseTitle.contains('calm')) {
      return Icons.spa;
    } else if (lowercaseTitle.contains('strength') || lowercaseTitle.contains('power')) {
      return Icons.emoji_events;
    } else {
      return Icons.self_improvement;
    }
  }
}

