import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/formation_slots.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/fixtures.dart';

const _engine = MatchEngine();

MatchTeam _team(int nation, int rating, Formation f, TacticalInstructions i) =>
    MatchTeam(
      nationId: nation,
      formation: f,
      instructions: i,
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

/// A varied engine match: shapes, dials, strengths, subs and extra time all
/// move with [seed].
_Match _match(int seed) {
  final r = SeededRng(seed * 7919 + 13);
  const fs = Formation.values;
  final home = _team(1, r.rangeInt(62, 84), fs[seed % fs.length], _dials(r));
  final away = _team(
    2,
    r.rangeInt(62, 84),
    fs[(seed * 7 + 3) % fs.length],
    _dials(r),
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
    rng: SeededRng.forFixture(0xF00D, seed),
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

bool _inWindow(PitchScript s, double t) =>
    s.windows.any((w) => t >= w.start && t < w.end);

/// Home share (0-100) of the quiet time the ball is a side's: at its man's
/// feet, or on its way from him.
double _homeBallShare(PitchScript s) {
  var home = 0.0;
  var all = 0.0;
  // Quiet time: the complement of the windows.
  final cuts = [
    for (final w in s.windows) (w.start, w.end),
  ];
  double quietWithin(double a, double b) {
    var len = b - a;
    for (final (ws, we) in cuts) {
      final lo = math.max(a, ws);
      final hi = math.min(b, we);
      if (hi > lo) len -= hi - lo;
    }
    return len;
  }

  for (final p in s.ballPhases) {
    final q = quietWithin(p.t0, p.t1);
    if (q <= 0) continue;
    final actor = switch (p) {
      CarryPhase(:final carrier) => carrier,
      FlightPhase(:final fromActor) => fromActor,
    };
    if (actor == null) continue;
    all += q;
    if (s.actorList[actor].teamNationId == s.homeNationId) home += q;
  }
  return 100 * home / all;
}

/// Screen seconds outside the staged windows.
double _quiet(PitchScript s) =>
    s.totalSeconds - s.windows.fold(0.0, (a, w) => a + w.end - w.start);

/// The least quiet time over which the story layer can steer the ball-time
/// split. Below it the pacer has cut every quiet minute to its 0.25 s floor
/// between back-to-back moments, and the ball simply stays with the side
/// each moment belongs to.
const double _steerable = 20;

MatchResult _withPossession(MatchResult r, int possession) => MatchResult(
  homeScore: r.homeScore,
  awayScore: r.awayScore,
  events: r.events,
  homeShots: r.homeShots,
  awayShots: r.awayShots,
  homePossession: possession,
  stoppage: r.stoppage,
  momentumByMinute: r.momentumByMinute,
  homePlan: r.homePlan,
  awayPlan: r.awayPlan,
  extraTime: r.extraTime,
  moments: r.moments,
  routineRestarts: r.routineRestarts,
);

int _count(PitchScript s, double t, int nation) => s
    .sample(Duration(microseconds: (t * 1e6).round()))
    .players
    .keys
    .where((id) => s.actorList[s.actorIndexOf(id)!].teamNationId == nation)
    .length;

void main() {
  test('quiet time obeys every invariant over 50 seeded matches', () {
    var maxSpeed = 0.0;
    var minGap = double.infinity;
    var keeperMax = 0.0;
    final split = <String>[];
    var worstSplit = 0.0;
    var missSum = 0.0;
    var steered = 0;
    for (var seed = 0; seed < 50; seed++) {
      final m = _match(seed);
      final speed = PitchSpeed.values[seed % 3];
      final s = _script(m, speed, seed: seed);
      final problems = PitchScriptValidator.validate(s);
      expect(problems, isEmpty, reason: 'match $seed ($speed)');

      // The measured figures for the report.
      final frames = s.keyframes;
      for (var k = 0; k + 1 < frames.length; k++) {
        final a = frames[k];
        final b = frames[k + 1];
        final dt = b.t - a.t;
        if (dt <= 1e-9) continue;
        for (var i = 0; i < s.actorList.length; i++) {
          if (!a.present(i) || !b.present(i)) continue;
          maxSpeed = math.max(maxSpeed, a.at(i).distanceTo(b.at(i)) / dt);
          for (var j = i + 1; j < s.actorList.length; j++) {
            if (!a.present(j) || !b.present(j)) continue;
            minGap = math.min(
              minGap,
              PitchScriptValidator.closestApproach(
                a.at(i),
                b.at(i),
                a.at(j),
                b.at(j),
              ),
            );
          }
        }
        final minute = s.pacer
            .matchAt(Duration(microseconds: (a.t * 1e6).round()))
            .minute;
        for (var i = 0; i < s.actorList.length; i++) {
          final actor = s.actorList[i];
          if (!actor.keeper || !a.present(i)) continue;
          final dir = attackDir(
            home: actor.teamNationId == s.homeNationId,
            minute: minute,
          );
          keeperMax = math.max(keeperMax, xToDepth(a.xs[i], dir));
        }
      }
      final share = _homeBallShare(s);
      final off = (share - m.result.homePossession).abs();
      final q = _quiet(s);
      if (q >= _steerable) {
        worstSplit = math.max(worstSplit, off);
        missSum += off;
        steered++;
      }
      split.add(
        '${m.result.homePossession}->${share.toStringAsFixed(0)}'
        '(q${q.toStringAsFixed(0)})',
      );
    }
    // ignore: avoid_print
    print(
      'max player speed ${maxSpeed.toStringAsFixed(2)} m/s, '
      'min gap ${minGap.toStringAsFixed(2)} m, '
      'keeper max ${keeperMax.toStringAsFixed(1)} m, '
      'ball-time miss mean ${(missSum / steered).toStringAsFixed(1)} '
      'worst ${worstSplit.toStringAsFixed(1)} pts over $steered steerable\n'
      'possession -> home ball time: ${split.join(' ')}',
    );
    // The split follows possession wherever there is quiet time to steer
    // it; a match whose quiet time is cut into slivers between moments of
    // the same side leans toward that side (see the report).
    expect(missSum / steered, lessThanOrEqualTo(3));
    expect(worstSplit, lessThanOrEqualTo(10));
  });

  test('a red card leaves the side with 10 and the shape re-forms', () {
    _Match? found;
    MatchEvent? red;
    for (var seed = 0; seed < 400 && found == null; seed++) {
      final m = _match(seed);
      // A side's first man down, with nobody coming on after him: ten men.
      final down = <int>{};
      for (final e in m.result.events) {
        final team = e.teamNationId;
        if (e.type == MatchEventType.substitution) down.add(team);
        if (e.type == MatchEventType.injury) down.add(team);
        if (e.type == MatchEventType.redCard &&
            e.minute < 80 &&
            !down.contains(team) &&
            !m.result.events.any(
              (x) =>
                  x.teamNationId == team &&
                  x != e &&
                  x.minute >= e.minute &&
                  (x.type != MatchEventType.goal &&
                      x.type != MatchEventType.yellowCard),
            )) {
          found = m;
          red = e;
          break;
        }
        if (e.type == MatchEventType.redCard) down.add(team);
      }
    }
    expect(found, isNotNull, reason: 'no red card in 400 matches');
    final s = _script(found!, PitchSpeed.mid);
    expect(PitchScriptValidator.validate(s), isEmpty);
    final start = s.departures[red!.playerId]!;
    expect(
      start,
      greaterThanOrEqualTo(
        s.pacer.screenAt(red.minute, red.stoppage).inMicroseconds / 1e6,
      ),
    );
    final gone = start + PitchScript.walkOffSeconds;
    // Walking off toward the nearer touchline, then gone.
    double edge(double t) {
      final p = s
          .sample(Duration(microseconds: (t * 1e6).round()))
          .players[red!.playerId]!;
      return math.min(p.y, PitchDims.width - p.y);
    }

    expect(edge(gone), lessThan(edge(start)));
    final after = s.sample(
      Duration(microseconds: ((gone + 0.05) * 1e6).round()),
    );
    expect(after.players.containsKey(red.playerId), isFalse);
    // Ten men from then on (bar a sub walking on for a man walking off).
    final side = red.teamNationId;
    for (var t = gone + 0.05; t < s.totalSeconds; t += 0.5) {
      expect(_count(s, t, side), lessThanOrEqualTo(10), reason: 't $t');
    }
    expect(_count(s, gone + 0.05, side), 10);
    expect(_count(s, start - 0.05, side), 11);

    // The shape re-forms: a back four that loses a centre-half still covers
    // both flanks with the three left.
    final l = layoutOf(Formation.f442);
    final re = reformedSlots(l, 0, {0, 1, 3, 4, 5, 6, 7, 8, 9, 10});
    expect([re[1].$1, re[3].$1, re[4].$1], [0.12, 0.5, 0.88]);
    // ...and a lone striker left of two holds the middle.
    final re2 = reformedSlots(l, 0, {for (var i = 0; i < 10; i++) i});
    expect(re2[9].$1, 0.5);
  });

  test('a sub swaps the right player', () {
    final m = _match(4);
    final sub = m.result.events.firstWhere(
      (e) => e.type == MatchEventType.substitution && e.teamNationId == 1,
    );
    final offId = sub.secondaryPlayerId!;
    final onId = sub.playerId;
    final s = _script(m, PitchSpeed.slow);
    expect(PitchScriptValidator.validate(s), isEmpty);
    final leave = s.departures[offId]!;
    final enter = s.arrivals[onId]!;
    final minuteStart =
        s.pacer.screenAt(sub.minute, sub.stoppage).inMicroseconds / 1e6;
    expect(leave, greaterThanOrEqualTo(minuteStart));
    expect(enter, closeTo(leave + PitchScript.walkOffSeconds, 1e-9));
    Duration at(double t) => Duration(microseconds: (t * 1e6).round());
    final before = s.sample(at(leave - 0.1));
    expect(before.players.containsKey(offId), isTrue);
    expect(before.players.containsKey(onId), isFalse);
    final later = s.sample(at(enter + 0.3));
    expect(later.players.containsKey(offId), isFalse);
    expect(later.players.containsKey(onId), isTrue);
    // On from the halfway line, benches' side.
    final first = later.players[onId]!;
    expect((first.x - PitchDims.length / 2).abs(), lessThan(6));
    expect(first.y, greaterThan(PitchDims.width - 4));
    // He wears a bench shirt and is no keeper.
    final actor = s.actorList[s.actorIndexOf(onId)!];
    expect(actor.shirt, greaterThanOrEqualTo(12));
    expect(actor.keeper, isFalse);
    expect(s.actors(sub.minute + 5).map((a) => a.playerId), contains(onId));
    expect(
      s.actors(sub.minute + 5).map((a) => a.playerId),
      isNot(contains(offId)),
    );
  });

  test('the same seed gives the same frames', () {
    final m = _match(11);
    final a = _script(m, PitchSpeed.mid, seed: 99);
    final b = _script(m, PitchSpeed.mid, seed: 99);
    final c = _script(m, PitchSpeed.mid, seed: 100);
    var differs = false;
    for (var t = 0.0; t < a.totalSeconds; t += 0.37) {
      final d = Duration(microseconds: (t * 1e6).round());
      final fa = a.sample(d);
      final fb = b.sample(d);
      expect(fb.players, fa.players);
      expect(fb.ball, fa.ball);
      expect(fb.ballHeight, fa.ballHeight);
      expect(fb.ballCarrierId, fa.ballCarrierId);
      expect(fb.camera, fa.camera);
      if (c.sample(d).ball != fa.ball) differs = true;
    }
    expect(differs, isTrue, reason: 'another seed tells another story');
  });

  test('possession 60% gives the home side about 60% of ball time (±7)', () {
    var checked = 0;
    for (var seed = 0; seed < 12; seed++) {
      final m = _match(seed);
      final r = _withPossession(m.result, 60);
      final s = StoryLayer.build(
        result: r,
        lineups: m.lineups,
        pacer: PitchPacer(r, PitchSpeed.values[seed % 3]),
        seed: seed,
      );
      if (_quiet(s) < _steerable) continue;
      checked++;
      expect(_homeBallShare(s), closeTo(60, 7), reason: 'match $seed');
    }
    expect(checked, greaterThanOrEqualTo(6));
  });

  test('line-ups deal shirts: keeper 1, the XI by slot, the bench on', () {
    final home = _team(1, 70, Formation.f433, const TacticalInstructions());
    final away = _team(2, 70, Formation.f352, const TacticalInstructions());
    final l = matchLineupsOf(home: home, away: away, homeBench: [150, 151]);
    expect(l.home.xi.map((p) => p.shirt), [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]);
    expect(l.away.formation, Formation.f352);
    expect(l.home.xi.first.playerId, 100);
    expect(l.home.bench, [150, 151]);
    expect(l.home.plan.formation, Formation.f433);
  });

  test('every staged window hands over a carried ball', () {
    final m = _match(3);
    final s = _script(m, PitchSpeed.fast);
    expect(s.windows, isNotEmpty);
    for (final w in s.windows) {
      expect(w.end, greaterThan(w.start));
      expect(w.entry.carrierId, isNotNull, reason: 'window at ${w.start}');
      expect(w.exit.players.length, lessThanOrEqualTo(22));
    }
  });

  test('the validator names what it catches', () {
    const r = MatchResult(
      homeScore: 0,
      awayScore: 0,
      events: [],
      homeShots: 0,
      awayShots: 0,
      homePossession: 50,
    );
    final pacer = PitchPacer(r, PitchSpeed.mid);
    final total = pacer.total.inMicroseconds / 1e6;
    ScriptKeyframe frame(double t, List<(double, double)> at) => ScriptKeyframe(
      t: t,
      xs: Float64List.fromList([for (final p in at) p.$1]),
      ys: Float64List.fromList([for (final p in at) p.$2]),
      facing: Float64List(at.length),
      cameraX: 52.5,
      zoom: 1,
    );
    final s = PitchScript(
      actorList: const [
        (playerId: 812, teamNationId: 1, shirt: 7, keeper: false),
        (playerId: 813, teamNationId: 1, shirt: 8, keeper: false),
        (playerId: 900, teamNationId: 2, shirt: 1, keeper: true),
      ],
      keyframes: [
        frame(0, [(40, 30), (50, 30.3), (20, 34)]),
        frame(1, [(54.2, 30), (50, 30.3), (20, 34)]),
        frame(total, [(54.2, 30), (50, 30.3), (20, 34)]),
      ],
      ballPhases: [CarryPhase(0, total, 1)],
      resets: const [],
      windows: const [],
      departures: const {},
      arrivals: const {},
      pacer: pacer,
      result: r,
      homeNationId: 1,
    );
    final found = PitchScriptValidator.validate(s);
    expect(found, contains('minute 1: player 812 moved 14.2 m/s'));
    expect(found.any((f) => f.contains('players 812 and 813')), isTrue);
    // The away keeper defends x 105 in the first half, so x 20 is miles off.
    expect(found.any((f) => f.contains('keeper 900')), isTrue);
  });
}
