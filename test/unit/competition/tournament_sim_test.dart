import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/competition/tournament_sim.dart';

void main() {
  test('runs a knockout and returns distinct medallists from the pool', () {
    final teams = [for (var i = 1; i <= 16; i++) i];
    final strength = {for (final id in teams) id: 220 - id};
    final r = TournamentSim.run(
      seededByStrength: teams,
      strengthById: strength,
      seed: 99,
    )!;
    expect(teams, contains(r.champion));
    expect(teams, contains(r.runnerUp));
    expect(r.champion, isNot(r.runnerUp));
    expect(r.finalHome, greaterThan(r.finalAway));
  });

  test('returns null for fewer than four teams', () {
    expect(
      TournamentSim.run(
        seededByStrength: [1, 2],
        strengthById: {1: 10, 2: 10},
        seed: 1,
      ),
      isNull,
    );
  });

  test('a dominant favourite wins most of the time', () {
    final teams = [for (var i = 1; i <= 8; i++) i];
    // Team 1 is far stronger than the rest.
    final strength = {for (final id in teams) id: id == 1 ? 1000 : 20};
    var topWins = 0;
    for (var s = 0; s < 60; s++) {
      final r = TournamentSim.run(
        seededByStrength: teams,
        strengthById: strength,
        seed: s,
      )!;
      if (r.champion == 1) topWins++;
    }
    expect(topWins, greaterThan(40));
  });
}
