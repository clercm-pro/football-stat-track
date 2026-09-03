import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:isar/isar.dart';
import 'package:football_stat_track/config/colors.dart';
import 'package:football_stat_track/l10n/app_localizations.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/models/match.dart';
import 'package:football_stat_track/providers/match_provider.dart';
import 'package:football_stat_track/providers/season_provider.dart';

/// Match Screen - Live match tracking with Scoreboard design (#3a)
/// 
/// Design: Scoreboard - Live Match
/// - Top row: arrow_back, LIVE badge, stop_circle
/// - Timer block: context line, timer display
/// - Two counter cards: Goals (primary) and Assists (white)
/// - Instruction line: "Short press = +1 • Long press = -1"
/// - Bottom row: Cancel and End match buttons
/// - Match summary: Bottom sheet (#3b)
class MatchScreen extends ConsumerStatefulWidget {

  const MatchScreen({required this.profile, super.key});
  final ChildProfile profile;

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();

  @override
  void debugFillProperties(final DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<ChildProfile>('profile', profile));
  }
}

class _MatchScreenState extends ConsumerState<MatchScreen>
    with TickerProviderStateMixin {
  int _goals = 0;
  int _assists = 0;
  late AnimationController _timerController;
  int _totalSeconds = 0;
  bool _isRunning = true;
  Id? _matchId;

  // For haptic feedback simulation (would use vibration package in production)
  final bool _enableHaptics = true;

  @override
  void initState() {
    super.initState();

    // Initialize timer animation
    _timerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _timerController.addListener(() {
      if (_isRunning) {
        _totalSeconds++;
        setState(() {});
      }
    });

    // Start the timer
    _timerController.repeat();
  }

  /// Initialize a new match
  Future<void> _initMatch(final WidgetRef ref) async {
    // Get current season
    final currentSeason = ref.read(currentSeasonProvider);
    if (currentSeason != null) {
      // Create new match in database
      final newMatch = await ref.read(matchesProvider.notifier).addMatch(
        Match.newMatch(
          childId: widget.profile.id,
          seasonId: currentSeason.id,
        ),
      );
      if (newMatch != null && mounted) {
        setState(() {
          _matchId = newMatch.id;
        });
      }
    }
  }

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  /// Format time as MM:SS with tabular figures
  String _formatTime() {
    final minutes = _totalSeconds ~/ 60;
    final seconds = _totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:'
        '${seconds.toString().padLeft(2, '0')}';
  }

  /// Increment goals counter
  Future<void> _incrementGoals() async {
    setState(() {
      _goals++;
    });
    _triggerHaptic();
    // Update in database if match exists
    if (_matchId != null) {
      await ref.read(matchesProvider.notifier).updateGoals(
        _matchId!,
        increment: true,
      );
    }
  }

  /// Decrement goals counter (long press)
  Future<void> _decrementGoals() async {
    if (_goals > 0) {
      setState(() {
        _goals--;
      });
      _triggerHaptic();
      // Update in database if match exists
      if (_matchId != null) {
        await ref.read(matchesProvider.notifier).updateGoals(
          _matchId!,
          increment: false,
        );
      }
    }
  }

  /// Increment assists counter
  Future<void> _incrementAssists() async {
    setState(() {
      _assists++;
    });
    _triggerHaptic();
    // Update in database if match exists
    if (_matchId != null) {
      await ref.read(matchesProvider.notifier).updateAssists(
        _matchId!,
        increment: true,
      );
    }
  }

  /// Decrement assists counter (long press)
  Future<void> _decrementAssists() async {
    if (_assists > 0) {
      setState(() {
        _assists--;
      });
      _triggerHaptic();

      // Update in database if match exists
      if (_matchId != null) {
        await ref.read(matchesProvider.notifier).updateAssists(
          _matchId!,
          increment: false,
        );
      }
    }
  }

  /// Simulate haptic feedback (would use vibration package)
  void _triggerHaptic() {
    if (_enableHaptics) {
      // In production: Vibration.vibrate(duration: 30);
    }
  }

  /// Stop the match and show summary bottom sheet
  Future<void> _stopMatch(final WidgetRef ref) async {
    _isRunning = false;
    _timerController.stop();

    if (mounted) {
      await _showMatchSummarySheet(context, ref);
    }
  }

  /// Show match summary bottom sheet (#3b)
  Future<void> _showMatchSummarySheet(
    final BuildContext context,
    final WidgetRef ref,
  ) async {
    final localization = AppLocalizations.of(context);
    final currentSeason = ref.read(currentSeasonProvider);
    
    // Calculate totals for confirmation message
    int totalGoals = _goals;
    int totalMatches = 0;
    if (_matchId != null) {
      final existingMatch = ref.read(matchesProvider.notifier).getMatch(_matchId!);
      if (existingMatch != null) {
        // Get all matches for this profile and season
        final profileMatches = ref
            .read(matchesProvider.notifier)
            .getMatchesForProfileAndSeason(
              widget.profile.id,
              existingMatch.seasonId,
            );
        final stats = MatchStats.fromMatches(profileMatches);
        totalGoals = stats.totalGoals + _goals;
        totalMatches = stats.totalMatches + 1;
      }
    }
    
    final confirmationMessage =
        '${localization.savedToSeason} ${currentSeason?.name ?? ''}. '
        '${widget.profile.nickname} ${localization.willBeAt} $totalGoals '
        '${localization.goalsIn} $totalMatches ${localization.matchesPeriod}';

    await showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (final context) {
        return _buildMatchSummarySheet(
          context,
          localization,
          confirmationMessage,
          currentSeason?.name,
          ref,
        );
      },
    );
  }

  /// Build match summary bottom sheet
  Widget _buildMatchSummarySheet(
    final BuildContext context,
    final AppLocalizations localization,
    final String confirmationMessage,
    final String? seasonName,
    final WidgetRef ref,
  ) {
    // Duration in MM:SS format
    final durationText = _formatTime();
    
    return Container(
      margin: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(52, 59, 70, 0.3),
            blurRadius: 30,
            offset: Offset(0, -6),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 28),
          
          // Eyebrow: "MATCH COMPLETED" 11px/700, letter-spacing 2px, #008A78
          Text(
            localization.matchCompleted,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 2,
              height: 1.0,
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Title: "Leo · 23 Aug" 30px/800, letter-spacing -0.8px, #343B46
          Text(
            '${widget.profile.nickname} · ${_formatDate(DateTime.now())}',
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 30,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.8,
              height: 1.0,
            ),
          ),
          
          const SizedBox(height: 20),
          
          // Three stat tiles
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Duration tile (white, value #343B46)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Value: 36px/800, #343B46
                    Text(
                      durationText,
                      style: const TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Label: 11px/600, letter-spacing 1px, rgba(52,59,70,.5)
                    Text(
                      localization.matchDuration,
                      style: const TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink60,
                        letterSpacing: 1,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 10),
              
              // Goals tile (#008A78, value white)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Value: 36px/800, white
                    Text(
                      _goals.toString(),
                      style: const TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Label: 11px/600, letter-spacing 1px, rgba(243,244,243,.7)
                    Text(
                      localization.goals,
                      style: const TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color.fromRGBO(243, 244, 243, 0.7),
                        letterSpacing: 1,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(width: 10),
              
              // Assists tile (white, value #343B46)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Value: 36px/800, #343B46
                    Text(
                      _assists.toString(),
                      style: const TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        height: 1.0,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Label: 11px/600, letter-spacing 1px, rgba(52,59,70,.5)
                    Text(
                      localization.assists,
                      style: const TextStyle(
                        fontFamily: 'Archivo',
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink60,
                        letterSpacing: 1,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 18),
          
          // Confirmation line: 13px, rgba(52,59,70,.5)
          Text(
            confirmationMessage,
            style: const TextStyle(
              fontFamily: 'Archivo',
              fontSize: 13,
              fontWeight: FontWeight.w400,
              color: AppColors.ink60,
              height: 1.0,
            ),
            textAlign: TextAlign.center,
          ),
          
          const SizedBox(height: 20),
          
          // Save match button: height 56, radius 16, #01584A
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () async {
                // Save match with final stats
                if (_matchId != null) {
                  await ref
                      .read(matchesProvider.notifier)
                      .endMatchWithStats(
                        _matchId!,
                        _goals,
                        _assists,
                      );
                }
                if (!context.mounted) {
                  return;
                }
                Navigator.pop(context);
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.check,
                size: 22,
                color: Colors.white,
              ),
              label: Text(
                localization.saveMatch,
                style: const TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.0,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryDark,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
                minimumSize: const Size.fromHeight(56),
              ),
            ),
          ),
          
          const SizedBox(height: 8),
          
          // Resume timer button: text button, height 52, 15px/600, #008A78
          SizedBox(
            height: 52,
            child: TextButton(
              onPressed: () {
                // Resume timer
                _isRunning = true;
                _timerController.repeat();
                Navigator.pop(context);
              },
              child: Text(
                localization.resumeTimer,
                style: const TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                  height: 1.0,
                ),
              ),
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                minimumSize: const Size.fromHeight(52),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Format date as "23 Aug"
  String _formatDate(final DateTime date) {
    final day = date.day;
    final month = date.month;

    const monthNames = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];

    return '$day ${monthNames[month - 1]}';
  }

  @override
  Widget build(final BuildContext context) {
    final localization = AppLocalizations.of(context);

    // Check if there's a current season
    final currentSeason = ref.watch(currentSeasonProvider);

    // If no season selected, show error
    if (currentSeason == null && _matchId == null) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localization.selectSeasonFirst,
              style: const TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColors.error,
            behavior: SnackBarBehavior.floating,
          ),
        );
        // Go back after showing error
        WidgetsBinding.instance.addPostFrameCallback((final _) {
          if (mounted) {
            Navigator.pop(context);
          }
        });
      });
      return const Scaffold(
        backgroundColor: AppColors.background,
      );
    }

    // Initialize match on first build
    if (_matchId == null) {
      WidgetsBinding.instance.addPostFrameCallback((final _) {
        _initMatch(ref);
      });
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            // Top row: arrow_back, LIVE badge, stop_circle
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 4, 18, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // arrow_back 24px #343B46
                  IconButton(
                    icon: const Icon(Icons.arrow_back, size: 24),
                    onPressed: () {
                      _timerController.stop();
                      Navigator.pop(context);
                    },
                    color: AppColors.ink,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                  
                  // LIVE badge: 8px dot #008A78 + "LIVE" 11px/700 letter-spacing 1.5px #008A78
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        localization.live,
                        style: const TextStyle(
                          fontFamily: 'Archivo',
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 1.5,
                          height: 1.0,
                        ),
                      ),
                    ],
                  ),
                  
                  // stop_circle 22px rgba(52,59,70,.35)
                  IconButton(
                    icon: const Icon(Icons.stop_circle, size: 22),
                    onPressed: () => _stopMatch(ref),
                    color: AppColors.ink30,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 40, minHeight: 40),
                  ),
                ],
              ),
            ),
            
            // Timer block
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 22, 24, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Context line: "Leo · 2026/2027" 13px/600 rgba(52,59,70,.5)
                  Text(
                    '${widget.profile.nickname} · ${currentSeason?.name ?? ''}',
                    style: const TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink60,
                      height: 1.0,
                    ),
                  ),
                  
                  // Timer: 76px/800 letter-spacing -3px tabular #343B46
                  Text(
                    _formatTime(),
                    style: const TextStyle(
                      fontFamily: 'Archivo',
                      fontSize: 76,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -3,
                      height: 1.0,
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 22),
            
            // Two counter cards fill remaining height
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Goals counter card
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 6),
                        child: _buildCounterCard(
                          label: localization.goals,
                          hint: localization.tapToAdd,
                          value: _goals,
                          backgroundColor: AppColors.primary,
                          textColor: Colors.white,
                          shadowColor: const Color.fromRGBO(1, 88, 74, 0.25),
                          onTap: _incrementGoals,
                          onLongPress: _decrementGoals,
                        ),
                      ),
                    ),
                    
                    // Assists counter card
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: _buildCounterCard(
                          label: localization.assists,
                          hint: localization.tapToAdd,
                          value: _assists,
                          backgroundColor: AppColors.surface,
                          textColor: AppColors.ink,
                          shadowColor: const Color.fromRGBO(52, 59, 70, 0.07),
                          borderColor: AppColors.hairlineLight,
                          onTap: _incrementAssists,
                          onLongPress: _decrementAssists,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Instruction line
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 6),
              child: Text(
                localization.counterInstructions,
                style: const TextStyle(
                  fontFamily: 'Archivo',
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink60,
                  height: 1.0,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            
            // Bottom row
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Cancel button: 110×56, radius 16, 1.5px border rgba(52,59,70,.15)
                  SizedBox(
                    width: 110,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () async {
                        _timerController.stop();
                        // Delete the match if it was created
                        if (_matchId != null) {
                          await ref
                              .read(matchesProvider.notifier)
                              .deleteMatch(_matchId!);
                        }
                        if (!mounted) {
                          return;
                        }
                        Navigator.pop(context);
                      },
                      child: Text(
                        localization.cancel,
                        style: const TextStyle(
                          fontFamily: 'Archivo',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink60,
                          height: 1.0,
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.ink60,
                        backgroundColor: AppColors.surface,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        side: const BorderSide(
                          color: AppColors.hairlineLight,
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  
                  // End match button: flex, height 56, radius 16, #01584A
                  Expanded(
                    child: SizedBox(
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () => _stopMatch(ref),
                        icon: const Icon(
                          Icons.check,
                          size: 22,
                          color: Colors.white,
                        ),
                        label: Text(
                          localization.endMatch,
                          style: const TextStyle(
                            fontFamily: 'Archivo',
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            height: 1.0,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryDark,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                          minimumSize: const Size.fromHeight(56),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build counter card
  Widget _buildCounterCard({
    required final String label,
    required final String hint,
    required final int value,
    required final Color backgroundColor,
    required final Color textColor,
    required final Color shadowColor,
    final Color? borderColor,
    required final VoidCallback onTap,
    required final VoidCallback onLongPress,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(22),
          border: borderColor != null
              ? Border.all(color: borderColor, width: 1.5)
              : null,
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: borderColor != null ? 3.0 : 6.0,
              offset: Offset(0, borderColor != null ? 1.0 : 2.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 22),
            
            // Label: 12px/700 letter-spacing 1.5px
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: backgroundColor == AppColors.primary
                    ? const Color.fromRGBO(243, 244, 243, 0.7)
                    : AppColors.ink60,
                letterSpacing: 1.5,
                height: 1.0,
              ),
            ),
            
            // Hint: 15px
            Text(
              hint,
              style: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: backgroundColor == AppColors.primary
                    ? const Color.fromRGBO(243, 244, 243, 0.6)
                    : AppColors.ink60,
                height: 1.0,
              ),
            ),
            
            const Spacer(),
            
            // Value: 92px/800 line-height 0.85 tabular
            Text(
              value.toString(),
              style: TextStyle(
                fontFamily: 'Archivo',
                fontSize: 92,
                fontWeight: FontWeight.w800,
                color: textColor,
                height: 0.85,
              ),
              textAlign: TextAlign.right,
            ),
            
            const SizedBox(height: 22),
          ],
        ),
      ),
    );
  }
}