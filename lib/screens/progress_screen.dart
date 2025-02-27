
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:serene_app/models/mood_entry.dart';
import 'package:serene_app/models/journal_entry.dart';
import 'package:serene_app/services/database_service.dart';

class ProgressScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const ProgressScreen({super.key, required this.databaseService});

  @override
  _ProgressScreenState createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  List<MoodEntry> _moodEntries = [];
  List<JournalEntry> _journalEntries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() {
      _isLoading = true;
    });

    final moodEntries = widget.databaseService.getMoodEntries();
    final journalEntries = widget.databaseService.getJournalEntries();

    setState(() {
      _moodEntries = moodEntries;
      _journalEntries = journalEntries;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Journey'),
        backgroundColor: Color(0xFFAA8FD8), // Light purple from screenshot
        elevation: 0,
      ),
      backgroundColor: Color(0xFFF5F0FF), // Very light purple background
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFAA8FD8),
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadProgress,
              color: Color(0xFFAA8FD8),
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader('Mood Insights', Icons.mood),
                    const SizedBox(height: 12),
                    _buildMoodProgress(),
                    const SizedBox(height: 24),
                    _buildMoodFrequencyGraph(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Journal Entries', Icons.book),
                    const SizedBox(height: 12),
                    _buildJournalProgress(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(
          icon,
          color: Color(0xFF9370DB), // Medium purple
          size: 28,
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF6A3EA1), // Darker purple
          ),
        ),
      ],
    );
  }

  Widget _buildMoodProgress() {
    if (_moodEntries.isEmpty) {
      return _buildEmptyState(
        'Track your first mood',
        'Your mood entries will appear here',
        Icons.sentiment_satisfied_alt,
      );
    }

    return Column(
      children: [
        Card(
          elevation: 3,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Recent Moods',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF6A3EA1),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(5, (index) {
                    final moodIndex = index < _moodEntries.length ? index : null;
                    return _buildMoodCircle(moodIndex);
                  }),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _moodEntries.length,
          itemBuilder: (context, index) {
            final entry = _moodEntries[index];
            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getMoodColor(entry.moodScore),
                  child: Icon(
                    _getMoodIcon(entry.moodScore),
                    color: Colors.white,
                  ),
                ),
                title: Text(
                  'Mood: ${_getMoodText(entry.moodScore)}',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                subtitle: Text(
                  'Date: ${_formatDate(entry.date)}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: Color(0xFFAA8FD8),
                ),
                onTap: () {
                  // View mood entry details
                },
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMoodFrequencyGraph() {
    // Count frequency of each mood score
    Map<int, int> moodCounts = {};
    for (var entry in _moodEntries) {
      moodCounts[entry.moodScore] = (moodCounts[entry.moodScore] ?? 0) + 1;
    }

    if (moodCounts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mood Frequency',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A3EA1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'How you\'ve been feeling lately',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            Container(
              height: 200,
              padding: const EdgeInsets.only(right: 16),
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  maxY: (moodCounts.values.fold(0, (p, c) => p > c ? p : c) * 1.2).toDouble(),
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        getTitlesWidget: (value, meta) {
                          return Text(
                            value.toInt().toString(),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                          );
                        },
                      ),
                    ),
                   /* bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final List<Widget> moodIcons = [
                            Icon(Icons.sentiment_very_dissatisfied, color: Colors.red[400]),
                            Icon(Icons.sentiment_dissatisfied, color: Colors.orange[400]),
                            Icon(Icons.sentiment_neutral, color: Colors.amber[400]),
                            Icon(Icons.sentiment_satisfied, color: Colors.lightGreen[400]),
                            Icon(Icons.sentiment_very_satisfied, color: Colors.green[400]),
                          ];
                          return SideTitleWidget(
                            axisSide: meta.axisSide, // Pass the meta.axisSide
                            child: moodIcons[value.toInt()],
                          );
                        },
                      ),
                    ),*/

                    bottomTitles: AxisTitles(
  sideTitles: SideTitles(
    showTitles: true,
    getTitlesWidget: (value, meta) {
      final List<Widget> moodIcons = [
        Icon(Icons.sentiment_very_dissatisfied, color: Colors.red[400]),
        Icon(Icons.sentiment_dissatisfied, color: Colors.orange[400]),
        Icon(Icons.sentiment_neutral, color: Colors.amber[400]),
        Icon(Icons.sentiment_satisfied, color: Colors.lightGreen[400]),
        Icon(Icons.sentiment_very_satisfied, color: Colors.green[400]),
      ];
      return SideTitleWidget(
  // Remove the axisSide parameter
  meta: meta,  // Just use the meta parameter
  child: moodIcons[value.toInt()],
);
    },
  ),
),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  gridData: FlGridData(
                    show: true,
                    horizontalInterval: 1,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) {
                      return FlLine(
                        color: Colors.grey[200],
                        strokeWidth: 1,
                      );
                    },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  barGroups: [0, 1, 2, 3, 4].map((moodScore) {
                    return BarChartGroupData(
                      x: moodScore,
                      barRods: [
                        BarChartRodData(
                          toY: (moodCounts[moodScore] ?? 0).toDouble(),
                          color: _getMoodColor(moodScore),
                          width: 20,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(6),
                            topRight: Radius.circular(6),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMoodLegendItem('Sad', Icons.sentiment_very_dissatisfied, Colors.red[400]!),
                _buildMoodLegendItem('Okay', Icons.sentiment_dissatisfied, Colors.orange[400]!),
                _buildMoodLegendItem('Good', Icons.sentiment_neutral, Colors.amber[400]!),
                _buildMoodLegendItem('Great', Icons.sentiment_satisfied, Colors.lightGreen[400]!),
                _buildMoodLegendItem('Excellent', Icons.sentiment_very_satisfied, Colors.green[400]!),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodLegendItem(String label, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey[700],
          ),
        ),
      ],
    );
  }

  Widget _buildMoodCircle(int? index) {
    if (index == null) {
      return Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          shape: BoxShape.circle,
        ),
      );
    }

    final entry = _moodEntries[index];
    return Column(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: _getMoodColor(entry.moodScore),
            shape: BoxShape.circle,
          ),
          child: Icon(
            _getMoodIcon(entry.moodScore),
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatDayOfWeek(entry.date),
          style: TextStyle(fontSize: 12, color: Colors.grey[700]),
        ),
      ],
    );
  }

  Widget _buildJournalProgress() {
    if (_journalEntries.isEmpty) {
      return _buildEmptyState(
        'Write your first entry',
        'Your journal entries will appear here',
        Icons.edit,
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _journalEntries.length,
      itemBuilder: (context, index) {
        final entry = _journalEntries[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        entry.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Color(0xFFE6DDFF), // Very light purple
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _formatDate(entry.date),
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6A3EA1),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  _generatePreview(entry),
                  style: TextStyle(
                    color: Colors.grey[700],
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // View full journal entry
                    },
                    child: Text(
                      'Read More',
                      style: TextStyle(
                        color: Color(0xFF9370DB),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Icon(
              icon,
              size: 48,
              color: Color(0xFFAA8FD8),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A3EA1),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    // Simple date formatting
    return '${date.month}/${date.day}/${date.year}';
  }

  String _formatDayOfWeek(DateTime date) {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[date.weekday - 1];
  }

  String _getMoodText(int score) {
    final moods = ['Sad', 'Okay', 'Good', 'Great', 'Excellent'];
    return moods[score.clamp(0, 4)];
  }

  IconData _getMoodIcon(int score) {
    final icons = [
      Icons.sentiment_very_dissatisfied,
      Icons.sentiment_dissatisfied,
      Icons.sentiment_neutral,
      Icons.sentiment_satisfied,
      Icons.sentiment_very_satisfied,
    ];
    return icons[score.clamp(0, 4)];
  }

  Color _getMoodColor(int score) {
    final colors = [
      Colors.red[400]!,
      Colors.orange[400]!,
      Colors.amber[400]!,
      Colors.lightGreen[400]!,
      Colors.green[400]!,
    ];
    return colors[score.clamp(0, 4)];
  }

  String _generatePreview(JournalEntry entry) {
    // This is a placeholder - in your actual app, you would use the entry's content
    return "Today I took some time to reflect on my goals and progress. I feel like I'm making steady improvements with my meditation practice...";
  }
}

