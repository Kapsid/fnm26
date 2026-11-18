import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/big_game_difficulty.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/mid_tier_difficulty.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/knockout_lab.dart';

/// The 1.1.2 big-game difficulty (`BigGameDifficulty`): a finals knockout
/// against a stronger side is harder for a near-top nation the manager runs,
/// an elite or a minnow side and every level tie play as before, and nothing
/// moves in a cycle without the `difficulty2` marker.
///
/// The lab cells are paired (the same seeds with the package on and off).
/// `FNM_KO_LAB=1` on `big_game_difficulty_lab_test.dart` prints the full table.
void main() {
  group('which ties', () {
    test('World Championship and continental finals knockouts, by stage', () {
      const stages = {
        'R32': 0,
        'R16': 0,
        'QF': 1,
        'SF': 2,
        '3RD': 2,
        'FINAL': 2,
        'CR16': 0,
        'CQF': 1,
        'CSF': 2,
        'C3RD': 2,
        'CFINAL': 2,
      };
      stages.forEach((round, stage) {
        expect(
          BigGameDifficulty.finalsKnockoutStage(round),
          stage,
          reason: round,
        );
      });
    });

    test('nothing else: groups, qualifiers, play-offs, cups, friendlies', () {
      for (final round in const [
        null,
        'GROUP',
        'CGROUP',
        'CQ',
        'NSF',
        'NFINAL',
        'NQF',
        'XASF',
        'ICSF',
        'ICFINAL',
        'AFFINAL',
        'FFINAL',
        'FRIENDLY',
      ]) {
        expect(
          BigGameDifficulty.finalsKnockoutStage(round),
          isNull,
          reason: '$round',
        );
      }
    });
  });

  group('the term', () {
    double term(double mine, double theirs, {String round = 'QF'}) =>
        BigGameDifficulty.term(round: round, mine: mine, theirs: theirs);

    test('is zero against an equal or a weaker side', () {
      for (final theirs in const [70.0, 78.0, 80.0]) {
        expect(term(80, theirs), 0);
      }
    });

    test('grows with the gap and with the round', () {
      expect(term(80, 84), closeTo(0.04, 1e-9));
      expect(term(80, 88), closeTo(0.08, 1e-9));
      expect(term(80, 88, round: 'R16'), closeTo(0.064, 1e-9));
      expect(term(80, 88, round: 'FINAL'), closeTo(0.088, 1e-9));
      expect(term(80, 88, round: 'GROUP'), 0);
    });

    test('adds the opponent pedigree over his, and is capped', () {
      final withPedigree = BigGameDifficulty.term(
        round: 'SF',
        mine: 80,
        theirs: 84,
        myPedigree: 0.5,
        theirPedigree: 2.5,
      );
      expect(withPedigree, closeTo(0.044 + 0.02, 1e-9));
      // His own pedigree never earns him anything back.
      expect(
        BigGameDifficulty.term(
          round: 'SF',
          mine: 80,
          theirs: 84,
          myPedigree: 2.5,
        ),
        closeTo(0.044, 1e-9),
      );
      expect(
        BigGameDifficulty.term(
          round: 'FINAL',
          mine: 72,
          theirs: 92,
          theirPedigree: 2.5,
        ),
        BigGameDifficulty.maxTerm,
      );
    });

    test('is zero for a minnow and an elite side, smooth between', () {
      for (final mine in const [50.0, 62.0, 87.0, 89.0]) {
        expect(term(mine, mine + 8), 0, reason: '$mine');
      }
      var last = 0.0;
      for (var r = 62.0; r <= 70; r += 0.25) {
        final w = BigGameDifficulty.weight(r);
        expect(w, greaterThanOrEqualTo(last));
        expect(w - last, lessThan(0.07));
        last = w;
      }
      for (var r = 70.0; r <= 82; r += 1) {
        expect(BigGameDifficulty.weight(r), 1);
      }
      for (var r = 82.0; r <= 87; r += 0.25) {
        final w = BigGameDifficulty.weight(r);
        expect(w, lessThanOrEqualTo(last));
        expect(last - w, lessThan(0.08));
        last = w;
      }
    });
  });

  group('the played seam', () {
    test('a zero term hands back the very same map', () {
      final base = MidTierDifficulty.chemistryByNation(
        managerNationId: 1,
        familiarity: 0.6,
        fieldedRating: 80,
      );
      expect(
        identical(
          BigGameDifficulty.withTerm(
            base,
            managerNationId: 1,
            opponentNationId: 2,
            term: 0,
          ),
          base,
        ),
        isTrue,
      );
    });

    test('a term takes from him and gives to the opponent', () {
      final out = BigGameDifficulty.withTerm(
        const {1: 1.04},
        managerNationId: 1,
        opponentNationId: 2,
        term: 0.05,
      );
      expect(out[1], closeTo(1.04 * 0.95, 1e-12));
      expect(out[2], closeTo(1.05, 1e-12));
    });

    test('the skipped twin is an edge against him, zero at no term', () {
      expect(BigGameDifficulty.skippedEdge(0), 0);
      expect(BigGameDifficulty.skippedEdge(0.08), closeTo(-5.2, 1e-9));
    });
  });

  group('the mid-tier band in a difficulty2 cycle', () {
    test('reaches 81 at full strength and runs out at 87', () {
      expect(MidTierDifficulty.weight(81, wide: true), 1);
      expect(MidTierDifficulty.weight(87, wide: true), 0);
      expect(MidTierDifficulty.weight(84, wide: true), greaterThan(0));
      // Off, the band is the one every older cycle plays.
      expect(MidTierDifficulty.weight(84), 0);
      for (var r = 40.0; r <= 92; r += 0.5) {
        if (r <= 78) {
          expect(
            MidTierDifficulty.weight(r, wide: true),
            MidTierDifficulty.weight(r),
            reason: '$r',
          );
        }
      }
    });
  });

  group('team talks', () {
    test('no scale plays exactly as before; a scale trims only the lift', () {
      const engine = MatchEngine();
      final home = MatchTeam(
        nationId: 1,
        xi: [
          for (var i = 0; i < 11; i++)
            player(
              id: 100 + i,
              nationId: 1,
              position: Formation.f433.positions[i],
              attributes: flatAttributes(78),
            ),
        ],
        instructions: const TacticalInstructions(),
        formation: Formation.f433,
      );
      final away = MatchTeam(
        nationId: 2,
        xi: [
          for (var i = 0; i < 11; i++)
            player(
              id: 200 + i,
              nationId: 2,
              position: Formation.f433.positions[i],
              attributes: flatAttributes(82),
            ),
        ],
        instructions: const TacticalInstructions(),
        formation: Formation.f433,
      );
      const talks = [
        TeamTalk(teamNationId: 1, minute: 46, tone: TeamTalkTone.demandMore),
      ];
      var changed = 0;
      for (var seed = 0; seed < 60; seed++) {
        String play(Map<int, double>? scale) {
          final r = engine.play(
            home: home,
            away: away,
            rng: SeededRng.forFixture(77, seed),
            talks: talks,
            talkScaleByNation: scale ?? const {},
          );
          return '${r.homeScore}-${r.awayScore} ${r.events.length}';
        }

        expect(play(const {1: 1.0}), play(null), reason: 'seed $seed');
        if (play(const {1: 0.7}) != play(null)) changed++;
      }
      expect(changed, greaterThan(0));
    });
  });

  group('the knockout lab', () {
    // A few hundred seeds a cell: the bands are wide enough for the noise
    // (about 0.02 to 0.03 a cell); the table test measures at full size.
    double played(double mine, double theirs, KoEdge e, {required bool d}) =>
        koPlayed(
          mine: mine,
          theirs: theirs,
          edge: e,
          difficulty: d,
          seeds: e.smart ? 300 : 500,
        );
    double skipped(double mine, double theirs, {required bool d}) => koSkipped(
      mine: mine,
      theirs: theirs,
      edge: koTypical,
      difficulty: d,
      seeds: 1500,
    );

    test('a near-top side meets the target against the giants', () {
      final hot88 = played(80, 88, koHotSmart, d: true);
      final hot84 = played(80, 84, koHotSmart, d: true);
      final typical88 = played(80, 88, koTypical, d: true);
      // ignore: avoid_print
      print('80v88 hot $hot88 typical $typical88 | 80v84 hot $hot84');
      expect(hot88, inInclusiveRange(0.22, 0.34));
      expect(hot84, inInclusiveRange(0.40, 0.54));
      expect(typical88, inInclusiveRange(0.15, 0.27));
      // And it is a trim, not a wall: still well above the AI world's.
      expect(typical88, greaterThan(koWorld(mine: 80, theirs: 88) + 0.06));
    });

    test('played and skipped move together', () {
      final dPlayed =
          played(80, 84, koTypical, d: true) -
          played(80, 84, koTypical, d: false);
      final dSkipped = skipped(80, 84, d: true) - skipped(80, 84, d: false);
      // ignore: avoid_print
      print('80v84 delta played $dPlayed skipped $dSkipped');
      expect((dPlayed - dSkipped).abs(), lessThan(0.05));
      expect(dSkipped, lessThan(-0.05));
    }, tags: ['slow']);

    test('elite, minnow and level ties are essentially unchanged', () {
      for (final (mine, theirs) in const [
        (88.0, 84.0),
        (88.0, 88.0),
        (80.0, 80.0),
        (60.0, 70.0),
      ]) {
        final delta =
            played(mine, theirs, koTypical, d: true) -
            played(mine, theirs, koTypical, d: false);
        expect(delta.abs(), lessThan(0.03), reason: '$mine v $theirs');
        final skipDelta =
            skipped(mine, theirs, d: true) - skipped(mine, theirs, d: false);
        expect(skipDelta.abs(), lessThan(0.02), reason: '$mine v $theirs');
      }
    }, tags: ['slow']);
  });
}
