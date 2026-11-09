import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/display_spacing.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

import '../../helpers/pitch_match_lab.dart';

/// The owner's 2026-11 "players sometimes walk off the pitch and play
/// continues", over 40 lab matches at every speed.
///
/// - Nobody playing (keepers included) ever stands, or is drawn, outside
///   the lines. The one allowance is the man taking a throw-in or a
///   corner, who may stand just past the line (at most `takerRoom`) around
///   his restart.
/// - A man sent off, injured or substituted leaves while play is stopped:
///   the window that stops play for him holds until he is off, and a cut
///   (the camera away) takes him off at once, so he is hardly ever seen
///   walking off with the ball in play (only when the next moment follows
///   straight on with no cut).
void main() {
  const takerRoom = 1.0;
  const step = 0.05;

  bool held(PitchScript s, double t) =>
      s.windows.any((w) => t >= w.start - 1e-9 && t < w.exit.t - 1e-9);

  /// The men who may stand just past a line at [t]: a routine restart's
  /// taker around his restart, a staged set piece's taker in its window.
  Set<int> takers(PitchScript s, double t) => {
    for (final r in s.restarts)
      if (t >= r.out - 1.0 && t <= r.taken + 1.0) r.takerId,
    for (final w in s.windows)
      if (t >= w.start - 1e-9 && t < w.exit.t)
        for (final id in w.actors) id,
  };

  double outside(Offset2 p) => [
    -p.x,
    p.x - PitchDims.length,
    -p.y,
    p.y - PitchDims.width,
  ].reduce((a, b) => a > b ? a : b);

  test('nobody playing stands or is drawn off the pitch', () {
    final off = <String>[];
    for (var seed = 0; seed < 40; seed++) {
      final m = labMatch(seed);
      final speed = PitchSpeed.values[seed % PitchSpeed.values.length];
      final s = labScript(m, speed, seed: seed);
      for (var t = s.start; t < s.totalSeconds; t += step) {
        final f = s.sample(Duration(microseconds: (t * 1e6).round()));
        final drawn = Declutter.frame(s, f, t);
        final room = takers(s, t);
        f.players.forEach((id, p) {
          final dep = s.departures[id];
          if (dep != null && t >= dep - 1e-9) return;
          final allowed = room.contains(id) ? takerRoom : 0.0;
          final o = outside(p);
          final od = outside(drawn[id]!);
          if (o > allowed + 1e-6 || od > allowed + 1e-6) {
            off.add(
              'match $seed ${s.minuteLabel(t)}: player $id at $p '
              '(drawn ${drawn[id]})',
            );
          }
        });
      }
    }
    expect(off.take(10), isEmpty, reason: '${off.length} frames off');
  });

  test('a man going off leaves while play is stopped', () {
    final live = <String>[];
    var departures = 0;
    for (var seed = 0; seed < 40; seed++) {
      final m = labMatch(seed);
      final speed = PitchSpeed.values[seed % PitchSpeed.values.length];
      final s = labScript(m, speed, seed: seed);
      s.departures.forEach((id, at) {
        final i = s.actorIndexOf(id)!;
        departures++;
        var seen = 0.0;
        for (var t = at; t < s.totalSeconds; t += step) {
          final f = s.sample(Duration(microseconds: (t * 1e6).round()));
          if (!f.players.containsKey(id)) break;
          if (!held(s, t)) seen += step;
        }
        if (seen > 0.5) {
          final (p, _) = s.actorAt(i, at);
          live.add(
            'match $seed ${s.minuteLabel(at)}: $id walked '
            '${seen.toStringAsFixed(1)} s in play from $p',
          );
        }
      });
    }
    // ignore: avoid_print
    print('$departures departures; walked in play:\n  ${live.join('\n  ')}');
    expect(departures, greaterThan(60));
    expect(live.length, lessThanOrEqualTo(departures ~/ 10), reason: '$live');
  });
}
