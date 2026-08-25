import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:football_stat_track/models/season.dart';
import 'package:football_stat_track/providers/database_provider.dart';

/// Season State Notifier
/// 
/// Manages the state for seasons including:
/// - List of all seasons
/// - Adding new seasons
/// - Updating existing seasons
/// - Deleting seasons
/// - Getting current season
class SeasonNotifier extends StateNotifier<List<Season>> {
  
  SeasonNotifier(this._isar, this._collection) : super([]);
  final Isar _isar;
  final IsarCollection<Season> _collection;

  /// Load seasons from database
  Future<void> loadSeasons() async {
    final seasons = await _collection.where().findAll();
    // Sort by start year descending (most recent first)
    seasons.sort(
      (final a, final b) => b.startYear.compareTo(a.startYear),
    );
    state = seasons;
  }

  /// Add a new season
  Future<Season> addSeason(final Season season) async {
    // Check if season already exists in DB
    final existing = await _collection
        .where()
        .filter()
        .nameEqualTo(season.name)
        .findFirst();
    if (existing != null) {
      return season;
    }
    
    // Save to database (must be in transaction)
    await _isar.writeTxn(() async {
      await _collection.put(season);
    });
    
    // Reload state
    await loadSeasons();
    return season;
  }

  /// Update an existing season
  Future<bool> updateSeason(final Season updatedSeason) async {
    // Check if new name conflicts with another season
    final existing = await _collection
        .where()
        .idNotEqualTo(updatedSeason.id)
        .filter()
        .nameEqualTo(updatedSeason.name)
        .findFirst();
    if (existing != null) {
      return false;
    }
    
    // Save to database (must be in transaction)
    await _isar.writeTxn(() async {
      await _collection.put(updatedSeason);
    });
    
    // Reload state
    await loadSeasons();
    return true;
  }

  /// Delete a season by ID
  Future<bool> deleteSeason(final Id seasonId) async {
    // Delete from database (must be in transaction)
    final success = await _isar.writeTxn<bool>(() async {
      return _collection.delete(seasonId);
    });
    
    // Reload state
    await loadSeasons();
    return success;
  }

  /// Get season by ID
  Season? getSeason(final Id seasonId) {
    try {
      return state.firstWhere((final s) => s.id == seasonId);
    } on Exception {
      return null;
    }
  }

  /// Get current season (most recent that includes current date)
  Season? getCurrentSeason() {
    final now = DateTime.now();
    
    // Find the most recent season that is current or in the past
    Season? currentSeason;
    for (final season in state) {
      if (season.isCurrent) {
        return season;
      }
      if (season.endYear <= now.year &&
          (currentSeason == null ||
              season.startYear > currentSeason.startYear)) {
        currentSeason = season;
      }
    }
    
    // If no season found, return the most recent
    if (state.isNotEmpty) {
      return state.first;
    }
    return null;
  }

  /// Get most recent season
  Season? getMostRecentSeason() {
    if (state.isEmpty) {
      return null;
    }
    return state.first; // Already sorted by startYear descending
  }
}


/// Notifier factory to avoid duplicate initialization code
SeasonNotifier _getSeasonsNotifier(final Ref ref) {
  final isar = ref.watch(isarProvider);
  final collection = ref.watch(seasonCollectionProvider);
  final notifier = SeasonNotifier(isar, collection);
  notifier.loadSeasons();
  return notifier;
}

/// Seasons Provider
/// Watches the list of seasons
final seasonsProvider = StateNotifierProvider<SeasonNotifier, List<Season>>(
  _getSeasonsNotifier,
);

/// Selected Season Provider
/// Holds the currently selected season
final selectedSeasonProvider = StateProvider<Season?>(
  (final ref) => null,
);

/// Current Season Provider
/// Gets the current season based on today's date
final currentSeasonProvider = Provider<Season?>(
  (final ref) => _getSeasonsNotifier(ref).getCurrentSeason(),
);