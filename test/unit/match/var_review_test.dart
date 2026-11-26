import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/live_rating.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';

import '../../helpers/fixtures.dart';

/// The video referee in the engine: which goals he checks and the rare one
/// he chalks off. A real outcome, on a stream of its own: the score, the
/// scorers and the tallies never count a goal chalked off, the same seed
/// always gives the same call, and a match he leaves alone plays exactly as
/// it did before he came in.

const _engine = MatchEngine();

MatchTeam _team(int nation, int rating, TacticalInstructions i) => MatchTeam(
  nationId: nation,
  formation: Formation.f433,
  instructions: i,
  xi: [
    for (var k = 0; k < 11; k++)
      player(
        id: nation * 100 + k,
        nationId: nation,
        position: Formation.f433.positions[k],
        attributes: flatAttributes(rating),
      ),
  ],
);

MatchResult _match(int seed, {bool video = true}) {
  final r = SeededRng(seed * 7919 + 17);
  TacticalInstructions dials() => TacticalInstructions(
    mentality: r.rangeInt(20, 90),
    pressing: r.rangeInt(20, 90),
    tempo: r.rangeInt(20, 90),
  );
  final home = _team(1, r.rangeInt(60, 85), dials());
  final away = _team(2, r.rangeInt(60, 85), dials());
  return _engine.play(
    home: home,
    away: away,
    rng: SeededRng.forFixture(0x7A5E, seed),
    neutralVenue: seed.isEven,
    extraTimeIfLevel: seed % 5 == 0,
    videoReferee: video,
  );
}

const _n = 900;
final List<MatchResult> _results = [for (var s = 0; s < _n; s++) _match(s)];

int _goals(MatchResult r, int nation) => r.events
    .where((e) => e.type == MatchEventType.goal && e.teamNationId == nation)
    .length;

void main() {
  test('checks about one goal in five, chalks off a few of those', () {
    var goals = 0;
    var checked = 0;
    var denied = 0;
    var eligible = 0;
    for (final r in _results) {
      for (final e in r.events) {
        if (e.type == MatchEventType.goal) {
          goals++;
          if (!e.penalty) eligible++;
          if (e.varReview == VarReview.confirmed) checked++;
        }
        if (e.type == MatchEventType.disallowedGoal) {
          denied++;
          eligible++;
          checked++;
          expect(e.varReview, isIn([VarReview.offside, VarReview.foul]));
          expect(e.penalty, isFalse);
          expect(e.ownGoal, isFalse);
        }
      }
    }
    final checkRate = checked / eligible;
    final denyRate = denied / checked;
    // ignore: avoid_print
    print(
      'VAR over $_n matches: ${goals / _n} goals a match, '
      '$checked checks of $eligible goals '
      '(${(100 * checkRate).toStringAsFixed(1)}%), $denied chalked off '
      '(${(100 * denyRate).toStringAsFixed(1)}% of checks, '
      '${(denied / _n).toStringAsFixed(3)} a match)',
    );
    expect(checkRate, inInclusiveRange(0.15, 0.25));
    expect(denyRate, inInclusiveRange(0.02, 0.12));
    expect(denied, greaterThan(0));
    // Rare: the goals a match stay where international football has them.
    expect(denied / (goals + denied), lessThan(0.025));
    expect(goals / _n, inInclusiveRange(2.2, 3.2));
  });

  test('a goal chalked off never counts: score, scorers, tallies', () {
    var seen = 0;
    for (final r in _results) {
      if (!r.events.any((e) => e.type == MatchEventType.disallowedGoal)) {
        continue;
      }
      seen++;
      final reg = r.events.where((e) => e.minute <= 90).toList();
      int count(int nation) => reg
          .where(
            (e) => e.type == MatchEventType.goal && e.teamNationId == nation,
          )
          .length;
      expect(r.homeScore, count(1));
      expect(r.awayScore, count(2));
      final et = r.extraTime;
      if (et != null) {
        expect(et.homeScore, _goals(r, 1));
        expect(et.awayScore, _goals(r, 2));
      }
      final tally = MatchTally.of(r.events, r.moments);
      for (final e in r.events) {
        if (e.type != MatchEventType.disallowedGoal) continue;
        final scored = r.events.where(
          (g) => g.type == MatchEventType.goal && g.playerId == e.playerId,
        );
        expect(tally.goals[e.playerId] ?? 0, scored.length);
        // Its shot: in the net, chalked off, pointing at the event.
        final shot = r.moments.whereType<ShotMoment>().firstWhere(
          (s) =>
              s.goalEventIndex != null &&
              identical(r.events[s.goalEventIndex!], e),
        );
        expect(shot.outcome, ShotOutcome.disallowed);
        expect(shot.outcome.inNet, isTrue);
      }
    }
    expect(seen, greaterThan(0));
  });

  test('the same seed, the same calls', () {
    for (var s = 0; s < 60; s++) {
      final a = _results[s];
      final b = _match(s);
      expect(b.homeScore, a.homeScore);
      expect(b.awayScore, a.awayScore);
      expect(b.events.length, a.events.length);
      for (var i = 0; i < a.events.length; i++) {
        expect(b.events[i].type, a.events[i].type);
        expect(b.events[i].playerId, a.events[i].playerId);
        expect(b.events[i].varReview, a.events[i].varReview);
      }
    }
  });

  test('with nothing chalked off the match is the one it was before VAR; '
      'otherwise it is the same up to the goal chalked off', () {
    var unchanged = 0;
    var diverged = 0;
    for (var s = 0; s < _n; s++) {
      final now = _results[s];
      final before = _match(s, video: false);
      final firstDenied = now.events.indexWhere(
        (e) => e.type == MatchEventType.disallowedGoal,
      );
      if (firstDenied < 0) {
        unchanged++;
        expect(now.homeScore, before.homeScore, reason: 'match $s');
        expect(now.awayScore, before.awayScore, reason: 'match $s');
        expect(now.homeShots, before.homeShots, reason: 'match $s');
        expect(now.awayShots, before.awayShots, reason: 'match $s');
        expect(now.events.length, before.events.length, reason: 'match $s');
        for (var i = 0; i < now.events.length; i++) {
          final a = now.events[i];
          final b = before.events[i];
          expect(a.type, b.type, reason: 'match $s');
          expect(a.playerId, b.playerId, reason: 'match $s');
          expect(a.minute, b.minute, reason: 'match $s');
        }
        continue;
      }
      diverged++;
      // Up to the call, the same match; the goal itself is the one that
      // went in without VAR.
      final d = now.events[firstDenied];
      for (var i = 0; i < firstDenied; i++) {
        final a = now.events[i];
        final b = before.events[i];
        if (a.minute == d.minute && a.stoppage == d.stoppage) break;
        expect(a.type, b.type, reason: 'match $s');
        expect(a.playerId, b.playerId, reason: 'match $s');
      }
      expect(
        before.events.any(
          (e) =>
              e.type == MatchEventType.goal &&
              e.minute == d.minute &&
              e.stoppage == d.stoppage &&
              e.playerId == d.playerId,
        ),
        isTrue,
        reason: 'match $s',
      );
    }
    expect(unchanged, greaterThan(_n * 0.9));
    expect(diverged, greaterThan(0));
  });
}
