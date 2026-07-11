import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

MatchTeam team(int nationId, int rating) {
  final positions = Formation.f433.positions;
  final xi = [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + i,
        nationId: nationId,
        position: positions[i],
        attributes: flatAttributes(rating),
      ),
  ];
  return MatchTeam(
    nationId: nationId,
    xi: xi,
    instructions: const TacticalInstructions(),
  );
}

void main() {
  const engine = MatchEngine();

  test('same teams + same seed produce an identical match', () {
    final home = team(1, 80);
    final away = team(2, 75);
    final a = engine.play(home: home, away: away, rng: SeededRng.forFixture(9, 1));
    final b = engine.play(home: home, away: away, rng: SeededRng.forFixture(9, 1));

    expect(a.homeScore, b.homeScore);
    expect(a.awayScore, b.awayScore);
    expect(a.events.map((e) => '${e.minute}:${e.playerId}').toList(),
        b.events.map((e) => '${e.minute}:${e.playerId}').toList());
  });

  test('goal events belong to a scoring team and one of its players', () {
    final home = team(1, 82);
    final away = team(2, 70);
    final result =
        engine.play(home: home, away: away, rng: SeededRng.forFixture(3, 7));

    final homeIds = home.xi.map((p) => p.id).toSet();
    final awayIds = away.xi.map((p) => p.id).toSet();
    var homeGoals = 0;
    var awayGoals = 0;
    for (final e in result.events) {
      if (e.type != MatchEventType.goal) continue;
      if (e.teamNationId == 1) {
        expect(homeIds.contains(e.playerId), isTrue);
        homeGoals++;
      } else {
        expect(awayIds.contains(e.playerId), isTrue);
        awayGoals++;
      }
    }
    expect(homeGoals, result.homeScore);
    expect(awayGoals, result.awayScore);
  });

  test('a substitution is deterministic and recorded as an event', () {
    final home = team(1, 80);
    final away = team(2, 78);
    final sub = Substitution(
      teamNationId: 1,
      minute: 60,
      offId: home.xi.last.id,
      on: player(
        id: 999,
        nationId: 1,
        name: 'Super Sub',
        position: home.xi.last.position,
        attributes: flatAttributes(95),
      ),
    );
    final a = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(5, 2),
      subs: [sub],
    );
    final b = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(5, 2),
      subs: [sub],
    );

    expect(a.homeScore, b.homeScore);
    final subEvents =
        a.events.where((e) => e.type == MatchEventType.substitution).toList();
    expect(subEvents, hasLength(1));
    expect(subEvents.single.minute, 60);
    expect(subEvents.single.playerName, 'Super Sub');
    expect(subEvents.single.secondaryName, isNotNull);
  });

  test('subbing on a far stronger forward lifts goals over many matches', () {
    var withSub = 0;
    var without = 0;
    for (var seed = 0; seed < 40; seed++) {
      final home = team(1, 70);
      final away = team(2, 70);
      final on = player(
        id: 999,
        nationId: 1,
        position: home.xi.last.position,
        attributes: flatAttributes(99),
      );
      final sub = Substitution(
        teamNationId: 1,
        minute: 1,
        offId: home.xi.last.id,
        on: on,
      );
      withSub += engine
          .play(
            home: home,
            away: away,
            rng: SeededRng.forFixture(seed, seed),
            subs: [sub],
          )
          .homeScore;
      without += engine
          .play(home: home, away: away, rng: SeededRng.forFixture(seed, seed))
          .homeScore;
    }
    expect(withSub, greaterThan(without));
  });

  test('stronger teams outscore weaker ones across many matches', () {
    final strong = team(1, 86);
    final weak = team(2, 56);
    var strongGoals = 0;
    var weakGoals = 0;
    for (var seed = 0; seed < 30; seed++) {
      final r = engine.play(
        home: strong,
        away: weak,
        rng: SeededRng.forFixture(seed, seed),
      );
      strongGoals += r.homeScore;
      weakGoals += r.awayScore;
    }
    expect(strongGoals, greaterThan(weakGoals));
  });
}
