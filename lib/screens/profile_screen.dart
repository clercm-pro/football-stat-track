import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/l10n/app_localizations.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/models/match.dart';
import 'package:football_stat_track/models/season.dart';
import 'package:football_stat_track/providers/season_provider.dart';
import 'package:football_stat_track/providers/match_provider.dart';
import 'package:football_stat_track/screens/match_screen.dart';

/// Profile Screen - Displays season stats for one player, match log, start a match button
/// 
/// Design: Scoreboard (#2b - PROFILE-01)
/// - Hero block: background #01584A with profile info and season totals
/// - Match log section with season selector
/// - Match history list
/// - Start a match CTA button
class ProfileScreen extends ConsumerWidget {

  const ProfileScreen({required this.profile, super.key});
  final ChildProfile profile;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final seasons = ref.watch(seasonsProvider);
    final selectedSeason = ref.watch(selectedSeasonProvider);

    
    // Get selected season or most recent season
    final effectiveSeason = selectedSeason ?? 
        (seasons.isNotEmpty ? seasons.first : null);
    
    // Calculate stats for this profile and season
    final stats = effectiveSeason != null 
        ? ref.read(matchesProvider.notifier).getStatsForProfileAndSeason(
            profile.id, effectiveSeason.id)
        : MatchStats.empty();
    
    // Get matches for this profile and season
    final profileMatches = effectiveSeason != null
        ? ref.read(matchesProvider.notifier).getMatchesForProfileAndSeason(
            profile.id, effectiveSeason.id)
        : [];
    
    // Calculate age if birth year is available
    final age = profile.birthYear != null
        ? DateTime.now().year - profile.birthYear!
        : null;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: [
            // Hero block with profile info and season totals
            SliverToBoxAdapter(
              child: _buildHeroBlock(
                context, 
                profile, 
                effectiveSeason,
                stats,
                age,
              ),
            ),
            
            // Match log section header
            SliverToBoxAdapter(
              child: _buildMatchLogHeader(
                context, 
                seasons, 
                effectiveSeason,
                ref,
              ),
            ),
            
            // Match log list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (final context, final index) => _buildMatchLogItem(
                  context,
                  profileMatches[index],
                ),
                childCount: profileMatches.length,
              ),
            ),
            
            // Start match button
            SliverToBoxAdapter(
              child: _buildStartMatchButton(context, ref),
            ),
            
            // 30px bottom inset
            const SliverToBoxAdapter(
              child: SizedBox(height: 30),
            ),
          ],
        ),
      ),
    );
  }

  /// Build hero block with profile info and season totals
  Widget _buildHeroBlock(
    final BuildContext context,
    final ChildProfile profile,
    final Season? season,
    final MatchStats stats,
    final int? age,
  ) {
    // Build sub-line: firstName + lastName + age
    final subLineParts = <String>[];
    if (profile.firstName != null) {
      subLineParts.add(profile.firstName!);
    }
    if (profile.lastName != null) {
      subLineParts.add(profile.lastName!);
    }
    if (age != null) {
      subLineParts.add('$age years old');
    }
    
    final subLine = subLineParts.isNotEmpty 
        ? subLineParts.join(' · ')
        : null;

    return Container(
      color: AppColors.primaryDark,
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top row with back and home buttons
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
            child: Row(
              children: [
                // Back button
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 24),
                  onPressed: () => Navigator.pop(context),
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
                const Spacer(),
                // Home button
                IconButton(
                  icon: const Icon(Icons.home, size: 24),
                  onPressed: () => Navigator.popUntil(
                    context,
                    (final route) => route.isFirst,
                  ),
                  color: Colors.white,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 10),
          
          // Profile info
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Season eyebrow: "2026/2027" 11px/700, letter-spacing 2px, #2CADA3
                if (season != null) ...[
                  Text(
                    season.name,
                    style: const TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.accent,
                      letterSpacing: 2,
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),
                ],
                
                // Profile name: 40px/800, letter-spacing -1.2px, white
                Text(
                  profile.nickname,
                  style: const TextStyle(
                    fontFamily: 'Archivo',
                    fontSize: 40,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: -1.2,
                    height: 1.0,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                
                // Sub-line: firstName lastName · age, 13px, rgba(243,244,243,.6)
                if (subLine != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subLine,
                    style: const TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                      color: Color.fromRGBO(243, 244, 243, 0.6),
                      height: 1.0,
                    ),
                  ),
                ],
              ],
            ),
          ),
          
          const SizedBox(height: 22),
          
          // Season totals: GOALS, ASSISTS, MATCHES
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildSeasonTotal(
                  context,
                  stats.totalGoals,
                  AppLocalizations.of(context).goalsLabel,
                ),
                _buildSeasonTotal(
                  context,
                  stats.totalAssists,
                  AppLocalizations.of(context).assistsLabel,
                ),
                _buildSeasonTotal(
                  context,
                  stats.totalMatches,
                  AppLocalizations.of(context).matchesLabel,
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  /// Build season total column
  Widget _buildSeasonTotal(
    final BuildContext context,
    final int value,
    final String label,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Value: 38px/800, tabular, white
        Text(
          value.toString(),
          style: const TextStyle(
            fontFamily: 'Archivo',
            fontSize: 38,
            fontWeight: FontWeight.w800,
            color: Colors.white,
            height: 0.9,
          ),
        ),
        const SizedBox(height: 4),
        // Label: 11px/600, letter-spacing 1px, rgba(243,244,243,.55)
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'Archivo',
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: Color.fromRGBO(243, 244, 243, 0.55),
            letterSpacing: 1,
            height: 1.0,
          ),
        ),
      ],
    );
  }

  /// Build match log header with season selector
  Widget _buildMatchLogHeader(
    final BuildContext context,
    final List<Season> seasons,
    final Season? selectedSeason,
    final WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 18, 24, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // "Match log" 16px/700, #343B46
          Text(
            AppLocalizations.of(context).matchLog,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
              height: 1.0,
            ),
          ),
          
          // Season selector: season name + expand_more icon
          if (seasons.isNotEmpty) ...[
            GestureDetector(
              onTap: () => _showSeasonSelector(context, seasons, selectedSeason, ref),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Season name: 12px/600, #008A78
                    Text(
                      selectedSeason?.name ?? seasons.first.name,
                      style: const TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(width: 4),
                    // expand_more icon: 18px, #008A78
                    const Icon(
                      Icons.expand_more,
                      size: 18,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Show season selector
  Future<void> _showSeasonSelector(
    final BuildContext context,
    final List<Season> seasons,
    final Season? selectedSeason,
    final WidgetRef ref,
  ) async {
    if (seasons.isEmpty) return;
    
    final effectiveSelected = selectedSeason ?? seasons.first;
    
    showModalBottomSheet<Season>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      builder: (final context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: seasons.map((final season) {
                return ListTile(
                  title: Text(
                    season.name,
                    style: const TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: AppColors.ink,
                    ),
                  ),
                  selected: season.id == effectiveSelected.id,
                  selectedTileColor: AppColors.primaryLight,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () => Navigator.pop(context, season),
                );
              }).toList(),
            ),
          ),
        );
      },
    ).then((final selected) {
      if (selected != null) {
        ref.read(selectedSeasonProvider.notifier).state = selected;
      }
    });
  }

  /// Build match log item
  Widget _buildMatchLogItem(
    final BuildContext context,
    final Match match,
  ) {
    // Format date: "23 Aug"
    final date = _formatDate(match.startTime);
    
    // Format duration: "90 min" or use actual duration
    final duration = match.durationInMinutes ?? 0;
    final durationText = '$duration min';
    
    // Color for goal value: #008A78 if > 0, rgba(52,59,70,.3) if 0
    final goalsColor = match.goals > 0 
        ? AppColors.primary 
        : AppColors.ink30;
    
    // Color for assist value: #343B46 if > 0, rgba(52,59,70,.3) if 0
    final assistsColor = match.assists > 0 
        ? AppColors.ink 
        : AppColors.ink30;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(52, 59, 70, 0.06),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left: match info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Date and duration: "23 Aug · 90 min" 12px, rgba(52,59,70,.5)
                    Text(
                      '$date · $durationText',
                      style: const TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.ink60,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Right: goals and assists
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Goals: value + "G" unit
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Goals value: 22px/800, tabular
                      Text(
                        match.goals.toString(),
                        style: TextStyle(
                          fontFamily: 'Archivo',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: goalsColor,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 2),
                      // "G" unit: 10px, letter-spacing 0.5px, rgba(52,59,70,.45)
                      Text(
                        'G',
                        style: const TextStyle(
                          fontFamily: 'Archivo',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(52, 59, 70, 0.45),
                          letterSpacing: 0.5,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(width: 12),
                  
                  // Assists: value + "A" unit
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Assists value: 22px/800, tabular
                      Text(
                        match.assists.toString(),
                        style: TextStyle(
                          fontFamily: 'Archivo',
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: assistsColor,
                          height: 1.0,
                        ),
                      ),
                      const SizedBox(width: 2),
                      // "A" unit: 10px, letter-spacing 0.5px, rgba(52,59,70,.45)
                      Text(
                        'A',
                        style: const TextStyle(
                          fontFamily: 'Archivo',
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: Color.fromRGBO(52, 59, 70, 0.45),
                          letterSpacing: 0.5,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Format date as "23 Aug" or similar
  String _formatDate(final DateTime date) {
    final day = date.day;
    final month = date.month;
    
    // Short month names
    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '$day ${monthNames[month - 1]}';
  }

  /// Build start match button
  Widget _buildStartMatchButton(
    final BuildContext context,
    final WidgetRef ref,
  ) {
    final localization = AppLocalizations.of(context);
    
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: SizedBox(
        height: 56,
        child: ElevatedButton.icon(
          onPressed: () {
            final hasMatchInProgress = ref
                .read(matchesProvider.notifier)
                .hasMatchInProgress(profile.id);
            
            if (hasMatchInProgress) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(localization.matchInProgressError),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                ),
              );
              return;
            }
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (final context) => MatchScreen(profile: profile),
              ),
            );
          },
          icon: const Icon(
            Icons.play_arrow,
            size: 22,
            color: Colors.white,
          ),
          label: Text(
            AppLocalizations.of(context).startMatchButton,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              height: 1.0,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 0,
            shadowColor: const Color.fromRGBO(1, 88, 74, 0.25),
            textStyle: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
            minimumSize: const Size.fromHeight(56),
          ),
        ),
      ),
    );
  }
}
