
import 'package:flutter/material.dart';
import 'package:serene_app/services/database_service.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const BreathingExerciseScreen({super.key, required this.databaseService});

  @override
  _BreathingExerciseScreenState createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen> {
  final List<Map<String, String>> _breathingTips = [
    {
      'title': 'Box Breathing',
      'description': 'Inhale for 4 seconds, hold for 4, exhale for 4, hold for 4. Repeat.',
      'fact': 'Box breathing activates your parasympathetic nervous system, which helps reduce stress.'
    },
    {
      'title': '4-7-8 Technique',
      'description': 'Inhale for 4 seconds, hold for 7, exhale for 8. Repeat 3-4 times.',
      'fact': 'This technique can help reduce anxiety and improve sleep quality.'
    },
    {
      'title': 'Diaphragmatic Breathing',
      'description': 'Breathe deeply into your belly rather than your chest. Place a hand on your stomach to feel it rise and fall.',
      'fact': 'Diaphragmatic breathing increases oxygen flow and can lower blood pressure.'
    },
    {
      'title': 'Mindful Breath',
      'description': 'Focus solely on your breath, noticing how it feels as you inhale and exhale.',
      'fact': 'Mindful breathing can increase activity in brain regions associated with attention and body awareness.'
    },
  ];

  final List<String> _psychFacts = [
    'Taking just 5 minutes to focus on breathing can reduce cortisol levels significantly.',
    'Deep breathing exercises can help activate your body\'s relaxation response within 90 seconds.',
    'Regular breathing practices can improve your heart rate variability, an indicator of good health.',
    'Controlled breathing exercises can help manage symptoms of anxiety, depression, and PTSD.',
    'Your breathing pattern directly affects your emotional state and can influence your thoughts.',
  ];

  @override
  Widget build(BuildContext context) {
    // The databaseService is available as widget.databaseService if needed
    // We're not using it in this UI version, but keeping the parameter for compatibility
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serene', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.purple[300],
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {},
          ),
        ],
      ),
      backgroundColor: Colors.purple[50],
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              _buildHeaderSection(),
              const SizedBox(height: 24),
              _buildBreathingTipsSection(),
              const SizedBox(height: 24),
              _buildTryExerciseSection(),
              const SizedBox(height: 24),
              _buildPsychFactsSection(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.purple,
        unselectedItemColor: Colors.purple[200],
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book_outlined),
            label: 'Journal',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mood_outlined),
            label: 'Mood',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            label: 'Chat',
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Breathe & Center',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.purple[800],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Take a moment to regulate your breathing and find calm',
          style: TextStyle(
            fontSize: 16,
            color: Colors.purple[700],
          ),
        ),
      ],
    );
  }

  Widget _buildBreathingTipsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.air,
              color: Colors.purple[400],
            ),
            const SizedBox(width: 8),
            Text(
              'Breathing Techniques',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        for (var tip in _breathingTips)
          _buildTipCard(
            title: tip['title']!,
            description: tip['description']!,
            fact: tip['fact']!,
          ),
      ],
    );
  }

  Widget _buildTipCard({
    required String title,
    required String description,
    required String fact,
  }) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.purple[800],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.purple[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.psychology,
                    color: Colors.purple[700],
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Fun Fact: $fact',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.purple[800],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTryExerciseSection() {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      color: Colors.purple[200],
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(
              Icons.favorite,
              color: Colors.white,
              size: 40,
            ),
            const SizedBox(height: 16),
            const Text(
              'Ready to practice?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Take a few minutes to follow along with a guided exercise',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.purple[700],
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                'Start 2-Minute Exercise',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPsychFactsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.psychology,
              color: Colors.purple[400],
            ),
            const SizedBox(width: 8),
            Text(
              'Psychology Facts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.purple[700],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              for (var i = 0; i < _psychFacts.length; i++)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          color: Colors.purple[100],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple[800],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _psychFacts[i],
                          style: const TextStyle(
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

