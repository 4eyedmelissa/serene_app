import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    primaryColor: Color(0xFFB39DDB),  // Light purple
    colorScheme: ColorScheme.light(
      primary: Color(0xFFB39DDB),      // Light purple
      secondary: Color(0xFF9575CD),    // Slightly darker purple
    ),
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: Color(0xFF673AB7), fontWeight: FontWeight.bold),
      titleLarge: TextStyle(color: Color(0xFF673AB7), fontWeight: FontWeight.w600, fontSize: 20),
      bodyLarge: TextStyle(color: Color(0xFF424242)),
    ),
    appBarTheme: AppBarTheme(
      color: Color(0xFFB39DDB),
      elevation: 0,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white, backgroundColor: Color(0xFF9575CD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    ),
    cardTheme: CardTheme(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
    ),
  );
}