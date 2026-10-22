import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/competition/finals.dart';
import 'package:fnm/domain/services/match/ai_substitutions.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_simulator.dart';

import '../../helpers/fixtures.dart';

/// Live extra time (the engine playing minutes 91-120) must settle level ties
/// about as often as the background `decideKnockout` draw does (about half of
/// them), and must not
/// hand the stronger side a bigger edge than it has over ninety minutes. The
/// shootout split must leave `decideKnockout` byte-identical, since background
/// AI knockouts and the commit fallback still go through it.

/// Level-at-ninety runs per pair (two pairs, so 1,500 in all).
const _levelRunsPerPair = 750;

/// A frozen copy of `WorldCupFinals.decideKnockout` as it stood before the
/// shootout was split out into `decideShootout`. Never edit it: it is the
/// reference the refactor is checked against.
KnockoutOutcome _legacyDecideKnockout(
  int home,
  int away,
  SeededRng rng, {
  double homeStrength = 1,
  double awayStrength = 1,
  List<double> homeTakerSkill = const [],
  List<double> awayTakerSkill = const [],
}) {
  final total = homeStrength + awayStrength;
  final homeShare = total <= 0 ? 0.5 : homeStrength / total;

  var h = home;
  var a = away;
  final chances = rng.rangeInt(2, 5);
  for (var i = 0; i < chances; i++) {
    if (!rng.chance(0.22)) continue;
    if (rng.chance(homeShare)) {
      h++;
    } else {
      a++;
    }
  }
  if (h != a) {
    return KnockoutOutcome(
      homeScore: h,
      awayScore: a,
      afterExtraTime: true,
      homeKicks: const [],
      awayKicks: const [],
    );
  }

  final homeBase = (0.75 + 0.12 * (homeShare - 0.5) * 2).clamp(0.55, 0.9);
  final awayBase = (0.75 + 0.12 * (0.5 - homeShare) * 2).clamp(0.55, 0.9);
  double convOf(double base, List<double> skill, int kick) => skill.isEmpty
      ? base
      : (base * skill[kick % skill.length]).clamp(0.35, 0.96);
  final homeKicks = <bool>[];
  final awayKicks = <bool>[];
  int hs() => homeKicks.where((s) => s).length;
  int as_() => awayKicks.where((s) => s).length;

  bool decided() {
    final hRem = 5 - homeKicks.length;
    final aRem = 5 - awayKicks.length;
    return hs() > as_() + aRem || as_() > hs() + hRem;
  }

  for (var round = 0; round < 5; round++) {
    if (decided()) break;
    homeKicks.add(
      rng.chance(convOf(homeBase, homeTakerSkill, homeKicks.length)),
    );
    if (decided()) break;
    awayKicks.add(
      rng.chance(convOf(awayBase, awayTakerSkill, awayKicks.length)),
    );
  }
  while (hs() == as_()) {
    homeKicks.add(
      rng.chance(convOf(homeBase, homeTakerSkill, homeKicks.length)),
    );
    awayKicks.add(
      rng.chance(convOf(awayBase, awayTakerSkill, awayKicks.length)),
    );
  }

  return KnockoutOutcome(
    homeScore: h,
    awayScore: a,
    afterExtraTime: true,
    homeKicks: homeKicks,
    awayKicks: awayKicks,
  );
}

String _sig(KnockoutOutcome o) =>
    '${o.homeScore}-${o.awayScore} ${o.afterExtraTime} '
    '${o.homeKicks.map((k) => k ? 1 : 0).join()}/'
    '${o.awayKicks.map((k) => k ? 1 : 0).join()}';

/// What the engine's extra time did with one pair's level ninety minutes.
typedef _Pair = ({
  int levelRuns,
  int etDecided,
  int etStrongerWins,
  int decided90,
  int decided90StrongerWins,
});

/// The away side's seven substitutes, rated like its XI, outfield only (a
/// sub-for-sub swap of equals, so the change is fresh legs, not quality).
List<Player> _bench(int nationId, int rating) => [
  for (var i = 0; i < 7; i++)
    player(
      id: nationId * 100 + 50 + i,
      nationId: nationId,
      position: Formation.f433.positions[1 + i],
      attributes: flatAttributes(rating),
    ),
];

/// Who is still on for [team] once the ninety is over: the XI after the
/// planned [subs] that landed, less anyone sent off or carried off.
List<Player> _onPitchAt90(
  MatchTeam team,
  List<Substitution> subs,
  MatchResult r,
) {
  final onPitch = [...team.xi];
  final gone = {
    for (final e in r.events)
      if (e.minute <= 90 &&
          e.teamNationId == team.nationId &&
          (e.type == MatchEventType.redCard || e.type == MatchEventType.injury))
        e.playerId,
  };
  for (final s in subs) {
    final idx = onPitch.indexWhere((p) => p.id == s.offId);
    if (idx != -1 && !gone.contains(s.offId)) onPitch[idx] = s.on;
  }
  return onPitch.where((p) => !gone.contains(p.id)).toList();
}

/// Plays [strong] (home) v [weak] (away) on neutral ground the way Task C3's
/// live knockout will: the away side is the AI (managed by the scoreline and
/// clock, its second-half subs planned on `^ 0x5195`, and one extra-time sub
/// at 91 from `AiSubstitutions.planExtraTime` on `^ 0x5196`). Runs until
/// [_levelRunsPerPair] ninety-minute draws have gone to extra time; every
/// decided ninety on the way counts toward the 90-minute edge.
_Pair _enginePair(int strong, int weak) {
  const engine = MatchEngine();
  final home = ratedTeam(1, strong);
  final away = ratedTeam(2, weak);
  final bench = _bench(2, weak);
  var level = 0;
  var etDecided = 0;
  var etStrong = 0;
  var decided90 = 0;
  var strong90 = 0;
  for (var seed = 0; level < _levelRunsPerPair; seed++) {
    final regulationSubs = AiSubstitutions.plan(
      nationId: 2,
      xi: away.xi,
      bench: bench,
      rng: SeededRng.forFixture(0xC2E7, seed ^ 0x5195),
    );
    MatchResult play(List<Substitution> subs) => engine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(0xC2E7, seed),
      subs: subs,
      aiManagedNationIds: const {2},
      neutralVenue: true,
      bigMatch: true,
      extraTimeIfLevel: true,
    );
    var r = play(regulationSubs);
    if (r.homeScore != r.awayScore) {
      decided90++;
      if (r.homeScore > r.awayScore) strong90++;
      continue;
    }
    level++;
    // The extra-time sub reads who finished the ninety, then the tie is
    // replayed with it (the ninety is identical, only 91-120 can change).
    final used = {for (final s in regulationSubs) s.on.id};
    final etSub = AiSubstitutions.planExtraTime(
      nationId: 2,
      onPitchAt90: _onPitchAt90(away, regulationSubs, r),
      bench: [
        for (final p in bench)
          if (!used.contains(p.id)) p,
      ],
      rng: SeededRng.forFixture(0xC2E7, seed ^ 0x5196),
    );
    if (etSub != null) r = play([...regulationSubs, etSub]);
    final et = r.extraTime!;
    if (et.homeScore == et.awayScore) continue;
    etDecided++;
    if (et.homeScore > et.awayScore) etStrong++;
  }
  return (
    levelRuns: level,
    etDecided: etDecided,
    etStrongerWins: etStrong,
    decided90: decided90,
    decided90StrongerWins: strong90,
  );
}

/// The share of level ties `decideKnockout` settles in extra time for the
/// background path's weights of the same pair.
double _backgroundEtShare(int strong, int weak) {
  const n = 4000;
  var settled = 0;
  for (var i = 0; i < n; i++) {
    final ko = WorldCupFinals.decideKnockout(
      1,
      1,
      SeededRng.forFixture(0xC2B6, i),
      homeStrength: RatingMatchSimulator.knockoutWeight(strong),
      awayStrength: RatingMatchSimulator.knockoutWeight(weak),
    );
    if (!ko.wentToShootout) settled++;
  }
  return settled / n;
}

void main() {
  test('decideKnockout is unchanged', () {
    const strengthPairs = [(1.0, 1.0), (1.4, 0.8), (0.6, 2.2)];
    const takers = [1.1, 0.9, 1.05, 0.8, 1.2];
    for (final (hs, as_) in strengthPairs) {
      for (var seed = 0; seed < 500; seed++) {
        for (final withTakers in [false, true]) {
          final score = seed % 3;
          final now = WorldCupFinals.decideKnockout(
            score,
            score,
            SeededRng.forFixture(0x1E6A, seed),
            homeStrength: hs,
            awayStrength: as_,
            homeTakerSkill: withTakers ? takers : const [],
            awayTakerSkill: withTakers ? takers.reversed.toList() : const [],
          );
          final legacy = _legacyDecideKnockout(
            score,
            score,
            SeededRng.forFixture(0x1E6A, seed),
            homeStrength: hs,
            awayStrength: as_,
            homeTakerSkill: withTakers ? takers : const [],
            awayTakerSkill: withTakers ? takers.reversed.toList() : const [],
          );
          expect(
            _sig(now),
            _sig(legacy),
            reason: 'seed $seed, $hs v $as_, takers $withTakers',
          );
        }
      }
    }
  });

  test('decideShootout settles a level score with a winner', () {
    for (var seed = 0; seed < 200; seed++) {
      final o = WorldCupFinals.decideShootout(2, 2, SeededRng(seed));
      expect(o.homeScore, 2);
      expect(o.awayScore, 2);
      expect(o.afterExtraTime, isTrue);
      expect(o.wentToShootout, isTrue);
      expect(o.homePens, isNot(o.awayPens));
    }
  });

  group('live extra time', () {
    // Shared between the two tests below so the engine runs only once.
    final pairs = <(int, int), _Pair>{};
    _Pair pair(int strong, int weak) =>
        pairs[(strong, weak)] ??= _enginePair(strong, weak);

    test('extra time settles about as many level ties as today', () {
      for (final (strong, weak) in const [(80, 80), (84, 76)]) {
        final p = pair(strong, weak);
        final share = p.etDecided / p.levelRuns;
        final background = _backgroundEtShare(strong, weak);
        // Printed so the numbers are on the record, not just asserted.
        // ignore: avoid_print
        print(
          'extra time, $strong v $weak: engine settles '
          '${(100 * share).toStringAsFixed(1)}% of ${p.levelRuns} level ties, '
          'background ${(100 * background).toStringAsFixed(1)}%',
        );
        expect(share, inInclusiveRange(0.30, 0.60));
        expect((share - background).abs(), lessThanOrEqualTo(0.06));
      }
    });

    test("the stronger side's edge is not inflated", () {
      final p = pair(84, 76);
      final etEdge = p.etStrongerWins / p.etDecided;
      final edge90 = p.decided90StrongerWins / p.decided90;
      // Printed for the record, like the shares above.
      // ignore: avoid_print
      print(
        '84 v 76: stronger side wins ${(100 * etEdge).toStringAsFixed(1)}% '
        'of ${p.etDecided} extra-time decisions, '
        '${(100 * edge90).toStringAsFixed(1)}% of ${p.decided90} decided '
        'ninety-minute games',
      );
      expect(etEdge, lessThanOrEqualTo(edge90 + 0.05));
    });
  });
}
