import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_flow_charts.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

/// Match texture on screen (release 1.2, C): the charts over the match in
/// the stats tab, the woodwork and big saves on the Timeline, and an own goal
/// told as one.

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

MatchResult _result() {
  final homeXg = <double>[0];
  final awayXg = <double>[0];
  final shots = <int>[0];
  for (var m = 1; m <= 90; m++) {
    homeXg.add(homeXg.last + (m % 9 == 0 ? 0.2 : 0));
    awayXg.add(awayXg.last + (m % 13 == 0 ? 0.15 : 0));
    shots.add(shots.last + (m % 9 == 0 ? 1 : 0));
  }
  return MatchResult(
    homeScore: 1,
    awayScore: 0,
    events: const [],
    homeShots: shots.last,
    awayShots: 6,
    homePossession: 55,
    homeXg: homeXg.last,
    awayXg: awayXg.last,
    homeXgByMinute: homeXg,
    awayXgByMinute: awayXg,
    homeShotsByMinute: shots,
    awayShotsByMinute: shots,
    ratings: const [],
  );
}

Future<void> _pump(WidgetTester tester, Widget child) async {
  await tester.binding.setSurfaceSize(const Size(400, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  final l = AppLocalizationsEn();

  testWidgets('the stats tab draws xG and momentum over the match', (
    tester,
  ) async {
    await _pump(
      tester,
      MatchStatsPanel(
        result: _result(),
        homeCode: 'CZE',
        awayCode: 'SVK',
        homeNationId: _home,
        ground: _ground,
        neutral: false,
        groundCode: 'CZE',
        minute: 40,
        fullTime: false,
        events: const [],
        homeColor: Colors.red,
        awayColor: Colors.blue,
      ),
    );
    expect(find.text(l.matchChartXg), findsOneWidget);
    expect(find.text(l.matchChartMomentum), findsOneWidget);
    expect(find.byKey(const Key('match.xgChart')), findsOneWidget);
    expect(find.byKey(const Key('match.momentumChart')), findsOneWidget);
    // Drawn only as far as the clock.
    final xg = tester.widget<CustomPaint>(
      find.byKey(const Key('match.xgChart')),
    );
    expect((xg.painter! as XgRacePainter).upTo, 40);
    final mo = tester.widget<CustomPaint>(
      find.byKey(const Key('match.momentumChart')),
    );
    expect((mo.painter! as MomentumPainter).momentum.length, 40);
  });

  testWidgets('at full time the charts show the whole match', (tester) async {
    await _pump(
      tester,
      MatchStatsPanel(
        result: _result(),
        homeCode: 'CZE',
        awayCode: 'SVK',
        homeNationId: _home,
        ground: _ground,
        neutral: false,
        groundCode: 'CZE',
        minute: 90,
        fullTime: true,
        events: const [],
      ),
    );
    final xg = tester.widget<CustomPaint>(
      find.byKey(const Key('match.xgChart')),
    );
    expect((xg.painter! as XgRacePainter).upTo, 90);
  });

  testWidgets('the Timeline shows woodwork, big saves and own goals', (
    tester,
  ) async {
    await _pump(
      tester,
      const MatchTimeline(
        events: [
          MatchEvent(
            minute: 33,
            type: MatchEventType.goal,
            teamNationId: _home,
            playerId: 205,
            playerName: 'Jan Kral',
            ownGoal: true,
          ),
        ],
        chances: [
          (
            minute: 12,
            stoppage: 0,
            teamNationId: _home,
            name: 'Adam Hlozek',
            woodwork: true,
          ),
          (
            minute: 58,
            stoppage: 0,
            teamNationId: _away,
            name: 'Martin Dubravka',
            woodwork: false,
          ),
        ],
        live: false,
        homeId: _home,
      ),
    );
    expect(find.byType(WoodworkMark), findsOneWidget);
    expect(find.byIcon(Icons.back_hand_outlined), findsOneWidget);
    expect(find.text('A. Hlozek'), findsOneWidget);
    expect(find.text('M. Dubravka'), findsOneWidget);
    expect(find.text('J. Kral (${l.matchGoalOwnGoal})'), findsOneWidget);
    expect(
      find.bySemanticsLabel(
        RegExp(RegExp.escape(l.matchTimelineWoodwork('A. Hlozek'))),
      ),
      findsWidgets,
    );
  });
}
