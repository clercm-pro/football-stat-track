import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/l10n/app_localizations.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/providers/child_profile_provider.dart';
import 'package:football_stat_track/screens/create_profile_screen.dart';
import 'package:football_stat_track/screens/create_season_screen.dart';
import 'package:football_stat_track/screens/profile_screen.dart';

/// Home Screen - Displays the list of child profiles
/// 
/// Design: Premium Sports Tech
/// - Dark theme with electric purple accents
/// - Card grid layout (2 columns)
/// - Floating add button
/// - Deerflow branding in footer
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(final BuildContext context, final WidgetRef ref) {
    final profiles = ref.watch(childProfilesProvider);
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(
          AppLocalizations.of(context).statTrackTitle,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
            letterSpacing: 1.5,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
        actions: [
          // Deerflow branding as subtle icon in AppBar
          IconButton(
            icon: const Icon(Icons.flash_on, size: 20),
            color: AppColors.accent,
            tooltip: AppLocalizations.of(context).createdByDeerflow,
            onPressed: () {
              // Open Deerflow link in browser
              // In production, use url_launcher package
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: profiles.isEmpty
                  ? _buildEmptyState(context)
                  : _buildProfileGrid(profiles, context, ref),
            ),
            // Footer with Deerflow mention
            _buildFooter(context),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(context, profiles),
    );
  }

  /// Build empty state when no profiles exist
  Widget _buildEmptyState(final BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Animated soccer ball icon
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.sports_soccer,
              size: 60,
              color: AppColors.accent,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppLocalizations.of(context).noProfiles,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).addFirstPlayer,
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
        ],
      ),
    );
  }

  /// Build profile grid (2 columns)
  Widget _buildProfileGrid(
    final List<ChildProfile> profiles,
    final BuildContext context,
    final WidgetRef ref,
  ) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.8,
        ),
        itemCount: profiles.length,
        itemBuilder: (final context, final index) {
          final profile = profiles[index];
          return ProfileCard(
            profile: profile,
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
      ),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteDialog(
    final BuildContext context,
    final WidgetRef ref,
    final ChildProfile profile,
  ) {
    showDialog(
      context: context,
      builder: (final context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(
          AppLocalizations.of(context).deleteProfileTitle,
          style: const TextStyle(color: Colors.white),
        ),
        content: Text(
          '${AppLocalizations.of(context).deleteProfileConfirmation} '
          '${profile.nickname}? '
          '${AppLocalizations.of(context).actionCannotBeUndone}',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context).cancel,
              style: const TextStyle(color: AppColors.secondary),
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
              AppLocalizations.of(context).delete,
              style: const TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Build add floating action button with menu
  Widget _buildAddButton(
    final BuildContext context,
    final List<ChildProfile> profiles,
  ) {
    final isProfileLimitReached =
        profiles.length >= ChildProfileNotifier.maxProfiles;
    return FloatingActionButton(
      onPressed: () => _showCreateMenu(context, isProfileLimitReached),
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      tooltip: AppLocalizations.of(context).addProfileTooltip,
      elevation: 6,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 30),
    );
  }

  /// Show menu to create profile or season
  void _showCreateMenu(
    final BuildContext context,
    final bool isProfileLimitReached,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      builder: (final context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Create Profile option
              ListTile(
                leading: const Icon(Icons.person_add, color: AppColors.accent),
                title: Text(
                  AppLocalizations.of(context).createProfileTitle,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  AppLocalizations.of(context).addNewPlayer,
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
                ),
                enabled: !isProfileLimitReached,
                onTap: isProfileLimitReached ? null : () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (final ctx) => const CreateProfileScreen(),
                    ),
                  );
                },
              ),
              // Create Season option
              ListTile(
                leading: const Icon(
                  Icons.calendar_today,
                  color: AppColors.accent,
                ),
                title: Text(
                  AppLocalizations.of(context).createSeasonTitle,
                  style: const TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  AppLocalizations.of(context).addNewSeason,
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (final ctx) => const CreateSeasonScreen(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build footer with Deerflow branding
  Widget _buildFooter(final BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: AppColors.surfaceDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Text(
              AppLocalizations.of(context).builtWithFlutter,
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.6),
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Deerflow branding - subtle mention
          Flexible(
            child: GestureDetector(
              onTap: () {
                // TODO(mickael): Open Deerflow link
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.flash_on,
                    size: 14,
                    color: AppColors.accent,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Deerflow',
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 12,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile Card Widget
class ProfileCard extends StatelessWidget {

  const ProfileCard({
    required this.profile,
    required this.onTap,
    required this.onLongPress,
    super.key,
  });
  final ChildProfile profile;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(final BuildContext context) {
    return Card(
      color: AppColors.surfaceLight,
      elevation: 8,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.5),
          width: 1.0,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(12),
        splashColor: AppColors.primary.withValues(alpha: 0.2),
        highlightColor: AppColors.primary.withValues(alpha: 0.1),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: Color(profile.avatarColor),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(profile.avatarColor).withValues(alpha: 0.4),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
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
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              // Nickname
              Text(
                profile.nickname,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              // Age if available
              if (profile.birthYear != null) ...[
                Text(
                  '${DateTime.now().year - profile.birthYear!} years old',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Colors.white.withValues(alpha: 0.6),
                  ),
                ),
              ],
              const SizedBox(height: 8),
              // Stats
              Divider(
                color: Colors.white.withValues(alpha: 0.2),
                height: 1,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(
                    Icons.emoji_events,
                    '0',
                    AppLocalizations.of(context).matchesLabel,
                  ),
                  _buildStatItem(
                    Icons.sports_soccer,
                    '0',
                    AppLocalizations.of(context).goalsLabel,
                  ),
                  _buildStatItem(
                    Icons.assistant,
                    '0',
                    AppLocalizations.of(context).assistsLabel,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build stat item for profile card
  Widget _buildStatItem(
    final IconData icon,
    final String value,
    final String label,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          size: 20,
          color: AppColors.accent,
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
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
    );
  }

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ChildProfile>('profile', profile));
    properties.add(ObjectFlagProperty<VoidCallback>.has('onTap', onTap));
    properties.add(
      ObjectFlagProperty<VoidCallback>.has('onLongPress', onLongPress),
    );
  }
}
