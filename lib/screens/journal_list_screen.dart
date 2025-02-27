// lib/screens/journal_list_screen.dart
import 'package:flutter/material.dart';
import 'package:serene_app/models/journal_entry.dart';
import 'package:serene_app/services/database_service.dart';
import 'package:serene_app/screens/journal_editor_screen.dart';
import 'package:intl/intl.dart';

class JournalListScreen extends StatefulWidget {
  const JournalListScreen({super.key});

  @override
  _JournalListScreenState createState() => _JournalListScreenState();
}

class _JournalListScreenState extends State<JournalListScreen> {
  final DatabaseService _databaseService = DatabaseService();
  List<JournalEntry> _entries = [];
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadEntries();
  }
  
  Future<void> _loadEntries() async {
    setState(() {
      _isLoading = true;
    });
    
    _entries = _databaseService.getJournalEntries();
    
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Journal'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadEntries,
              child: _entries.isEmpty
                  ? _buildEmptyState()
                  : ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: _entries.length,
                      itemBuilder: (context, index) {
                        return _buildJournalCard(_entries[index]);
                      },
                    ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalEditorScreen(),
            ),
          );
          
          if (result == true) {
            _loadEntries();
          }
        },
        icon: Icon(Icons.edit),
        label: Text('New Entry'),
      ),
    );
  }
  
  Widget _buildJournalCard(JournalEntry entry) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalEditorScreen(entryId: entry.id),
            ),
          );
          
          if (result == true) {
            _loadEntries();
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete_outline, color: Colors.grey[600]),
                    onPressed: () {
                      _showDeleteConfirmation(entry);
                    },
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                DateFormat('EEEE, MMMM d, yyyy').format(entry.date),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 12),
              Text(
                entry.content.length > 100
                    ? '${entry.content.substring(0, 100)}...'
                    : entry.content,
                style: TextStyle(fontSize: 16),
              ),
              if (entry.tags != null && entry.tags!.isNotEmpty) ...[
                SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  children: entry.tags!.map((tag) {
                    return Chip(
                      label: Text(tag),
                      backgroundColor: Theme.of(context).primaryColor.withOpacity(0.2),
                      labelStyle: TextStyle(fontSize: 12),
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.book_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'Your journal is empty',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Start writing your thoughts and reflections',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.grey[500],
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => JournalEditorScreen(),
                ),
              );
              
              if (result == true) {
                _loadEntries();
              }
            },
            icon: Icon(Icons.edit),
            label: Text('Write First Entry'),
          ),
        ],
      ),
    );
  }
  
  void _showDeleteConfirmation(JournalEntry entry) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Delete Journal Entry'),
          content: Text('Are you sure you want to delete this entry? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await _databaseService.deleteJournalEntry(entry.id!);
                Navigator.pop(context);
                _loadEntries();
              },
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}

