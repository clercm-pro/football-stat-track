import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/child_profile.dart';
import '../models/season.dart';
import '../models/match.dart';

/// Provider for Isar database instance
final isarProvider = Provider<Isar>((ref) {
  throw UnimplementedError('Isar instance must be provided in main()');
});

/// Provider for ChildProfile collection
final childProfileCollectionProvider = Provider<IsarCollection<ChildProfile>>((ref) {
  final isar = ref.watch(isarProvider);
  return isar.childProfiles;
});

/// Provider for Season collection
final seasonCollectionProvider = Provider<IsarCollection<Season>>((ref) {
  final isar = ref.watch(isarProvider);
  return isar.seasons;
});

/// Provider for Match collection
final matchCollectionProvider = Provider<IsarCollection<Match>>((ref) {
  final isar = ref.watch(isarProvider);
  return isar.matches;
});
