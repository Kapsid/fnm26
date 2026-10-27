import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_bracket.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// Playtest: "sometimes a problem in KO rounds that team names got cut".
///
/// A knockout tie row gives each side half a phone's width, less a flag, a
/// tick and the scoreline. Names over fourteen letters fell back to the code,
/// and the ones under that still ellipsised. Every name here has to arrive
/// whole, unbroken mid-word, and still readable.
void main() {
  const longNames = [
    'Bosnia and Herzegovina',
    'Central African Republic',
    'Trinidad and Tobago',
    'Saint Vincent and the Grenadines',
    // Long translations.
    'Zentralafrikanische Republik',
    'St. Vincent und die Grenadinen',
    'Keski-Afrikan tasavalta',
    'Saint Vincent és a Grenadine-szigetek',
    'Άγιος Βικέντιος και Γρεναδίνες',
    'Κεντροαφρικανική Δημοκρατία',
  ];
  String name(int id) => longNames[id % longNames.length];
  String code(int id) => 'N$id';

  Fixture tie(int home, int away) => Fixture(
    id: home * 100 + away,
    careerId: 1,
    competitionId: 1,
    matchday: 1,
    date: DateTime(2030, 6, 20),
    homeNationId: home,
    awayNationId: away,
    homeScore: 1,
    awayScore: 1,
    homePenalties: 4,
    awayPenalties: 3,
    played: true,
    round: 'QF',
  );

  void phone(WidgetTester tester, double width) {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = Size(width, 1600);
    addTearDown(tester.view.reset);
  }

  void expectAllWhole(WidgetTester tester, Iterable<String> names) {
    expect(tester.takeException(), isNull);
    expectNothingCut(tester, 'the knockout round');
    for (final n in names) {
      final f = find.text(n);
      expectNoBrokenWord(f, n);
      for (final e in f.evaluate()) {
        expectLegible(tester, find.byWidget(e.widget).first, n);
      }
    }
  }

  for (final width in [320.0, 360.0]) {
    testWidgets('a knockout round list keeps long names whole at $width', (
      tester,
    ) async {
      phone(tester, width);
      await tester.pumpApp(
        Scaffold(
          body: TournamentBracket(
            fixtures: [
              for (var i = 0; i < longNames.length; i += 2) tie(i, i + 1),
            ],
            rounds: const [('QF', 'Quarter-finals')],
            ladder: const [('QF', 'QF')],
            playerNationId: 0,
            code: code,
            name: name,
          ),
        ),
      );
      await tester.pumpAndSettle();
      expectAllWhole(tester, longNames);
    });
  }

  testWidgets('the intercontinental play-off keeps long names whole', (
    tester,
  ) async {
    phone(tester, 360);
    PlayoffTie t(int h, int a, {bool fin = false}) => (
      home: h,
      away: a,
      homeScore: 2,
      awayScore: 1,
      winner: h,
      isFinal: fin,
    );
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: IntercontinentalPlayoffBracket(
            ties: [t(1, 3), t(5, 7), t(9, 1, fin: true), t(2, 5, fin: true)],
            code: code,
            name: name,
            playerNationId: 1,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expectAllWhole(tester, {
      for (final id in [1, 3, 5, 7, 9, 2]) name(id),
    });
  });
}
