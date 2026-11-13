import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/set_piece_order.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';

import '../../helpers/fixtures.dart';

List<Player> _xi(int nationId) {
  final positions = Formation.f433.positions;
  return [
    for (var i = 0; i < 11; i++)
      player(
        id: nationId * 100 + i,
        nationId: nationId,
        position: positions[i],
        attributes: flatAttributes(78),
      ),
  ];
}

MatchTeam _home(SetPieceOrder order) => MatchTeam(
  nationId: 1,
  xi: _xi(1),
  instructions: const TacticalInstructions(),
  setPieceOrder: order,
);

final MatchTeam _away = MatchTeam(
  nationId: 2,
  xi: _xi(2),
  instructions: const TacticalInstructions(),
);

/// Ordered takers in the engine: the first listed still on the pitch steps
/// up, and each corner flag sends its own man.
void main() {
  const engine = MatchEngine();

  test('the second penalty taker steps up when the first is off', () {
    const first = 102, second = 103, third = 104;
    var bySecond = 0, byOthers = 0;
    for (var seed = 0; seed < 400; seed++) {
      final r = engine.play(
        home: _home(
          const SetPieceOrder(penalties: [first, second, third]),
        ),
        away: _away,
        rng: SeededRng.forFixture(seed, 3),
        subs: [
          Substitution(
            teamNationId: 1,
            minute: 1,
            offId: first,
            on: player(id: 150, nationId: 1),
          ),
        ],
      );
      for (final g in r.events.where(
        (e) =>
            e.type == MatchEventType.goal &&
            e.penalty &&
            e.teamNationId == 1 &&
            !e.ownGoal,
      )) {
        if (g.playerId == second) {
          bySecond++;
        } else {
          byOthers++;
        }
      }
    }
    expect(bySecond, greaterThan(0));
    // The second man leaving the pitch himself (injured, sent off) is the
    // only way anybody else takes one.
    expect(bySecond, greaterThan(byOthers * 5));
  });

  test('a man named mid-match heads the order from that minute', () {
    const first = 102, second = 103;
    var afterBySecond = 0, afterByFirst = 0;
    for (var seed = 0; seed < 400; seed++) {
      final xi = _xi(1);
      final r = engine.play(
        home: _home(const SetPieceOrder(penalties: [first])),
        away: _away,
        rng: SeededRng.forFixture(seed, 3),
        changes: [
          TacticalChange(
            teamNationId: 1,
            minute: 60,
            formation: Formation.f433,
            instructions: const TacticalInstructions(),
            xi: xi,
            takers: const SetPieceOrder(penalties: [second, first]),
          ),
        ],
      );
      for (final g in r.events.where(
        (e) =>
            e.type == MatchEventType.goal &&
            e.penalty &&
            e.teamNationId == 1 &&
            e.minute >= 60,
      )) {
        if (g.playerId == second) afterBySecond++;
        if (g.playerId == first) afterByFirst++;
      }
    }
    expect(afterBySecond, greaterThan(0));
    expect(afterBySecond, greaterThan(afterByFirst * 5));
  });

  test('each corner flag sends its own taker, free kicks theirs', () {
    const left = 102, right = 106, freeKick = 108;
    var leftCorners = 0, rightCorners = 0, freeKicks = 0;
    for (var seed = 0; seed < 150; seed++) {
      final r = engine.play(
        home: _home(
          const SetPieceOrder(
            freeKicks: [freeKick],
            cornersLeft: [left],
            cornersRight: [right],
          ),
        ),
        away: _away,
        rng: SeededRng.forFixture(seed, 5),
      );
      // When each man left the pitch (a knock or a red), if he did: the
      // coach's pick takes over from then on, which is right.
      final goneAt = <int, int>{
        for (final e in r.events)
          if (e.teamNationId == 1 &&
              (e.type == MatchEventType.injury ||
                  e.type == MatchEventType.redCard))
            e.playerId: e.minute,
      };
      final ms = r.moments;
      for (var i = 0; i < ms.length; i++) {
        final m = ms[i];
        if (m is! SetPieceMoment || m.teamNationId != 1) continue;
        final next = i + 1 < ms.length ? ms[i + 1] : null;
        // The man heading it in cannot also deliver it: the next listed (or
        // the engine's pick) does, and that is right.
        bool shooterIs(int id) => next is ShotMoment && next.shooterId == id;
        bool gone(int id) => (goneAt[id] ?? 999) <= m.minute;
        switch (m.kind) {
          case SetPieceKind.corner:
            final expected = m.left ? left : right;
            if (shooterIs(expected) || gone(expected)) continue;
            expect(m.takerId, expected, reason: 'seed $seed corner $m');
            m.left ? leftCorners++ : rightCorners++;
          case SetPieceKind.freeKick when !m.routine:
            // A dangerous free kick, or a crossed one ahead of a header.
            if (shooterIs(freeKick) || gone(freeKick)) continue;
            expect(m.takerId, freeKick, reason: 'seed $seed free kick');
            freeKicks++;
          default:
        }
      }
    }
    expect(leftCorners, greaterThan(20));
    expect(rightCorners, greaterThan(20));
    expect(freeKicks, greaterThan(20));
  });

  test('a corner flag with nobody on the pitch falls back to the coach', () {
    for (var seed = 0; seed < 40; seed++) {
      final r = engine.play(
        home: _home(const SetPieceOrder(cornersLeft: [999])),
        away: _away,
        rng: SeededRng.forFixture(seed, 5),
      );
      for (final m in r.moments.whereType<SetPieceMoment>()) {
        expect(m.takerId, isNot(999));
      }
    }
  });

  test('an explicit one-man order plays exactly as the pair', () {
    final xi = _xi(1);
    for (var seed = 0; seed < 30; seed++) {
      final pair = engine.play(
        home: MatchTeam(
          nationId: 1,
          xi: xi,
          instructions: const TacticalInstructions(),
          penaltyTakerId: 103,
          deadBallTakerId: 107,
        ),
        away: _away,
        rng: SeededRng.forFixture(seed, 9),
      );
      final order = engine.play(
        home: MatchTeam(
          nationId: 1,
          xi: xi,
          instructions: const TacticalInstructions(),
          setPieceOrder: SetPieceOrder.single(penalty: 103, deadBall: 107),
        ),
        away: _away,
        rng: SeededRng.forFixture(seed, 9),
      );
      expect(order.moments, pair.moments);
      expect(
        order.events.map((e) => '${e.minute}:${e.playerId}:${e.type}'),
        pair.events.map((e) => '${e.minute}:${e.playerId}:${e.type}'),
      );
    }
  });
}
