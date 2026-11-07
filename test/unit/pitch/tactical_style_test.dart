import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/fixtures.dart';
import '../../helpers/pitch_audit.dart';

/// Spec item 14 (the tactics show in the play, not only the result) and
/// item 13 (restarts that lead to action).
///
/// The side under test is the home side (nation 1), in a 4-3-3: slot k is
/// player 100 + k, so the left-back is 101, the right-back 104, the
/// holding midfielder 105, the left winger 108, the striker 109 and the
/// right winger 110. It meets the same balanced 4-4-2 every time.

const _matches = 100;
const _lb = 101, _rb = 104, _dm = 105, _lw = 108, _st = 109, _rw = 110;

Duration _dur(double t) => Duration(microseconds: (t * 1e6).round());

MatchTeam _side(
  int nation,
  int rating,
  Formation f,
  TacticalInstructions i, {
  Map<int, PlayerRole> roles = const {},
  FullBackPushes fullBacks = FullBackPushes.neutral,
}) => MatchTeam(
  nationId: nation,
  formation: f,
  instructions: i,
  roles: roles,
  fullBacks: fullBacks,
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

/// One style's 100 matches, built once and shared by the tests.
class _Style {
  _Style(
    this.instr, {
    this.roles = const {},
    this.fullBacks = FullBackPushes.neutral,
  });

  final TacticalInstructions instr;
  final Map<int, PlayerRole> roles;
  final FullBackPushes fullBacks;

  late final List<PitchScript> scripts = [
    for (var seed = 0; seed < _matches; seed++) _build(seed),
  ];

  PitchScript _build(int seed) {
    final r = SeededRng(seed * 6007 + 29);
    final home = _side(
      1,
      r.rangeInt(68, 80),
      Formation.f433,
      instr,
      roles: roles,
      fullBacks: fullBacks,
    );
    final away = _side(
      2,
      r.rangeInt(68, 80),
      Formation.f442,
      const TacticalInstructions(),
    );
    final result = const MatchEngine().play(
      home: home,
      away: away,
      rng: SeededRng.forFixture(0x7AC, seed),
      neutralVenue: true,
    );
    return StoryLayer.build(
      result: result,
      lineups: matchLineupsOf(home: home, away: away, result: result),
      pacer: PitchPacer(result, PitchSpeed.mid),
      seed: seed,
    );
  }
}

final _gegenpress = _Style(Playstyle.gegenpress.instructions!);
final _lowBlock = _Style(Playstyle.lowBlock.instructions!);
final _direct = _Style(Playstyle.direct.instructions!);
final _possession = _Style(Playstyle.possession.instructions!);
final _counter = _Style(Playstyle.counter.instructions!);
final _targetMan = _Style(
  Playstyle.possession.instructions!,
  roles: const {_st: PlayerRole.targetMan},
);
final _balanced = _Style(const TacticalInstructions());
final _overlapping = _Style(
  const TacticalInstructions(),
  fullBacks: const FullBackPushes(
    left: FullBackPush.up,
    right: FullBackPush.up,
  ),
);
final _insideForwards = _Style(
  const TacticalInstructions(),
  roles: const {
    _lw: PlayerRole.invertedWinger,
    _rw: PlayerRole.invertedWinger,
  },
);

final _all = [
  _gegenpress,
  _lowBlock,
  _direct,
  _possession,
  _counter,
  _targetMan,
  _balanced,
  _overlapping,
  _insideForwards,
];

/// A script read back for open play: quiet time, well clear of every
/// moment, cut and kick-off.
class _Read {
  _Read(this.s) {
    for (final w in s.windows) {
      _busy.add((w.start - 0.5, w.end + 3));
    }
    for (final c in [...s.cuts, ...s.resets]) {
      _busy.add((c - 0.5, c + 2));
    }
  }

  final PitchScript s;
  final List<(double, double)> _busy = [];

  bool quiet(double t) => !_busy.any((b) => t >= b.$1 && t <= b.$2);

  bool home(int actor) => s.actorList[actor].teamNationId == s.homeNationId;

  int dir(bool home, double t) =>
      attackDir(home: home, minute: s.pacer.matchAt(_dur(t)).minute);

  double depth(Offset2 p, bool home, double t) => xToDepth(p.x, dir(home, t));

  double lat(Offset2 p, bool home, double t) =>
      (p.y - PitchDims.width / 2) * dir(home, t);

  /// Every quiet keyframe while somebody carries the ball: the frame, and
  /// whether the home side has it.
  Iterable<(ScriptKeyframe, bool)> carried() sync* {
    var k = 0;
    final frames = s.keyframes;
    for (final p in s.ballPhases) {
      if (p is! CarryPhase) continue;
      final homeBall = home(p.carrier);
      while (k < frames.length && frames[k].t < p.t0) {
        k++;
      }
      for (var j = k; j < frames.length && frames[j].t < p.t1; j++) {
        if (quiet(frames[j].t)) yield (frames[j], homeBall);
      }
    }
  }

  /// [id]'s place in keyframe [f], or null when he is not on.
  Offset2? at(ScriptKeyframe f, int id) {
    final i = s.actorIndexOf(id);
    if (i == null || !f.present(i)) return null;
    return f.at(i);
  }
}

double _mean(List<double> xs) =>
    xs.isEmpty ? double.nan : xs.reduce((a, b) => a + b) / xs.length;

/// The home side's mean outfield depth while the other side has the ball.
double _defendingDepth(_Style style) {
  final depths = <double>[];
  for (final s in style.scripts) {
    final r = _Read(s);
    for (final (f, homeBall) in r.carried()) {
      if (homeBall) continue;
      for (var i = 0; i < s.actorList.length; i++) {
        if (!r.home(i) || !f.present(i) || f.keeper(i)) continue;
        depths.add(r.depth(f.at(i), true, f.t));
      }
    }
  }
  return _mean(depths);
}

/// The home side's quiet-time passes, man to man: their mean length.
double _passLength(_Style style) {
  final lengths = <double>[];
  for (final s in style.scripts) {
    final r = _Read(s);
    for (final p in s.ballPhases) {
      if (p is! FlightPhase || !p.pass || p.resting) continue;
      final from = p.fromActor;
      final to = p.toActor;
      if (from == null || to == null) continue;
      if (!r.home(from) || !r.home(to)) continue;
      if (!r.quiet(p.t0) || !r.quiet(p.t1)) continue;
      lengths.add(p.from.distanceTo(p.to));
    }
  }
  return _mean(lengths);
}

/// After winning the ball in open play in its own half, how fast the home
/// side gets it toward the opponent's third (depth 70 or more):
/// - the ball's mean forward speed (m/s) over the first 2.5 s it keeps it;
/// - the mean time to the third, over the turnovers that get there inside
///   6 s without losing it or a moment;
/// - the share of all such turnovers that get there within 4 s.
(double, double, double) _breakTime(_Style style) {
  final rates = <double>[];
  final times = <double>[];
  var turnovers = 0;
  for (final s in style.scripts) {
    final r = _Read(s);
    for (final p in s.ballPhases) {
      if (p is! FlightPhase || p.resting) continue;
      final from = p.fromActor;
      final to = p.toActor;
      if (from == null || to == null) continue;
      if (r.home(from) || !r.home(to)) continue;
      if (!r.quiet(p.t1) || !r.quiet(p.t1 + 6)) continue;
      // Won short of halfway: there is a pitch to cross.
      final d0 = r.depth(p.to, true, p.t1);
      if (d0 >= PitchDims.length / 2) continue;
      turnovers++;
      // Ours from p.t1: follow it while we keep it.
      double? kept;
      var reached = false;
      for (var t = p.t1; t < p.t1 + 6; t += 0.1) {
        final f = s.sample(_dur(t));
        final c = f.ballCarrierId;
        if (c != null && !r.home(s.actorIndexOf(c)!)) break;
        final d = r.depth(f.ball, true, t);
        if (t - p.t1 <= 2.5) kept = (d - d0) / math.max(0.1, t - p.t1);
        if (!reached && d >= 70) {
          times.add(t - p.t1);
          reached = true;
        }
      }
      if (kept != null) rates.add(kept);
    }
  }
  final quick = times.where((x) => x <= 4).length;
  return (_mean(rates), _mean(times), quick / math.max(1, turnovers));
}

/// Over quiet frames with the home side on the ball in the other half, the
/// share in which each full-back stands beyond his winger's line.
double _overlapShare(_Style style) {
  var ahead = 0;
  var n = 0;
  for (final s in style.scripts) {
    final r = _Read(s);
    for (final (f, homeBall) in r.carried()) {
      if (!homeBall) continue;
      final ball = s.sample(_dur(f.t)).ball;
      if (r.depth(ball, true, f.t) < PitchDims.length / 2) continue;
      for (final (fb, w) in [(_lb, _lw), (_rb, _rw)]) {
        final a = r.at(f, fb);
        final b = r.at(f, w);
        if (a == null || b == null) continue;
        n++;
        if (r.depth(a, true, f.t) > r.depth(b, true, f.t)) ahead++;
      }
    }
  }
  return ahead / math.max(1, n);
}

/// The mean depth (and, as the second figure, distance from the middle
/// across the pitch) of player [id] while the home side is on the ball.
(double, double) _inPossession(_Style style, List<int> ids) {
  final depths = <double>[];
  final lats = <double>[];
  for (final s in style.scripts) {
    final r = _Read(s);
    for (final (f, homeBall) in r.carried()) {
      if (!homeBall) continue;
      for (final id in ids) {
        final p = r.at(f, id);
        if (p == null) continue;
        depths.add(r.depth(p, true, f.t));
        lats.add(r.lat(p, true, f.t).abs());
      }
    }
  }
  return (_mean(depths), _mean(lats));
}

/// The engine's index into `routineRestarts` for a match minute: stoppage
/// folds onto 90.
int _restartIndex(PitchScript s, double t) {
  final m = s.pacer.matchAt(_dur(t));
  return m.minute > 90 || m.stoppage == 0 ? m.minute : 90;
}

void main() {
  test("high press: the defending side's mean depth is ≥ 8 m higher than "
      "a low block's", () {
    final high = _defendingDepth(_gegenpress);
    final low = _defendingDepth(_lowBlock);
    // ignore: avoid_print
    print(
      'defending depth: high press ${high.toStringAsFixed(1)} m, '
      'low block ${low.toStringAsFixed(1)} m',
    );
    expect(high - low, greaterThanOrEqualTo(8));
  });

  test('direct sides average longer passes than patient ones (≥ 30%)', () {
    final direct = _passLength(_direct);
    final patient = _passLength(_possession);
    // ignore: avoid_print
    print(
      'pass length: direct ${direct.toStringAsFixed(1)} m, '
      'patient ${patient.toStringAsFixed(1)} m',
    );
    expect(direct, greaterThanOrEqualTo(patient * 1.3));
  });

  test("counter sides reach the opponent's third faster after a turnover", () {
    final (counterRate, counter, counterShare) = _breakTime(_counter);
    final (patientRate, patient, patientShare) = _breakTime(_possession);
    // ignore: avoid_print
    print(
      'after a turnover in their own half: counter '
      '${counterRate.toStringAsFixed(1)} m/s up the pitch, '
      '${counter.toStringAsFixed(2)} s to the final third '
      '(${(counterShare * 100).round()}% within 4 s); patient '
      '${patientRate.toStringAsFixed(1)} m/s, '
      '${patient.toStringAsFixed(2)} s (${(patientShare * 100).round()}%)',
    );
    expect(counterRate, greaterThanOrEqualTo(patientRate * 1.3));
    expect(counter, lessThan(patient));
    // A fixed floor: at least 15% of these breaks reach the final third
    // within 4 s (the patient side manages 0%).
    expect(counterShare, greaterThanOrEqualTo(0.15));
  });

  test("overlapping full-backs pass their winger's line in possession", () {
    final up = _overlapShare(_overlapping);
    final neutral = _overlapShare(_balanced);
    // ignore: avoid_print
    print(
      'full-back beyond his winger: pushed on ${(up * 100).round()}%, '
      'neutral ${(neutral * 100).round()}%',
    );
    expect(up, greaterThanOrEqualTo(0.5));
    expect(up - neutral, greaterThanOrEqualTo(0.3));
  });

  test('a false nine drops ≥ 10 m deeper than a target man', () {
    // The same patient side; only the striker's role differs. With no
    // role, a lone striker in a patient side plays as a false nine.
    final (nine, _) = _inPossession(_possession, [_st]);
    final (target, _) = _inPossession(_targetMan, [_st]);
    // ignore: avoid_print
    print(
      'striker depth on the ball: false nine ${nine.toStringAsFixed(1)} m, '
      'target man ${target.toStringAsFixed(1)} m',
    );
    expect(target - nine, greaterThanOrEqualTo(10));
  });

  test('inside forwards come in off the flank; wide wingers hold the width', () {
    final (_, inside) = _inPossession(_insideForwards, [_lw, _rw]);
    final (_, wide) = _inPossession(_balanced, [_lw, _rw]);
    // ignore: avoid_print
    print(
      'winger distance from the middle on the ball: inside forwards '
      '${inside.toStringAsFixed(1)} m, wide wingers ${wide.toStringAsFixed(1)} m',
    );
    expect(wide - inside, greaterThanOrEqualTo(8));
  });

  test('a holding midfielder screens his back line: central, in front of it, '
      'and stays behind the ball', () {
    final gaps = <double>[];
    final lats = <double>[];
    var behind = 0;
    var n = 0;
    for (final s in _balanced.scripts) {
      final r = _Read(s);
      for (final (f, homeBall) in r.carried()) {
        final dm = r.at(f, _dm);
        if (dm == null) continue;
        final dmDepth = r.depth(dm, true, f.t);
        if (homeBall) {
          final ball = s.sample(_dur(f.t)).ball;
          if (r.depth(ball, true, f.t) < 60) continue;
          n++;
          if (dmDepth < r.depth(ball, true, f.t) - 10) behind++;
          continue;
        }
        final backs = [
          for (final id in [102, 103])
            if (r.at(f, id) case final p?) r.depth(p, true, f.t),
        ];
        if (backs.isEmpty) continue;
        gaps.add(dmDepth - _mean(backs));
        lats.add(r.lat(dm, true, f.t).abs());
      }
    }
    final gap = _mean(gaps);
    final lat = _mean(lats);
    // ignore: avoid_print
    print(
      'holding midfielder out of possession: ${gap.toStringAsFixed(1)} m '
      'ahead of his centre-backs, ${lat.toStringAsFixed(1)} m off the '
      'middle; behind the ball in the final third ${(behind / n * 100).round()}%',
    );
    expect(gap, inInclusiveRange(4, 14));
    expect(lat, lessThan(10));
    expect(behind / n, greaterThan(0.85));
  });

  test('AI drift changes the picture from the minute after it happens', () {
    var checked = 0;
    for (var seed = 0; seed < 40 && checked < 5; seed++) {
      final home = _side(1, 84, Formation.f433, const TacticalInstructions());
      final away = _side(2, 66, Formation.f442, const TacticalInstructions());
      final result = const MatchEngine().play(
        home: home,
        away: away,
        rng: SeededRng.forFixture(0xD21F7, seed),
        aiManagedNationIds: const {2},
      );
      if (result.instructionLog.isEmpty) continue;
      final first = result.instructionLog.first.minute;
      if (first >= 89) continue;
      checked++;
      final lineups = matchLineupsOf(home: home, away: away, result: result);
      final pacer = PitchPacer(result, PitchSpeed.mid);
      // The same result both times: only whether the drift is followed
      // differs.
      PitchScript build({required bool drift}) => StoryLayer.build(
        result: result,
        lineups: lineups,
        pacer: pacer,
        seed: seed,
        followDrift: drift,
      );
      final drifted = build(drift: true);
      final fixed = build(drift: false);
      final from = pacer.screenAt(first + 1, 0).inMicroseconds / 1e6;
      // Up to the minute after the change: the very same picture.
      for (var t = 0.0; t < from - 1e-3; t += 0.1) {
        expect(
          drifted.sample(_dur(t)).players,
          fixed.sample(_dur(t)).players,
          reason:
              'match $seed: the change at $first\' shows before '
              '${first + 1}\' (t $t)',
        );
      }
      // From it on, the side that changed plays differently.
      var differs = false;
      final to =
          pacer.screenAt(math.min(first + 4, 90), 0).inMicroseconds / 1e6;
      for (var t = from; t < to && !differs; t += 0.1) {
        final a = drifted.sample(_dur(t)).players;
        final b = fixed.sample(_dur(t)).players;
        differs = a.keys.any((id) => id ~/ 100 == 2 && a[id] != b[id]);
      }
      expect(differs, isTrue, reason: 'match $seed: drift at $first\' unseen');
      expect(PitchScriptValidator.validate(drifted), isEmpty);
    }
    expect(checked, 5);
  });

  test('a routine restart is staged only when it opens the build-up to the '
      'next moment, in the flow and with no line', () {
    var staged = 0;
    var goalKicks = 0;
    for (final style in [_balanced, _counter, _direct]) {
      for (final s in style.scripts) {
        final perMinute = <int, int>{};
        for (final x in s.restarts) {
          staged++;
          final label =
              'match ${s.result.homeScore}-${s.result.awayScore} '
              '${s.minuteLabel(x.out)}';
          // Short and in the flow: no window, cut or kick-off in it.
          expect(x.taken - x.out, inInclusiveRange(0, 1.2), reason: label);
          expect(s.windowAt(x.out), isNull, reason: label);
          expect(s.windowAt(x.taken), isNull, reason: label);
          expect(
            [...s.cuts, ...s.resets].where(
              (c) => c >= x.out - 1e-9 && c <= x.taken + 1e-9,
            ),
            isEmpty,
            reason: label,
          );
          // Only as many as the engine recorded in that minute.
          final idx = _restartIndex(s, x.out);
          perMinute[idx] = (perMinute[idx] ?? 0) + 1;
          expect(
            perMinute[idx],
            lessThanOrEqualTo(s.result.routineRestarts[idx]),
            reason: label,
          );
          // The next window is the restarting side's shot or corner.
          final next = s.windows.firstWhere((w) => w.start > x.taken);
          final m = next.moments.first;
          expect(m.teamNationId, x.teamNationId, reason: label);
          expect(
            (m is ShotMoment && m.origin != ShotOrigin.penalty) ||
                (m is SetPieceMoment && m.kind == SetPieceKind.corner),
            isTrue,
            reason: '$label: $m',
          );
          // Close before it: the lead-in and a second, two more for a goal
          // kick's long ball.
          expect(
            next.start - x.taken,
            lessThanOrEqualTo(
              LeadIn.ball + (x.kind == PitchRestartKind.goalKick ? 3 : 1),
            ),
            reason: label,
          );
          // ... and the restarting side keeps the ball from the restart
          // into it: the same build-up.
          for (final p in s.ballPhases) {
            if (p.t1 <= x.taken + 1e-9 || p.t0 >= next.start - 1e-9) continue;
            final who = switch (p) {
              CarryPhase(:final carrier) => carrier,
              FlightPhase(:final toActor) => toActor,
            };
            if (who == null) continue;
            expect(
              s.actorList[who].teamNationId,
              x.teamNationId,
              reason: '$label: the ball is lost before the moment',
            );
          }
          // The taker restarts it: a throw from the touchline, a goal kick
          // from the six-yard box, the ball leaving from him.
          final f = s.sample(_dur(x.taken));
          final taker = f.players[x.takerId]!;
          final kick = s.ballPhases.whereType<FlightPhase>().firstWhere(
            (p) => (p.t0 - x.taken).abs() < 1e-6 && !p.resting,
          );
          expect(kick.fromActor, s.actorIndexOf(x.takerId), reason: label);
          expect(kick.from.distanceTo(taker), lessThan(2.0), reason: label);
          if (x.kind == PitchRestartKind.throwIn) {
            expect(
              math.min(taker.y, PitchDims.width - taker.y),
              lessThan(1.5),
              reason: label,
            );
          } else {
            expect(f.keepers, contains(x.takerId), reason: label);
            final home = x.teamNationId == s.homeNationId;
            final dir = attackDir(
              home: home,
              minute: s.pacer.matchAt(_dur(x.taken)).minute,
            );
            expect(xToDepth(taker.x, dir), lessThan(8), reason: label);
            // It becomes a counter: long, up to a team-mate, and the side
            // is in the other half before its moment.
            goalKicks++;
            expect(kick.from.distanceTo(kick.to), greaterThanOrEqualTo(25));
            expect(
              xToDepth(kick.to.x, dir) - xToDepth(kick.from.x, dir),
              greaterThanOrEqualTo(20),
              reason: label,
            );
            var over = false;
            for (var t = x.taken; t < next.start && !over; t += 0.1) {
              over =
                  xToDepth(s.sample(_dur(t)).ball.x, dir) >
                  PitchDims.length / 2;
            }
            expect(over, isTrue, reason: '$label: no counter');
          }
        }
      }
    }
    // ignore: avoid_print
    print(
      'restarts staged: $staged ($goalKicks goal kicks into a counter) over '
      '${3 * _matches} matches',
    );
    expect(staged, greaterThan(20));
    expect(goalKicks, greaterThan(0));
  });

  test('every Ruling 9 class still 0, validator 0', () {
    final invalid = <String>[];
    final outcome = <String>[];
    var other = 0;
    var i = 0;
    for (final style in _all) {
      for (final s in style.scripts) {
        final label = 'style ${i ~/ _matches} match ${i % _matches}';
        i++;
        final v = PitchScriptValidator.validate(s, limit: 5);
        if (v.isNotEmpty) invalid.add('$label: ${v.join('; ')}');
        final a = PitchAudit(s, label)..run();
        for (final p in a.problems) {
          if (pitchOutcomeClasses.any(p.contains)) {
            outcome.add(p);
          } else {
            other++;
          }
        }
      }
    }
    // ignore: avoid_print
    print(
      'validator: ${invalid.length}; outcome findings ${outcome.length}; '
      'other $other\n${invalid.take(10).join('\n')}\n'
      '${outcome.take(20).join('\n')}',
    );
    expect(invalid, isEmpty);
    expect(outcome, isEmpty);
    // The same bound as the 200-match audit, scaled to these matches.
    expect(other, lessThan(40 * _all.length * _matches ~/ 200));
  });
}
