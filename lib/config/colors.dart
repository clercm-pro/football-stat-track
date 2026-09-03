import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AppColors - Color palette for StatTrack application
/// 
/// NEW: Scoreboard Theme v2.0 - Modern Turquoise Palette
/// Based on Claude design #2b/#3a-#3c
/// 
/// Design Tokens System:
/// - background: #F3F4F3 (screen background)
/// - surface: #FFFFFF (cards, elevated surfaces)
/// - ink: #343B46 (primary text)
/// - primary: #008A78 (goals, accents)
/// - primaryDark: #01584A (hero block, primary buttons)
/// - accent: #2CADA3 (sparkline bars)
/// - ink60: rgba(52,59,70,.5) (secondary text)
/// - ink30: rgba(52,59,70,.3) (tertiary text, disabled)
/// - hairline: rgba(52,59,70,.12) (borders, dividers)
/// 
/// Avatar colors:
/// - avatar1: #6A71FF (blue)
/// - avatar2: #6BFF9B (green)
/// - avatar3: #FFE16B (yellow)
/// - avatar4: #FF6E6B (red)
class AppColors {
  // ===========================================================================
  // DESIGN TOKENS - Scoreboard Theme v2.0
  // ===========================================================================
  
  // Background colors
  static const background = Color(0xFFF3F4F3);
  static const surface = Color(0xFFFFFFFF);
  
  // Surface variants (for backward compatibility)
  static const surfaceLight = Color(0xFF2A2A2A); // Kept for compatibility
  static const surfaceDark = Color(0xFF0F0F0F); // Kept for compatibility
  
  // Ink colors (text)
  static const ink = Color(0xFF343B46);
  static const ink60 = Color.fromRGBO(52, 59, 70, 0.5);
  static const ink30 = Color.fromRGBO(52, 59, 70, 0.3);
  
  // Primary colors (turquoise)
  static const primary = Color(0xFF008A78);
  static const primaryDark = Color(0xFF01584A);
  static const primaryLight = Color.fromRGBO(0, 138, 120, 0.08);
  
  // Accent colors
  static const accent = Color(0xFF2CADA3);
  static const accentDim = Color(0xFFFF4C6B); // Kept for compatibility
  
  // Secondary colors (for backward compatibility)
  static const secondary = Color(0xFF08BDBD); // Kept for compatibility
  static const secondaryLight = Color(0xFF33D4D4); // Kept for compatibility
  
  // Error colors (for backward compatibility)
  static const error = Color(0xFFFF9914); // Kept for compatibility
  static const errorLight = Color(0xFFFFB340); // Kept for compatibility
  
  // Text colors (for backward compatibility)
  static const textPrimary = Colors.white; // Kept for compatibility
  static const textSecondary = Color(0xFFB0B0B0); // Kept for compatibility
  static const textMuted = Color(0xFF6C6C6C); // Kept for compatibility
  
  // Hairline (borders, dividers)
  static const hairline = Color.fromRGBO(52, 59, 70, 0.12);
  static const hairlineLight = Color.fromRGBO(52, 59, 70, 0.15);
  
  // ===========================================================================
  // AVATAR COLORS - Player identity colors
  // ===========================================================================
  
  static const avatar1 = Color(0xFF6A71FF);
  static const avatar2 = Color(0xFF6BFF9B);
  static const avatar3 = Color(0xFFFFE16B);
  static const avatar4 = Color(0xFFFF6E6B);
  
  static Color avatarColor(final int index) {
    switch (index % 4) {
      case 0: return avatar1;
      case 1: return avatar2;
      case 2: return avatar3;
      case 3: return avatar4;
      default: return avatar1;
    }
  }
  
  // ===========================================================================
  // SHADOWS - Design system shadows
  // ===========================================================================
  
  static const shadowPlayerCard = BoxShadow(
    color: Color.fromRGBO(52, 59, 70, 0.08),
    blurRadius: 2,
    offset: Offset(0, 1),
  );
  
  static const shadowAssistCard = BoxShadow(
    color: Color.fromRGBO(52, 59, 70, 0.07),
    blurRadius: 3,
    offset: Offset(0, 1),
  );
  
  static const shadowGoalsCard = BoxShadow(
    color: Color.fromRGBO(1, 88, 74, 0.25),
    blurRadius: 6,
    offset: Offset(0, 2),
  );
  
  static const shadowBottomSheet = BoxShadow(
    color: Color.fromRGBO(52, 59, 70, 0.3),
    blurRadius: 30,
    offset: Offset(0, -6),
  );
  
  // ===========================================================================
  // THEME DATA - Light theme with Scoreboard design
  // ===========================================================================
  
  static ThemeData get themeData => ThemeData(
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: surface,
      error: error,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: ink,
      onError: Colors.white,
      brightness: Brightness.light,
    ),
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    textTheme: GoogleFonts.archivoTextTheme(),
    appBarTheme: const AppBarTheme(
      centerTitle: true,
      elevation: 0,
      backgroundColor: surface,
      foregroundColor: ink,
      titleTextStyle: TextStyle(
        fontFamily: 'Archivo',
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: ink,
        letterSpacing: -0.5,
      ),
      iconTheme: IconThemeData(
        color: ink,
        size: 24,
      ),
    ),
    cardTheme: CardThemeData(
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shadowColor: const Color.fromRGBO(52, 59, 70, 0.08),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      color: surface,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryDark,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 0,
        shadowColor: const Color.fromRGBO(1, 88, 74, 0.25),
        textStyle: const TextStyle(
          fontFamily: 'Archivo',
          fontSize: 16,
          fontWeight: FontWeight.w700,
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: ink,
        backgroundColor: surface,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        side: const BorderSide(color: hairlineLight, width: 1.5),
        textStyle: const TextStyle(
          fontFamily: 'Archivo',
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primary,
        textStyle: const TextStyle(
          fontFamily: 'Archivo',
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: hairline, width: 1.5),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: hairline, width: 1.5),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: primary, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(color: error, width: 1.5),
      ),
      labelStyle: const TextStyle(
        fontFamily: 'Archivo',
        fontSize: 12,
        fontWeight: FontWeight.w700,
        color: ink,
      ),
      hintStyle: const TextStyle(
        fontFamily: 'Archivo',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: ink30,
      ),
    ),
    iconTheme: const IconThemeData(
      color: ink,
      size: 24,
    ),
    dividerTheme: const DividerThemeData(
      color: hairline,
      thickness: 1,
      space: 1,
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      modalBackgroundColor: background,
      elevation: 0,
      shadowColor: Color.fromRGBO(52, 59, 70, 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: surface,
      elevation: 0,
      shadowColor: const Color.fromRGBO(52, 59, 70, 0.3),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
      ),
    ),
  );
  
  static const List<FontFeature> tabularFigures = [
    FontFeature.tabularFigures(),
  ];
}
