import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:football_stat_track/app.dart';
import 'package:football_stat_track/error_handler.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/models/season.dart';
import 'package:football_stat_track/models/match.dart';
import 'package:football_stat_track/providers/database_provider.dart';

/// Main entry point for the StatTrack application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Setup global error handling
  setupErrorHandling();

  // Initialize Isar for local storage
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    [ChildProfileSchema, SeasonSchema, MatchSchema],
    directory: dir.path,
    name: 'statrack',
    inspector: false,
  );

  // Run the application
  runApp(
    ProviderScope(
      overrides: [
        isarProvider.overrideWithValue(isar),
      ],
      child: const StatTrackApp(),
    ),
  );
}
