import 'package:flutter_test/flutter_test.dart';
import 'package:football_stat_track/models/child_profile.dart';
import 'package:football_stat_track/providers/child_profile_provider.dart';

void main() {
  group('ChildProfileNotifier', () {
    test('maxProfiles is 4', () {
      expect(ChildProfileNotifier.maxProfiles, 4);
    });
  });

  group('ChildProfile model', () {
    test('can create profile with required fields', () {
      final profile = ChildProfile(
        nickname: 'Test',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(profile.nickname, 'Test');
    });

    test('can create profile with all fields', () {
      final profile = ChildProfile(
        id: 1,
        nickname: 'Test',
        firstName: 'First',
        lastName: 'Last',
        birthYear: 2020,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      expect(profile.nickname, 'Test');
      expect(profile.firstName, 'First');
      expect(profile.lastName, 'Last');
      expect(profile.birthYear, 2020);
    });
  });
}
