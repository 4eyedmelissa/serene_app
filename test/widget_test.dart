
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serene_app/main.dart';
import 'package:serene_app/screens/login_screen.dart';
import 'package:serene_app/main_navigator.dart'; // Import MainNavigator
import 'package:serene_app/services/database_service.dart'; // Import DatabaseService

void main() {
  group('SereneApp Widget Tests', () {
    late DatabaseService databaseService;

    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});

      // Initialize DatabaseService for testing
      databaseService = DatabaseService();
      await databaseService.init(); // Initialize Hive boxes
    });

    testWidgets('Should show LoginScreen when not logged in', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(SereneApp(
        isLoggedIn: false,
        databaseService: databaseService, // Pass DatabaseService
      ));

      // Verify that LoginScreen is shown
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(MainNavigator), findsNothing); // Check for MainNavigator instead of HomeScreen
    });

    testWidgets('Should show MainNavigator when logged in', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(SereneApp(
        isLoggedIn: true,
        databaseService: databaseService, // Pass DatabaseService
      ));

      // Wait for any animations to complete
      await tester.pumpAndSettle();

      // Verify that MainNavigator is shown
      expect(find.byType(MainNavigator), findsOneWidget); // Check for MainNavigator instead of HomeScreen
      expect(find.byType(LoginScreen), findsNothing);
    });
  });
}

/*import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:serene_app/main.dart';
import 'package:serene_app/screens/login_screen.dart';
import 'package:serene_app/screens/home_screen.dart';
import 'package:serene_app/screens/journal_list_screen.dart';
import 'package:serene_app/screens/mood_tracking_screen.dart';
import 'package:serene_app/screens/chat_screen.dart';
void main() {
  group('SereneApp Widget Tests', () {
    setUp(() async {
      // Initialize SharedPreferences for testing
      SharedPreferences.setMockInitialValues({});
    });

    testWidgets('Should show LoginScreen when not logged in', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const SereneApp(isLoggedIn: false));

      // Verify that LoginScreen is shown
      expect(find.byType(LoginScreen), findsOneWidget);
      expect(find.byType(HomeScreen), findsNothing);
    });

    testWidgets('Should show HomeScreen when logged in', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const SereneApp(isLoggedIn: true));

      // Wait for any animations to complete
      await tester.pumpAndSettle();

      // Verify that HomeScreen is shown
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.byType(LoginScreen), findsNothing);
    });*/

   /* testWidgets('Bottom navigation bar should work correctly', (WidgetTester tester) async {
      // Build our app with logged in state
      await tester.pumpWidget(const SereneApp(isLoggedIn: true));
      await tester.pumpAndSettle();

      // Verify initial screen is HomeScreen
      expect(find.byType(HomeScreen), findsOneWidget);

      // Tap journal icon and verify navigation
      await tester.tap(find.byIcon(Icons.book_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(JournalListScreen), findsOneWidget);

      // Tap mood tracking icon and verify navigation
      await tester.tap(find.byIcon(Icons.track_changes_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(MoodTrackingScreen), findsOneWidget);

      // Tap chat icon and verify navigation
      await tester.tap(find.byIcon(Icons.chat_outlined));
      await tester.pumpAndSettle();
      expect(find.byType(ChatScreen), findsOneWidget);
    });*/
 