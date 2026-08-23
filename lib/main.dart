import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'app.dart';
import 'models/child_profile.dart';
import 'models/season.dart';
import 'models/match.dart';

/// Main entry point for the StatTrack application
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Isar for local storage
  final dir = await getApplicationDocumentsDirectory();
  final isar = await Isar.open(
    schemas: [ChildProfileSchema, SeasonSchema, MatchSchema],
    directory: dir.path,
    name: 'statrack',
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
