import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData darkTheme() {
    const darkColorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFE50914),
      onPrimary: Colors.white,
      secondary: Color(0xFFE50914),
      onSecondary: Colors.white,
      error: Colors.redAccent,
      onError: Colors.white,
      surface: Color(0xFF141414),
      onSurface: Colors.white,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,

      scaffoldBackgroundColor: darkColorScheme.surface,

      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF1E1E1E),
        foregroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor:
              WidgetStateProperty.all(darkColorScheme.primary),
          foregroundColor:
              WidgetStateProperty.all(darkColorScheme.onPrimary),
          textStyle: WidgetStateProperty.all(
            const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
