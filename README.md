ID: 25345
Names: Ikirezi Cyuzuzo Melissa <br>

# Serene Mental Health App

Serene (adjective): Calm, peaceful, and untroubled. <br>
The Serene Mental Health App is designed to help students achieve a state of calm and peace by providing tools to manage their mental wellness. The app offers features like mood tracking, journaling, guided meditation, and peer support to help users navigate stress and anxiety in a healthy way.

## Core Features Implemented

  - Mood Tracking: Log your daily mood with emojis and notes, it also includes graphs to show different moods during the week.
  - Journaling: Write and manage journal entries with tags and prompts.
  - Guided Meditation: Access meditation sessions with self affirmations to cheer you up.
  - Breathing Exercises: Practice breathing techniques to reduce stress.
  - Peer Support Chat: Join anonymous support groups and chat with peers.
  - Emergency Contacts: Quickly access emergency helplines and university counselors.

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

## Download APK and try out the app

  - Go to releases section of this repository
  - Transfer the APK file to your Android device (if downloaded on a computer).
  - On your Android device, enable Install from Unknown Sources:
  - Go to Settings > Security > Enable Unknown Sources.
  - Open the APK file and tap Install.
  - Once installed, open the app and start using it!

## Screenshots

Here are some screenshots of the app:

<img src="https://github.com/user-attachments/assets/851c490c-7a4e-4d5a-9218-6a059e33952b" width="250">

<img src="https://github.com/user-attachments/assets/db703743-0519-42ca-b22f-e59a48c78c9a" width="250">

<img src="https://github.com/user-attachments/assets/d1afd1eb-ce2b-4702-88b9-022719453c8b" width ="250">

<img src="https://github.com/user-attachments/assets/ebad5c29-44ee-424c-b5e2-a8e141c6c55b" width="250">

<img src="https://github.com/user-attachments/assets/4179e342-33b9-4762-8f0b-74dffc89bea5" width="250">

<img src="https://github.com/user-attachments/assets/4e3fa8ca-7457-4797-b252-d8232921ac99" width="250">

<img src="https://github.com/user-attachments/assets/1f324404-ab46-4cae-9f23-f00fcb09720d" width="250">

<img src="https://github.com/user-attachments/assets/a4a4e387-f621-4de0-95b8-f63a96f21a0b" width="250">

<img src="https://github.com/user-attachments/assets/6c656a05-ad3d-45dc-be74-81ac5a01aaee" width="250">

<img src="https://github.com/user-attachments/assets/bb8dc320-7d99-48dd-aa0a-0269f9955f76" width="250">

<img src="https://github.com/user-attachments/assets/e370b98b-c3e4-4ae5-8fae-1fc462dd6a72" width="250">

<img src="https://github.com/user-attachments/assets/784419ab-c279-401c-9284-07ebecb331eb" width="250">











