import 'package:material_ui/material_ui.dart';
import 'config/colors.dart';
import 'screens/home_screen.dart';

/// StatTrackApp - Main application widget
/// 
/// Configures the theme and home screen
class StatTrackApp extends StatelessWidget {
  const StatTrackApp({super.key});

  @override
  Widget build(BuildContext context) {
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
