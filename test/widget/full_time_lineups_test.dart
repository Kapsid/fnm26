import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/card_status.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/card_mark.dart';
import 'package:fnm/shared/widgets/rating_badge.dart';

import '../helpers/fixtures.dart';

/// The full-time line-up pitch: each man in his own formation slot in the
/// odd shapes too, and a man sent off still on it, with his red card and
/// his mark.
void main() {
  const surnames = [
    'Alpha', 'Bravo', 'Charlie', 'Delta', 'Echo', 'Foxtrot', 'Golf', //
    'Hotel', 'India', 'Juliet', 'Kilo',
  ];

  MatchTeam team(Formation f) => MatchTeam(
    nationId: 1,
    formation: f,
    instructions: const TacticalInstructions(),
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: 100 + i,
          nationId: 1,
          name: 'Jan ${surnames[i]}',
          position: f.positions[i],
          attributes: flatAttributes(75),
        ),
    ],
  );

  Future<void> pump(WidgetTester tester, MatchTeam t, int redId) async {
    tester.view
      ..physicalSize = const Size(400, 1200)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final side = (
      nationId: 1,
      code: 'CZE',
      team: t,
      cameOn: const <Player>[],
      kit: null,
      cards: {redId: MatchCard.red},
    );
    final other = (
      nationId: 2,
      code: 'POR',
      team: MatchTeam(
        nationId: 2,
        formation: t.formation,
        instructions: const TacticalInstructions(),
        xi: t.xi,
      ),
      cameOn: const <Player>[],
      kit: null,
      cards: const <int, MatchCard>{},
    );
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: MatchFullTimeLineups(
            home: side,
            away: other,
            ratings: {for (final p in t.xi) p.id: 6.0 + p.id % 10 / 10},
            motmId: null,
            playerNationId: 1,
            list: const SizedBox(),
          ),
        ),
      ),
    );
  }

  for (final f in [Formation.f343, Formation.f532, Formation.f352]) {
    testWidgets('${f.name}: every man in his own slot; the man sent off '
        'wears his red card and keeps his mark', (tester) async {
      final t = team(f);
      final red = t.xi[5];
      await pump(tester, t, red.id);
      expect(tester.takeException(), isNull);
      for (var slot = 0; slot < 11; slot++) {
        // The slot's place on top of the disc, his name inside it.
        final pos = tester.widget<Text>(
          find.descendant(
            of: find.byKey(ValueKey('pitchPos$slot')),
            matching: find.byType(Text),
          ),
        );
        expect(pos.data, f.positions[slot].label, reason: 'slot $slot');
        expect(
          find.descendant(
            of: find.byKey(ValueKey('pitchName$slot')),
            matching: find.textContaining(
              RegExp(surnames[slot], caseSensitive: false),
              findRichText: true,
            ),
          ),
          findsOneWidget,
          reason: 'slot $slot',
        );
        final badge = tester.widget<RatingBadge>(
          find.descendant(
            of: find.byKey(ValueKey('pitchRating$slot')),
            matching: find.byType(RatingBadge),
            matchRoot: true,
          ),
        );
        expect(badge.rating, 6.0 + t.xi[slot].id % 10 / 10);
      }
      final card = find.byKey(const ValueKey('pitchCard5'));
      expect(card, findsOneWidget);
      expect(
        tester
            .widget<CardMark>(
              find.descendant(of: card, matching: find.byType(CardMark)),
            )
            .card,
        MatchCard.red,
      );
    });
  }
}
