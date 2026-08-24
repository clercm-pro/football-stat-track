import 'package:isar/isar.dart';

part 'match.g.dart';

/// Match model - Represents a game session with recorded statistics
/// 
/// Isar collection for local storage
/// Tracks goals, assists, and duration for a specific profile and season
@Collection()
class Match {

  Match({
    required this.childId,
    required this.seasonId,
    required this.startTime,
    required this.createdAt,
    required this.updatedAt,
    this.id = Isar.autoIncrement,
    this.endTime,
    this.goals = 0,
    this.assists = 0,
  });

  /// Create a new match with auto-increment ID
  factory Match.newMatch({
    required final int childId,
    required final int seasonId,
  }) {
    return Match(
      childId: childId,
      seasonId: seasonId,
      startTime: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Create from JSON
  factory Match.fromJson(final Map<String, dynamic> json) {
    return Match(
      id: json['id'] as int? ?? Isar.autoIncrement,
      childId: json['childId'] as int,
      seasonId: json['seasonId'] as int,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime'] as String) 
          : null,
      goals: json['goals'] as int,
      assists: json['assists'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }
  Id id = Isar.autoIncrement;
  
  final int childId;
  
  final int seasonId;
  
  final DateTime startTime;
  
  final DateTime? endTime;
  
  final int goals;
  
  final int assists;
  
  final DateTime createdAt;
  
  final DateTime updatedAt;

  /// Check if match is currently in progress
  bool get isInProgress => endTime == null;

  /// Calculate duration in seconds
  /// Duration is not supported by Isar, so we use @Ignore annotation
  @Ignore()
  Duration? get duration {
    if (endTime == null) {
      return null;
    }
    return endTime!.difference(startTime);
  }

  /// Duration in minutes (rounded down) - computed from endTime/startTime
  /// This is a computed property, not stored in Isar
  @Ignore()
  int? get durationInMinutes {
    if (endTime == null) {
      return null;
    }
    return endTime!.difference(startTime).inMinutes;
  }

  /// Copy with updated values
  Match copyWith({
    final Id? id,
    final int? childId,
    final int? seasonId,
    final DateTime? startTime,
    final DateTime? endTime,
    final int? goals,
    final int? assists,
    final DateTime? createdAt,
    final DateTime? updatedAt,
  }) {
    return Match(
      id: id ?? this.id,
      childId: childId ?? this.childId,
      seasonId: seasonId ?? this.seasonId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      goals: goals ?? this.goals,
      assists: assists ?? this.assists,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Increment goals
  Match addGoal() {
    return copyWith(
      goals: goals + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// Decrement goals (minimum 0)
  Match removeGoal() {
    return copyWith(
      goals: goals > 0 ? goals - 1 : 0,
      updatedAt: DateTime.now(),
    );
  }

  /// Increment assists
  Match addAssist() {
    return copyWith(
      assists: assists + 1,
      updatedAt: DateTime.now(),
    );
  }

  /// Decrement assists (minimum 0)
  Match removeAssist() {
    return copyWith(
      assists: assists > 0 ? assists - 1 : 0,
      updatedAt: DateTime.now(),
    );
  }

  /// End the match
  Match endMatch() {
    return copyWith(
      endTime: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'childId': childId,
      'seasonId': seasonId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'goals': goals,
      'assists': assists,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'Match(id: $id, childId: $childId, goals: $goals, '
        'assists: $assists, isInProgress: $isInProgress)';
  }

  @override
  bool operator ==(final Object other) {
    if (identical(this, other)) {
      return true;
    }
    return other is Match && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// MatchStats - Computed statistics from multiple matches
class MatchStats {

  MatchStats({
    this.totalMatches = 0,
    this.totalGoals = 0,
    this.totalAssists = 0,
  });

  /// Create from list of matches
  factory MatchStats.fromMatches(final List<Match> matches) {
    return MatchStats(
      totalMatches: matches.length,
      totalGoals: matches.fold(
        0,
        (final sum, final match) => sum + match.goals,
      ),
      totalAssists: matches.fold(
        0,
        (final sum, final match) => sum + match.assists,
      ),
    );
  }
  final int totalMatches;
  final int totalGoals;
  final int totalAssists;

  /// Copy with updated values
  MatchStats copyWith({
    final int? totalMatches,
    final int? totalGoals,
    final int? totalAssists,
  }) {
    return MatchStats(
      totalMatches: totalMatches ?? this.totalMatches,
      totalGoals: totalGoals ?? this.totalGoals,
      totalAssists: totalAssists ?? this.totalAssists,
    );
  }

  @override
  String toString() {
    return 'MatchStats(matches: $totalMatches, goals: $totalGoals, '
        'assists: $totalAssists)';
  }
}
