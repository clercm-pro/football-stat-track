import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'season.g.dart';

/// Season model - Represents a sports season for organizing data
/// 
/// Isar collection for local storage
/// A season runs from September to June and spans two years (e.g., 2026/2027)
@collection
class Season {
  @Id()
  final String id;
  
  final String name;
  
  final int startYear;
  
  final int endYear;
  
  final DateTime createdAt;

  Season({
    required this.id,
    required this.name,
    required this.startYear,
    required this.endYear,
    required this.createdAt,
  });

  /// Create a new season with generated ID
  factory Season.newSeason({
    required int startYear,
    required int endYear,
  }) {
    final name = '$startYear/${endYear}';
    return Season(
      id: const Uuid().v4(),
      name: name,
      startYear: startYear,
      endYear: endYear,
      createdAt: DateTime.now(),
    );
  }

  /// Check if this season is the current season
  bool get isCurrent {
    final now = DateTime.now();
    final currentMonth = now.month;
    
    // Season runs from September to June
    // Current season starts in September of startYear and ends in June of endYear
    if (currentMonth >= 9) {
      // September to December: current season is startYear/endYear where startYear == now.year
      return startYear == now.year;
    } else {
      // January to June: current season is startYear/endYear where endYear == now.year
      return endYear == now.year;
    }
  }

  /// Check if this season is in the future
  bool get isFuture {
    final now = DateTime.now();
    final currentMonth = now.month;
    
    if (endYear > now.year) {
      return true;
    }
    if (endYear == now.year && currentMonth < 9) {
      // Before September of endYear
      return true;
    }
    return false;
  }

  /// Check if this season is in the past
  bool get isPast {
    final now = DateTime.now();
    final currentMonth = now.month;
    
    if (startYear < now.year) {
      return true;
    }
    if (startYear == now.year && currentMonth >= 9) {
      // After September of startYear
      return false; // This is current season
    }
    return startYear < now.year;
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'startYear': startYear,
      'endYear': endYear,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory Season.fromJson(Map<String, dynamic> json) {
    return Season(
      id: json['id'] as String,
      name: json['name'] as String,
      startYear: json['startYear'] as int,
      endYear: json['endYear'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'Season(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Season && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
