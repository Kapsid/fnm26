import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

import '../../helpers/pitch_match_lab.dart';

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

/// How an open-play chance was made, read off the picture: the ball the
/// shooter had before he struck it.
String _route(PitchScript s, StagedWindow w, ShotMoment m) {
  final si = s.actorIndexOf(m.shooterId);
  final dir = attackDir(
    home: m.teamNationId == s.homeNationId,
    minute: s.pacer.matchAt(_at(w.start + 1e-4)).minute,
  );
  double depth(Offset2 p) => xToDepth(p.x, dir);
  FlightPhase? strike;
  final balls = <FlightPhase>[];
  for (final p in s.ballPhases) {
    if (p is! FlightPhase || p.resting) continue;
    if (p.t0 < w.start - 1e-9 || p.t0 > w.end + 1) continue;
    // The strike: his ball to nobody, or to one of theirs (a keeper, a
    // blocker); a short ball to a team-mate is not it.
    final to = p.toActor;
    final theirs = to == null || s.actorList[to].teamNationId != m.teamNationId;
    if (p.fromActor == si && !p.pass && theirs) {
      strike = p;
      break;
    }
    balls.add(p);
  }
  if (strike == null) return 'none';
  final toHim = balls.where((p) => p.toActor == si).toList();
  final fromHim = balls.where((p) => p.fromActor == si).toList();
  if (toHim.isEmpty) {
    // His own ball: a run with it from well short (from where the picture
    // cut to him) is a carry.
    var from = w.start;
    for (final c in s.cuts) {
      if (c >= w.start - 1e-9 && c < strike.t0) from = c;
    }
    final ball = s.sample(_at(from + 1e-5)).ball;
    return depth(strike.from) - depth(ball) > 5 ? 'carry' : 'direct';
  }
  final last = toHim.last;
  if (fromHim.any((p) => p.t0 < last.t0 && p.toActor == last.fromActor)) {
    return 'one-two';
  }
  if (depth(last.from) >= 95 && depth(last.to) < depth(last.from) - 3) {
    return 'cut-back';
  }
  // Into space: forward, and he runs on to meet it.
  final (at, _) = s.actorAt(si!, last.t0);
  if (depth(last.to) - depth(last.from) >= 8 &&
      depth(last.to) - depth(at) >= 3) {
    return 'through';
  }
  return 'pass';
}

/// The home side's chances and passes over [n] seeded matches in which it
/// plays [mine] against a balanced side: its open-play routes (as
/// [_route] reads them) and the share of its quiet-time passes that go
/// long (over 28 m).
({Map<String, int> routes, int shots, double long}) _profile(
  TacticalInstructions mine, {
  int n = 30,
}) {
  final routes = <String, int>{};
  var shots = 0;
  var passes = 0;
  var long = 0;
  for (var seed = 0; seed < n; seed++) {
    final home = labTeam(1, 75, Formation.f433, mine);
    final away = labTeam(2, 75, Formation.f433, const TacticalInstructions());
    final result = labEngine.play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(0x5EED, seed),
      neutralVenue: true,
    );
    final m = (
      result: result,
      lineups: matchLineupsOf(
        home: home,
        away: away,
        homeBench: const [],
        awayBench: const [],
        result: result,
      ),
    );
    final s = labScript(m, PitchSpeed.mid, seed: seed);
    for (final w in s.windows) {
      final first = w.moments.firstOrNull;
      if (first is! ShotMoment ||
          first.origin != ShotOrigin.openPlay ||
          first.teamNationId != 1 ||
          first.header ||
          first.outcome == ShotOutcome.blocked) {
        continue;
      }
      shots++;
      final r = _route(s, w, first);
      routes[r] = (routes[r] ?? 0) + 1;
    }
    for (final p in s.ballPhases) {
      if (p is! FlightPhase || !p.pass || p.toActor == null) continue;
      final from = p.fromActor;
      if (from == null || s.windowAt(p.t0 + 1e-6) != null) continue;
      if (s.actorList[from].teamNationId != 1 ||
          s.actorList[p.toActor!].teamNationId != 1) {
        continue;
      }
      passes++;
      if (p.from.distanceTo(p.to) > 28) long++;
    }
  }
  return (routes: routes, shots: shots, long: long / passes);
}

double _share(Map<String, int> r, int n, String k) => (r[k] ?? 0) / n;

void main() {
  test(
    'a direct, quick side and a patient one make their chances differently',
    () {
      final direct = _profile(
        const TacticalInstructions(directness: 90, tempo: 90, width: 60),
      );
      final patient = _profile(
        const TacticalInstructions(directness: 10, tempo: 40, width: 40),
      );
      // ignore: avoid_print
      print(
        'direct ${direct.shots} shots ${direct.routes} long passes '
        '${(direct.long * 100).round()}%\n'
        'patient ${patient.shots} shots ${patient.routes} long passes '
        '${(patient.long * 100).round()}%',
      );
      expect(
        _share(direct.routes, direct.shots, 'through'),
        greaterThan(1.5 * _share(patient.routes, patient.shots, 'through')),
      );
      expect(
        _share(patient.routes, patient.shots, 'one-two'),
        greaterThan(1.5 * _share(direct.routes, direct.shots, 'one-two')),
      );
      expect(direct.long, greaterThan(1.5 * patient.long));
    },
  );

  test('open-play chances are made in different ways', () {
    final routes = <String, int>{};
    var shots = 0;
    for (var seed = 0; seed < 40; seed++) {
      final m = labMatch(seed);
      final speed = PitchSpeed.values[seed % PitchSpeed.values.length];
      final s = labScript(m, speed, seed: seed);
      for (final w in s.windows) {
        final first = w.moments.firstOrNull;
        if (first is! ShotMoment || first.origin != ShotOrigin.openPlay) {
          continue;
        }
        // A header is always crossed in, a block played as it comes.
        if (first.header || first.outcome == ShotOutcome.blocked) continue;
        shots++;
        final r = _route(s, w, first);
        routes[r] = (routes[r] ?? 0) + 1;
      }
    }
    // ignore: avoid_print
    print('$shots open-play shots: $routes');
    for (final r in ['one-two', 'cut-back', 'through']) {
      expect(
        routes[r] ?? 0,
        greaterThan(shots * 0.04),
        reason: '$r too rare: $routes',
      );
    }
    expect(routes['carry'] ?? 0, greaterThan(0), reason: '$routes');
    final most = routes.values.reduce((a, b) => a > b ? a : b);
    expect(most, lessThan(shots * 0.45), reason: 'samey: $routes');
  });

  test('the build-up mixes short passes, long ones and switches', () {
    var passes = 0;
    var short = 0;
    var long = 0;
    var switches = 0;
    for (var seed = 0; seed < 20; seed++) {
      final m = labMatch(seed);
      final s = labScript(m, PitchSpeed.slow, seed: seed);
      for (final p in s.ballPhases) {
        if (p is! FlightPhase || !p.pass || p.toActor == null) continue;
        if (s.windowAt(p.t0 + 1e-6) != null) continue;
        final from = p.fromActor;
        if (from == null ||
            s.actorList[from].teamNationId !=
                s.actorList[p.toActor!].teamNationId) {
          continue;
        }
        passes++;
        final d = p.from.distanceTo(p.to);
        if (d < 14) short++;
        if (d > 28) long++;
        if ((p.to.y - p.from.y).abs() > 30) switches++;
      }
    }
    // ignore: avoid_print
    print('$passes passes: $short short, $long long, $switches switches');
    expect(short, greaterThan(passes * 0.15));
    expect(long, greaterThan(passes * 0.12));
    expect(switches, greaterThan(passes * 0.015));
  });

  test('the same seed gives the same chances', () {
    final m = labMatch(5);
    final a = labScript(m, PitchSpeed.mid, seed: 5);
    final b = labScript(m, PitchSpeed.mid, seed: 5);
    expect(b.ballPhases.length, a.ballPhases.length);
    for (var k = 0; k < a.ballPhases.length; k++) {
      expect(b.ballPhases[k].t0, a.ballPhases[k].t0);
    }
  });
}
