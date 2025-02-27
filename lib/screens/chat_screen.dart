// lib/screens/chat_screen.dart

import 'package:flutter/material.dart';
import 'package:serene_app/models/chat_message.dart';
import 'package:serene_app/models/support_group.dart';
import 'package:serene_app/services/database_service.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatScreen extends StatefulWidget {
  final String groupId;
  
  const ChatScreen({super.key, required this.groupId});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final DatabaseService _databaseService = DatabaseService();
  final TextEditingController _messageController = TextEditingController();
  final _scrollController = ScrollController();
  
  SupportGroup? _group;
  List<ChatMessage> _messages = [];
  bool _isLoading = true;
  late String _userId;
  bool _isAnonymous = true;

  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    // Get or create user ID
    final prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('user_id') ?? Uuid().v4();
    await prefs.setString('user_id', _userId);
    
    await _loadGroupDetails();
    await _loadMessages();
  }

  Future<void> _loadGroupDetails() async {
    _group = await _databaseService.getSupportGroupById(widget.groupId);
    setState(() {});
  }

  Future<void> _loadMessages() async {
    setState(() {
      _isLoading = true;
    });
    
    _messages = _databaseService.getChatMessages();
    
    setState(() {
      _isLoading = false;
    });
    
    // Scroll to bottom after messages load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty) return;
    
    final message = ChatMessage(
      id: Uuid().v4(),
      senderId: _userId,
      content: _messageController.text.trim(),
      timestamp: DateTime.now(),
      isAnonymous: _isAnonymous,
    );
    
    await _databaseService.saveMessage(message, widget.groupId);
    _messageController.clear();
    await _loadMessages();
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_group?.name ?? 'Chat'),
        actions: [
          IconButton(
            icon: Icon(_isAnonymous ? Icons.visibility_off : Icons.visibility),
            tooltip: _isAnonymous ? 'Anonymous Mode On' : 'Anonymous Mode Off',
            onPressed: () {
              setState(() {
                _isAnonymous = !_isAnonymous;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isAnonymous 
                    ? 'Anonymous mode activated' 
                    : 'Anonymous mode deactivated'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Support group info card
          if (_group != null)
            Card(
              margin: EdgeInsets.all(8),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.group, color: Theme.of(context).primaryColor),
                    SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _group!.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            _group!.description,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          
          // Messages list
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          final isCurrentUser = message.senderId == _userId;
                          return _buildMessageBubble(message, isCurrentUser);
                        },
                      ),
          ),
          
          // Message input
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  offset: Offset(0, -1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: 'Type your message...',
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          _isAnonymous ? Icons.visibility_off : Icons.visibility,
                          color: _isAnonymous ? Colors.grey : Theme.of(context).primaryColor,
                          size: 18,
                        ),
                      ),
                      textCapitalization: TextCapitalization.sentences,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.send),
                    color: Theme.of(context).primaryColor,
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message, bool isCurrentUser) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isCurrentUser 
              ? Theme.of(context).primaryColor 
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(18),
        ),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: isCurrentUser ? Colors.white : Colors.black87,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message.isAnonymous
                  ? 'Anonymous • ${DateFormat('h:mm a').format(message.timestamp)}'
                  : isCurrentUser
                      ? 'You • ${DateFormat('h:mm a').format(message.timestamp)}'
                      : 'User • ${DateFormat('h:mm a').format(message.timestamp)}',
              style: TextStyle(
                color: isCurrentUser ? Colors.white70 : Colors.black54,
                fontSize: 11,
              ),
            ),
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
          Icon(
            Icons.chat_bubble_outline,
            size: 64,
            color: Colors.grey[400],
          ),
          SizedBox(height: 16),
          Text(
            'No messages yet',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          SizedBox(height: 8),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              'Be the first to send a message in this support group',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.grey[500],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

