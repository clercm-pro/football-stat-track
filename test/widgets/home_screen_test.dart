import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:football_stat_track/l10n/app_localizations.dart';
import 'package:football_stat_track/screens/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays app bar title', (final tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(FloatingActionButton), findsOneWidget);
  });

  testWidgets('HomeScreen FAB has add icon', (final tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: HomeScreen(),
        ),
      ),
    );

    expect(find.byIcon(Icons.add), findsOneWidget);
  });
}
