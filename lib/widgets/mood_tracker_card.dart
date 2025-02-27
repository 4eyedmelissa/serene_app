// lib/widgets/mood_tracker_card.dart

import 'package:flutter/material.dart';
import 'package:serene_app/models/mood_entry.dart';
import 'package:serene_app/services/database_service.dart';

class MoodTrackerCard extends StatelessWidget {
  final DatabaseService databaseService;

  const MoodTrackerCard({super.key, required this.databaseService});

  @override
  Widget build(BuildContext context) {
    return Card(
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
                Icon(Icons.mood, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text(
                  'Today\'s Mood',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildMoodOption(context, '😢', 'Sad', 1),
                _buildMoodOption(context, '😐', 'Okay', 2),
                _buildMoodOption(context, '🙂', 'Good', 3),
                _buildMoodOption(context, '😄', 'Great', 4),
                _buildMoodOption(context, '🥳', 'Excellent', 5),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodOption(BuildContext context, String emoji, String label, int moodScore) {
    return InkWell(
      onTap: () async {
        // Save the selected mood to the database
        final moodEntry = MoodEntry(
          date: DateTime.now(),
          moodScore: moodScore,
        );

        await databaseService.insertMoodEntry(moodEntry);

        // Show a confirmation message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Mood recorded: $label'),
            duration: Duration(seconds: 2),
          ),
        );
      },
      child: Column(
        children: [
          Text(
            emoji,
            style: TextStyle(fontSize: 32),
          ),
          SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }
}

