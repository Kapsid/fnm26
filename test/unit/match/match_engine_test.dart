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

  test('a clear favourite wins the majority of matches (upsets are rare)', () {
    final strong = team(1, 84);
    final weak = team(2, 62);
    var strongWins = 0;
    var draws = 0;
    const n = 80;
    for (var seed = 0; seed < n; seed++) {
      final r = engine.play(
        home: strong,
        away: weak,
        rng: SeededRng.forFixture(seed * 7 + 1, seed),
      );
      if (r.homeScore > r.awayScore) {
        strongWins++;
      } else if (r.homeScore == r.awayScore) {
        draws++;
      }
    }
    // The stronger side should win well over half and lose only occasionally.
    expect(strongWins / n, greaterThan(0.6));
    expect((n - strongWins - draws) / n, lessThan(0.2)); // weak wins are rare
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

  test('a live tactical change is deterministic and preserves earlier play',
      () {
    final home = team(1, 78);
    final away = team(2, 78);
    // Same starting XI, in a fresh 4-3-3, from minute 60.
    final change = TacticalChange(
      teamNationId: 1,
      minute: 60,
      formation: Formation.f433,
      instructions: const TacticalInstructions(mentality: 80),
      xi: home.xi,
    );
    final a = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(11, 4),
      changes: [change],
    );
    final b = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(11, 4),
      changes: [change],
    );
    expect(a.homeScore, b.homeScore);
    expect(a.awayScore, b.awayScore);

    // Minutes before the change match a run with no change at all.
    final plain = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(11, 4),
    );
    final earlyChanged =
        a.events.where((e) => e.minute < 60).map((e) => e.minute).toList();
    final earlyPlain =
        plain.events.where((e) => e.minute < 60).map((e) => e.minute).toList();
    expect(earlyChanged, earlyPlain);
  });

  test('every player who takes part gets a rating, both teams', () {
    final home = team(1, 80);
    final away = team(2, 78);
    final r = engine.play(home: home, away: away, rng: SeededRng.forFixture(3, 7));
    final rated = r.ratings.map((x) => x.playerId).toSet();
    expect(rated, containsAll(home.xi.map((p) => p.id)));
    expect(rated, containsAll(away.xi.map((p) => p.id)));
    expect(r.ratings.every((x) => x.rating >= 3.0 && x.rating <= 10.0), isTrue);
  });

  test('a scorer is rated above a team-mate who did nothing', () {
    // Play many seeds; whenever a home player scores, they outrate the average.
    var checks = 0;
    for (var seed = 0; seed < 60 && checks < 5; seed++) {
      final home = team(1, 80);
      final away = team(2, 62);
      final r =
          engine.play(home: home, away: away, rng: SeededRng.forFixture(seed, seed));
      final scorerIds = r.events
          .where((e) => e.type == MatchEventType.goal && e.teamNationId == 1)
          .map((e) => e.playerId)
          .toSet();
      if (scorerIds.isEmpty) continue;
      final byId = {for (final x in r.ratings) x.playerId: x.rating};
      final scorerAvg = scorerIds.map((id) => byId[id]!).reduce((a, b) => a + b) /
          scorerIds.length;
      expect(scorerAvg, greaterThan(6.5));
      checks++;
    }
    expect(checks, greaterThan(0));
  });

  test('assists name a team-mate of the scorer, never the scorer', () {
    for (var seed = 0; seed < 40; seed++) {
      final home = team(1, 82);
      final away = team(2, 80);
      final r =
          engine.play(home: home, away: away, rng: SeededRng.forFixture(seed, seed));
      for (final e in r.events.where((e) => e.type == MatchEventType.goal)) {
        if (e.assistPlayerId == null) continue;
        expect(e.assistPlayerId, isNot(e.playerId));
        final teamIds = (e.teamNationId == 1 ? home : away).xi.map((p) => p.id);
        expect(teamIds, contains(e.assistPlayerId));
      }
    }
  });

  test('bringing a stronger XI on lifts goals over many matches', () {
    var withChange = 0;
    var without = 0;
    for (var seed = 0; seed < 40; seed++) {
      final home = team(1, 68);
      final away = team(2, 68);
      // From minute 1, swap the whole XI for a far stronger one.
      final strongXi = [
        for (var i = 0; i < 11; i++)
          player(
            id: 900 + i,
            nationId: 1,
            position: Formation.f433.positions[i],
            attributes: flatAttributes(95),
          ),
      ];
      final change = TacticalChange(
        teamNationId: 1,
        minute: 1,
        formation: Formation.f433,
        instructions: const TacticalInstructions(),
        xi: strongXi,
      );
      withChange += engine
          .play(
            home: home,
            away: away,
            rng: SeededRng.forFixture(seed, seed),
            changes: [change],
          )
          .homeScore;
      without += engine
          .play(home: home, away: away, rng: SeededRng.forFixture(seed, seed))
          .homeScore;
    }
    expect(withChange, greaterThan(without));
  });

  group('injuries', () {
    test('a hurt player leaves the pitch and cannot score afterwards', () {
      // Regression: the injury event was emitted but the player was never
      // removed, so he played the rest of the match at full strength — the
      // knock cost nothing until the NEXT game, and declining the substitution
      // was free.
      var checked = 0;
      for (var seed = 0; seed < 400 && checked < 5; seed++) {
        final r = const MatchEngine().play(
          home: team(1, 80),
          away: team(2, 80),
          rng: SeededRng(seed),
        );
        final injuries =
            r.events.where((e) => e.type == MatchEventType.injury).toList();
        if (injuries.isEmpty) continue;
        checked++;
        for (final hurt in injuries) {
          final after = r.events.where(
            (e) =>
                e.minute > hurt.minute &&
                e.playerId == hurt.playerId &&
                (e.type == MatchEventType.goal ||
                    e.type == MatchEventType.yellowCard ||
                    e.type == MatchEventType.redCard),
          );
          expect(
            after,
            isEmpty,
            reason: 'seed $seed: ${hurt.playerName} was hurt at '
                '${hurt.minute}\' and kept playing',
          );
        }
      }
      expect(checked, greaterThan(0), reason: 'no injury ever occurred');
    });
  });
}
