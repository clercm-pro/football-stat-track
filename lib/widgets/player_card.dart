import 'package:flutter/material.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/widgets/sparkline.dart';

/// PlayerCard widget for Home Screen (Scoreboard design #2b)
/// 
/// Displays player information in a card with:
/// - Color bar (8px × 36px) in avatar color
/// - Player name (19px/700)
/// - Season info (12px, rgba(52,59,70,.5))
/// - Stats row: Goals (44px/800, #008A78) + Assists (44px/800, #343B46)
/// - Sparkline: 6 bars for last matches' goals
/// - Chevron right icon (20px, rgba(52,59,70,.3))
class PlayerCard extends StatelessWidget {
  final ChildProfile profile;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  
  /// Number of matches for this player (in current season)
  final int matchCount;
  
  /// Number of goals for this player (in current season)
  final int goals;
  
  /// Number of assists for this player (in current season)
  final int assists;
  
  /// List of goals for last 6 matches (for sparkline)
  final List<int> lastSixMatchesGoals;
  
  /// Season label (e.g., "2026/2027")
  final String seasonLabel;

  const PlayerCard({
    required this.profile,
    required this.onTap,
    required this.onLongPress,
    this.matchCount = 0,
    this.goals = 0,
    this.assists = 0,
    this.lastSixMatchesGoals = const [],
    this.seasonLabel = '',
    super.key,
  });

  /// Get avatar index from profile
  /// Uses a simple hash of the profile ID to ensure consistent color
  int _getAvatarIndex(final ChildProfile profile) {
    // Simple hash function to get a consistent index from the profile ID
    // This ensures the same profile always gets the same color
    final hash = profile.id.hashCode;
    return hash % 4;
  }

  @override
  Widget build(final BuildContext context) {
    // Get avatar color based on profile index
    // For now, we use a simple hash of the profile ID to determine index
    // In a real implementation, this would be stored in the profile
    final avatarIndex = _getAvatarIndex(profile);
    final avatarColor = AppColors.avatarColor(avatarIndex);
    
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [AppColors.shadowPlayerCard],
        ),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top row: Color bar + Name + Season + Chevron
              Row(
                children: [
                  // Color bar: 8px × 36px, radius 4, avatar color
                  Container(
                    width: 8,
                    height: 36,
                    decoration: BoxDecoration(
                      color: avatarColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  const SizedBox(width: 12),
                  
                  // Name and season info
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Player name: 19px/700, #343B46
                        Text(
                          profile.nickname,
                          style: const TextStyle(
                            fontFamily: 'Archivo',
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            height: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        
                        // Season info: 12px, rgba(52,59,70,.5)
                        if (seasonLabel.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            '$matchCount matches · $seasonLabel',
                            style: const TextStyle(
                              fontFamily: 'Archivo',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: AppColors.ink60,
                              height: 1.0,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ],
                    ),
                  ),
                  
                  // Chevron right icon: 20px, rgba(52,59,70,.3)
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.ink30,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Stats row: Goals + Assists + Sparkline
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  // Goals: 44px/800, #008A78, tabular figures
                  Text(
                    goals.toString(),
                    style: TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      height: 0.9,
                      fontFeatures: AppColors.tabularFigures,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Goals label: 11px/600, letter-spacing 1px, rgba(52,59,70,.5)
                  const Text(
                    'GOALS',
                    style: TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink60,
                      letterSpacing: 1,
                      height: 1.0,
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Assists: 44px/800, #343B46, tabular figures
                  Text(
                    assists.toString(),
                    style: TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      height: 0.9,
                      fontFeatures: AppColors.tabularFigures,
                    ),
                  ),
                  const SizedBox(width: 8),
                  
                  // Assists label: 11px/600, letter-spacing 1px, rgba(52,59,70,.5)
                  const Text(
                    'ASSISTS',
                    style: TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink60,
                      letterSpacing: 1,
                      height: 1.0,
                    ),
                  ),
                  
                  const SizedBox(width: 20),
                  
                  // Sparkline: fills remaining width, height 44
                  Expanded(
                    child: Sparkline(
                      goals: lastSixMatchesGoals,
                      height: 44,
                      gap: 3,
                      barRadius: 2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  
}
