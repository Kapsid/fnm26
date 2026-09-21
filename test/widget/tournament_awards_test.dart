import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/competition/tournament_stars.dart';
import 'package:fnm/features/tournaments/tournament_awards.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

Player _p(int id, String name, PlayerPosition pos) => Player(
  id: id,
  nationId: 1,
  name: name,
  position: pos,
  age: 27,
  club: 'C',
  attributes: const PlayerAttributes(
    physical: 80,
    technical: 80,
    stamina: 80,
  ),
);

StarPlayer _star(
  int id,
  String name,
  PlayerPosition pos, {
  double rating = 7.4,
  int goals = 0,
  int apps = 6,
}) => StarPlayer(
  player: _p(id, name, pos),
  goals: goals,
  score: rating * 10,
  apps: apps,
  meanRating: rating,
  motms: 1,
);

/// The Team of the Tournament shows the mark that earned each place.
///
/// The award used to be picked from squad rating and goals, because per-match
/// ratings existed only for the manager's own fixtures — so the card was a list
/// of famous names with no evidence behind it.
void main() {
  testWidgets('each pick shows the average rating behind it', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 780)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: TeamOfTournamentCard(
            stars: [
              _star(1, 'Keeper', PlayerPosition.gk, rating: 7.21),
              _star(2, 'Stopper', PlayerPosition.cb, rating: 7.85),
              _star(3, 'Runner', PlayerPosition.cm, rating: 8.02),
              _star(4, 'Finisher', PlayerPosition.st, rating: 7.6, goals: 5),
            ],
            code: (_) => 'ESP',
            name: (_) => 'Spain',
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('TEAM OF THE TOURNAMENT'), findsOneWidget);
    for (final mark in ['7.21', '7.85', '8.02', '7.60']) {
      expect(find.text(mark), findsOneWidget, reason: 'the mark is the reason');
    }
    // A defender can make the team, and does here on his mark alone.
    expect(find.text('Stopper'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });

  testWidgets('an unrated edition still renders without marks', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(360, 780)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpApp(
      Scaffold(
        body: TeamOfTournamentCard(
          // apps 0 = an edition played before per-match ratings existed.
          stars: [_star(1, 'Legend', PlayerPosition.st, apps: 0)],
          code: (_) => 'ITA',
          name: (_) => 'Italy',
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Legend'), findsOneWidget);
    expect(find.text('7.40'), findsNothing, reason: 'no marks to show');
    expect(tester.takeException(), isNull);
    expectNothingCut(tester);
  });
}
