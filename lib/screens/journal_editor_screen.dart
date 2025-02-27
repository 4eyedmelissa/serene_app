// lib/screens/journal_editor_screen.dart

import 'package:flutter/material.dart';
import 'package:serene_app/models/journal_entry.dart';
import 'package:serene_app/services/database_service.dart';

class JournalEditorScreen extends StatefulWidget {
  final int? entryId;
  
  const JournalEditorScreen({super.key, this.entryId});
  
  @override
  _JournalEditorScreenState createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final DatabaseService _databaseService = DatabaseService();
  
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _tagsController = TextEditingController();
  
  bool _isLoading = false;
  bool _isEditMode = false;
  String? _prompt;
  JournalEntry? _existingEntry;
  
  @override
  void initState() {
    super.initState();
    _isEditMode = widget.entryId != null;
    if (_isEditMode) {
      _loadExistingEntry();
    } else {
      // Offer a random prompt
      _setRandomPrompt();
    }
  }
  
  void _setRandomPrompt() {
    final prompts = [
      "What made you smile today?",
      "What's something you're grateful for today?",
      "Describe a challenge you faced today and how you handled it.",
      "What's something you learned today?",
      "How did you practice self-care today?",
      "What's something you're looking forward to tomorrow?",
      "Describe a meaningful interaction you had today.",
      "What emotions did you experience today and why?",
    ];
    
    setState(() {
      _prompt = prompts[DateTime.now().millisecond % prompts.length];
    });
  }
  
  Future<void> _loadExistingEntry() async {
    setState(() {
      _isLoading = true;
    });
    
    _existingEntry = await _databaseService.getJournalEntryById(widget.entryId!);
    
    if (_existingEntry != null) {
      _titleController.text = _existingEntry!.title;
      _contentController.text = _existingEntry!.content;
      _prompt = _existingEntry!.prompt;
      
      if (_existingEntry!.tags != null) {
        _tagsController.text = _existingEntry!.tags!.join(', ');
      }
    }
    
    setState(() {
      _isLoading = false;
    });
  }
  
  Future<void> _saveEntry() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      // Parse tags from comma-separated string to List<String>
      List<String>? tags;
      if (_tagsController.text.isNotEmpty) {
        tags = _tagsController.text.split(',')
            .map((tag) => tag.trim())
            .where((tag) => tag.isNotEmpty)
            .toList();
      }
      
      final entry = JournalEntry(
        id: _existingEntry?.id,
        title: _titleController.text,
        content: _contentController.text,
        date: _existingEntry?.date ?? DateTime.now(),
        prompt: _prompt,
        tags: tags,
      );
      
      try {
        if (_isEditMode && _existingEntry != null) {
          // Find the index of the existing entry
          final index = _databaseService.getJournalEntries().indexOf(_existingEntry!);
          await _databaseService.updateJournalEntry(index, entry); // Pass index and entry
        } else {
          await _databaseService.insertJournalEntry(entry);
        }
        
        if (mounted) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        // Handle error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to save journal entry'))
          );
        }
      } finally {
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _tagsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditMode ? 'Edit Journal Entry' : 'New Journal Entry'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: _saveEntry,
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (_prompt != null) ...[
                      Card(
                        color: Theme.of(context).primaryColor.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.lightbulb_outlined, 
                                    color: Theme.of(context).primaryColor),
                                  SizedBox(width: 8),
                                  Text(
                                    'Prompt',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Text(
                                _prompt!,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                    ],
                    
                    // Title Field
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a title';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    // Content Field
                    TextFormField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        labelText: 'Write your thoughts here...',
                        alignLabelWithHint: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      maxLines: 15,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please write something';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    
                    // Tags Field
                    TextFormField(
                      controller: _tagsController,
                      decoration: InputDecoration(
                        labelText: 'Tags (comma-separated)',
                        hintText: 'gratitude, reflection, goals',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}


