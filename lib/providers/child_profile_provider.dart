import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/providers/database_provider.dart';

/// Child Profile State Notifier
/// 
/// Manages the state for child profiles including:
/// - List of all profiles
/// - Adding new profiles
/// - Updating existing profiles
/// - Deleting profiles
/// - Maximum of 4 profiles per device (R-01)
class ChildProfileNotifier extends StateNotifier<List<ChildProfile>> {
  
  ChildProfileNotifier(this._collection) : super([]);
  final IsarCollection<ChildProfile> _collection;

  /// Maximum number of profiles allowed per device
  static const int maxProfiles = 4;

  /// Load profiles from database
  Future<void> loadProfiles() async {
    final profiles = await _collection.where().findAll();
    state = profiles;
  }

  /// Add a new profile
  /// Returns the added profile or null if limit reached
  Future<ChildProfile?> addProfile(final ChildProfile profile) async {
    // Check current count from DB
    final count = await _collection.count();
    if (count >= maxProfiles) {
      return null;
    }
    
    // Check if nickname already exists in DB
    final existing = await _collection
        .where()
        .filter()
        .nicknameEqualTo(profile.nickname)
        .findFirst();
    if (existing != null) {
      return null;
    }
    
    // Save to database
    await _collection.put(profile);
    
    // Reload state
    await loadProfiles();
    return profile;
  }

  /// Update an existing profile
  Future<bool> updateProfile(final ChildProfile updatedProfile) async {
    // Check if new nickname conflicts with another profile
    final existing = await _collection
        .where()
        .idNotEqualTo(updatedProfile.id)
        .filter()
        .nicknameEqualTo(updatedProfile.nickname)
        .findFirst();
    if (existing != null) {
      return false;
    }
    
    // Save to database
    await _collection.put(updatedProfile);
    
    // Reload state
    await loadProfiles();
    return true;
  }

  /// Delete a profile by ID
  /// Cannot delete the last profile (R-08)
  Future<bool> deleteProfile(final Id profileId) async {
    // Check current count
    final count = await _collection.count();
    if (count <= 1) {
      return false; // Cannot delete the last profile
    }
    
    // Delete from database
    final success = await _collection.delete(profileId);
    
    // Reload state
    await loadProfiles();
    return success;
  }

  /// Get profile by ID
  ChildProfile? getProfile(final Id profileId) {
    try {
      return state.firstWhere((p) => p.id == profileId);
    } catch (e) {
      return null;
    }
  }

  /// Check if profile limit reached
  bool get isLimitReached => state.length >= maxProfiles;

  /// Get profile count
  int get profileCount => state.length;
}

/// Child Profiles Provider
/// Watches the list of child profiles
final childProfilesProvider = StateNotifierProvider<ChildProfileNotifier, List<ChildProfile>>(
  (final ref) {
    final collection = ref.watch(childProfileCollectionProvider);
    final notifier = ChildProfileNotifier(collection);
    notifier.loadProfiles();
    return notifier;
  },
);

/// Selected Child Profile Provider
/// Holds the currently selected profile
final selectedChildProfileProvider = StateProvider<ChildProfile?>(
  (final ref) => null,
);

/// Child Profile by ID Provider
/// Gets a specific profile by ID
final childProfileProvider = Provider.family<ChildProfile?, Id>(
  (ref, Id profileId) {
    final profiles = ref.watch(childProfilesProvider);
    try {
      return profiles.firstWhere((p) => p.id == profileId);
    } catch (e) {
      return null;
    }
  },
);
