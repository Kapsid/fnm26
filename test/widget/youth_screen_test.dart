import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/player/prospects.dart';
import 'package:fnm/features/squad/youth_providers.dart';
import 'package:fnm/features/squad/youth_screen.dart';
import 'package:fnm/features/squad/youth_watch_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/fixtures.dart';

void main() {
  Prospect prospectAt(YouthLevel level) => (
    player: player(
      id: 1000 + level.index,
      nationId: 1,
      name: 'Boy ${level.label}',
      position: PlayerPosition.cm,
      age: level.minAge,
      attributes: flatAttributes(50),
    ),
    yearGain: 1,
    caps: 0,
    stars: 4,
    certain: false,
  );

  Widget app(YouthPyramid pyramid) => ProviderScope(
    overrides: [
      youthPyramidProvider(1).overrideWith((ref) async => pyramid),
      // The watchlist tab is first and reads the marks; an empty list keeps
      // these cases about the pyramid.
      youthMarksProvider(1).overrideWith((ref) async => const <YouthMark>[]),
      youthShortlistProvider(1).overrideWith((ref) async => const []),
    ],
    child: const MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: YouthScreen(careerId: 1),
    ),
  );

  testWidgets('every level gets a tab', (tester) async {
    await tester.pumpWidget(
      app((
        byLevel: {
          for (final level in YouthLevel.values) level: [prospectAt(level)],
        },
        releasedByLevel: const <YouthLevel, List<String>>{},
        years: 3,
      )),
    );
    await tester.pumpAndSettle();

    for (final level in YouthLevel.values) {
      expect(
        find.text(level.label),
        findsWidgets,
        reason: 'no tab for ${level.label}',
      );
    }
    // The shortlist tab is the one that opens, so the U-13s are off-stage
    // until it is asked for.
    expect(find.text('Boy U-13'), findsNothing);
    await tester.tap(find.text(YouthLevel.u13.label));
    await tester.pumpAndSettle();
    expect(find.text('Boy U-13'), findsOneWidget);
  });

  testWidgets('a level with nobody says so', (tester) async {
    await tester.pumpWidget(
      app((
        byLevel: const <YouthLevel, List<Prospect>>{},
        releasedByLevel: const <YouthLevel, List<String>>{},
        years: 0,
      )),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(YouthLevel.u13.label));
    await tester.pumpAndSettle();

    final l = AppLocalizations.of(
      tester.element(find.byType(YouthScreen)),
    );
    expect(find.text(l.youthEmptyLevel), findsWidgets);
  });

  testWidgets('boys released this year are named, not silently gone', (
    tester,
  ) async {
    await tester.pumpWidget(
      app((
        byLevel: {
          YouthLevel.u13: [prospectAt(YouthLevel.u13)],
        },
        releasedByLevel: const {
          YouthLevel.u13: ['Gone Boy'],
        },
        years: 2,
      )),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(YouthLevel.u13.label));
    await tester.pumpAndSettle();

    expect(find.text('Gone Boy'), findsOneWidget);
  });
}
