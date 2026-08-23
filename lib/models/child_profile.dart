import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

part 'child_profile.g.dart';

/// ChildProfile model - Represents a player being tracked
/// 
/// Isar collection for local storage
/// Fields match the specification in DATA-MODEL.md
@collection
class ChildProfile {
  @Id()
  final String id;
  
  final String nickname;
  
  final String? firstName;
  
  final String? lastName;
  
  final int? birthYear;
  
  final DateTime createdAt;
  
  final DateTime updatedAt;

  ChildProfile({
    required this.id,
    required this.nickname,
    this.firstName,
    this.lastName,
    this.birthYear,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Create a new profile with generated ID
  factory ChildProfile.newProfile({
    required String nickname,
    String? firstName,
    String? lastName,
    int? birthYear,
  }) {
    return ChildProfile(
      id: const Uuid().v4(),
      nickname: nickname,
      firstName: firstName,
      lastName: lastName,
      birthYear: birthYear,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  /// Copy with updated values
  ChildProfile copyWith({
    String? id,
    String? nickname,
    String? firstName,
    String? lastName,
    int? birthYear,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ChildProfile(
      id: id ?? this.id,
      nickname: nickname ?? this.nickname,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      birthYear: birthYear ?? this.birthYear,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  /// Calculate age from birth year
  int? get age {
    if (birthYear == null) return null;
    return DateTime.now().year - birthYear!;
  }

  /// Full name (first + last, or nickname if no names)
  String get displayName {
    if (firstName != null && lastName != null) {
      return '$firstName $lastName';
    }
    if (firstName != null) {
      return firstName!;
    }
    return nickname;
  }

  /// Initials for avatar
  String get initials {
    final name = displayName;
    if (name.isNotEmpty) {
      final parts = name.split(' ');
      if (parts.length > 1) {
        return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      }
      return name[0].toUpperCase();
    }
    return '?';
  }

  /// Convert to JSON for serialization
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nickname': nickname,
      'firstName': firstName,
      'lastName': lastName,
      'birthYear': birthYear,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  /// Create from JSON
  factory ChildProfile.fromJson(Map<String, dynamic> json) {
    return ChildProfile(
      id: json['id'] as String,
      nickname: json['nickname'] as String,
      firstName: json['firstName'] as String?,
      lastName: json['lastName'] as String?,
      birthYear: json['birthYear'] as int?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  @override
  String toString() {
    return 'ChildProfile(id: $id, nickname: $nickname, age: $age)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChildProfile && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}
