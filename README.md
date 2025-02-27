# Serene Mental Health App

Serene (adjective): Calm, peaceful, and untroubled.
The Serene Mental Health App is designed to help students achieve a state of calm and peace by providing tools to manage their mental wellness. The app offers features like mood tracking, journaling, guided meditation, and peer support to help users navigate stress and anxiety in a healthy way.

## Core Features Implemented

Mood Tracking: Log your daily mood with emojis and notes, it also includes graphs to show different moods during the week.

Journaling: Write and manage journal entries with tags and prompts.

Guided Meditation: Access meditation sessions with self affirmations to cheer you up.

Breathing Exercises: Practice breathing techniques to reduce stress.

Peer Support Chat: Join anonymous support groups and chat with peers.

Emergency Contacts: Quickly access emergency helplines and university counselors.

## Installation Guide
### Prerequisites
- Flutter SDK (version 3.0.0 or higher)
- Android Studio or VS Code (with Flutter and Dart plugins installed)
- Hive (for local storage)

### Steps to Run the App
1. Clone the Repository:
   
   git clone https://github.com/4eyedmelissa/serene_app.git
   cd serene-mental-health-app
   
2. Install Dependencies, Run the app and Generate APK (Optional):

   flutter pub get
   flutter run
   flutter build apk

## Code Structure

   - lib/
      - constants/
        - app_theme.dart
      - models/
        - breathing_exercise.dart
        - chat_message.dart
        - journal_entry.dart
        - meditation.dart
        - mood_entry.dart
        - support_group.dart
        - user.dart (for logging in)
      - screens/
         -  breathing_exercise_screen.dart 
         - chat_screen.dart               
         - emergency_contacts_screen.dart 
         - home_screen.dart               
         - journal_editor_screen.dart     
         - journal_list_screen.dart       
         - login_screen.dart            
         - mood_tracking_screen.dart     
         - notifications_screen.dart     
         - peer_support_screen.dart       
         - progress_screen.dart           
         - self_care_screen.dart          
         - settings_screen.dart          
         - signup_screen.dart
       - service/
         - database_service.dart
       - widgets/
          - breathing_exercise_card.dart
          - daily_quote_card.dart        
          - mood_tracker_card.dart
        - main_navigation.dart
        - main.dart
    
## Dependencies

   - Hive: For local storage and data persistence.
   - Google Fonts: For custom typography.
   - Fl Chart: For displaying mood charts.
   - Shared Preferences: For storing user preferences.
   - Url Launcher: For opening emergency contacts (calls and emails).

## Screenshots


![image](https://github.com/user-attachments/assets/2fb10e8f-a1a2-4ef4-8e3d-7df63f7ee0a7)

  
         

   



