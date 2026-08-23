import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/colors.dart';
import '../models/child_profile.dart';
import '../providers/child_profile_provider.dart';
import 'create_profile_screen.dart';
import 'profile_screen.dart';

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
  Widget build(BuildContext context, WidgetRef ref) {
    final profiles = ref.watch(childProfilesProvider);
    
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text(
          'STATTRACK',
          style: TextStyle(
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
            tooltip: 'Created By Deerflow',
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
                  ? _buildEmptyState()
                  : _buildProfileGrid(profiles, context),
            ),
            // Footer with Deerflow mention
            _buildFooter(),
          ],
        ),
      ),
      floatingActionButton: _buildAddButton(context),
    );
  }

  /// Build empty state when no profiles exist
  Widget _buildEmptyState() {
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
            'No profiles yet',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white.withValues(alpha: 0.8),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap + to add your first player',
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
  Widget _buildProfileGrid(List<ChildProfile> profiles, BuildContext context) {
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
        itemBuilder: (context, index) {
          final profile = profiles[index];
          return ProfileCard(
            profile: profile,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfileScreen(profile: profile),
                ),
              );
            },
            onLongPress: () => _showDeleteDialog(context, profile),
          );
        },
      ),
    );
  }

  /// Build profile card
  Widget _buildProfileCard(ChildProfile profile, BuildContext context) {
    return ProfileCard(
      profile: profile,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(profile: profile),
          ),
        );
      },
      onLongPress: () => _showDeleteDialog(context, profile),
    );
  }

  /// Show delete confirmation dialog
  void _showDeleteDialog(BuildContext context, ChildProfile profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete Profile',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Are you sure you want to delete ${profile.nickname}? This action cannot be undone.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(childProfilesProvider.notifier).deleteProfile(profile.id);
              Navigator.pop(context);
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Build add profile floating action button
  Widget _buildAddButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CreateProfileScreen(),
          ),
        );
      },
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: const CircleBorder(),
      child: const Icon(Icons.add, size: 30),
    );
  }

  /// Build footer with Deerflow branding
  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      color: AppColors.surfaceDark,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Built with Flutter',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: Colors.white,
              opacity: 0.6,
            ),
          ),
          // Deerflow branding - subtle mention
          GestureDetector(
            onTap: () {
              // TODO: Open Deerflow link
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.flash_on,
                  size: 14,
                  color: AppColors.accent,
                ),
                SizedBox(width: 4),
                Text(
                  'Deerflow',
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontSize: 12,
                    color: Colors.white,
                    opacity: 0.6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Profile Card Widget
class ProfileCard extends StatelessWidget {
  final ChildProfile profile;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const ProfileCard({
    super.key,
    required this.profile,
    required this.onTap,
    required this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.surface,
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: AppColors.primary.withValues(alpha: 0.3),
          width: 1,
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
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.4),
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
              const Divider(
                color: Colors.white,
                opacity: 0.2,
                height: 1,
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatItem(Icons.emoji_events, '12', 'Matches'),
                  _buildStatItem(Icons.sports_soccer, '24', 'Goals'),
                  _buildStatItem(Icons.assistant, '10', 'Assists'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Build stat item for profile card
  Widget _buildStatItem(IconData icon, String value, String label) {
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
}
