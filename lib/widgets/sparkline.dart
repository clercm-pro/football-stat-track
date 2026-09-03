import 'package:flutter/material.dart';
import 'package:football_stat_track/config/colors.dart';

/// Sparkline widget for displaying goal trends
/// 
/// Shows last 6 matches' goals as proportional bars
/// - Bars are colored with accent (#2CADA3)
/// - Last bar is colored with primaryDark (#01584A)
/// - Height is proportional to goals, with minimum 15% height
/// - Used in PlayerCard on Home Screen
class Sparkline extends StatelessWidget {
  /// List of goal counts for the last 6 matches
  /// Should contain exactly 6 values, or will be padded with zeros
  final List<int> goals;
  
  /// Maximum goals in any single match (for proportional scaling)
  /// If null, will be calculated from the goals list
  final int? maxGoals;
  
  /// Height of the sparkline
  final double height;
  
  /// Gap between bars
  final double gap;
  
  /// Bar radius
  final double barRadius;

  const Sparkline({
    super.key,
    required this.goals,
    this.height = 44,
    this.gap = 3,
    this.barRadius = 2,
    this.maxGoals,
  });

  /// Ensures the list has exactly 6 values by padding with zeros
  List<int> _ensureSixValues(final List<int> input) {
    if (input.length >= 6) {
      return input.sublist(input.length - 6);
    }
    return [...input, ...List.filled(6 - input.length, 0)];
  }

  @override
  Widget build(final BuildContext context) {
    // Ensure we have exactly 6 bars
    final displayGoals = _ensureSixValues(goals);
    
    // Calculate max goals for scaling (minimum 1 to avoid division by zero)
    final effectiveMaxGoals = maxGoals ??
        displayGoals.reduce((final a, final b) => a > b ? a : b);
    final safeMaxGoals = effectiveMaxGoals > 0 ? effectiveMaxGoals : 1;
    
    // Minimum height ratio (15%)
    const minHeightRatio = 0.15;
    
    return SizedBox(
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: displayGoals.asMap().entries.map((final entry) {
          final index = entry.key;
          final goalCount = entry.value;
          
          // Calculate bar height as percentage of max, with minimum 15%
          final heightRatio = (goalCount / safeMaxGoals)
              .clamp(minHeightRatio, 1.0);
          final barHeight = height * heightRatio;
          
          // Last bar uses primaryDark, others use accent
          final isLastBar = index == displayGoals.length - 1;
          final barColor = isLastBar 
              ? AppColors.primaryDark 
              : AppColors.accent;
          
          return Padding(
            padding: EdgeInsets.only(left: gap),
            child: Container(
              width: (height - gap * 5) / 6,
              height: barHeight,
              decoration: BoxDecoration(
                color: barColor,
                borderRadius: BorderRadius.circular(barRadius),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
  
}
