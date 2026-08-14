import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

MatchTeam team(
  int nationId,
  int rating, {
  TacticalInstructions instructions = const TacticalInstructions(),
}) {
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
  return MatchTeam(nationId: nationId, xi: xi, instructions: instructions);
}

void main() {
  const engine = MatchEngine();

  test('same teams + same seed produce an identical match', () {
    final home = team(1, 80);
    final away = team(2, 75);
    final a = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(9, 1),
    );
    final b = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(9, 1),
    );

    expect(a.homeScore, b.homeScore);
    expect(a.awayScore, b.awayScore);
    expect(
      a.events.map((e) => '${e.minute}:${e.playerId}').toList(),
      b.events.map((e) => '${e.minute}:${e.playerId}').toList(),
    );
  });

  group('momentum', () {
    test('records a net-momentum series and stays deterministic', () {
      final home = team(1, 80);
      final away = team(2, 78);
      final a = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(5, 2),
      );
      final b = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(5, 2),
      );
      expect(a.momentumByMinute.length, 91);
      expect(a.momentumByMinute, b.momentumByMinute);
    });

    test('a goalless deadlock keeps momentum flat at zero', () {
      // Two weak, ultra-defensive sides rarely score; with no goals, momentum
      // never swings off zero.
      const park = TacticalInstructions(mentality: 5, tempo: 10);
      final a = engine.play(
        home: team(1, 40, instructions: park),
        away: team(2, 40, instructions: park),
        rng: SeededRng.forFixture(1, 1),
      );
      if (a.homeScore == 0 && a.awayScore == 0) {
        expect(a.momentumByMinute.every((m) => m == 0), isTrue);
      }
    });
  });

  group('chemistry', () {
    test('empty chemistry map leaves the match byte-identical to default', () {
      final home = team(1, 80);
      final away = team(2, 76);
      final base = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(7, 3),
      );
      final withMap = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(7, 3),
        chemistryByNation: const {},
      );
      expect(withMap.homeScore, base.homeScore);
      expect(withMap.awayScore, base.awayScore);
    });

    test('a drilled side outscores its unfamiliar self on aggregate', () {
      var drilled = 0;
      var neutral = 0;
      for (var seed = 0; seed < 60; seed++) {
        final home = team(1, 78);
        final away = team(2, 78);
        final rng = SeededRng.forFixture(seed, 11);
        drilled += engine
            .play(
              home: home,
              away: away,
              rng: SeededRng(rng.state),
              chemistryByNation: const {1: 1.06},
            )
            .homeScore;
        neutral += engine
            .play(home: home, away: away, rng: SeededRng(rng.state))
            .homeScore;
      }
      expect(drilled, greaterThan(neutral));
    });
  });

  test('goal events belong to a scoring team and one of its players', () {
    final home = team(1, 82);
    final away = team(2, 70);
    final result = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(3, 7),
    );

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
    final subEvents = a.events
        .where((e) => e.type == MatchEventType.substitution)
        .toList();
    expect(subEvents, hasLength(1));
    expect(subEvents.single.minute, 60);
    expect(subEvents.single.playerName, 'Super Sub');
    expect(subEvents.single.secondaryName, isNotNull);
  });

  test('subbing on a far stronger forward lifts goals over many matches', () {
    var withSub = 0;
    var without = 0;
    // 300 seeds, not 40: one striker's upgrade is worth a fraction of a goal a
    // game, so at 40 the two totals sat a single goal apart and any unrelated
    // tuning (a sending-off costing a little more, say) flipped the sign.
    for (var seed = 0; seed < 300; seed++) {
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

  test(
    'a live tactical change is deterministic and preserves earlier play',
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
      final earlyChanged = a.events
          .where((e) => e.minute < 60)
          .map((e) => e.minute)
          .toList();
      final earlyPlain = plain.events
          .where((e) => e.minute < 60)
          .map((e) => e.minute)
          .toList();
      expect(earlyChanged, earlyPlain);
    },
  );

  test('every player who takes part gets a rating, both teams', () {
    final home = team(1, 80);
    final away = team(2, 78);
    final r = engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(3, 7),
    );
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
      final r = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(seed, seed),
      );
      final scorerIds = r.events
          .where((e) => e.type == MatchEventType.goal && e.teamNationId == 1)
          .map((e) => e.playerId)
          .toSet();
      if (scorerIds.isEmpty) continue;
      final byId = {for (final x in r.ratings) x.playerId: x.rating};
      final scorerAvg =
          scorerIds.map((id) => byId[id]!).reduce((a, b) => a + b) /
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
      final r = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(seed, seed),
      );
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
        final injuries = r.events
            .where((e) => e.type == MatchEventType.injury)
            .toList();
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
            reason:
                'seed $seed: ${hurt.playerName} was hurt at '
                '${hurt.minute}\' and kept playing',
          );
        }
      }
      expect(checked, greaterThan(0), reason: 'no injury ever occurred');
    });
  });

  group('stoppage time', () {
    test('every match plays at least one added minute', () {
      for (var seed = 0; seed < 30; seed++) {
        final r = engine.play(
          home: team(1, 78),
          away: team(2, 76),
          rng: SeededRng.forFixture(seed, 5),
        );
        expect(
          r.stoppage,
          greaterThanOrEqualTo(1),
          reason: 'seed $seed had no stoppage',
        );
        expect(r.stoppage, lessThanOrEqualTo(8));
      }
    });

    test('a stoppage-time goal is tagged 90+X and sits at minute 90', () {
      // Play seeds until a stoppage goal turns up, then check its shape.
      var checked = 0;
      for (var seed = 0; seed < 400 && checked < 3; seed++) {
        final r = engine.play(
          home: team(1, 84),
          away: team(2, 62),
          rng: SeededRng.forFixture(seed, seed),
        );
        final stoppageGoals = r.events.where(
          (e) => e.type == MatchEventType.goal && e.stoppage > 0,
        );
        for (final g in stoppageGoals) {
          expect(g.minute, 90, reason: 'a 90+X event is stored at minute 90');
          expect(g.stoppage, lessThanOrEqualTo(r.stoppage));
          checked++;
        }
      }
      expect(
        checked,
        greaterThan(0),
        reason: 'no stoppage-time goal ever occurred',
      );
    });

    test('stoppage keeps the match deterministic', () {
      final a = engine.play(
        home: team(1, 80),
        away: team(2, 78),
        rng: SeededRng.forFixture(4, 9),
      );
      final b = engine.play(
        home: team(1, 80),
        away: team(2, 78),
        rng: SeededRng.forFixture(4, 9),
      );
      expect(a.stoppage, b.stoppage);
      expect(
        a.events.map((e) => '${e.minute}+${e.stoppage}:${e.playerId}').toList(),
        b.events.map((e) => '${e.minute}+${e.stoppage}:${e.playerId}').toList(),
      );
    });
  });

  group('set-piece takers', () {
    test('a designated penalty taker takes the penalties', () {
      final base = team(1, 80);
      // Pick a defender (low shooting) as the designated penalty taker — the
      // engine would never auto-pick them, so any penalty they score proves the
      // override works.
      final taker = base.xi.firstWhere(
        (p) => p.position.category == PositionCategory.defender,
      );
      var penaltiesByTaker = 0;
      var otherPenalties = 0;
      for (var seed = 0; seed < 300; seed++) {
        final home = MatchTeam(
          nationId: 1,
          xi: base.xi,
          instructions: const TacticalInstructions(),
          penaltyTakerId: taker.id,
        );
        final r = engine.play(
          home: home,
          away: team(2, 78),
          rng: SeededRng.forFixture(seed, 3),
        );
        for (final g in r.events.where(
          (e) =>
              e.type == MatchEventType.goal && e.penalty && e.teamNationId == 1,
        )) {
          if (g.playerId == taker.id) {
            penaltiesByTaker++;
          } else {
            otherPenalties++;
          }
        }
      }
      expect(
        penaltiesByTaker,
        greaterThan(0),
        reason: 'the designated taker should take penalties',
      );
      // Anyone else taking one is the documented fallback — the taker having
      // left the pitch (injury) — so they must be the rare exception.
      expect(
        penaltiesByTaker,
        greaterThan(otherPenalties * 5),
        reason: 'the taker takes the overwhelming majority',
      );
    });
  });

  group('player roles', () {
    test('a poacher takes a bigger share of the goals', () {
      // The same forward, with and without the poacher role, over many seeds.
      final base = team(1, 80);
      final poacherId = base.xi
          .firstWhere((p) => p.position.category == PositionCategory.forward)
          .id;
      int goalsFor(Map<int, PlayerRole> roles) {
        var g = 0;
        for (var seed = 0; seed < 120; seed++) {
          final home = MatchTeam(
            nationId: 1,
            xi: base.xi,
            instructions: const TacticalInstructions(),
            roles: roles,
          );
          final r = engine.play(
            home: home,
            away: team(2, 76),
            rng: SeededRng.forFixture(seed, 4),
          );
          g += r.events
              .where(
                (e) => e.type == MatchEventType.goal && e.playerId == poacherId,
              )
              .length;
        }
        return g;
      }

      expect(
        goalsFor({poacherId: PlayerRole.poacher}),
        greaterThan(goalsFor(const {})),
      );
    });

    test('roles keep the match deterministic', () {
      final home = MatchTeam(
        nationId: 1,
        xi: team(1, 80).xi,
        instructions: const TacticalInstructions(),
        roles: {team(1, 80).xi.first.id: PlayerRole.playmaker},
      );
      final away = team(2, 78);
      final a = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(5, 1),
      );
      final b = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(5, 1),
      );
      expect(a.homeScore, b.homeScore);
      expect(
        a.events.map((e) => '${e.minute}:${e.playerId}').toList(),
        b.events.map((e) => '${e.minute}:${e.playerId}').toList(),
      );
    });
  });

  group('set pieces', () {
    test(
      'set-piece goals occur, are tagged, and belong to the scoring team',
      () {
        final home = team(1, 80);
        final away = team(2, 78);
        final homeIds = home.xi.map((p) => p.id).toSet();
        final awayIds = away.xi.map((p) => p.id).toSet();
        var checked = 0;
        for (var seed = 0; seed < 200 && checked < 5; seed++) {
          final r = engine.play(
            home: home,
            away: away,
            rng: SeededRng.forFixture(seed, 2),
          );
          for (final g in r.events.where(
            (e) => e.type == MatchEventType.goal && e.setPiece,
          )) {
            expect(g.penalty, isFalse, reason: 'set piece is not a penalty');
            final ids = g.teamNationId == 1 ? homeIds : awayIds;
            expect(ids.contains(g.playerId), isTrue);
            checked++;
          }
        }
        expect(
          checked,
          greaterThan(0),
          reason: 'no set-piece goal ever occurred',
        );
      },
    );

    test(
      'a physical side scores more set-piece goals than a weak-aerial one',
      () {
        MatchTeam physical(int nationId, int strength) {
          final positions = Formation.f433.positions;
          final xi = [
            for (var i = 0; i < 11; i++)
              player(
                id: nationId * 100 + i,
                nationId: nationId,
                position: positions[i],
                attributes: flatAttributes(76).copyWith(physical: strength),
              ),
          ];
          return MatchTeam(
            nationId: nationId,
            xi: xi,
            instructions: const TacticalInstructions(),
          );
        }

        var strong = 0;
        var weak = 0;
        for (var seed = 0; seed < 120; seed++) {
          strong += engine
              .play(
                home: physical(1, 95),
                away: physical(2, 55),
                rng: SeededRng.forFixture(seed, 7),
              )
              .events
              .where((e) => e.teamNationId == 1 && e.setPiece)
              .length;
          weak += engine
              .play(
                home: physical(1, 55),
                away: physical(2, 95),
                rng: SeededRng.forFixture(seed, 7),
              )
              .events
              .where((e) => e.teamNationId == 1 && e.setPiece)
              .length;
        }
        expect(strong, greaterThan(weak));
      },
    );
  });

  group('fatigue', () {
    // A team of a given stamina, running flat out (max tempo + press) so legs
    // empty over the 90 — the sharper test of whether fatigue bites.
    MatchTeam staTeam(int nationId, int stamina) {
      final positions = Formation.f433.positions;
      final xi = [
        for (var i = 0; i < 11; i++)
          player(
            id: nationId * 100 + i,
            nationId: nationId,
            position: positions[i],
            attributes: flatAttributes(78).copyWith(stamina: stamina),
          ),
      ];
      return MatchTeam(
        nationId: nationId,
        xi: xi,
        instructions: const TacticalInstructions(tempo: 100, pressing: 100),
      );
    }

    test('a high-stamina side outscores an identical low-stamina one', () {
      var fresh = 0;
      var spent = 0;
      for (var seed = 0; seed < 80; seed++) {
        fresh += engine
            .play(
              home: staTeam(1, 95),
              away: staTeam(2, 30),
              rng: SeededRng.forFixture(seed, 6),
            )
            .homeScore;
        // Same fixture, roles reversed: now the home side is the tired one.
        spent += engine
            .play(
              home: staTeam(1, 30),
              away: staTeam(2, 95),
              rng: SeededRng.forFixture(seed, 6),
            )
            .homeScore;
      }
      expect(fresh, greaterThan(spent));
    });

    test('a tired side commits more fouls and knocks on aggregate', () {
      bool foulOrKnock(MatchEventType t) =>
          t == MatchEventType.yellowCard ||
          t == MatchEventType.redCard ||
          t == MatchEventType.injury;
      var freshCards = 0;
      var tiredCards = 0;
      for (var seed = 0; seed < 120; seed++) {
        freshCards += engine
            .play(
              home: staTeam(1, 95),
              away: staTeam(2, 78),
              rng: SeededRng.forFixture(seed, 8),
            )
            .events
            .where((e) => e.teamNationId == 1 && foulOrKnock(e.type))
            .length;
        tiredCards += engine
            .play(
              home: staTeam(1, 25),
              away: staTeam(2, 78),
              rng: SeededRng.forFixture(seed, 8),
            )
            .events
            .where((e) => e.teamNationId == 1 && foulOrKnock(e.type))
            .length;
      }
      expect(tiredCards, greaterThan(freshCards));
    });
  });

  group('team talks', () {
    test('a talk keeps the match deterministic', () {
      final home = team(1, 80);
      final away = team(2, 78);
      const talk = TeamTalk(
        teamNationId: 1,
        minute: 46,
        tone: TeamTalkTone.demandMore,
      );
      final a = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(9, 1),
        talks: const [talk],
      );
      final b = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(9, 1),
        talks: const [talk],
      );
      expect(a.homeXg, b.homeXg);
      expect(a.homeScore, b.homeScore);
    });

    test('"demand more" lifts the side\'s attacking output on aggregate', () {
      final home = team(1, 78);
      final away = team(2, 78);
      var withTalk = 0.0;
      var without = 0.0;
      for (var seed = 0; seed < 120; seed++) {
        without += engine
            .play(home: home, away: away, rng: SeededRng.forFixture(seed, 1))
            .homeXg;
        withTalk += engine
            .play(
              home: home,
              away: away,
              rng: SeededRng.forFixture(seed, 1),
              talks: const [
                TeamTalk(
                  teamNationId: 1,
                  minute: 46,
                  tone: TeamTalkTone.demandMore,
                ),
              ],
            )
            .homeXg;
      }
      expect(withTalk, greaterThan(without));
    });

    test('"keep it tight" reduces the goals a side concedes on aggregate', () {
      final home = team(1, 78);
      final away = team(2, 78);
      var withTalk = 0.0;
      var without = 0.0;
      for (var seed = 0; seed < 120; seed++) {
        without += engine
            .play(home: home, away: away, rng: SeededRng.forFixture(seed, 3))
            .awayXg;
        withTalk += engine
            .play(
              home: home,
              away: away,
              rng: SeededRng.forFixture(seed, 3),
              talks: const [
                TeamTalk(
                  teamNationId: 1,
                  minute: 46,
                  tone: TeamTalkTone.praise,
                ),
              ],
            )
            .awayXg;
      }
      expect(withTalk, lessThan(without));
    });
  });

  group('tactical match-ups', () {
    // Aggregate the home side's xG across many seeds, so we compare the tactical
    // tendency rather than one noisy match.
    double homeXg(MatchTeam h, MatchTeam a, {int runs = 150}) {
      var sum = 0.0;
      for (var s = 0; s < runs; s++) {
        sum += engine
            .play(home: h, away: a, rng: SeededRng.forFixture(s, 1))
            .homeXg;
      }
      return sum;
    }

    final direct = team(
      1,
      78,
      instructions: const TacticalInstructions(directness: 90),
    );
    final possession = team(
      1,
      78,
      instructions: const TacticalInstructions(directness: 10),
    );

    test('direct play beats a HIGH defensive line (space in behind)', () {
      final highLine = team(
        2,
        78,
        instructions: const TacticalInstructions(defensiveLine: 90),
      );
      expect(
        homeXg(direct, highLine),
        greaterThan(homeXg(possession, highLine)),
      );
    });

    test('but a DEEP line turns the same direct plan wasteful (a counter)', () {
      final deep = team(
        2,
        78,
        instructions: const TacticalInstructions(defensiveLine: 10),
      );
      // No space in behind: direct is no better than keeping the ball.
      expect(homeXg(direct, deep), lessThan(homeXg(possession, deep)));
    });

    test(
      'a high press strangles slow build-up but direct plays through it',
      () {
        final press = team(
          2,
          78,
          instructions: const TacticalInstructions(pressing: 90),
        );
        expect(homeXg(direct, press), greaterThan(homeXg(possession, press)));
      },
    );

    test('attacking wide into a narrow defence beats wide-vs-wide', () {
      final wide = team(
        1,
        78,
        instructions: const TacticalInstructions(width: 90),
      );
      final narrowDef = team(
        2,
        78,
        instructions: const TacticalInstructions(width: 10),
      );
      final wideDef = team(
        2,
        78,
        instructions: const TacticalInstructions(width: 90),
      );
      // The width edge is the smallest of the tactical swings — about two parts
      // in a thousand — so it needs far more samples than the default to rise
      // clear of match-to-match noise. At 800 runs the ordering flips on any
      // change that merely shifts the RNG stream.
      expect(
        homeXg(wide, narrowDef, runs: 3000),
        greaterThan(homeXg(wide, wideDef, runs: 3000)),
      );
    });

    test('the match-up keeps the game deterministic', () {
      final a = engine.play(home: direct, away: possession, rng: SeededRng(3));
      final b = engine.play(home: direct, away: possession, rng: SeededRng(3));
      expect(a.homeXg, b.homeXg);
    });
  });

  group('reactive AI management', () {
    test('managing a side keeps the match deterministic', () {
      final home = team(1, 82);
      final away = team(2, 68);
      final a = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(5, 2),
        aiManagedNationIds: const {2},
      );
      final b = engine.play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(5, 2),
        aiManagedNationIds: const {2},
      );
      expect(a.awayXg, b.awayXg);
      expect(
        a.events.map((e) => '${e.minute}:${e.playerId}').toList(),
        b.events.map((e) => '${e.minute}:${e.playerId}').toList(),
      );
    });

    test(
      'a managed underdog that trails commits forward late, raising its xG',
      () {
        // A weak away side against a strong home side trails often, so from the
        // hour mark the reactive manager pushes it forward — lifting its xG.
        final home = team(1, 84);
        final away = team(2, 66);
        var managed = 0.0;
        var unmanaged = 0.0;
        for (var seed = 0; seed < 200; seed++) {
          unmanaged += engine
              .play(home: home, away: away, rng: SeededRng.forFixture(seed, 4))
              .awayXg;
          managed += engine
              .play(
                home: home,
                away: away,
                rng: SeededRng.forFixture(seed, 4),
                aiManagedNationIds: const {2},
              )
              .awayXg;
        }
        expect(managed, greaterThan(unmanaged));
      },
    );
  });
}
