import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pitch_audit.dart';

const _engine = MatchEngine();

MatchTeam _team(
  int nation,
  int rating,
  Formation f,
  TacticalInstructions i, {
  ThrowInStyle throwIn = ThrowInStyle.neutral,
}) => MatchTeam(
  nationId: nation,
  formation: f,
  instructions: i,
  throwInStyle: throwIn,
  xi: [
    for (var k = 0; k < 11; k++)
      player(
        id: nation * 100 + k,
        nationId: nation,
        position: f.positions[k],
        attributes: flatAttributes(rating),
      ),
  ],
);

TacticalInstructions _dials(SeededRng r) => TacticalInstructions(
  mentality: r.rangeInt(10, 90),
  pressing: r.rangeInt(10, 90),
  tempo: r.rangeInt(10, 90),
  width: r.rangeInt(10, 90),
  defensiveLine: r.rangeInt(10, 90),
  directness: r.rangeInt(10, 90),
);

typedef _Match = ({MatchResult result, MatchLineups lineups});

/// A varied engine match: shapes, dials, strengths, subs, long throws and
/// extra time all move with [seed].
_Match _match(int seed) {
  final r = SeededRng(seed * 7919 + 13);
  const fs = Formation.values;
  final home = _team(
    1,
    r.rangeInt(62, 84),
    fs[seed % fs.length],
    _dials(r),
    throwIn: seed % 4 == 1 ? ThrowInStyle.long : ThrowInStyle.neutral,
  );
  final away = _team(
    2,
    r.rangeInt(62, 84),
    fs[(seed * 7 + 3) % fs.length],
    _dials(r),
    throwIn: seed % 5 == 2 ? ThrowInStyle.long : ThrowInStyle.neutral,
  );
  final subs = <Substitution>[];
  final homeBench = <int>[];
  final awayBench = <int>[];
  for (var k = 0; k < 1 + seed % 3; k++) {
    final on = player(id: 150 + k, nationId: 1);
    homeBench.add(on.id);
    subs.add(
      Substitution(
        teamNationId: 1,
        minute: 50 + k * 12 + seed % 9,
        offId: 100 + 1 + (seed + k * 3) % 10,
        on: on,
      ),
    );
  }
  if (seed.isEven) {
    final on = player(id: 250, nationId: 2);
    awayBench.add(on.id);
    subs.add(
      Substitution(teamNationId: 2, minute: 46 + seed % 30, offId: 209, on: on),
    );
  }
  final result = _engine.play(
    home: home,
    away: away,
    rng: SeededRng.forFixture(0xB0A7, seed),
    subs: subs,
    neutralVenue: true,
    bigMatch: true,
    extraTimeIfLevel: seed % 3 == 0,
  );
  return (
    result: result,
    lineups: matchLineupsOf(
      home: home,
      away: away,
      homeBench: homeBench,
      awayBench: awayBench,
      result: result,
    ),
  );
}

PitchScript _script(_Match m, PitchSpeed speed, {int seed = 7}) =>
    StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, speed),
      seed: seed,
    );

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

void main() {
  test('every moment type, staged over 200 seeded matches, shows its record', () {
    final counts = <String, int>{};
    final worst = <String, double>{};
    final problems = <String>[];
    final invalid = <String>[];
    for (var seed = 0; seed < 200; seed++) {
      final m = _match(seed);
      final speed = PitchSpeed.values[seed % 3];
      final s = _script(m, speed, seed: seed);
      final v = PitchScriptValidator.validate(s, limit: 5);
      if (v.isNotEmpty) invalid.add('match $seed ($speed): ${v.join('; ')}');
      final a = PitchAudit(s, 'match $seed ($speed)')..run();
      problems.addAll(a.problems);
      a.counts.forEach((k, n) => counts[k] = (counts[k] ?? 0) + n);
      a.worst.forEach((k, x) => worst[k] = math.max(worst[k] ?? x, x));
    }
    final keys = counts.keys.toList()..sort();
    // Findings by kind, numbers and names apart.
    final kinds = <String, int>{};
    for (final p in [...problems, ...invalid.expand((x) => x.split('; '))]) {
      final k = p
          .replaceAll(RegExp(r'^match \d+ \(PitchSpeed\.\w+\)( \S+)?:? '), '')
          .replaceAll(RegExp(r'minute \S+: '), '')
          .replaceAll(RegExp(r'-?\d+(\.\d+)?'), '#');
      kinds[k] = (kinds[k] ?? 0) + 1;
    }
    final byCount = kinds.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    // ignore: avoid_print
    print([for (final e in byCount) '${e.value} x ${e.key}'].join('\n'));
    // ignore: avoid_print
    print(
      'counts: ${[for (final k in keys) '$k ${counts[k]}'].join(', ')}\n'
      'worst: ${[for (final e in worst.entries) '${e.key} ${e.value.toStringAsFixed(2)}'].join(', ')}\n'
      'validator: ${invalid.length} matches; staging: ${problems.length} '
      'findings\n${invalid.take(10).join('\n')}\n${problems.take(40).join('\n')}',
    );
    // Every invariant holds in every match.
    expect(invalid, isEmpty);
    // What the engine recorded always reaches the screen: these findings
    // are never allowed, in any match.
    const mustNot = pitchOutcomeClasses;
    final outcome = [
      for (final p in problems)
        if (mustNot.any(p.contains)) p,
    ];
    // ignore: avoid_print
    print(
      'outcome findings ${outcome.length}; other staging findings '
      '${problems.length - outcome.length}',
    );
    expect(outcome, isEmpty);
    // The rest (a fouler a stride short, a kick-off a moment that cuts in
    // at once) are bounded.
    expect(problems.length - outcome.length, lessThan(40));
    for (final k in [
      'shot openPlay',
      'corner',
      'free kick direct',
      'free kick crossed',
      'penalty',
      'long throw',
      'foul + card',
      'offside',
      'sub',
      'injury',
      'shot goal',
      'shot saved',
      'shot wide',
      'shot blocked',
      'shot woodwork',
      'goal kick-off',
    ]) {
      expect(counts[k] ?? 0, greaterThan(0), reason: '$k never staged');
    }
  });

  // Task 15c f: the owner saw off-ball men stand about next to the net.
  // Outside set pieces and goal celebrations, at most four of the side
  // defending a goal (its keeper with three more) are within 6 m of its
  // line across the box, and the attackers the moment does not name never
  // park there.
  test('off-ball men never crowd a goal line in play', () {
    var defenders = 0.0;
    var attackers = 0.0;
    final at = <String>[];
    for (var seed = 0; seed < 200; seed++) {
      final m = _match(seed);
      final speed = PitchSpeed.values[seed % 3];
      final a = PitchAudit(_script(m, speed, seed: seed), 'match $seed')
        ..goalLineCrowds();
      final d = a.worst['goal line: defenders'] ?? 0;
      final k = a.worst['goal line: attackers'] ?? 0;
      if (d > 3 || k > 2) at.add('match $seed: $d defenders, $k attackers');
      defenders = math.max(defenders, d);
      attackers = math.max(attackers, k);
    }
    // ignore: avoid_print
    print(
      'goal line, most outfield men within 6 m: defenders $defenders, '
      'attackers $attackers; ${at.length} matches over\n'
      '${at.take(10).join('\n')}',
    );
    expect(defenders, lessThanOrEqualTo(3));
    expect(attackers, lessThanOrEqualTo(2));
  });

  test('a 120-minute match builds quickly', () {
    for (var seed = 0; seed < 60; seed += 3) {
      final m = _match(seed);
      if (m.result.extraTime == null) continue;
      final sw = Stopwatch()..start();
      final s = _script(m, PitchSpeed.slow, seed: seed);
      sw.stop();
      // ignore: avoid_print
      print(
        '120-minute build (match $seed, slow): ${sw.elapsedMilliseconds} ms, '
        '${s.keyframes.length} frames',
      );
      expect(sw.elapsedMilliseconds, lessThan(3000));
      return;
    }
    fail('no extra time in 20 matches');
  });

  test('the same seed gives the same frames', () {
    final m = _match(17);
    final a = _script(m, PitchSpeed.slow, seed: 5);
    final b = _script(m, PitchSpeed.slow, seed: 5);
    expect(b.keyframes.length, a.keyframes.length);
    for (var t = 0.0; t < a.totalSeconds; t += 0.21) {
      final fa = a.sample(_at(t));
      final fb = b.sample(_at(t));
      expect(fb.players, fa.players);
      expect(fb.ball, fa.ball);
      expect(fb.ballHeight, fa.ballHeight);
      expect(fb.tagged, fa.tagged);
    }
  });

  test('a moment staged from part-way through still shows its record', () {
    var resumed = 0;
    final kinds = <String>{};
    for (var seed = 0; seed < 24 && resumed < 40; seed++) {
      final m = _match(seed);
      final speed = PitchSpeed.values[seed % 3];
      final first = _script(m, speed, seed: seed);
      for (final w in first.windows) {
        if (w.moments.isEmpty) continue;
        final k = w.moments.first;
        final key = switch (k) {
          ShotMoment(:final origin) => 'shot ${origin.name}',
          SetPieceMoment(:final kind) => kind.name,
          _ => k.runtimeType.toString(),
        };
        if (kinds.contains('$key $seed')) continue;
        kinds.add('$key $seed');
        for (final frac in [0.3, 0.7]) {
          final at = w.start + (w.end - w.start) * frac;
          final state = first.stateAt(_at(at));
          final second = StoryLayer.build(
            result: m.result,
            lineups: m.lineups,
            pacer: PitchPacer(m.result, speed),
            seed: seed,
            resumeFrom: state,
          );
          resumed++;
          final seam = second.sample(_at(second.start));
          for (final e in state.players.entries) {
            expect(
              seam.players[e.key]!.distanceTo(e.value),
              lessThan(1e-6),
              reason: 'player ${e.key}, match $seed, $key at $frac',
            );
          }
          expect(
            seam.ball.distanceTo(state.ball),
            lessThan(1e-6),
            reason: 'ball, match $seed, $key at $frac',
          );
          expect(
            PitchScriptValidator.validate(second),
            isEmpty,
            reason: 'match $seed, $key resumed at $frac',
          );
          // A foul resumed still shows its whistle and its card.
          if (k is FoulMoment) {
            final again = second.windows.firstWhere(
              (x) => (x.start - w.start).abs() < 1e-6,
            );
            final kinds = {
              for (final q in again.cues)
                if (q.playerId == k.foulerId) q.kind,
            };
            expect(
              kinds.contains(PitchCueKind.foul) &&
                  (kinds.contains(PitchCueKind.yellowCard) ||
                      kinds.contains(PitchCueKind.redCard)),
              isTrue,
              reason: 'match $seed: resumed foul at $frac lost its cues',
            );
          }
          // A goal still ends in the net.
          for (final x in w.moments) {
            if (x is ShotMoment && x.outcome == ShotOutcome.goal) {
              final f = second.sample(_at(w.end - 1e-3));
              final dir = attackDir(
                home: x.teamNationId == second.homeNationId,
                minute: x.minute,
              );
              expect(
                xToDepth(f.ball.x, dir),
                greaterThan(PitchDims.length),
                reason: 'match $seed: resumed goal not in the net',
              );
            }
          }
        }
      }
    }
    expect(resumed, greaterThan(20));
  });

  test('a resume exactly on a kick-off does not play it again', () {
    for (var seed = 0; seed < 30; seed++) {
      final m = _match(seed);
      final first = _script(m, PitchSpeed.mid, seed: seed);
      // The intervals and the kick-offs after goals.
      final goals = [
        for (final w in first.windows)
          if (w.moments.any(
            (x) => x is ShotMoment && x.outcome == ShotOutcome.goal,
          ))
            for (final c in first.cuts)
              if ((c - w.end).abs() < 1e-6) c,
      ];
      if (goals.isEmpty) continue;
      for (final r in [...first.resets, ...goals]) {
        final state = first.stateAt(_at(r));
        final second = StoryLayer.build(
          result: m.result,
          lineups: m.lineups,
          pacer: PitchPacer(m.result, PitchSpeed.mid),
          seed: seed,
          resumeFrom: state,
        );
        expect(second.start, closeTo(r, 1e-5));
        // The frames at the kick-off: never the play before it again (a
        // moment opening there may still cut to itself, as it did).
        int at(PitchScript x) =>
            x.keyframes.where((f) => (f.t - r).abs() < 1e-5).length;
        expect(
          at(second),
          lessThanOrEqualTo(at(first)),
          reason: 'replayed at $r',
        );
        final seam = second.sample(_at(r));
        for (final e in state.players.entries) {
          expect(seam.players[e.key]!.distanceTo(e.value), lessThan(1e-6));
        }
        expect(PitchScriptValidator.validate(second), isEmpty);
      }
      return;
    }
    fail('no match with a goal in 30');
  });

  test('a pass whose receiver walks off mid-flight goes to a team-mate', () {
    var redirected = 0;
    for (var seed = 0; seed < 60 && redirected == 0; seed++) {
      final m = _match(seed);
      if (!m.result.events.any((e) => e.type == MatchEventType.injury)) {
        continue;
      }
      final s = StoryLayer.build(
        result: m.result,
        lineups: m.lineups,
        pacer: PitchPacer(m.result, PitchSpeed.slow),
        seed: 3,
        stager: const _PassToLeaver(),
      );
      expect(PitchScriptValidator.validate(s), isEmpty, reason: 'match $seed');
      // No flight of no length, the re-aimed one included.
      for (final p in s.ballPhases) {
        expect(p.t1, greaterThan(p.t0 + 1e-9));
      }
      for (final w in s.windows) {
        final off = w.injury?.playerId;
        if (off == null) continue;
        final oi = s.actorIndexOf(off)!;
        for (final p in s.ballPhases) {
          if (p is! FlightPhase || (p.t0 - w.end).abs() > 1e-6) continue;
          // Re-aimed where it was as he set off, at a team-mate.
          if (p.toActor != null &&
              p.toActor != oi &&
              s.actorList[p.toActor!].teamNationId ==
                  s.actorList[oi].teamNationId) {
            redirected++;
          }
        }
      }
    }
    expect(redirected, greaterThan(0));
  });

  test('a stand-in keeps goal until the keeper coming on takes over', () {
    final home = _team(1, 75, Formation.f442, const TacticalInstructions());
    final away = _team(2, 75, Formation.f433, const TacticalInstructions());
    final backup = player(id: 150, nationId: 1, position: PlayerPosition.gk);
    const r = MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [
        MatchEvent(
          minute: 30,
          type: MatchEventType.substitution,
          teamNationId: 1,
          playerId: 150,
          playerName: 'Backup',
          secondaryPlayerId: 100,
          secondaryName: 'Keeper',
        ),
      ],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
    );
    final s = StoryLayer.build(
      result: r,
      lineups: matchLineupsOf(
        home: home,
        away: away,
        homeBench: [backup.id],
      ),
      pacer: PitchPacer(r, PitchSpeed.mid),
      seed: 9,
    );
    expect(PitchScriptValidator.validate(s), isEmpty);
    Set<int> homeKeepers(double t) => {
      for (final id in s.keepersAt(t))
        if (s.actorList[s.actorIndexOf(id)!].teamNationId == 1) id,
    };
    final off = s.departures[100]!;
    final on = s.arrivals[150]!;
    double? takeover;
    // From the keeper's walk until the end, exactly one man keeps goal.
    for (final f in s.keyframes) {
      if (f.t < off) continue;
      final k = homeKeepers(f.t);
      expect(k.length, 1, reason: 'keepers $k at ${f.t}');
      if (takeover == null && k.contains(150)) takeover = f.t;
    }
    expect(takeover, isNotNull);
    expect(takeover!, greaterThanOrEqualTo(on));
    final standIn = homeKeepers(on + 0.3).single;
    expect(standIn, isNot(anyOf(100, 150)));
    // The stand-in goes back to his own place afterwards.
    final dir = attackDir(home: true, minute: 31);
    final before = xToDepth(s.sample(_at(takeover)).players[standIn]!.x, dir);
    final later = xToDepth(
      s.sample(_at(takeover + 6)).players[standIn]!.x,
      dir,
    );
    expect(later, greaterThan(before + 4));
  });

  test('a wall stands 9.15 m from a direct free kick, 3 to 5 men', () {
    var walls = 0;
    for (var seed = 0; seed < 120 && walls < 12; seed++) {
      final m = _match(seed);
      final s = _script(m, PitchSpeed.values[seed % 3], seed: seed);
      for (final w in s.windows) {
        if (w.moments.length < 2) continue;
        final sp = w.moments.first;
        final shot = w.moments[1];
        if (sp is! SetPieceMoment ||
            shot is! ShotMoment ||
            shot.origin != ShotOrigin.directFreeKick) {
          continue;
        }
        final a = PitchAudit(s, 'match $seed')..freeKick(w, sp);
        expect(a.problems, isEmpty);
        walls++;
      }
    }
    expect(walls, greaterThan(0));
  });
}

/// A stager that, in an injury's window, passes to the man hurt so that
/// the ball lands after he has started to walk off.
class _PassToLeaver implements MomentStager {
  const _PassToLeaver();

  @override
  StagedPlan stage(StagingContext context) => _PassToLeaverPlan(context);
}

class _PassToLeaverPlan implements StagedPlan {
  _PassToLeaverPlan(this.c);
  final StagingContext c;
  bool done = false;

  @override
  PlayerDrive? drive(int playerId, double t, ScriptState now) => null;

  @override
  bool settled(double t, ScriptState now) => true;

  @override
  BallAction? ball(double t, ScriptState now) {
    final off = c.window.injury?.playerId;
    if (done || off == null) return null;
    final car = now.carrierId;
    if (car == null || car == off) return null;
    if (now.teams[car] != now.teams[off]) return null;
    final p = now.players[off];
    if (p == null || p.distanceTo(now.ball) < 9) return null;
    if (t < c.window.end - 0.3) return null;
    done = true;
    return PassAction(toPlayerId: off, arriveAt: c.window.end + 0.8);
  }
}
