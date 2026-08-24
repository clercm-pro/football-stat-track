import 'package:flutter/material.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/screens/home_screen.dart';

/// StatTrackApp - Main application widget
/// 
/// Configures the theme and home screen
class StatTrackApp extends StatelessWidget {
  const StatTrackApp({super.key});

  @override
  Widget build(final BuildContext context) {
    return MaterialApp(
      title: 'StatTrack',
      theme: AppColors.themeData,
      darkTheme: AppColors.themeData,
      themeMode: ThemeMode.dark,
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
