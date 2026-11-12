import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/same_day_results.dart';
import 'package:fnm/domain/services/match/stadium/away_fan_share.dart';
import 'package:fnm/domain/services/match/stadium/ground_character.dart';
import 'package:fnm/domain/services/match/stadium/kick_off.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/features/match/full_time_tabs.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pitch_view_fixture.dart';
import '../helpers/seeded_save.dart' show enL;

/// The two tabs the match screen adds at full time, Player and Stadium, on
/// their own: what each shows, the empty state, and that nothing overflows
/// at the largest text size or in Czech.

const _home = 10;
const _away = 20;

MatchResult _result({List<PlayerRating>? ratings, bool moments = true}) =>
    MatchResult(
      homeScore: 1,
      awayScore: 2,
      homeShots: 6,
      awayShots: 9,
      homePossession: 47,
      events: const [
        MatchEvent(
          minute: 12,
          type: MatchEventType.goal,
          teamNationId: _away,
          playerId: 201,
          playerName: 'Away Striker',
          assistPlayerId: 202,
          assistName: 'Away Winger',
        ),
        MatchEvent(
          minute: 40,
          type: MatchEventType.goal,
          teamNationId: _home,
          playerId: 101,
          playerName: 'Home Forward',
        ),
        MatchEvent(
          minute: 55,
          type: MatchEventType.yellowCard,
          teamNationId: _away,
          playerId: 201,
          playerName: 'Away Striker',
        ),
        MatchEvent(
          minute: 77,
          type: MatchEventType.goal,
          teamNationId: _away,
          playerId: 201,
          playerName: 'Away Striker',
        ),
        MatchEvent(
          minute: 81,
          type: MatchEventType.substitution,
          teamNationId: _away,
          playerId: 209,
          playerName: 'Away Sub',
          secondaryPlayerId: 201,
          secondaryName: 'Away Striker',
        ),
      ],
      moments: moments
          ? const [
              ShotMoment(
                minute: 12,
                stoppage: 0,
                seq: 0,
                teamNationId: _away,
                shooterId: 201,
                zone: PitchZone.boxCentre,
                xg: 0.4,
                outcome: ShotOutcome.goal,
                origin: ShotOrigin.openPlay,
                keeperId: 100,
                goalEventIndex: 0,
              ),
              ShotMoment(
                minute: 30,
                stoppage: 0,
                seq: 0,
                teamNationId: _away,
                shooterId: 201,
                zone: PitchZone.boxLeft,
                xg: 0.2,
                outcome: ShotOutcome.saved,
                origin: ShotOrigin.openPlay,
                keeperId: 100,
              ),
              ShotMoment(
                minute: 60,
                stoppage: 0,
                seq: 0,
                teamNationId: _away,
                shooterId: 201,
                zone: PitchZone.boxRight,
                xg: 0.1,
                outcome: ShotOutcome.wide,
                origin: ShotOrigin.openPlay,
                keeperId: 100,
              ),
              ShotMoment(
                minute: 77,
                stoppage: 0,
                seq: 0,
                teamNationId: _away,
                shooterId: 201,
                zone: PitchZone.boxCentre,
                xg: 0.3,
                outcome: ShotOutcome.goal,
                origin: ShotOrigin.openPlay,
                keeperId: 100,
                goalEventIndex: 3,
              ),
              ShotMoment(
                minute: 85,
                stoppage: 0,
                seq: 0,
                teamNationId: _home,
                shooterId: 101,
                zone: PitchZone.boxCentre,
                xg: 0.3,
                outcome: ShotOutcome.saved,
                origin: ShotOrigin.openPlay,
                keeperId: 200,
              ),
            ]
          : const [],
      ratings:
          ratings ??
          const [
            PlayerRating(
              playerId: 101,
              playerName: 'Home Forward',
              teamNationId: _home,
              rating: 7.4,
              position: PlayerPosition.st,
            ),
            PlayerRating(
              playerId: 201,
              playerName: 'Away Striker',
              teamNationId: _away,
              rating: 8.7,
              position: PlayerPosition.st,
            ),
            PlayerRating(
              playerId: 200,
              playerName: 'Away Keeper',
              teamNationId: _away,
              rating: 6.9,
              position: PlayerPosition.gk,
            ),
          ],
    );

const MatchGround _ground = (
  stadium: 'Stadion Nad Lesem',
  city: 'Brno',
  groundNationId: _home,
  capacity: 41250,
  attendance: 33000,
  soldOut: false,
);

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  Size size = const Size(360, 1400),
  String locale = 'en',
  double scale = 1,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        potmCareerStatsProvider.overrideWith(
          (ref, a) async => a.playerId == 201
              ? (
                  caps: 31,
                  goals: 12,
                  assists: 5,
                  cleanSheets: 0,
                  motm: 4,
                  yellows: 3,
                  reds: 0,
                  avgRating: 7.1,
                  bestRating: 9.0,
                  formRating: 7.3,
                )
              : null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme,
        locale: Locale(locale),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, c) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: c!,
        ),
        home: Scaffold(body: child),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

PitchStadium _stadium() {
  final home = pitchNation('CZE');
  final away = pitchNation('POR');
  return PitchStadium.forMatch(
    ground: (
      stadium: _ground.stadium,
      city: _ground.city,
      groundNationId: home.id,
      capacity: _ground.capacity,
      attendance: _ground.attendance,
      soldOut: false,
    ),
    home: home,
    away: away,
    awayShare: AwayFanShare.estimate(
      home: home,
      away: away,
      neutral: false,
      tournament: false,
      distanceKm: AwayFanShare.proxyDistanceKm(home, away),
    ),
    date: DateTime(2026, 9, 10),
    kickOff: const KickOffTime(20, 45),
    weather: WeatherKind.rain,
  );
}

Widget _stadiumTab({PitchStadium? stadium, GroundWorks? works}) =>
    MatchStadiumTab(
      ground: _ground,
      neutral: false,
      groundNationCode: 'CZE',
      groundNationName: 'Czechia',
      homeNationName: 'Czechia',
      kickOff: const KickOffTime(20, 45),
      weather: WeatherKind.rain,
      stadium: stadium,
      works: works ?? GroundWorks.none,
    );

void main() {
  group('his match line', () {
    test('reads goals, assists, shots, minutes and cards off the result', () {
      final line = playerMatchLine(_result(), 201);
      expect(line.goals, 2);
      expect(line.assists, 0);
      expect(line.shots, 4);
      expect(line.onTarget, 3);
      expect(line.yellows, 1);
      expect(line.reds, 0);
      // Off at 81'.
      expect(line.minutes, 81);
      expect(line.xg, closeTo(1.0, 1e-9));
      expect(playerMatchLine(_result(), 202).assists, 1);
      // The keeper's saves: the shot at 30' only.
      expect(playerMatchLine(_result(), 100).saves, 1);
      // Came on at 81'.
      expect(playerMatchLine(_result(), 209).minutes, 9);
    });

    test('a result without moments leaves the shots out, not zero', () {
      final line = playerMatchLine(_result(moments: false), 201);
      expect(line.shots, isNull);
      expect(line.onTarget, isNull);
      expect(line.saves, isNull);
      expect(line.goals, 2);
    });
  });

  group('the Player tab', () {
    testWidgets('the man of the match from the away side', (tester) async {
      await _pump(
        tester,
        PlayerOfMatchTab(
          result: _result(),
          careerId: 1,
          nationCode: 'POR',
          nationName: 'Portugal',
          age: 27,
          onOpenPlayer: () {},
        ),
      );
      expect(tester.takeException(), isNull);
      final header = find.byKey(PlayerOfMatchTab.headerKey);
      expect(header, findsOneWidget);
      Finder inHeader(String t) =>
          find.descendant(of: header, matching: find.text(t));
      expect(inHeader('Away Striker'), findsOneWidget);
      expect(inHeader('8.7'), findsOneWidget);
      expect(inHeader('Portugal'), findsOneWidget);
      expect(inHeader(enL.tacticsAgeOnly(27)), findsOneWidget);
      expect(inHeader("81'"), findsOneWidget);
      expect(inHeader(enL.ratingPlayerOfTheMatch), findsOneWidget);
      expect(find.text('3 / 4'), findsOneWidget);
      expect(find.byKey(PlayerOfMatchTab.careerKey), findsOneWidget);
      expect(find.text('31'), findsOneWidget);
      expect(find.text('12'), findsOneWidget);
      expect(find.byKey(PlayerOfMatchTab.openKey), findsOneWidget);
    });

    testWidgets('the man of the match from the home side', (tester) async {
      await _pump(
        tester,
        PlayerOfMatchTab(
          result: _result(
            ratings: const [
              PlayerRating(
                playerId: 101,
                playerName: 'Home Forward',
                teamNationId: _home,
                rating: 8.1,
                position: PlayerPosition.st,
              ),
              PlayerRating(
                playerId: 201,
                playerName: 'Away Striker',
                teamNationId: _away,
                rating: 7.0,
                position: PlayerPosition.st,
              ),
            ],
          ),
          careerId: 1,
          nationCode: 'CZE',
          nationName: 'Czechia',
        ),
      );
      final header = find.byKey(PlayerOfMatchTab.headerKey);
      expect(
        find.descendant(of: header, matching: find.text('Home Forward')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: header, matching: find.text('Czechia')),
        findsOneWidget,
      );
      expect(find.text('Away Striker'), findsNothing);
      // No record for him: the block is left out.
      expect(find.byKey(PlayerOfMatchTab.careerKey), findsNothing);
      expect(find.byKey(PlayerOfMatchTab.openKey), findsNothing);
    });

    testWidgets('a keeper leads with his saves', (tester) async {
      await _pump(
        tester,
        PlayerOfMatchTab(
          result: _result(
            ratings: const [
              PlayerRating(
                playerId: 200,
                playerName: 'Away Keeper',
                teamNationId: _away,
                rating: 8.0,
                position: PlayerPosition.gk,
              ),
            ],
          ),
          careerId: 1,
        ),
      );
      expect(
        find.descendant(
          of: find.byKey(PlayerOfMatchTab.headerKey),
          matching: find.text(enL.matchStatSaves.toUpperCase()),
        ),
        findsOneWidget,
      );
    });

    testWidgets('no man of the match: a calm empty state', (tester) async {
      await _pump(
        tester,
        PlayerOfMatchTab(result: _result(ratings: const []), careerId: 1),
      );
      expect(find.byKey(PlayerOfMatchTab.emptyKey), findsOneWidget);
      expect(find.text(enL.matchPotmNone), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });

  group('the Stadium tab', () {
    testWidgets('name, capacity, attendance and how full', (tester) async {
      await _pump(tester, _stadiumTab(stadium: _stadium()));
      expect(tester.takeException(), isNull);
      expect(find.byKey(MatchStadiumTab.pictureKey), findsOneWidget);
      expect(find.text('Stadion Nad Lesem'), findsOneWidget);
      expect(find.text('Brno · Czechia'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(MatchStadiumTab.capacityKey),
          matching: find.text('41,250'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(MatchStadiumTab.attendanceKey),
          matching: find.text('33,000'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(MatchStadiumTab.fillKey),
          matching: find.text('80%'),
        ),
        findsOneWidget,
      );
      expect(find.text(enL.matchStadiumHomeOf('Czechia')), findsOneWidget);
      expect(
        find.text(
          '${enL.matchConditionsKickOff} 20:45 · ${enL.matchWeatherRain}',
        ),
        findsOneWidget,
      );
    });

    testWidgets('says what the federation did to the ground', (tester) async {
      await _pump(
        tester,
        _stadiumTab(
          works: const GroundWorks(built: true, underWay: true),
        ),
      );
      expect(find.text(enL.matchStadiumBuilt), findsOneWidget);
      expect(find.text(enL.matchStadiumWorks), findsOneWidget);
      expect(find.byKey(MatchStadiumTab.pictureKey), findsNothing);
    });
  });

  group('at the largest text size', () {
    for (final locale in const ['en', 'cs', 'de']) {
      testWidgets('neither tab overflows at 320 in $locale', (tester) async {
        for (final tab in [
          PlayerOfMatchTab(
            result: _result(),
            careerId: 1,
            nationCode: 'POR',
            nationName: 'Bosnia and Herzegovina',
            age: 27,
            onOpenPlayer: () {},
          ),
          _stadiumTab(
            stadium: _stadium(),
            works: const GroundWorks(upgrades: 1, underWay: true),
          ),
        ]) {
          await _pump(
            tester,
            tab,
            size: const Size(320, 640),
            locale: locale,
            scale: 1.4,
          );
          expect(tester.takeException(), isNull);
          // Scrolled through to the end, nothing overflows on the way.
          await tester.drag(find.byType(ListView), const Offset(0, -3000));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      });
    }
  });

  group('the full-time tab strip', () {
    for (final width in const [320.0, 360.0]) {
      for (final locale in const ['cs', 'en', 'de']) {
        testWidgets('every label whole at $width in $locale', (tester) async {
          await _pump(
            tester,
            Builder(
              builder: (context) {
                final l = AppLocalizations.of(context);
                return DefaultTabController(
                  length: 5,
                  child: Column(
                    children: [
                      MatchDetailTabs(
                        extra: [l.matchTabPlayer, l.matchTabStadium],
                      ),
                    ],
                  ),
                );
              },
            ),
            size: Size(width, 400),
            locale: locale,
          );
          final l = AppLocalizations.of(
            tester.element(find.byType(MatchDetailTabs)),
          );
          for (final label in [
            l.matchTabTimeline,
            l.matchTabStats,
            l.matchTabLineups,
            l.matchTabPlayer,
            l.matchTabStadium,
          ]) {
            final finder = find.text(label);
            expect(finder, findsOneWidget, reason: '"$label" is missing');
            expectOneLine(finder, 'the "$label" tab');
            // Scrolling, nothing is squeezed at all.
            expectLegible(tester, finder, 'the "$label" tab', min: 0.99);
          }
        });
      }
    }
  });

  group('the Summary', () {
    // Two other matches of the group, one with a long pair of names; and a
    // knockout tie of the round settled on penalties.
    final others = [
      SameDayResult.of(
        Fixture(
          id: 501,
          careerId: 1,
          competitionId: 7,
          matchday: 2,
          date: DateTime(2030, 6, 14),
          homeNationId: 30,
          awayNationId: 40,
          groupId: 3,
          homeScore: 3,
          awayScore: 1,
          played: true,
        ),
        const [
          (nationId: 30, playerId: 1, minute: 9),
          (nationId: 40, playerId: 2, minute: 44),
          (nationId: 30, playerId: 3, minute: 46),
          (nationId: 30, playerId: 4, minute: 88),
        ],
      ),
      SameDayResult.of(
        Fixture(
          id: 502,
          careerId: 1,
          competitionId: 7,
          matchday: 2,
          date: DateTime(2030, 6, 14),
          homeNationId: 50,
          awayNationId: 60,
          groupId: 3,
          homeScore: 2,
          awayScore: 1,
          played: true,
          afterExtraTime: true,
          homePenalties: 4,
          awayPenalties: 3,
        ),
        const [
          (nationId: 50, playerId: 5, minute: 70),
        ],
      ),
    ];
    String nameOf(int id) => switch (id) {
      30 => 'Bosnia and Herzegovina',
      40 => 'Central African Republic',
      50 => 'Papua New Guinea',
      _ => 'Saint Vincent and the Grenadines',
    };

    Widget summary({
      bool fullTime = true,
      bool motm = true,
      SameDayPhase? phase,
      List<SameDayResult>? sameDay,
    }) {
      final r = _result();
      return MatchSummaryTab(
        result: fullTime ? r : null,
        potm: fullTime && motm
            ? PlayerOfMatchHeader(
                result: r,
                nationCode: 'POR',
                nationName: 'Portugal',
                age: 27,
              )
            : null,
        ground: _ground,
        groundNationName: 'Czechia',
        kickOff: const KickOffTime(20, 45),
        weather: WeatherKind.rain,
        sameDay: sameDay ?? others,
        sameDayPhase:
            phase ?? (fullTime ? SameDayPhase.fullTime : SameDayPhase.live),
        codeOf: (id) => 'C$id',
        nameOf: nameOf,
        playerTab: fullTime ? 3 : null,
        stadiumTab: fullTime ? 4 : null,
      );
    }

    String scoreOf(WidgetTester tester, int fixtureId) => tester
        .widgetList<Text>(
          find.descendant(
            of: find.byKey(MatchSummaryTab.otherScoreKey(fixtureId)),
            matching: find.byType(Text),
          ),
        )
        .map((t) => t.data)
        .join(' | ');

    double topOf(WidgetTester tester, Key key) =>
        tester.getTopLeft(find.byKey(key)).dy;

    testWidgets('full time: no score card, his card, the day, the ground', (
      tester,
    ) async {
      await _pump(tester, summary());
      // The scoreboard above has the score: the tab does not repeat it, nor
      // the scorers.
      expect(find.text('1 - 2'), findsNothing);
      expect(find.textContaining('Striker', findRichText: true), findsWidgets);
      expect(
        find.textContaining("A. Striker 12'", findRichText: true),
        findsNothing,
      );
      expect(find.byKey(MatchSummaryTab.headlineKey), findsOneWidget);
      expect(find.text('47%'), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(MatchSummaryTab.potmKey),
          matching: find.text('Away Striker'),
        ),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: find.byKey(MatchSummaryTab.stadiumKey),
          matching: find.text(_ground.stadium),
        ),
        findsOneWidget,
      );
      expect(
        find.textContaining('33,000 / 41,250 · 80%', findRichText: true),
        findsOneWidget,
      );
      // The ground's box has no picture: the Stadium tab keeps it.
      expect(find.byType(GroundStill), findsNothing);
      // Full-time results of the rest of the day.
      expect(scoreOf(tester, 501), '3 - 1 | FT');
      expect(scoreOf(tester, 502), '1 - 1 | AET | 4–3 pens');
      // The order: player of the match, the day, the ground, the figures.
      final potm = topOf(tester, MatchSummaryTab.potmKey);
      final day = topOf(tester, MatchSummaryTab.otherMatchesKey);
      final ground = topOf(tester, MatchSummaryTab.stadiumKey);
      final figures = topOf(tester, MatchSummaryTab.headlineKey);
      expect(potm < day && day < ground && ground < figures, isTrue);
    });

    testWidgets('while it is on: the ground first, then the day, live', (
      tester,
    ) async {
      await _pump(tester, summary(fullTime: false));
      expect(find.byKey(MatchSummaryTab.headlineKey), findsNothing);
      expect(find.byKey(MatchSummaryTab.potmKey), findsNothing);
      expect(find.byType(PlayerOfMatchHeader), findsNothing);
      expect(find.byType(GroundStill), findsNothing);
      expect(find.byKey(MatchSummaryTab.attendanceKey), findsOneWidget);
      expect(
        topOf(tester, MatchSummaryTab.stadiumKey),
        lessThan(topOf(tester, MatchSummaryTab.otherMatchesKey)),
      );
      // No spoilers before our break: no score at all, just "live".
      expect(scoreOf(tester, 501), 'LIVE');
      expect(scoreOf(tester, 502), 'LIVE');
      expect(find.text('Bosnia and Herzegovina'), findsOneWidget);
    });

    testWidgets('from our half time their half-time score, then the result', (
      tester,
    ) async {
      await _pump(
        tester,
        summary(fullTime: false, phase: SameDayPhase.halfTime),
      );
      expect(scoreOf(tester, 501), '1 - 1 | HT');
      expect(scoreOf(tester, 502), '0 - 0 | HT');
      await _pump(tester, summary());
      expect(scoreOf(tester, 501), '3 - 1 | FT');
    });

    testWidgets('no other match that day: no card', (tester) async {
      await _pump(tester, summary(sameDay: const []));
      expect(find.byKey(MatchSummaryTab.otherMatchesKey), findsNothing);
      await _pump(tester, summary(fullTime: false, sameDay: const []));
      expect(find.byKey(MatchSummaryTab.otherMatchesKey), findsNothing);
      expect(find.byKey(MatchSummaryTab.stadiumKey), findsOneWidget);
    });

    testWidgets('an old result without a man of the match', (tester) async {
      await _pump(tester, summary(motm: false));
      expect(find.byKey(MatchSummaryTab.potmKey), findsNothing);
      expect(find.byKey(MatchSummaryTab.stadiumKey), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('a tap opens the Player tab, another the Stadium tab', (
      tester,
    ) async {
      await _pump(tester, DefaultTabController(length: 5, child: summary()));
      final controller = DefaultTabController.of(
        tester.element(find.byType(MatchSummaryTab)),
      );
      await tester.tap(find.byKey(MatchSummaryTab.potmKey));
      await tester.pumpAndSettle();
      expect(controller.index, 3);
      await tester.ensureVisible(find.byKey(MatchSummaryTab.stadiumKey));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(MatchSummaryTab.stadiumKey));
      await tester.pumpAndSettle();
      expect(controller.index, 4);
    });

    for (final locale in const ['en', 'cs', 'de']) {
      testWidgets('no overflow at 320 and the largest text in $locale', (
        tester,
      ) async {
        for (final phase in SameDayPhase.values) {
          await _pump(
            tester,
            summary(
              fullTime: phase == SameDayPhase.fullTime,
              phase: phase,
            ),
            size: const Size(320, 640),
            locale: locale,
            scale: 1.4,
          );
          expect(tester.takeException(), isNull);
          await tester.drag(find.byType(ListView), const Offset(0, -3000));
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
        }
      });
    }
  });
}
