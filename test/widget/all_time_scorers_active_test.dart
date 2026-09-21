import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/features/tournaments/all_time_scorers_legend.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart'
    show AllTimeScorer, CupPlayerRecord;
import 'package:fnm/features/tournaments/tournament_history.dart';
import 'package:fnm/features/tournaments/tournament_stats.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/pump_app.dart';

/// An all-time scoring chart mixes two kinds of player: men you could still
/// pick on Saturday, and legends who retired cycles ago. Read cold, the two
/// lines look identical — so every all-time list marks the active ones, with
/// the SAME badge ([ActiveBadge]) meaning the same thing (his own career has
/// not ended, not a flat age cut-off).
///
/// The badge sits between a name that may already be ellipsizing and a tally,
/// so the width cases check it survives a phone in Czech as well as English.
void main() {
  const codes = {10: 'NED', 11: 'CZE'};
  String code(int id) => codes[id] ?? '??';
  String name(int id) => 'Nation $id';

  /// One man still playing, one long retired — the whole point of the chart.
  const allTime = <AllTimeScorer>[
    (
      playerId: 1,
      nationId: 10,
      name: 'Bartholomew Vanderberghe',
      goals: 31,
      active: true,
    ),
    (
      playerId: 2,
      nationId: 11,
      name: 'Radoslav Nepomucky',
      goals: 28,
      active: false,
    ),
  ];

  Future<void> pumpAt(
    WidgetTester tester,
    Widget child, {
    double? width,
    Locale locale = const Locale('en'),
  }) async {
    if (width != null) {
      tester.view
        ..physicalSize = Size(width, 900)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
    }
    await tester.pumpApp(Scaffold(body: child), locale: locale);
    await tester.pumpAndSettle();
  }

  Widget scorersTab() => TournamentScorers(
    scorers: const [(playerId: 1, nationId: 10, goals: 4)],
    playerNames: const {1: 'Bartholomew Vanderberghe'},
    code: code,
    allTime: allTime,
  );

  /// The other two boards behind the same switch: one man still playing, one
  /// retired, exactly as on the scorers board.
  const records = <CupPlayerRecord>[
    (
      playerId: 1,
      nationId: 10,
      name: 'Bartholomew Vanderberghe',
      count: 24,
      active: true,
    ),
    (
      playerId: 2,
      nationId: 11,
      name: 'Radoslav Nepomucky',
      count: 19,
      active: false,
    ),
  ];

  /// Two editions won, so the "Cups played" board is offered at all — before
  /// the second edition everyone is on one and the board is hidden.
  final honours = <Honour>[
    for (final year in [2026, 2030])
      (
        year: year,
        competition: 'World Championship',
        championId: 10,
        runnerUpId: 11,
        thirdId: null,
        thirdId2: null,
        hostId: 10,
        hostIds: [10],
        finalHomeScore: 2,
        finalAwayScore: 1,
        topScorerName: null,
        topScorerGoals: null,
      ),
  ];

  Widget statsTab({
    List<CupPlayerRecord> topGames = const [],
    List<CupPlayerRecord> topCups = const [],
  }) => TournamentStatsTab(
    honours: honours,
    allTimeScorers: allTime,
    topGames: topGames,
    topCups: topCups,
    code: code,
    name: name,
  );

  group('a competition scorer chart', () {
    testWidgets('marks the active scorer only once on the all-time tab', (
      tester,
    ) async {
      await pumpAt(tester, scorersTab());

      // This edition first: everyone playing in it is active by definition,
      // so the badge would say nothing.
      expect(find.byType(ActiveBadge), findsNothing);

      await tester.tap(find.text('All-time'));
      await tester.pumpAndSettle();

      expect(find.text('Bartholomew Vanderberghe'), findsOneWidget);
      expect(find.text('Radoslav Nepomucky'), findsOneWidget);
      expect(
        find.byType(ActiveBadge),
        findsOneWidget,
        reason: 'only the man still playing is marked',
      );
    });
  });

  group("a cup's all-time leaderboard", () {
    testWidgets('marks the active scorer', (tester) async {
      await pumpAt(tester, statsTab());

      expect(find.text('Bartholomew Vanderberghe'), findsOneWidget);
      expect(
        find.byType(ActiveBadge),
        findsOneWidget,
        reason: 'the scorers board must say who is still playing',
      );
    });
  });

  group('every board behind the one switch', () {
    testWidgets('marks the active holder on games, cups and scorers too', (
      tester,
    ) async {
      await pumpAt(tester, statsTab(topGames: records, topCups: records));

      expect(
        find.byType(SegmentedButton<int>),
        findsOneWidget,
        reason: 'all three boards should be on offer',
      );

      // Opens on Games: the badge has to be there, not only on Scorers.
      expect(
        find.byType(ActiveBadge),
        findsOneWidget,
        reason: 'the games board must say who is still playing',
      );

      // And on each of the other two segments in turn.
      for (final segment in [1, 2]) {
        await tester.tap(
          find
              .descendant(
                of: find.byType(SegmentedButton<int>),
                matching: find.byType(Text),
              )
              .at(segment),
        );
        await tester.pumpAndSettle();
        expect(
          find.byType(ActiveBadge),
          findsOneWidget,
          reason: 'segment $segment must mark the active holder as well',
        );
      }
    });
  });

  group('the badge', () {
    testWidgets("speaks the reader's language", (tester) async {
      await pumpAt(tester, const ActiveBadge(), locale: const Locale('cs'));
      expect(find.text('AKTIVNÍ'), findsOneWidget);

      await pumpAt(tester, const ActiveBadge());
      expect(find.text('ACTIVE'), findsOneWidget);
    });
  });

  for (final width in [400.0, 360.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      final at = '${width.toInt()}px in ${locale.languageCode}';

      testWidgets('the all-time chart fits $at', (tester) async {
        await pumpAt(tester, scorersTab(), width: width, locale: locale);
        // The second segment is "All-time" in whichever language is on.
        await tester.tap(
          find
              .descendant(
                of: find.byType(SegmentedButton<bool>),
                matching: find.byType(Text),
              )
              .at(1),
        );
        await tester.pumpAndSettle();
        expect(
          tester.takeException(),
          isNull,
          reason: 'a marked all-time row must never run off a phone',
        );
        expect(find.byType(ActiveBadge), findsOneWidget);
      });

      testWidgets('the all-time legend line fits $at', (tester) async {
        // The header above the World Championship's all-time chart: a
        // heading, the badge, and the words that explain it. It sits in the
        // screen's own side margins, so the test gives it the same ones.
        await pumpAt(
          tester,
          const Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.marginMobile,
            ),
            child: AllTimeScorersLegend(),
          ),
          width: width,
          locale: locale,
        );
        expect(
          tester.takeException(),
          isNull,
          reason: 'the legend must never run off a phone-width screen',
        );
        expect(find.byType(ActiveBadge), findsOneWidget);
      });

      testWidgets('the all-time leaderboard fits $at', (tester) async {
        await pumpAt(tester, statsTab(), width: width, locale: locale);
        expect(
          tester.takeException(),
          isNull,
          reason: 'a marked leaderboard row must never run off a phone',
        );
        expect(find.byType(ActiveBadge), findsOneWidget);
      });
    }
  }

  test('every all-time scorer list renders the shared badge', () {
    // The lists that cannot be pumped without a save behind them (each is
    // driven by a provider over the database). The guard is coarse on
    // purpose: it fails when a list stops mentioning the badge at all, which
    // is exactly how this feedback arrived in the first place.
    const lists = [
      'lib/features/records/all_time_records_screen.dart',
      'lib/features/tournaments/cup_detail_screen.dart',
      'lib/features/tournaments/tournament_history.dart',
      'lib/features/tournaments/tournament_stats.dart',
      'lib/features/nations/nation_vitrine_screen.dart',
      'lib/features/records/record_book_screen.dart',
      'lib/features/stats/team_stats_screen.dart',
    ];
    for (final path in lists) {
      expect(
        File(path).readAsStringSync(),
        contains('ActiveBadge'),
        reason: '$path shows an all-time chart without marking who still plays',
      );
    }
  });
}
