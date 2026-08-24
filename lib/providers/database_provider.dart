import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/models/season.dart';
import 'package:football_stat_track/models/match.dart';

/// Provider for Isar database instance
final isarProvider = Provider<Isar>((final ref) {
  throw UnimplementedError('Isar instance must be provided in main()');
});

/// Provider for ChildProfile collection
final childProfileCollectionProvider = Provider<IsarCollection<ChildProfile>>(
  (final ref) {
    final isar = ref.watch(isarProvider);
    return isar.collection<ChildProfile>();
  },
);

/// Provider for Season collection
final seasonCollectionProvider = Provider<IsarCollection<Season>>(
  (final ref) {
    final isar = ref.watch(isarProvider);
    return isar.collection<Season>();
  },
);

/// Provider for Match collection
final matchCollectionProvider = Provider<IsarCollection<Match>>(
  (final ref) {
    final isar = ref.watch(isarProvider);
    return isar.collection<Match>();
  },
);
