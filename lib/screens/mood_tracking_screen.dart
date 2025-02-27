// lib/screens/mood_tracking_screen.dart

import 'package:flutter/material.dart';
import 'package:serene_app/models/mood_entry.dart';
import 'package:serene_app/services/database_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class MoodTrackingScreen extends StatefulWidget {
  const MoodTrackingScreen({super.key});

  @override
  _MoodTrackingScreenState createState() => _MoodTrackingScreenState();
}

class _MoodTrackingScreenState extends State<MoodTrackingScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<MoodEntry> _recentEntries = [];
  List<MoodEntry> _weeklyEntries = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadMoodData();
  }
  
  Future<void> _loadMoodData() async {
    setState(() {
      _isLoading = true;
    });
    
    // Get all recent entries
    _recentEntries = _databaseService.getMoodEntries();
    
    // Get entries for the past week
    final now = DateTime.now();
    final weekAgo = now.subtract(Duration(days: 7));
    _weeklyEntries = _databaseService.getMoodEntriesForRange(weekAgo, now);
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mood Tracker'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadMoodData,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Mood History',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    SizedBox(height: 24),
                    
                    // Weekly chart
                    if (_weeklyEntries.isNotEmpty) ...[
                      _buildWeeklyChart(),
                      SizedBox(height: 32),
                    ],
                    
                    Text(
                      'Recent Entries',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    SizedBox(height: 16),
                    
                    // Show recent entries or empty state
                    _recentEntries.isEmpty
                        ? _buildEmptyState()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: _recentEntries.length,
                            itemBuilder: (context, index) {
                              return _buildMoodEntryCard(_recentEntries[index]);
                            },
                          ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddMoodDialog();
        },
        tooltip: 'Add mood entry',
        child: Icon(Icons.add),
      ),
    );
  }
  
  Widget _buildWeeklyChart() {
  return SizedBox(
    height: 200,
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: LineChart(
          LineChartData(
            gridData: FlGridData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, meta) {
                    String emoji = '';
                    switch (value.toInt()) {
                      case 1: emoji = '😢'; break;
                      case 2: emoji = '😐'; break;
                      case 3: emoji = '🙂'; break;
                      case 4: emoji = '😄'; break;
                      case 5: emoji = '🥳'; break;
                    }
                    return Text(emoji);
                  },
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 22,
                  getTitlesWidget: (value, meta) {
                    final index = value.toInt();
                    if (index >= 0 && index < _weeklyEntries.length) {
                      return Text(DateFormat('E').format(_weeklyEntries[index].date));
                    }
                    return const Text('');
                  },
                ),
              ),
              rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
             LineChartBarData(
  spots: List.generate(_weeklyEntries.length, (index) {
    return FlSpot(index.toDouble(), _weeklyEntries[index].moodScore.toDouble());
  }),
  isCurved: true,
  color: Theme.of(context).primaryColor,  // This is where colors go
  barWidth: 4,
  dotData: FlDotData(show: true),
),
            ],
            minY: 1,
            maxY: 5,
          ),
        ),
      ),
    ),
  );
}
  
  Widget _buildMoodEntryCard(MoodEntry entry) {
    final List<String> moodEmojis = ['😢', '😐', '🙂', '😄', '🥳'];
    final List<String> moodLabels = ['Sad', 'Okay', 'Good', 'Great', 'Excellent'];
    
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Theme.of(context).primaryColor.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    moodEmojis[entry.moodScore - 1],
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moodLabels[entry.moodScore - 1],
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      DateFormat('MMM d, yyyy • h:mm a').format(entry.date),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (entry.note != null && entry.note!.isNotEmpty) ...[
              SizedBox(height: 12),
              Text(
                entry.note!,
                style: TextStyle(fontSize: 16),
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 24),
          Icon(
            Icons.mood,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No mood entries yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start tracking how you feel by adding your first mood entry',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
  
  void _showAddMoodDialog() {
    int selectedMood = 3; // Default: Good
    String noteText = '';
    
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'How are you feeling?',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildMoodOption('😢', 'Sad', 1, selectedMood, (value) {
                        setState(() => selectedMood = value);
                      }),
                      _buildMoodOption('😐', 'Okay', 2, selectedMood, (value) {
                        setState(() => selectedMood = value);
                      }),
                      _buildMoodOption('🙂', 'Good', 3, selectedMood, (value) {
                        setState(() => selectedMood = value);
                      }),
                      _buildMoodOption('😄', 'Great', 4, selectedMood, (value) {
                        setState(() => selectedMood = value);
                      }),
                      _buildMoodOption('🥳', 'Excellent', 5, selectedMood, (value) {
                        setState(() => selectedMood = value);
                      }),
                    ],
                  ),
                  SizedBox(height: 24),
                  TextField(
                    onChanged: (value) {
                      noteText = value;
                    },
                    decoration: InputDecoration(
                      labelText: 'Add a note (optional)',
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        final newEntry = MoodEntry(
                          date: DateTime.now(),
                          moodScore: selectedMood,
                          note: noteText.isNotEmpty ? noteText : null,
                        );
                        
                        await _databaseService.insertMoodEntry(newEntry);
                        Navigator.pop(context);
                        _loadMoodData();
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Save Entry'),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }
  
  Widget _buildMoodOption(String emoji, String label, int value, int selectedValue, Function(int) onSelected) {
    final isSelected = value == selectedValue;
    
    return InkWell(
      onTap: () => onSelected(value),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: isSelected 
                ? Theme.of(context).primaryColor.withOpacity(0.3)
                : Colors.grey.withOpacity(0.1),
              shape: BoxShape.circle,
              border: isSelected
                ? Border.all(color: Theme.of(context).primaryColor, width: 2)
                : null,
            ),
            alignment: Alignment.center,
            child: Text(
              emoji,
              style: TextStyle(fontSize: 28),
            ),
          ),
          SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

