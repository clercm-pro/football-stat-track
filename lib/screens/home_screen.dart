import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/l10n/app_localizations.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/models/match.dart';
import 'package:football_stat_track/models/season.dart';
import 'package:football_stat_track/providers/child_profile_provider.dart';
import 'package:football_stat_track/providers/match_provider.dart';
import 'package:football_stat_track/providers/season_provider.dart';
import 'package:football_stat_track/screens/create_profile_screen.dart';
import 'package:football_stat_track/screens/create_season_screen.dart';
import 'package:football_stat_track/screens/profile_screen.dart';
import 'package:football_stat_track/widgets/player_card.dart';

/// Home Screen - Displays the list of child profiles (Scoreboard design #2b)
/// 
/// Design specifications:
/// - Background: #F3F4F3
/// - Safe area: Top inset, 30px bottom inset
/// - Header: Eyebrow "STATTRACK" + dynamic title
/// - Player list: Horizontal padding 16px, 10px gap
/// - Add section: Padding 16px 16px 30px, 10px gap
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final profiles = ref.watch(childProfilesProvider);
    final matches = ref.watch(matchesProvider);
    final currentSeason = ref.watch(currentSeasonProvider);
    
    // Calculate stats for each profile
    final profileStats = _calculateProfileStats(
      profiles, matches, currentSeason,
    );
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false, // We handle bottom padding manually
        child: Column(
          children: [
            // Header with eyebrow and dynamic title
            _buildHeader(context, profiles.length),
            
            const SizedBox(height: 8),
            
            // Player list
            Expanded(
              child: profiles.isEmpty
                  ? _buildEmptyState(context)
                  : _buildProfileList(profiles, profileStats, context, ref),
            ),
            
            // Add player and create season section
            _buildAddSection(context, profiles),
            
            // 30px bottom inset
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  /// Build header with eyebrow and dynamic title
  Widget _buildHeader(final BuildContext context, final int profileCount) {
    final localization = AppLocalizations.of(context);
    
    // Build dynamic title based on profile count
    final title = _buildDynamicTitle(profileCount, localization);
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Eyebrow: "STATTRACK" 11px/700, letter-spacing 2px, #008A78
          Text(
            'STATTRACK',
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 2,
              height: 1.0,
            ),
          ),
          
          // Title: Dynamic, 34px/800, letter-spacing -1px, #343B46
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 34,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -1,
              height: 1.05,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// Build dynamic title based on profile count
  String _buildDynamicTitle(final int profileCount, final AppLocalizations localization) {
    if (profileCount == 0) {
      return ''; // Empty state handles the title
    } else if (profileCount == 1) {
      return '1 player this season';
    } else {
      return '$profileCount players this season';
    }
  }

  /// Build empty state when no profiles exist
  Widget _buildEmptyState(final BuildContext context) {
    final localization = AppLocalizations.of(context);
    
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Empty state text: "No profiles yet" 20px/700, #343B46
          Text(
            localization.noProfiles,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 4),
          
          // Subtitle: "Tap + to add your first player" 14px, rgba(52,59,70,.5)
          Text(
            localization.addFirstPlayer,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.ink60,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Build profile list with new Scoreboard design
  Widget _buildProfileList(
    final List<ChildProfile> profiles,
    final Map<String, ProfileStats> profileStats,
    final BuildContext context,
    final WidgetRef ref,
  ) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      itemCount: profiles.length,
      itemBuilder: (final context, final index) {
        final profile = profiles[index];
        final stats = profileStats[profile.id.toString()] ?? ProfileStats.empty();
        
        return PlayerCard(
          profile: profile,
          matchCount: stats.matchCount,
          goals: stats.goals,
          assists: stats.assists,
          lastSixMatchesGoals: stats.lastSixMatchesGoals,
          seasonLabel: stats.seasonLabel,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (final context) => ProfileScreen(profile: profile),
              ),
            );
          },
          onLongPress: () => _showDeleteDialog(context, ref, profile),
        );
      },
    );
  }

  /// Build add section with "Add player" and calendar buttons
  Widget _buildAddSection(final BuildContext context, final List<ChildProfile> profiles) {
    final localization = AppLocalizations.of(context);
    final isProfileLimitReached = profiles.length >= ChildProfileNotifier.maxProfiles;
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Primary "Add player" button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: isProfileLimitReached 
                  ? null 
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (final context) => const CreateProfileScreen(),
                        ),
                      );
                    },
              icon: const Icon(Icons.person_add, size: 20),
              label: Text(
                localization.addProfileTooltip,
                style: const TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 0,
              ),
            ),
          ),
          
          const SizedBox(width: 10),
          
          // Secondary calendar button (square 52x52)
          Tooltip(
            message: isProfileLimitReached 
                ? localization.profileLimitReachedMessage
                : localization.addNewSeason,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.hairlineLight,
                  width: 1.5,
                ),
              ),
              child: IconButton(
                onPressed: isProfileLimitReached 
                    ? null 
                    : () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (final context) => const CreateSeasonScreen(),
                          ),
                        );
                      },
                icon: const Icon(Icons.calendar_today, size: 22),
                color: AppColors.ink,
                disabledColor: AppColors.ink30,
                style: IconButton.styleFrom(
                  padding: EdgeInsets.zero,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteDialog(
    final BuildContext context,
    final WidgetRef ref,
    final ChildProfile profile,
  ) {
    final localization = AppLocalizations.of(context);
    
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        title: Text(
          localization.deleteProfileTitle,
          style: const TextStyle(
            fontFamily: 'Archivo',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.ink,
          ),
        ),
        content: Text(
          '${localization.deleteProfileConfirmation} ${profile.nickname}? ${localization.actionCannotBeUndone}',
          style: const TextStyle(
            fontFamily: 'Archivo',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: AppColors.ink60,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              localization.cancel,
              style: const TextStyle(
                fontFamily: 'Archivo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.ink60,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              final dialogContext = context;
              await ref
                  .read(childProfilesProvider.notifier)
                  .deleteProfile(profile.id);
              if (!dialogContext.mounted) {
                return;
              }
              Navigator.pop(dialogContext);
            },
            child: Text(
              localization.delete,
              style: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Calculate stats for each profile
  Map<String, ProfileStats> _calculateProfileStats(
    final List<ChildProfile> profiles,
    final List<Match> matches,
    final Season? currentSeason,
  ) {
    final statsMap = <String, ProfileStats>{};
    
    for (final profile in profiles) {
      // Get all matches for this profile
      final profileMatches = matches.where((match) => match.childId == profile.id).toList();
      
      // Get current season matches if season is available
      final currentSeasonId = currentSeason?.id;
      final currentSeasonMatches = currentSeasonId != null
          ? profileMatches.where((match) => match.seasonId == currentSeasonId).toList()
          : profileMatches;
      
      // Calculate stats
      final matchCount = currentSeasonMatches.length;
      final goals = currentSeasonMatches.fold<int>(
        0, (final int sum, final Match match) => sum + match.goals,
      );
      final assists = currentSeasonMatches.fold<int>(
        0, (final int sum, final Match match) => sum + match.assists,
      );
      
      // Get goals for last 6 matches (for sparkline)
      final completedMatches = currentSeasonMatches
          .where((final Match match) => match.endTime != null)
          .toList();
      
      completedMatches.sort(
        (final Match a, final Match b) => b.endTime!.compareTo(a.endTime!),
      );
      final lastSixMatches = completedMatches.take(6).toList();
      
      final lastSixMatchesGoals = lastSixMatches.map((match) => match.goals).toList();
      
      // Get season label
      final seasonLabel = currentSeason?.name ?? 'Unknown';
      
      statsMap[profile.id.toString()] = ProfileStats(
        matchCount: matchCount,
        goals: goals,
        assists: assists,
        lastSixMatchesGoals: lastSixMatchesGoals,
        seasonLabel: seasonLabel,
      );
    }
    
    return statsMap;
  }
}

/// Profile statistics for home screen display
class ProfileStats {
  final int matchCount;
  final int goals;
  final int assists;
  final List<int> lastSixMatchesGoals;
  final String seasonLabel;

  const ProfileStats({
    required this.matchCount,
    required this.goals,
    required this.assists,
    required this.lastSixMatchesGoals,
    required this.seasonLabel,
  });

  factory ProfileStats.empty() {
    return const ProfileStats(
      matchCount: 0,
      goals: 0,
      assists: 0,
      lastSixMatchesGoals: [],
      seasonLabel: '',
    );
  }
}
