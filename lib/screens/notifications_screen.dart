import 'package:flutter/material.dart';
import 'package:serene_app/services/database_service.dart';

class NotificationsScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const NotificationsScreen({super.key, required this.databaseService});

  @override
  _NotificationsScreenState createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = true;
  final Color primaryPurple = Color(0xFFAA84E3); // Light purple to match theme

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    setState(() {
      _isLoading = true;
    });
    
    // Fetch notifications from the database or backend
    // For now, we'll use expanded dummy data
    await Future.delayed(const Duration(milliseconds: 300)); // Simulate network delay
    
    setState(() {
      _notifications = [
        {
          'message': 'New guided meditation: "Calm Mind" is now available',
          'icon': Icons.self_improvement,
          'time': 'Just now',
          'type': 'meditation'
        },
        {
          'message': 'Your mood entry has been recorded. Keep the streak going!',
          'icon': Icons.mood,
          'time': '2 hours ago',
          'type': 'mood'
        },
        {
          'message': 'New journal prompt: "What brought you joy today?"',
          'icon': Icons.edit_note,
          'time': '4 hours ago',
          'type': 'journal'
        },
        {
          'message': 'Breathing reminder: Take a moment to center yourself',
          'icon': Icons.air,
          'time': 'Yesterday',
          'type': 'reminder'
        },
        {
          'message': 'Achievement unlocked: 5-day meditation streak!',
          'icon': Icons.emoji_events,
          'time': '2 days ago',
          'type': 'achievement'
        },
        {
          'message': 'Weekly mood summary is ready to view',
          'icon': Icons.insert_chart,
          'time': '3 days ago',
          'type': 'progress'
        },
        {
          'message': 'New community support group available',
          'icon': Icons.group,
          'time': '4 days ago',
          'type': 'community'
        },
      ];
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
        backgroundColor: primaryPurple,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.check_circle_outline, color: Colors.white),
            tooltip: 'Mark all as read',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('All notifications marked as read'),
                  backgroundColor: primaryPurple,
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      backgroundColor: Colors.grey[50],
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
                color: primaryPurple,
              ),
            )
          : RefreshIndicator(
              onRefresh: _loadNotifications,
              color: primaryPurple,
              child: _notifications.isEmpty
                  ? _buildEmptyState()
                  : _buildNotificationsList(),
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_off_outlined,
            size: 80,
            color: primaryPurple.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'All caught up!',
            style: TextStyle(
              fontSize: 20,
              color: Colors.purple[700],
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'You have no new notifications',
            style: TextStyle(
              color: Colors.purple[600],
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: _notifications.length,
      separatorBuilder: (context, index) => Divider(height: 1, color: Colors.grey[200]),
      itemBuilder: (context, index) {
        final notification = _notifications[index];
        return Dismissible(
          key: Key(index.toString()),
          background: Container(
            color: Colors.red[400],
            alignment: Alignment.centerRight,
            padding: EdgeInsets.only(right: 20),
            child: Icon(Icons.delete_outline, color: Colors.white),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction) {
            setState(() {
              _notifications.removeAt(index);
            });
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Notification removed'),
                backgroundColor: primaryPurple,
                duration: Duration(seconds: 2),
              ),
            );
          },
          child: ListTile(
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            leading: Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: _getColorForType(notification['type']),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                notification['icon'],
                color: Colors.white,
                size: 28,
              ),
            ),
            title: Text(
              notification['message'],
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: 4),
              child: Text(
                notification['time'],
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 13,
                ),
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.more_horiz, color: Colors.grey[600]),
              onPressed: () {
                _showNotificationOptions(context, index);
              },
            ),
            onTap: () {
              // Navigate to relevant section based on notification type
              _handleNotificationTap(notification['type']);
            },
          ),
        );
      },
    );
  }

  Color _getColorForType(String type) {
    switch (type) {
      case 'meditation':
        return Colors.indigo[400]!;
      case 'mood':
        return Colors.amber[600]!;
      case 'journal':
        return Colors.teal[500]!;
      case 'reminder':
        return Colors.blue[500]!;
      case 'achievement':
        return Colors.orange[500]!;
      case 'progress':
        return Colors.green[500]!;
      case 'community':
        return Colors.purple[500]!;
      default:
        return primaryPurple;
    }
  }

  void _showNotificationOptions(BuildContext context, int index) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.mark_email_read, color: primaryPurple),
                title: Text('Mark as read'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.notifications_off, color: primaryPurple),
                title: Text('Mute this type'),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.delete_outline, color: Colors.red),
                title: Text('Delete'),
                onTap: () {
                  Navigator.pop(context);
                  setState(() {
                    _notifications.removeAt(index);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleNotificationTap(String type) {
    // In a real app, navigate to the relevant section
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Navigating to $type section'),
        backgroundColor: primaryPurple,
        duration: Duration(seconds: 2),
      ),
    );
  }
}

