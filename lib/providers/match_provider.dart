import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/match.dart';
import 'database_provider.dart';

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
  final IsarCollection<Match> _collection;
  
  MatchNotifier(this._collection) : super([]);

  /// Load matches from database
  Future<void> loadMatches() async {
    final matches = await _collection.where().findAll();
    // Sort by start time descending (most recent first)
    matches.sort((a, b) => b.startTime.compareTo(a.startTime));
    state = matches;
  }

  /// Add a new match
  /// Returns the added match or null if a match is already in progress for this profile
  Future<Match?> addMatch(Match match) async {
    // Check if a match is already in progress for this profile (R-07)
    final inProgress = await _collection
        .where()
        .childIdEqualTo(match.childId)
        .and()
        .endTimeIsNull()
        .findFirst();
    if (inProgress != null) {
      return null;
    }
    
    // Save to database
    await _collection.put(match);
    
    // Reload state
    await loadMatches();
    return match;
  }

  /// Update match goals
  Future<Match?> updateGoals(String matchId, bool increment) async {
    final match = await _collection.get(matchId);
    if (match == null) return null;
    
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
  Future<Match?> updateAssists(String matchId, bool increment) async {
    final match = await _collection.get(matchId);
    if (match == null) return null;
    
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
  Future<Match?> endMatch(String matchId) async {
    final match = await _collection.get(matchId);
    if (match == null) return null;
    
    final updatedMatch = match.endMatch();
    
    // Save to database
    await _collection.put(updatedMatch);
    
    // Reload state
    await loadMatches();
    return updatedMatch;
  }

  /// Delete a match by ID
  Future<bool> deleteMatch(String matchId) async {
    // Delete from database
    final success = await _collection.delete(matchId);
    
    // Reload state
    await loadMatches();
    return success;
  }

  /// Get match by ID
  Match? getMatch(String matchId) {
    return state.firstWhere(
      (m) => m.id == matchId,
      orElse: () => null,
    );
  }

  /// Get all matches for a specific profile
  List<Match> getMatchesForProfile(String profileId) {
    return state.where((m) => m.childId == profileId).toList();
  }

  /// Get all matches for a specific season
  List<Match> getMatchesForSeason(String seasonId) {
    return state.where((m) => m.seasonId == seasonId).toList();
  }

  /// Get all matches for a profile and season
  List<Match> getMatchesForProfileAndSeason(String profileId, String seasonId) {
    return state.where((m) => 
        m.childId == profileId && 
        m.seasonId == seasonId
    ).toList();
  }

  /// Get match in progress for a profile
  Match? getMatchInProgressForProfile(String profileId) {
    return state.firstWhere(
      (m) => m.childId == profileId && m.isInProgress,
      orElse: () => null,
    );
  }

  /// Get stats for a profile and season
  MatchStats getStatsForProfileAndSeason(String profileId, String seasonId) {
    final matches = getMatchesForProfileAndSeason(profileId, seasonId);
    return MatchStats.fromMatches(matches);
  }

  /// Check if a match is already in progress for a profile
  bool hasMatchInProgress(String profileId) {
    return state.any((m) => m.childId == profileId && m.isInProgress);
  }


/// Matches Provider
/// Watches the list of matches
final matchesProvider = StateNotifierProvider<MatchNotifier, List<Match>>(
  (ref) {
    final collection = ref.watch(matchCollectionProvider);
    final notifier = MatchNotifier(collection);
    notifier.loadMatches();
    return notifier;
  },
);

/// Match in Progress Provider for a Profile
/// Gets the match in progress for a specific profile
final matchInProgressProvider = Provider.family<Match?, String>(
  (ref, profileId) {
    final matches = ref.watch(matchesProvider);
    return matches.firstWhere(
      (m) => m.childId == profileId && m.isInProgress,
      orElse: () => null,
    );
  },
);

/// Matches for Profile Provider
/// Gets all matches for a specific profile
final matchesForProfileProvider = Provider.family<List<Match>, String>(
  (ref, profileId) {
    final matches = ref.watch(matchesProvider);
    return matches.where((m) => m.childId == profileId).toList();
  },
);

/// Stats for Profile and Season Provider
/// Gets computed stats for a profile and season
final statsForProfileAndSeasonProvider = Provider.family<MatchStats, Map<String, String>>(
  (ref, ids) {
    final matches = ref.watch(matchesProvider);
    final profileId = ids['profileId']!;
    final seasonId = ids['seasonId']!;
    
    final profileMatches = matches.where((m) => 
        m.childId == profileId && 
        m.seasonId == seasonId
    ).toList();
    
    return MatchStats.fromMatches(profileMatches);
  },
);
