import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/background_match.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/penalty_takers.dart';
import 'package:fnm/domain/services/match/performance_mark.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/tactics/best_eleven.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/seed_pool.dart';

/// The community traits (1.1.5) in the engine: each one moves its own man
/// the way it says, over many seeds, and none of them moves the league.
const _engine = MatchEngine();

/// A flat 78 side for [nationId] (ids `nationId * 100 + slot`, the striker
/// at slot 9) carrying [traits].
MatchTeam _side(int nationId, {Map<int, List<PlayerTrait>> traits = const {}}) {
  final t = ratedTeam(nationId, 78);
  return MatchTeam(
    nationId: nationId,
    instructions: t.instructions,
    xi: t.xi,
    traitsByPlayer: traits,
  );
}

MatchResult _play(
  int i, {
  MatchTeam? home,
  MatchTeam? away,
  List<Substitution> subs = const [],
  bool bigMatch = false,
}) => _engine.play(
  home: home ?? _side(1),
  away: away ?? _side(2),
  rng: SeededRng.forFixture(0x7EA1, i),
  subs: subs,
  bigMatch: bigMatch,
);

double _mean(Iterable<num> v) =>
    v.isEmpty ? 0 : v.fold<double>(0, (a, b) => a + b) / v.length;

double _sd(Iterable<num> v) {
  final m = _mean(v);
  return sqrt(_mean([for (final x in v) (x - m) * (x - m)]));
}

double? _ratingOf(MatchResult r, int id) {
  for (final x in r.ratings) {
    if (x.playerId == id) return x.rating;
  }
  return null;
}

int _goalsBy(MatchResult r, int id) => r.events
    .where(
      (e) => e.type == MatchEventType.goal && !e.ownGoal && e.playerId == id,
    )
    .length;

int _assistsBy(MatchResult r, int id) => r.events
    .where((e) => e.type == MatchEventType.goal && e.assistPlayerId == id)
    .length;

int _goalsFor(MatchResult r, int nationId) => r.events
    .where((e) => e.type == MatchEventType.goal && e.teamNationId == nationId)
    .length;

void main() {
  const n = 1200;
  const striker = 109;
  const midfielder = 106;

  test('a 12th man lifts once he is on, and only then', () {
    final sub = player(
      id: 150,
      nationId: 1,
      position: PlayerPosition.st,
      attributes: flatAttributes(78),
    );
    final subs = [
      Substitution(teamNationId: 1, minute: 55, offId: striker, on: sub),
    ];
    final plain = [for (var i = 0; i < n; i++) _play(i, subs: subs)];
    final lifted = [
      for (var i = 0; i < n; i++)
        _play(
          i,
          subs: subs,
          home: _side(
            1,
            traits: {
              150: [PlayerTrait.twelfthMan],
            },
          ),
        ),
    ];
    final markGain =
        _mean([for (final r in lifted) ?_ratingOf(r, 150)]) -
        _mean([for (final r in plain) ?_ratingOf(r, 150)]);
    expect(markGain, greaterThan(0.3));
    expect(markGain, lessThan(0.6), reason: 'small, never a match-winner');
    int involved(List<MatchResult> rs) => [
      for (final r in rs) _goalsBy(r, 150) + _assistsBy(r, 150),
    ].reduce((a, b) => a + b);
    expect(involved(lifted), greaterThan(involved(plain)));
    // The side's goals rise a touch: felt, not decisive.
    final gain =
        _mean([for (final r in lifted) _goalsFor(r, 1)]) -
        _mean([for (final r in plain) _goalsFor(r, 1)]);
    expect(gain, inInclusiveRange(0.0, 0.08));

    // As a starter he is just a player: the match is the plain one.
    final starter = _side(
      1,
      traits: {
        striker: [PlayerTrait.twelfthMan],
      },
    );
    for (var i = 0; i < 50; i++) {
      final a = _play(i, home: starter);
      final b = _play(i);
      expect('${a.homeScore}-${a.awayScore}', '${b.homeScore}-${b.awayScore}');
      expect(_ratingOf(a, striker), _ratingOf(b, striker));
    }
  });

  test('consistent narrows his marks, inconsistent widens them', () {
    List<double> marks(List<PlayerTrait> t) => [
      for (var i = 0; i < n; i++)
        ?_ratingOf(_play(i, home: _side(1, traits: {striker: t})), striker),
    ];
    final plain = _sd(marks(const []));
    final steady = _sd(marks(const [PlayerTrait.consistent]));
    final erratic = _sd(marks(const [PlayerTrait.inconsistent]));
    expect(steady, lessThan(plain * 0.9));
    expect(erratic, greaterThan(plain * 1.1));

    // And his form: the same five marks read nearer steady, or further off.
    const hot = [7.8, 7.6, 7.9, 7.4, 7.7];
    final base = Condition.form(hot);
    final calm = Condition.form(
      hot,
      swing: PlayerTraits.swingOf(const [PlayerTrait.consistent]),
    );
    final wild = Condition.form(
      const [6.0, 5.9, 6.1, 5.8, 6.0],
      swing: PlayerTraits.swingOf(const [PlayerTrait.inconsistent]),
    );
    expect(calm.delta, lessThan(base.delta));
    expect(
      wild.delta,
      lessThan(Condition.form(const [6.0, 5.9, 6.1, 5.8, 6.0]).delta),
    );
    // The average itself is reported as it was.
    expect(calm.avg, base.avg);
  });

  test("an inconsistent side's days cancel out over a tournament", () {
    final all = {
      for (var s = 0; s < 11; s++) 100 + s: [PlayerTrait.inconsistent],
    };
    final plain = [for (var i = 0; i < n; i++) _goalsFor(_play(i), 1)];
    final erratic = [
      for (var i = 0; i < n; i++)
        _goalsFor(_play(i, home: _side(1, traits: all)), 1),
    ];
    // Different matches, the same side on average.
    expect(
      [for (var i = 0; i < n; i++) plain[i] != erratic[i]].where((d) => d),
      isNotEmpty,
    );
    expect((_mean(erratic) - _mean(plain)).abs(), lessThan(0.1));
  });

  test('injury-prone takes about twice his share of the knocks', () {
    int knocks(List<PlayerTrait> t, {int? who}) {
      var k = 0;
      for (var i = 0; i < 3000; i++) {
        final r = _play(i, home: _side(1, traits: {midfielder: t}));
        k += r.events
            .where(
              (e) =>
                  e.type == MatchEventType.injury &&
                  e.teamNationId == 1 &&
                  (who == null || e.playerId == who),
            )
            .length;
      }
      return k;
    }

    final plain = knocks(const [], who: midfielder);
    final prone = knocks(const [PlayerTrait.injuryProne], who: midfielder);
    expect(plain, greaterThan(20));
    expect(prone / plain, inInclusiveRange(1.5, 2.6));
    // Who gets hurt, not how often the side does.
    final sidePlain = knocks(const []);
    final sideProne = knocks(const [PlayerTrait.injuryProne]);
    expect((sideProne - sidePlain).abs() / sidePlain, lessThan(0.08));
  });

  test('easily tired drains about a fifth faster', () {
    double drain(List<PlayerTrait> t) => _mean([
      for (var i = 0; i < 300; i++)
        100 -
            (_play(
                  i,
                  home: _side(1, traits: {midfielder: t}),
                ).energyByPlayer[midfielder] ??
                100),
    ]);
    final ratio = drain(const [PlayerTrait.easilyTired]) / drain(const []);
    expect(ratio, inInclusiveRange(1.12, 1.28));
  });

  test('poor under pressure costs only on the big night', () {
    final all = {
      for (var s = 0; s < 11; s++) 100 + s: [PlayerTrait.poorUnderPressure],
    };
    // An ordinary match: exactly the match it always was.
    for (var i = 0; i < 100; i++) {
      final a = _play(i, home: _side(1, traits: all));
      final b = _play(i);
      expect(a.events.length, b.events.length);
      expect('${a.homeScore}-${a.awayScore}', '${b.homeScore}-${b.awayScore}');
    }
    double margin(Map<int, List<PlayerTrait>> t) => _mean([
      for (var i = 0; i < n; i++)
        () {
          final r = _play(i, home: _side(1, traits: t), bigMatch: true);
          return r.homeScore - r.awayScore;
        }(),
    ]);
    final wilts = margin(all);
    final plain = margin(const {});
    final rises = margin({
      for (var s = 0; s < 11; s++) 100 + s: [PlayerTrait.bigGame],
    });
    expect(wilts, lessThan(plain - 0.1));
    // The mirror of a big-game player, about as large the other way.
    expect((plain - wilts) / (rises - plain), inInclusiveRange(0.6, 1.6));
    // And the shootout.
    final p = ratedTeam(1, 78).xi[striker - 100];
    expect(
      PenaltyTakers.skillOf(p, const [PlayerTrait.poorUnderPressure]),
      lessThan(PenaltyTakers.skillOf(p, const [])),
    );
  });

  test('an individualist shoots more and lays on less', () {
    final plain = [for (var i = 0; i < n; i++) _play(i)];
    final solo = [
      for (var i = 0; i < n; i++)
        _play(
          i,
          home: _side(
            1,
            traits: {
              striker: [PlayerTrait.individualistic],
            },
          ),
        ),
    ];
    int sum(List<MatchResult> rs, int Function(MatchResult) f) =>
        rs.map(f).reduce((a, b) => a + b);
    final shareWas =
        sum(plain, (r) => _goalsBy(r, striker)) /
        sum(plain, (r) => _goalsFor(r, 1));
    final shareNow =
        sum(solo, (r) => _goalsBy(r, striker)) /
        sum(solo, (r) => _goalsFor(r, 1));
    expect(shareNow, greaterThan(shareWas));
    expect(
      sum(solo, (r) => _assistsBy(r, striker)),
      lessThan(sum(plain, (r) => _assistsBy(r, striker))),
    );
    // His side loses a little, never a lot.
    final goalsWas = _mean([for (final r in plain) _goalsFor(r, 1)]);
    final goalsNow = _mean([for (final r in solo) _goalsFor(r, 1)]);
    expect(goalsNow, lessThanOrEqualTo(goalsWas + 0.02));
    expect(goalsNow, greaterThan(goalsWas * 0.95));
  });

  test('a mark is unchanged for a man without the traits', () {
    for (final goals in [0, 1, 2]) {
      expect(
        PerformanceMark.forPlayer(
          category: PositionCategory.forward,
          goals: goals,
          assists: 0,
          booked: false,
          sentOff: false,
          teamScore: 2,
          oppScore: 1,
          swing: PlayerTraits.swingOf(const [PlayerTrait.leader]),
          bonus: PlayerTraits.markBonusOf(const [
            PlayerTrait.leader,
          ], cameOn: true),
        ),
        PerformanceMark.forPlayer(
          category: PositionCategory.forward,
          goals: goals,
          assists: 0,
          booked: false,
          sentOff: false,
          teamScore: 2,
          oppScore: 1,
        ),
      );
    }
  });

  group('the league is unmoved', () {
    final pool = seedPool();
    final byNation = <int, List<Player>>{};
    for (final p in pool) {
      (byNation[p.nationId] ??= []).add(p);
    }
    final xis = [
      for (final e in byNation.entries)
        if (e.value.length >= 23)
          () {
            final byId = {for (final p in e.value) p.id: p};
            return [
              for (final id in bestEleven(Formation.f433, e.value))
                if (id != null) byId[id]!,
            ];
          }(),
    ].where((xi) => xi.length == 11).toList();

    Map<int, List<PlayerTrait>> traits(List<Player> xi, {required bool now}) =>
        {
          for (final p in xi)
            p.id: now
                ? PlayerTraits.of(p, saveSeed: 42)
                : PlayerTraits.earnedOf(p, saveSeed: 42),
        };

    test('goals within 1%, injuries within a few percent', () {
      ({double goals, double injuries}) league({required bool now}) {
        var goals = 0, injuries = 0;
        const matches = 4000;
        for (var i = 0; i < matches; i++) {
          final h = xis[i % xis.length];
          final a = xis[(i * 7 + 3) % xis.length];
          if (identical(h, a)) continue;
          final r = _engine.play(
            home: MatchTeam(
              nationId: h.first.nationId,
              xi: h,
              instructions: const TacticalInstructions(),
              traitsByPlayer: traits(h, now: now),
            ),
            away: MatchTeam(
              nationId: a.first.nationId,
              xi: a,
              instructions: const TacticalInstructions(),
              traitsByPlayer: traits(a, now: now),
            ),
            rng: SeededRng.forFixture(0x1EA6, i),
          );
          goals += r.homeScore + r.awayScore;
          injuries += r.events
              .where((e) => e.type == MatchEventType.injury)
              .length;
        }
        return (goals: goals / matches, injuries: injuries / matches);
      }

      final was = league(now: false);
      final now = league(now: true);
      expect(now.goals, closeTo(was.goals, was.goals * 0.01));
      expect(now.injuries, closeTo(was.injuries, was.injuries * 0.04));
    });

    test('the rest of the world: knocks within a few percent', () {
      int knocks({required bool now}) {
        var k = 0;
        for (var i = 0; i < 6000; i++) {
          List<Player> side(int j) => [
            for (final p in xis[j % xis.length])
              now
                  ? p
                  : p.copyWith(
                      fixedTraits: PlayerTraits.earnedOf(p, saveSeed: 42),
                    ),
          ];
          final h = side(i);
          final a = side(i * 5 + 1);
          final d = BackgroundMatch.detail(
            homeXi: h,
            awayXi: a,
            homeNationId: h.first.nationId,
            awayNationId: a.first.nationId,
            homeScore: 1,
            awayScore: 1,
            homeStrength: 75,
            awayStrength: 75,
            goalsByPlayer: {h[9].id: 1, a[9].id: 1},
            rng: SeededRng.forFixture(0xB6, i),
            competitive: true,
            saveSeed: 42,
          );
          k += d.events.where((e) => e.type == MatchEventType.injury).length;
        }
        return k;
      }

      final was = knocks(now: false);
      final now = knocks(now: true);
      expect(was, greaterThan(500));
      expect((now - was) / was, inInclusiveRange(-0.01, 0.06));
    });
  });
}
