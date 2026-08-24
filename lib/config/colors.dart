import 'package:flutter/material.dart';

/// AppColors - Color palette for StatTrack application
/// 
/// Based on the design specification:
/// - Primary: #5B23FF (Electric purple)
/// - Surface: #362F4F (Deep purple)
/// - Accent: #E4FF30 (Lime green)
/// - Secondary: #008BFF (Bright blue)
/// - Error: #EA4335 (Red)
/// - Text colors for dark theme
class AppColors {
  // Primary colors
  static const primary = Color(0xFF5B23FF);
  static const primaryLight = Color(0xFF7C4DFF);
  static const primaryDark = Color(0xFF4A1ECC);
  
  // Surface colors
  static const surface = Color(0xFF362F4F);
  static const surfaceLight = Color(0xFF4A4260);
  static const surfaceDark = Color(0xFF2A253D);
  
  // Accent colors
  static const accent = Color(0xFFE4FF30);
  static const accentDim = Color(0xFFB3CC25);
  
  // Secondary colors
  static const secondary = Color(0xFF008BFF);
  static const secondaryLight = Color(0xFF33A1FF);
  
  // Error colors
  static const error = Color(0xFFEA4335);
  static const errorLight = Color(0xFFFF6B6B);
  
  // Text colors
  static const textPrimary = Colors.white;
  static const textSecondary = Color(0xFFB0B0B0);
  static const textMuted = Color(0xFF6C6C6C);
  
  /// ThemeData for the application
  static ThemeData get themeData => ThemeData(
    colorScheme: const ColorScheme(
      primary: primary,
      secondary: secondary,
      surface: surface,
      error: error,
      onPrimary: textPrimary,
      onSecondary: textPrimary,
      onSurface: textPrimary,
      onError: textPrimary,
      brightness: Brightness.dark,
    ),
    useMaterial3: true,
    fontFamily: 'Roboto',
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 4,
      backgroundColor: primary,
      foregroundColor: textPrimary,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 4,
      margin: const EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: surface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
        textStyle: const TextStyle(
          fontFamily: 'Roboto',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceLight,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accent, width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: error),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: textSecondary,
      ),
      hintStyle: TextStyle(
        fontFamily: 'Roboto',
        fontSize: 14,
        color: textSecondary.withValues(alpha: 0.6),
      ),
    ),
    iconTheme: const IconThemeData(
      color: accent,
      size: 24,
    ),
    dividerTheme: DividerThemeData(
      color: Colors.white.withValues(alpha: 0.2),
      thickness: 1,
      space: 1,
    ),
  );
}
