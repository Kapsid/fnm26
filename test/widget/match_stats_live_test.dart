import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// The stats tab used to read "Stats available at full time." for the whole
/// match and then fill in at once, so a tab that was on screen for ninety
/// minutes was inert for eighty-nine of them. These tests pin the two halves
/// of the fix: the box score moves with the clock, and the figures that are
/// genuinely a verdict on ninety minutes still wait for the whistle.

const _home = 1;
const _away = 2;

const _ground = (
  stadium: 'Stadion Letna',
  city: 'Prague',
  groundNationId: _home,
  capacity: 20000,
  attendance: 18000,
  soldOut: false,
);

/// A match whose shots arrive in two bursts: home leads 4-1 at half time and
/// the away side takes over after it, so minute 30 and minute 80 can never be
/// mistaken for each other.
MatchResult _result() {
  final homeShots = <int>[0];
  final awayShots = <int>[0];
  final homeXg = <double>[0];
  final awayXg = <double>[0];
  for (var m = 1; m <= 90; m++) {
    // Home shoot in the first half, away in the second.
    homeShots.add(homeShots.last + (m <= 45 && m % 11 == 0 ? 1 : 0));
    awayShots.add(awayShots.last + (m > 45 && m % 7 == 0 ? 1 : 0));
    homeXg.add(homeXg.last + (m <= 45 && m % 11 == 0 ? 0.3 : 0));
    awayXg.add(awayXg.last + (m > 45 && m % 7 == 0 ? 0.4 : 0));
  }
  return MatchResult(
    homeScore: 1,
    awayScore: 1,
    events: const [],
    homeShots: homeShots.last,
    awayShots: awayShots.last,
    homePossession: 61,
    homeXg: homeXg.last,
    awayXg: awayXg.last,
    homeXgByMinute: homeXg,
    awayXgByMinute: awayXg,
    homeShotsByMinute: homeShots,
    awayShotsByMinute: awayShots,
    ratings: const [
      PlayerRating(
        playerId: 10,
        playerName: 'Vaclav Hruby',
        teamNationId: _home,
        rating: 8.4,
      ),
      PlayerRating(
        playerId: 20,
        playerName: 'Ondrej Maly',
        teamNationId: _away,
        rating: 6.1,
      ),
    ],
  );
}

const _events = [
  MatchEvent(
    minute: 22,
    type: MatchEventType.goal,
    teamNationId: _home,
    playerId: 10,
    playerName: 'Vaclav Hruby',
  ),
  MatchEvent(
    minute: 34,
    type: MatchEventType.yellowCard,
    teamNationId: _away,
    playerId: 20,
    playerName: 'Ondrej Maly',
  ),
  MatchEvent(
    minute: 61,
    type: MatchEventType.goal,
    teamNationId: _away,
    playerId: 20,
    playerName: 'Ondrej Maly',
  ),
  MatchEvent(
    minute: 77,
    type: MatchEventType.redCard,
    teamNationId: _home,
    playerId: 11,
    playerName: 'Petr Novy',
  ),
];

/// Pumps the stats tab as the match screen builds it: the events the clock has
/// reached are filtered by the screen, so the panel is handed exactly those.
Future<void> pumpStats(
  WidgetTester tester, {
  required int minute,
  required bool fullTime,
  Locale locale = const Locale('en'),
  MatchResult? result,
}) async {
  final r = result ?? _result();
  await tester.pumpWidget(
    MaterialApp(
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: MatchStatsPanel(
          result: r,
          homeCode: 'CZE',
          awayCode: 'SVK',
          homeNationId: _home,
          ground: _ground,
          neutral: false,
          groundCode: 'CZE',
          minute: minute,
          fullTime: fullTime,
          events: [
            for (final e in _events)
              if (e.minute <= minute) e,
          ],
        ),
      ),
    ),
  );
  // Settled, not merely pumped. The tallies flip and the bars slide when a
  // figure changes, so a single pump catches the switcher mid-transition with
  // the old number and the new one both on screen, and the bar reads five
  // Texts instead of three.
  await tester.pumpAndSettle();
}

/// The two figures on the stat bar headed [label], or null when the panel is
/// not showing that row at all. A bar prints the home figure, its (uppercased)
/// label, then the away figure, all in the same [Row].
(String, String)? _bar(WidgetTester tester, String label) {
  final heading = find.text(label);
  if (heading.evaluate().isEmpty) return null;
  // `.first` is the INNERMOST enclosing Row, which is the bar's own.
  final row = find.ancestor(of: heading, matching: find.byType(Row)).first;
  final texts = find
      .descendant(of: row, matching: find.byType(Text))
      .evaluate()
      .map((e) => (e.widget as Text).data)
      .whereType<String>()
      .toList();
  expect(texts.length, 3, reason: 'the "$label" bar is not shaped as expected');
  return (texts.first, texts.last);
}

void main() {
  testWidgets('the shot count moves with the clock, it does not wait', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpStats(tester, minute: 30, fullTime: false);
    final shotsAt30 = _bar(tester, 'SHOTS');
    final xgAt30 = _bar(tester, 'XG');
    expect(shotsAt30, isNotNull, reason: 'the shots row must be on screen');

    await pumpStats(tester, minute: 80, fullTime: false);
    final shotsAt80 = _bar(tester, 'SHOTS');

    // The regression: both readings used to be the same, because there was no
    // reading at all until the whistle.
    expect(
      shotsAt80,
      isNot(shotsAt30),
      reason:
          'shots at 80 read the same as at 30 ($shotsAt30): the box score is '
          'not following the clock',
    );
    expect(shotsAt30, ('2', '0'));
    expect(shotsAt80, ('4', '5'));
    // And so does xG, from the same kind of series.
    expect(_bar(tester, 'XG'), isNot(xgAt30));
  });

  testWidgets('goals and cards are counted as the clock reaches them', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // 22': one home goal, no cards yet.
    await pumpStats(tester, minute: 30, fullTime: false);
    expect(_bar(tester, 'GOALS'), ('1', '0'));
    expect(_bar(tester, 'YELLOWS'), isNull);
    expect(_bar(tester, 'REDS'), isNull);

    // 80': both goals, a yellow for the away side and a red for the home one.
    await pumpStats(tester, minute: 80, fullTime: false);
    expect(_bar(tester, 'GOALS'), ('1', '1'));
    expect(_bar(tester, 'YELLOWS'), ('0', '1'));
    expect(_bar(tester, 'REDS'), ('1', '0'));
  });

  testWidgets('the man of the match waits for the whistle', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final l = await AppLocalizations.delegate.load(const Locale('en'));

    // Mid-match: no verdict on ninety minutes, and no player ratings either.
    await pumpStats(tester, minute: 80, fullTime: false);
    expect(find.text(l.matchPlayerOfTheMatch), findsNothing);
    expect(find.text('Vaclav Hruby · CZE'), findsNothing);
    expect(find.text('Vaclav Hruby'), findsNothing);
    expect(find.text(l.matchPlayerRatings), findsNothing);
    // Possession is a share of the whole match, so it waits too.
    expect(_bar(tester, 'POSSESSION'), isNull);
    // What waits is stated, rather than left as a gap.
    expect(find.text(l.matchStatsAtFullTime), findsOneWidget);

    // Full time: all of it arrives, and the waiting line goes.
    await pumpStats(tester, minute: 90, fullTime: true);
    expect(find.text(l.matchPlayerOfTheMatch), findsOneWidget);
    expect(find.text('Vaclav Hruby · CZE'), findsOneWidget);
    expect(find.text(l.matchPlayerRatings), findsOneWidget);
    expect(_bar(tester, 'POSSESSION'), ('61%', '39%'));
    expect(find.text(l.matchStatsAtFullTime), findsNothing);
  });

  testWidgets('extra time reads the last recorded minute, it does not throw', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await pumpStats(tester, minute: 113, fullTime: false);
    expect(tester.takeException(), isNull);
    expect(_bar(tester, 'SHOTS'), ('4', '6'));
  });

  testWidgets('a result with no per-minute series states nothing early', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(400, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    // Not recorded: the full-match totals must not be passed off as the score
    // at minute 30 just because the series is missing.
    await pumpStats(
      tester,
      minute: 30,
      fullTime: false,
      result: const MatchResult(
        homeScore: 0,
        awayScore: 0,
        events: [],
        homeShots: 14,
        awayShots: 9,
        homePossession: 50,
      ),
    );
    expect(_bar(tester, 'SHOTS'), ('0', '0'));
  });

  for (final width in [320.0, 360.0, 400.0]) {
    for (final locale in [const Locale('en'), const Locale('cs')]) {
      testWidgets(
        'the live stats tab fits at ${width.toInt()} in ${locale.languageCode}',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 800));
          addTearDown(() => tester.binding.setSurfaceSize(null));

          await pumpStats(
            tester,
            minute: 80,
            fullTime: false,
            locale: locale,
          );
          expectLocale(
            tester,
            find.byType(MatchStatsPanel),
            locale.languageCode,
          );
          expect(tester.takeException(), isNull);
          expectNothingCut(tester, 'the live stats tab at ${width.toInt()}');

          // The waiting line is the one paragraph here allowed to wrap, so it
          // is checked for a word broken across lines rather than for width.
          final l = await AppLocalizations.delegate.load(locale);
          expectNoBrokenWord(
            find.text(l.matchStatsAtFullTime),
            'the full-time note',
          );
        },
      );
    }
  }
}
