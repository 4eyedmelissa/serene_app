// lib/widgets/breathing_exercise_card.dart

import 'package:flutter/material.dart';

class BreathingExerciseCard extends StatelessWidget {
  const BreathingExerciseCard({super.key});

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
                Icon(Icons.air, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text('Breathing Exercise',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              'Take a moment to breathe and center yourself.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton.icon(
                icon: Icon(Icons.play_circle_outline),
                label: Text('Start 2-Minute Exercise'),
                onPressed: () {
                  // TODO: Navigate to breathing exercise screen
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

