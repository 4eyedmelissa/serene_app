
import 'package:flutter/material.dart';
import 'package:serene_app/services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  final DatabaseService databaseService;

  const SettingsScreen({super.key, required this.databaseService});

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  
  // Settings toggles
  bool _notificationsEnabled = true;
  bool _darkModeEnabled = false;
  bool _soundEnabled = true;
  bool _reminderEnabled = true;
  double _meditationReminder = 8.0; // Default time (8:00 AM)
  
  final Color primaryPurple = Color(0xFFAA84E3); // Light purple to match theme

  @override
  void initState() {
    super.initState();
    _loadUserSettings();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _loadUserSettings() async {
    // Fetch user settings from the database or backend
    // For now, we'll use dummy data
    _nameController.text = 'Melissa';
    _emailController.text = 'melissa@example.com';
  }

  Future<void> _saveUserSettings() async {
    if (_formKey.currentState!.validate()) {
      // Save user settings to the database or backend
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Settings saved successfully'),
          backgroundColor: primaryPurple,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  String _formatTimeValue(double value) {
    final hour = value.floor();
    final minute = ((value - hour) * 60).round();
    final period = hour >= 12 ? 'PM' : 'AM';
    final hourFormatted = hour > 12 ? hour - 12 : hour == 0 ? 12 : hour;
    return '$hourFormatted:${minute.toString().padLeft(2, '0')} $period';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryPurple,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile section
            Container(
              color: primaryPurple,
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 30),
              child: Column(
                children: [
                  Center(
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white,
                          child: Text(
                            _nameController.text.isNotEmpty ? _nameController.text[0].toUpperCase() : 'M',
                            style: TextStyle(fontSize: 40, color: primaryPurple),
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(color: primaryPurple, width: 2),
                            ),
                            child: IconButton(
                              padding: EdgeInsets.zero,
                              icon: Icon(Icons.camera_alt, size: 20, color: primaryPurple),
                              onPressed: () {
                                // Add profile picture functionality
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Profile Information Form
            Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Account Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        prefixIcon: Icon(Icons.person, color: primaryPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryPurple, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email Address',
                        prefixIcon: Icon(Icons.email, color: primaryPurple),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: primaryPurple, width: 2),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 32),
                    Text(
                      'App Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Settings Toggles
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text('Notifications'),
                            subtitle: Text('Receive push notifications'),
                            secondary: Icon(Icons.notifications, color: primaryPurple),
                            value: _notificationsEnabled,
                            activeColor: primaryPurple,
                            onChanged: (value) {
                              setState(() {
                                _notificationsEnabled = value;
                              });
                            },
                          ),
                          Divider(height: 1),
                          SwitchListTile(
                            title: Text('Dark Mode'),
                            subtitle: Text('Use dark theme'),
                            secondary: Icon(Icons.dark_mode, color: primaryPurple),
                            value: _darkModeEnabled,
                            activeColor: primaryPurple,
                            onChanged: (value) {
                              setState(() {
                                _darkModeEnabled = value;
                              });
                            },
                          ),
                          Divider(height: 1),
                          SwitchListTile(
                            title: Text('Sound Effects'),
                            subtitle: Text('Play sounds during exercises'),
                            secondary: Icon(Icons.music_note, color: primaryPurple),
                            value: _soundEnabled,
                            activeColor: primaryPurple,
                            onChanged: (value) {
                              setState(() {
                                _soundEnabled = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    Text(
                      'Reminder Settings',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Reminder Settings
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          SwitchListTile(
                            title: Text('Daily Meditation Reminder'),
                            subtitle: Text('Remind me to meditate'),
                            secondary: Icon(Icons.self_improvement, color: primaryPurple),
                            value: _reminderEnabled,
                            activeColor: primaryPurple,
                            onChanged: (value) {
                              setState(() {
                                _reminderEnabled = value;
                              });
                            },
                          ),
                          Visibility(
                            visible: _reminderEnabled,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Reminder time:'),
                                        Text(
                                          _formatTimeValue(_meditationReminder),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: primaryPurple,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Slider(
                                    value: _meditationReminder,
                                    min: 5,
                                    max: 22,
                                    divisions: 34,
                                    activeColor: primaryPurple,
                                    inactiveColor: primaryPurple.withOpacity(0.2),
                                    onChanged: (value) {
                                      setState(() {
                                        _meditationReminder = value;
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 24),
                    Text(
                      'Data & Privacy',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    SizedBox(height: 8),
                    
                    // Data & Privacy
                    Card(
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: Icon(Icons.download, color: primaryPurple),
                            title: Text('Export My Data'),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Export data functionality
                            },
                          ),
                          Divider(height: 1),
                          ListTile(
                            leading: Icon(Icons.delete_outline, color: Colors.red),
                            title: Text('Delete Account', style: TextStyle(color: Colors.red)),
                            trailing: Icon(Icons.arrow_forward_ios, size: 16),
                            onTap: () {
                              // Delete account functionality
                            },
                          ),
                        ],
                      ),
                    ),
                    
                    SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _saveUserSettings,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Save Settings',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: 40),
                    Center(
                      child: Column(
                        children: [
                          Text(
                            'Serene',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: primaryPurple,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Version 1.0.0',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

