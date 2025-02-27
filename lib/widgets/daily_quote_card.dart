
// lib/widgets/daily_quote_card.dart
import 'package:flutter/material.dart';

class DailyQuoteCard extends StatelessWidget {
  const DailyQuoteCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Theme.of(context).primaryColor.withOpacity(0.2),
      elevation: 1,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.format_quote, color: Theme.of(context).primaryColor),
                SizedBox(width: 8),
                Text('Daily Inspiration',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            SizedBox(height: 12),
            Text(
              '"The greatest glory in living lies not in never falling, but in rising every time we fall."',
              style: TextStyle(
                fontSize: 16,
                fontStyle: FontStyle.italic,
              ),
            ),
            SizedBox(height: 4),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                '- Nelson Mandela',
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}