import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/stadium/match_weather.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/match/pitch/pitch_view_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/pitch_view_fixture.dart' show pitchNation;
import '../helpers/seeded_save.dart' show enL;

/// The kick-off time and the weather the venue card writes are the 2D TV's
/// own: the same function draws both, from the save's seed and the
/// fixture, never from a match attempt's dice.
void main() {
  MatchPreview preview({
    required int id,
    required String? round,
    required DateTime date,
    required String home,
    required String away,
    required String ground,
    required int saveSeed,
  }) {
    final h = pitchNation(home);
    final a = pitchNation(away);
    final g = pitchNation(ground);
    MatchTeam team(int nationId) => MatchTeam(
      nationId: nationId,
      formation: Formation.f433,
      instructions: const TacticalInstructions(),
      xi: const [],
    );
    return MatchPreview(
      fixture: Fixture(
        id: id,
        careerId: 1,
        competitionId: 1,
        matchday: 1,
        date: date,
        homeNationId: h.id,
        awayNationId: a.id,
        round: round,
      ),
      result: const MatchResult(
        homeScore: 0,
        awayScore: 0,
        events: [],
        homeShots: 0,
        awayShots: 0,
        homePossession: 50,
      ),
      nations: {h.id: h, a.id: a, g.id: g},
      homeTeam: team(h.id),
      awayTeam: team(a.id),
      playerNationId: h.id,
      bench: const [],
      saveSeed: saveSeed,
      neutralVenue: g.id != h.id,
      ground: (
        stadium: 'Test Park',
        city: 'Somewhere',
        groundNationId: g.id,
        capacity: 30000,
        attendance: 27000,
        soldOut: false,
      ),
    );
  }

  final fixtures = [
    for (var i = 0; i < 40; i++)
      preview(
        id: 100 + i * 37,
        round: const [
          null,
          'CQ',
          'FRIENDLY',
          'GROUP',
          'QF',
          'FINAL',
          'CGROUP',
          'C3RD',
          'NL',
          'POSF',
        ][i % 10],
        date: DateTime(2026 + i % 4, 1 + (i * 5) % 12, 1 + (i * 7) % 28),
        home: const ['CZE', 'NOR', 'BRA', 'QAT', 'JPN', 'MAR'][i % 6],
        away: const ['POR', 'ENG', 'ARG', 'KSA', 'KOR', 'SEN'][i % 6],
        ground: const ['CZE', 'NOR', 'BRA', 'QAT', 'FIN', 'USA'][(i * 5) % 6],
        saveSeed: 7 + i * 1009,
      ),
  ];

  test('the text and the 2D TV agree, kick-off and weather, for every '
      'fixture', () {
    final kinds = <WeatherKind>{};
    for (final p in fixtures) {
      final shown = matchConditionsShown(p);
      final stadium = pitchStadiumForPreview(p);
      expect(shown.kickOff, stadium.kickOff, reason: '${p.fixture.id}');
      expect(shown.weather, stadium.spec.weather, reason: '${p.fixture.id}');
      kinds.add(shown.weather);
    }
    // A spread of grounds and dates: more than one kind of weather.
    expect(kinds.length, greaterThan(1));
  });

  test('a pinned weather pins both', () {
    for (final w in WeatherKind.values) {
      final p = fixtures.first;
      expect(matchConditionsShown(p, weather: w).weather, w);
      expect(pitchStadiumForPreview(p, weather: w).spec.weather, w);
    }
  });

  testWidgets('the venue card writes "Kick-off 20:45 · Rain" with its icon', (
    tester,
  ) async {
    final p = fixtures[3];
    final shown = matchConditionsShown(p, weather: WeatherKind.rain);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: GroundCard(
            ground: p.ground,
            kickOff: shown.kickOff,
            weather: shown.weather,
          ),
        ),
      ),
    );
    final line = find.byKey(GroundCard.conditionsKey);
    expect(line, findsOneWidget);
    expect(
      find.descendant(
        of: line,
        matching: find.text(
          '${enL.matchConditionsKickOff} ${shown.kickOff.label} · '
          '${enL.matchWeatherRain}',
        ),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: line, matching: find.byIcon(Icons.umbrella_rounded)),
      findsOneWidget,
    );
  });
}
