import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

import '../../helpers/pitch_match_lab.dart';

/// 1.1.4 feedback: the 2D match had too many stops between the shots and
/// too little happening between them. Over 20 lab matches the picture is
/// sampled every 0.1 s; a "dead" stretch is more than a second of the ball
/// moving slower than 2.5 m/s (lying still, or a man standing over it).
/// The stops that are meant to be there (a goal and its celebration, a
/// card, a penalty and its foul, an injury, a red card's walk) are left
/// out, and so is a goal VAR chalks off (its check): they are staged as
/// they always were.
typedef _Dead = ({double perMatch, double mean, double max, double length});

_Dead _deadTime(PitchSpeed speed) {
  const n = 20;
  const dt = 0.1;
  var total = 0.0;
  var count = 0;
  var max = 0.0;
  var length = 0.0;
  for (var seed = 0; seed < n; seed++) {
    final s = labScript(labMatch(seed), speed);
    length += s.totalSeconds;
    bool meant(StagedWindow w) {
      if (w.injury != null) return true;
      if (w.moments.any(
        (m) =>
            m is ShotMoment &&
            (m.outcome.inNet || m.origin == ShotOrigin.penalty),
      )) {
        return true;
      }
      final m = w.moments.first;
      if (m is! FoulMoment) return false;
      if (m.cardEventIndex != null) return true;
      final i = s.windows.indexOf(w);
      final next = i + 1 < s.windows.length ? s.windows[i + 1] : null;
      final k = next == null || next.moments.isEmpty
          ? null
          : next.moments.first;
      return k is ShotMoment && k.origin == ShotOrigin.penalty;
    }

    bool counts(double t) {
      final w = s.windowAt(t);
      if (w != null) return !meant(w);
      final before = s.windows.where((x) => x.end <= t + 1e-6).lastOrNull;
      return before == null || t - before.end >= 0.5 || !meant(before);
    }

    final breaks = [...s.cuts, ...s.resets];
    var prev = s.sample(Duration.zero).ball;
    var run = 0.0;
    var from = 0.0;
    void close() {
      if (run > 1 + 1e-9 && counts(from + 0.05)) {
        total += run;
        count++;
        if (run > max) max = run;
      }
      run = 0;
    }

    for (var t = dt; t < s.totalSeconds; t += dt) {
      final b = s.sample(Duration(microseconds: (t * 1e6).round())).ball;
      final v = b.distanceTo(prev) / dt;
      prev = b;
      if (breaks.any((c) => c > t - dt && c <= t)) {
        close();
      } else if (v < 2.5) {
        if (run == 0) from = t;
        run += dt;
      } else {
        close();
      }
    }
    close();
  }
  return (
    perMatch: total / n,
    mean: count == 0 ? 0 : total / count,
    max: max,
    length: length / n,
  );
}

void main() {
  test('slow: few and short stops between the moments', () {
    final d = _deadTime(PitchSpeed.slow);
    // ignore: avoid_print
    print('slow dead time $d');
    // Before (with the 1.1.4 lull fixes): 22.0 s a match, a stop 1.93 s
    // on average, the longest 7.5 s; now about 9.8 s, 1.81 s and 4.7 s
    // (what leads into or out of a card keeps its full length). The match
    // is no longer for it.
    expect(d.perMatch, lessThan(10.5));
    expect(d.mean, lessThan(1.85));
    expect(d.max, lessThan(5));
    expect(d.length, inInclusiveRange(240, 265));
  });

  test('fast: few and short stops between the moments', () {
    final d = _deadTime(PitchSpeed.fast);
    // ignore: avoid_print
    print('fast dead time $d');
    // Before: 7.0 s a match, 1.90 s a stop, the longest 7.9 s (a
    // substitute's walk); now about 5.3 s, 1.71 s and 3.6 s.
    expect(d.perMatch, lessThan(5.5));
    expect(d.mean, lessThan(2));
    expect(d.max, lessThan(5));
  });

  test('the quiet play has tackles, crosses headed clear and dribbles', () {
    const n = 20;
    var tackles = 0;
    var crosses = 0;
    var dribbles = 0;
    var passes = 0;
    for (var seed = 0; seed < n; seed++) {
      final s = labScript(labMatch(seed), PitchSpeed.slow);
      for (final p in s.ballPhases) {
        if (s.windowAt((p.t0 + p.t1) / 2) != null) continue;
        switch (p) {
          case FlightPhase(:final fromActor?, :final toActor?) when !p.resting:
            final a = s.actorList[fromActor];
            final b = s.actorList[toActor];
            final turnover = a.teamNationId != b.teamNationId;
            final intoBox =
                (p.to.x < 28 || p.to.x > PitchDims.length - 28) &&
                (p.to.y - PitchDims.width / 2).abs() < 21;
            if (turnover && intoBox && p.toHeight > 1) {
              crosses++;
            } else if (turnover && p.from.distanceTo(p.to) < 6) {
              tackles++;
            } else if (!turnover) {
              passes++;
            }
          case CarryPhase(:final carrier) when p.t1 - p.t0 > 0.8:
            final id = s.actorList[carrier].playerId;
            final a = s
                .sample(Duration(microseconds: (p.t0 * 1e6).round()))
                .players[id];
            final b = s
                .sample(Duration(microseconds: (p.t1 * 1e6).round()))
                .players[id];
            if (a != null && b != null && a.distanceTo(b) / (p.t1 - p.t0) > 6) {
              dribbles++;
            }
          default:
            break;
        }
      }
    }
    // ignore: avoid_print
    print(
      'per match: tackles ${tackles / n}, crosses ${crosses / n}, '
      'dribbles ${dribbles / n}, passes ${passes / n}',
    );
    // Before: under a tackle a match, no cross headed clear, 4.5 dribbles
    // and 32 passes; now about 4.3, 1.5, 6.2 and 38. (Only forwards, wide
    // men and the attacking midfielder take a man on, and nobody a moment
    // is about to name.)
    expect(tackles / n, greaterThan(4));
    expect(crosses / n, greaterThan(1));
    expect(dribbles / n, greaterThan(5.5));
    expect(passes / n, greaterThan(35));
  });
}
