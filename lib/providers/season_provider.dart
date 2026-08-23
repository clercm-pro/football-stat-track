import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import '../models/season.dart';
import 'database_provider.dart';

/// Season State Notifier
/// 
/// Manages the state for seasons including:
/// - List of all seasons
/// - Adding new seasons
/// - Updating existing seasons
/// - Deleting seasons
/// - Getting current season
class SeasonNotifier extends StateNotifier<List<Season>> {
  final IsarCollection<Season> _collection;
  
  SeasonNotifier(this._collection) : super([]);

  /// Load seasons from database
  Future<void> loadSeasons() async {
    final seasons = await _collection.where().findAll();
    // Sort by start year descending (most recent first)
    seasons.sort((a, b) => b.startYear.compareTo(a.startYear));
    state = seasons;
  }

  /// Add a new season
  Future<Season> addSeason(Season season) async {
    // Check if season already exists in DB
    final existing = await _collection
        .where()
        .nameEqualTo(season.name)
        .findFirst();
    if (existing != null) {
      return season;
    }
    
    // Save to database
    await _collection.put(season);
    
    // Reload state
    await loadSeasons();
    return season;
  }

  /// Update an existing season
  Future<bool> updateSeason(Season updatedSeason) async {
    // Check if new name conflicts with another season
    final existing = await _collection
        .where()
        .idNotEqualTo(updatedSeason.id)
        .and()
        .nameEqualTo(updatedSeason.name)
        .findFirst();
    if (existing != null) {
      return false;
    }
    
    // Save to database
    await _collection.put(updatedSeason);
    
    // Reload state
    await loadSeasons();
    return true;
  }

  /// Delete a season by ID
  Future<bool> deleteSeason(String seasonId) async {
    // Delete from database
    final success = await _collection.delete(seasonId);
    
    // Reload state
    await loadSeasons();
    return success;
  }

  /// Get season by ID
  Season? getSeason(String seasonId) {
    return state.firstWhere(
      (s) => s.id == seasonId,
      orElse: () => null,
    );
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
      if (season.endYear <= now.year && (currentSeason == null || season.startYear > currentSeason.startYear)) {
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
    if (state.isEmpty) return null;
    return state.first; // Already sorted by startYear descending
  }


/// Seasons Provider
/// Watches the list of seasons
final seasonsProvider = StateNotifierProvider<SeasonNotifier, List<Season>>(
  (ref) {
    final collection = ref.watch(seasonCollectionProvider);
    final notifier = SeasonNotifier(collection);
    notifier.loadSeasons();
    return notifier;
  },
);

/// Selected Season Provider
/// Holds the currently selected season
final selectedSeasonProvider = StateProvider<Season?>(
  (ref) => null,
);

/// Season by ID Provider
/// Gets a specific season by ID
final seasonProvider = Provider.family<Season?, String>(
  (ref, seasonId) {
    final seasons = ref.watch(seasonsProvider);
    return seasons.firstWhere(
      (s) => s.id == seasonId,
      orElse: () => null,
    );
  },
);

/// Current Season Provider
/// Gets the current season based on today's date
final currentSeasonProvider = Provider<Season?>(
  (ref) {
    final seasons = ref.watch(seasonsProvider);
    final notifier = ref.read(seasonsProvider.notifier);
    return notifier.getCurrentSeason();
  },
);
