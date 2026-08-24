import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/models/season.dart';
import 'package:football_stat_track/providers/season_provider.dart';
import 'package:football_stat_track/providers/match_provider.dart';
import 'package:football_stat_track/screens/match_screen.dart';

/// Profile Screen - Displays details and stats for a specific profile
/// 
/// Design: Premium Sports Tech
/// - Hero section with profile avatar and name
/// - Season selector
/// - Statistics display
/// - Start match CTA
/// - Match history
class ProfileScreen extends ConsumerWidget {

  const ProfileScreen({required this.profile, super.key});
  final ChildProfile profile;

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final seasons = ref.watch(seasonsProvider);
    ref.watch(selectedSeasonProvider);
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
          color: Colors.white,
        ),
        title: Text(
          profile.nickname,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
        actions: [
          // Home button
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Navigator.popUntil(
              context,
              (final route) => route.isFirst,
            ),
            color: Colors.white,
            tooltip: 'Home',
          ),
        ],
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Hero section with profile info
            SliverToBoxAdapter(
              child: _buildProfileHero(context),
            ),
            // Season selector
            SliverToBoxAdapter(
              child: _buildSeasonSelector(seasons, ref),
            ),
            // Stats display
            SliverToBoxAdapter(
              child: _buildStatsDisplay(),
            ),
            // Start match button
            SliverToBoxAdapter(
              child: _buildStartMatchButton(context, ref),
            ),
            // Match history header
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Text(
                  'Recent Matches',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            // Match history list
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (final context, final index) => _buildMatchHistoryItem(),
                childCount: 5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build profile hero section
  Widget _buildProfileHero(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.primary.withValues(alpha: 0.3),
            AppColors.surface,
          ],
        ),
      ),
      child: Column(
        children: [
          // Avatar with glow effect
          Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.accent, AppColors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  profile.nickname.isNotEmpty
                      ? profile.nickname[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Profile name
          Text(
            profile.nickname,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
          // Profile details
          if (profile.firstName != null || profile.lastName != null) ...[
            Text(
              '${profile.firstName ?? ''} ${profile.lastName ?? ''}'.trim(),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                color: Colors.white.withValues(alpha: 0.7),
              ),
            ),
          ],
          if (profile.birthYear != null) ...[
            Text(
              '${DateTime.now().year - profile.birthYear!} years old',
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                color: AppColors.accent,
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Build season selector
  Widget _buildSeasonSelector(
    final List<Season> seasons,
    final WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: DropdownButton<Season>(
        value: seasons.isNotEmpty ? seasons.first : null,
        onChanged: (final newValue) {
          if (newValue != null) {
            ref.read(selectedSeasonProvider.notifier).state = newValue;
          }
        },
        items: seasons
            .map<DropdownMenuItem<Season>>(
              (final season) => DropdownMenuItem<Season>(
                value: season,
                child: Text(
                  season.name,
                  style: const TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            )
            .toList(),
        underline: Container(),
        isExpanded: true,
        dropdownColor: AppColors.surface,
        style: const TextStyle(
          fontFamily: 'Roboto',
          color: Colors.white,
        ),
        icon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.accent,
          size: 24,
        ),
        hint: Text(
          'Select Season',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ),
    );
  }

  /// Build stats display
  Widget _buildStatsDisplay() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildMainStat(Icons.emoji_events, '12', 'Matches'),
          _buildStatDivider(),
          _buildMainStat(Icons.sports_soccer, '24', 'Goals'),
          _buildStatDivider(),
          _buildMainStat(Icons.assistant, '10', 'Assists'),
        ],
      ),
    );
  }

  /// Build main stat item
  Widget _buildMainStat(
    final IconData icon,
    final String value,
    final String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: AppColors.accent,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 12,
            color: Colors.white.withValues(alpha: 0.6),
          ),
        ),
      ],
    );
  }

  /// Build stat divider
  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 48,
      color: Colors.white.withValues(alpha: 0.2),
    );
  }

  /// Build start match button
  Widget _buildStartMatchButton(
    final BuildContext context,
    final WidgetRef ref,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ElevatedButton.icon(
        onPressed: () {
          final hasMatchInProgress = ref
              .read(matchesProvider.notifier)
              .hasMatchInProgress(profile.id);
          if (hasMatchInProgress) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(
                  'A match is already in progress for this profile',
                ),
                backgroundColor: AppColors.error,
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
          size: 24,
          color: Colors.white,
        ),
        label: const Text(
          'START A MATCH',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 4,
          shadowColor: AppColors.primary.withValues(alpha: 0.5),
          minimumSize: const Size.fromHeight(56),
        ),
      ),
    );
  }

  /// Build match history item
  Widget _buildMatchHistoryItem() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.1),
        ),
      ),
      child: Row(
        children: [
          // Date
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Aug 23',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Match details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Friendly Match',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '90 min • Victory',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
            ),
          ),
          // Stats
          Row(
            children: [
              _buildMiniStat('3', 'Goals'),
              const SizedBox(width: 8),
              _buildMiniStat('1', 'Assists'),
            ],
          ),
        ],
      ),
    );
  }

  /// Build mini stat for match history
  Widget _buildMiniStat(final String value, final String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.accent,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 10,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ChildProfile>('profile', profile));
  }
}
