import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/colors.dart';

/// Match Screen - Live match tracking with goal/assist counters
/// 
/// Design: Premium Sports Tech
/// - Dark theme with accent timer
/// - Large tap targets for goal/assist
/// - Real-time counters
/// - Haptic feedback on press
/// - Stop/end match button
class MatchScreen extends ConsumerStatefulWidget {
  const MatchScreen({super.key});

  @override
  ConsumerState<MatchScreen> createState() => _MatchScreenState();
}

class _MatchScreenState extends ConsumerState<MatchScreen> with TickerProviderStateMixin {
  int _goals = 0;
  int _assists = 0;
  late AnimationController _timerController;
  late Animation<int> _secondsAnimation;
  late Animation<int> _minutesAnimation;
  int _totalSeconds = 0;
  bool _isRunning = true;
  
  // For haptic feedback simulation (would use vibration package in production)
  bool _enableHaptics = true;

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

  @override
  void dispose() {
    _timerController.dispose();
    super.dispose();
  }

  /// Format time as MM:SS
  String _formatTime() {
    final minutes = _totalSeconds ~/ 60;
    final seconds = _totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  /// Increment goals counter
  void _incrementGoals() {
    setState(() {
      _goals++;
    });
    _triggerHaptic();
  }

  /// Decrement goals counter (long press)
  void _decrementGoals() {
    if (_goals > 0) {
      setState(() {
        _goals--;
      });
      _triggerHaptic();
    }
  }

  /// Increment assists counter
  void _incrementAssists() {
    setState(() {
      _assists++;
    });
    _triggerHaptic();
  }

  /// Decrement assists counter (long press)
  void _decrementAssists() {
    if (_assists > 0) {
      setState(() {
        _assists--;
      });
      _triggerHaptic();
    }
  }

  /// Simulate haptic feedback (would use vibration package)
  void _triggerHaptic() {
    if (_enableHaptics) {
      // In production: Vibration.vibrate(duration: 30);
    }
  }

  /// Stop the match and show end dialog
  void _stopMatch() {
    _isRunning = false;
    _timerController.stop();
    
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Match Completed',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          height: 120,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                _formatTime(),
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDialogStat('Goals', _goals, AppColors.accent),
                  const SizedBox(width: 24),
                  _buildDialogStat('Assists', _assists, AppColors.secondary),
                ],
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Cancel and resume
              _isRunning = true;
              _timerController.repeat();
              Navigator.pop(context);
            },
            child: const Text(
              'RESUME',
              style: TextStyle(color: AppColors.secondary),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Save match and return
              Navigator.popUntil(context, (route) => route.isFirst);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text(
              'SAVE MATCH',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// Build stat for dialog
  Widget _buildDialogStat(String label, int value, Color color) {
    return Column(
      children: [
        Text(
          value.toString(),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _timerController.stop();
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: const Text(
          'MATCH IN PROGRESS',
          style: TextStyle(
            fontFamily: 'Roboto',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: AppColors.primary,
        elevation: 4,
        actions: [
          // Stop button
          IconButton(
            icon: const Icon(Icons.stop, size: 28),
            onPressed: _stopMatch,
            color: Colors.white,
            tooltip: 'End Match',
            style: IconButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Timer display
            _buildTimerDisplay(),
            const SizedBox(height: 24),
            // Counters and buttons
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    // Goals counter and button
                    Expanded(
                      child: _buildCounterButton(
                        icon: Icons.sports_soccer,
                        label: 'GOAL',
                        value: _goals,
                        onTap: _incrementGoals,
                        onLongPress: _decrementGoals,
                        borderColor: AppColors.accent,
                      ),
                    ),
                    const SizedBox(width: 16),
                    // Assists counter and button
                    Expanded(
                      child: _buildCounterButton(
                        icon: Icons.assistant,
                        label: 'ASSIST',
                        value: _assists,
                        onTap: _incrementAssists,
                        onLongPress: _decrementAssists,
                        borderColor: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Bottom actions
            _buildBottomActions(),
          ],
        ),
      ),
    );
  }

  /// Build timer display
  Widget _buildTimerDisplay() {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      child: Center(
        child: Text(
          _formatTime(),
          style: TextStyle(
            fontFamily: 'Roboto',
            fontSize: 64,
            fontWeight: FontWeight.bold,
            color: AppColors.accent,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
      ),
    );
  }

  /// Build counter button with tap and long press
  Widget _buildCounterButton({
    required IconData icon,
    required String label,
    required int value,
    required VoidCallback onTap,
    required VoidCallback onLongPress,
    required Color borderColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      onLongPress: onLongPress,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor.withValues(alpha: 0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: borderColor.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Counter value
            Text(
              value.toString(),
              style: TextStyle(
                fontFamily: 'Roboto',
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: borderColor,
              ),
            ),
            const SizedBox(height: 4),
            // Label
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.0,
              ),
            ),
            const SizedBox(height: 8),
            // Icon
            Icon(
              icon,
              size: 32,
              color: borderColor,
            ),
          ],
        ),
      ),
    );
  }

  /// Build bottom actions
  Widget _buildBottomActions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Cancel button
          OutlinedButton.icon(
            onPressed: () {
              _timerController.stop();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: AppColors.error),
            label: const Text(
              'CANCEL',
              style: TextStyle(
                fontFamily: 'Roboto',
                color: AppColors.error,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              side: const BorderSide(color: AppColors.error, width: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
          // Instructions
          Text(
            'Short press = +1 • Long press = -1',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 12,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          // End match button
          ElevatedButton.icon(
            onPressed: _stopMatch,
            icon: const Icon(Icons.check, size: 20),
            label: const Text(
              'END MATCH',
              style: TextStyle(
                fontFamily: 'Roboto',
                fontWeight: FontWeight.bold,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
