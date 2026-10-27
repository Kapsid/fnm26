import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

import '../../helpers/fixtures.dart';

MatchTeam _team(
  int nationId, {
  Formation formation = Formation.f442,
  FullBackPushes fullBacks = FullBackPushes.neutral,
}) {
  final positions = formation.positions;
  return MatchTeam(
    nationId: nationId,
    formation: formation,
    instructions: const TacticalInstructions(),
    fullBacks: fullBacks,
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
        ),
    ],
  );
}

typedef _Tally = ({int shotsFor, int shotsAgainst, int goalsFor, int goals});

/// The arrow side against an identical neutral side, every seed played both
/// ways round on a neutral venue. Paired seeds: the arrows change only the
/// chance RATE, never how many draws a minute takes, so the same seeds line
/// up and the comparison is nearly noise-free.
_Tally _play(
  FullBackPushes fullBacks, {
  Formation formation = Formation.f442,
  int seeds = 1500,
}) {
  const engine = MatchEngine();
  var shotsFor = 0;
  var shotsAgainst = 0;
  var goalsFor = 0;
  var goals = 0;
  for (var i = 0; i < seeds; i++) {
    for (final atHome in const [true, false]) {
      final a = _team(1, formation: formation, fullBacks: fullBacks);
      final b = _team(2, formation: formation);
      final r = engine.play(
        home: atHome ? a : b,
        away: atHome ? b : a,
        rng: SeededRng.forFixture(0xFB0, i),
        neutralVenue: true,
      );
      shotsFor += atHome ? r.homeShots : r.awayShots;
      shotsAgainst += atHome ? r.awayShots : r.homeShots;
      goalsFor += atHome ? r.homeScore : r.awayScore;
      goals += r.homeScore + r.awayScore;
    }
  }
  return (
    shotsFor: shotsFor,
    shotsAgainst: shotsAgainst,
    goalsFor: goalsFor,
    goals: goals,
  );
}

void main() {
  group('the arrows themselves', () {
    test('tap cycle: neutral, up, down, neutral', () {
      expect(FullBackPush.neutral.next, FullBackPush.up);
      expect(FullBackPush.up.next, FullBackPush.down);
      expect(FullBackPush.down.next, FullBackPush.neutral);
      const none = FullBackPushes.neutral;
      expect(none.cycled(FullBackSide.left).left, FullBackPush.up);
      expect(none.cycled(FullBackSide.left).right, FullBackPush.neutral);
    });

    test('count only on a flank that has a full-back', () {
      const both = FullBackPushes(
        left: FullBackPush.up,
        right: FullBackPush.up,
      );
      expect(both.netFor(Formation.f442.positions), 2);
      expect(both.netFor(Formation.f532.positions), 2, reason: 'back five');
      expect(both.netFor(Formation.f352.positions), 0, reason: 'back three');
      const mixed = FullBackPushes(
        left: FullBackPush.up,
        right: FullBackPush.down,
      );
      expect(mixed.netFor(Formation.f433.positions), 0);
      expect(
        FullBackPushes.hasSide(Formation.f343.positions, FullBackSide.left),
        isFalse,
      );
      expect(FullBackPushes.sideOf(PlayerPosition.rb), FullBackSide.right);
    });

    test('a loaded entry with no arrows keeps the current ones', () {
      const mine = FullBackPushes(left: FullBackPush.up);
      expect(mine.overlaidWith(FullBackPushes.neutral), mine);
      const loaded = FullBackPushes(right: FullBackPush.down);
      expect(mine.overlaidWith(loaded), loaded);
    });

    test('a missing or damaged stored value is neutral', () {
      expect(FullBackPushes.fromJson(null), FullBackPushes.neutral);
      expect(FullBackPushes.fromJson('junk'), FullBackPushes.neutral);
      expect(
        FullBackPushes.fromJson(const {'left': 'sideways'}),
        FullBackPushes.neutral,
      );
      const set = FullBackPushes(right: FullBackPush.down);
      expect(FullBackPushes.fromJson(set.toJson()), set);
      expect(FullBackPushes.neutral.toJson(), isEmpty);
    });
  });

  group('the engine (MatchEngine)', () {
    final neutral = _play(FullBackPushes.neutral);
    final up = _play(
      const FullBackPushes(left: FullBackPush.up, right: FullBackPush.up),
    );
    final down = _play(
      const FullBackPushes(left: FullBackPush.down, right: FullBackPush.down),
    );

    test('both up: slightly more chances for AND against', () {
      final forRatio = up.shotsFor / neutral.shotsFor;
      final againstRatio = up.shotsAgainst / neutral.shotsAgainst;
      // Two arrows at about 2.5% each: about +5% at both ends. Slight, not a
      // lever.
      expect(forRatio, inInclusiveRange(1.02, 1.09));
      expect(againstRatio, inInclusiveRange(1.02, 1.09));
    });

    test('both down: slightly fewer chances for AND against', () {
      final forRatio = down.shotsFor / neutral.shotsFor;
      final againstRatio = down.shotsAgainst / neutral.shotsAgainst;
      expect(forRatio, inInclusiveRange(0.91, 0.98));
      expect(againstRatio, inInclusiveRange(0.91, 0.98));
    });

    test('one arrow is about half of two', () {
      final one = _play(const FullBackPushes(left: FullBackPush.up));
      final oneLift = one.shotsFor / neutral.shotsFor - 1;
      final twoLift = up.shotsFor / neutral.shotsFor - 1;
      expect(oneLift, greaterThan(0));
      expect(oneLift / twoLift, inInclusiveRange(0.3, 0.7));
    });

    test('a back three has no full-backs, so its arrows do nothing', () {
      final plain = _play(
        FullBackPushes.neutral,
        formation: Formation.f352,
        seeds: 300,
      );
      final arrows = _play(
        const FullBackPushes(left: FullBackPush.up, right: FullBackPush.up),
        formation: Formation.f352,
        seeds: 300,
      );
      expect(arrows, plain);
    });
  });

  test('a skipped match feels the same lift (RatingMatchSimulator)', () {
    // The skip path multiplies the simulator's openness by
    // [MatchEngine.fullBackOpenness]: about +5% goals at both ends for two
    // arrows up, as in the played engine.
    expect(MatchEngine.fullBackOpenness(0), 1.0);
    expect(MatchEngine.fullBackOpenness(2), closeTo(1.0504, 0.001));
    expect(MatchEngine.fullBackOpenness(-2), closeTo(0.9496, 0.001));
    const sim = RatingMatchSimulator();
    int goals(double openness) {
      var total = 0;
      for (var i = 0; i < 4000; i++) {
        final o = sim.simulate(
          homeStrength: 78,
          awayStrength: 76,
          rng: SeededRng.forFixture(0x5C1, i),
          openness: openness,
        );
        total += o.homeScore + o.awayScore;
      }
      return total;
    }

    final base = goals(1);
    expect(
      goals(MatchEngine.fullBackOpenness(2)) / base,
      inInclusiveRange(1.02, 1.09),
    );
    expect(
      goals(MatchEngine.fullBackOpenness(-2)) / base,
      inInclusiveRange(0.91, 0.98),
    );
  });
}
