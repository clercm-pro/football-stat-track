import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:football_stat_track/models/match.dart';
import 'package:football_stat_track/providers/database_provider.dart';

/// Match State Notifier
/// 
/// Manages the state for matches including:
/// - List of all matches
/// - Adding new matches
/// - Updating existing matches (goals, assists)
/// - Ending matches
/// - Getting matches for a specific profile/season
/// - Business rule: Only one match in progress per profile (R-07)
class MatchNotifier extends StateNotifier<List<Match>> {
  
  MatchNotifier(this._collection) : super([]);
  final IsarCollection<Match> _collection;

  /// Load matches from database
  Future<void> loadMatches() async {
    final matches = await _collection.where().findAll();
    // Sort by start time descending (most recent first)
    matches.sort(
      (final a, final b) => b.startTime.compareTo(a.startTime),
    );
    state = matches;
  }

  /// Add a new match
  /// Returns the added match or null if a match is already in progress for this
  /// profile
  Future<Match?> addMatch(final Match match) async {
    // Check if a match is already in progress for this profile (R-07)
    final inProgress = await _collection
        .where()
        .filter()
        .childIdEqualTo(match.childId)
        .endTimeIsNull()
        .findFirst();
    if (inProgress != null)
      return null;
    
    // Save to database
    await _collection.put(match);
    
    // Reload state
    await loadMatches();
    return match;
  }

  /// Update match goals
  Future<Match?> updateGoals(
    final Id matchId, {
    final bool increment = true,
  }) async {
    final match = await _collection.get(matchId);
    if (match == null)
      return null;
    
    final updatedMatch = increment
        ? match.addGoal()
        : match.removeGoal();
    
    // Save to database
    await _collection.put(updatedMatch);
    
    // Reload state
    await loadMatches();
    return updatedMatch;
  }

  /// Update match assists
  Future<Match?> updateAssists(
    final Id matchId, {
    final bool increment = true,
  }) async {
    final match = await _collection.get(matchId);
    if (match == null)
      return null;
    
    final updatedMatch = increment
        ? match.addAssist()
        : match.removeAssist();
    
    // Save to database
    await _collection.put(updatedMatch);
    
    // Reload state
    await loadMatches();
    return updatedMatch;
  }

  /// End a match
  Future<Match?> endMatch(final Id matchId) async {
    final match = await _collection.get(matchId);
    if (match == null)
      return null;
    
    final updatedMatch = match.endMatch();
    
    // Save to database
    await _collection.put(updatedMatch);
    
    // Reload state
    await loadMatches();
    return updatedMatch;
  }

  /// Delete a match by ID
  Future<bool> deleteMatch(final Id matchId) async {
    // Delete from database
    final success = await _collection.delete(matchId);
    
    // Reload state
    await loadMatches();
    return success;
  }

  /// Get match by ID
  Match? getMatch(final Id matchId) {
    try {
      return state.firstWhere((final m) => m.id == matchId);
    } on Exception {
      return null;
    }
  }

  /// Get all matches for a specific profile
  List<Match> getMatchesForProfile(final Id profileId) {
    return state.where((final m) => m.childId == profileId).toList();
  }

  /// Get all matches for a specific season
  List<Match> getMatchesForSeason(final Id seasonId) {
    return state.where((final m) => m.seasonId == seasonId).toList();
  }

  /// Get all matches for a profile and season
  List<Match> getMatchesForProfileAndSeason(
    final Id profileId,
    final Id seasonId,
  ) {
    return state.where(
      (final m) =>
          m.childId == profileId &&
          m.seasonId == seasonId,
    ).toList();
  }

  /// Get match in progress for a profile
  Match? getMatchInProgressForProfile(final Id profileId) {
    try {
      return state.firstWhere(
        (final m) => m.childId == profileId && m.isInProgress,
      );
    } on Exception {
      return null;
    }
  }

  /// Get stats for a profile and season
  MatchStats getStatsForProfileAndSeason(
    final Id profileId,
    final Id seasonId,
  ) {
    final matches = getMatchesForProfileAndSeason(profileId, seasonId);
    return MatchStats.fromMatches(matches);
  }

  /// Check if a match is already in progress for a profile
  bool hasMatchInProgress(final Id profileId) {
    return state.any((final m) => m.childId == profileId && m.isInProgress);
  }
}


/// Matches Provider
/// Watches the list of matches
final matchesProvider = StateNotifierProvider<MatchNotifier, List<Match>>(
  (final ref) {
    final collection = ref.watch(matchCollectionProvider);
    final notifier = MatchNotifier(collection);
    notifier.loadMatches();
    return notifier;
  },
);