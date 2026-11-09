import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';

import '../../helpers/pitch_match_lab.dart';

/// What the 2D TV shows of a match: its staged highlights (subs and
/// injuries apart), by kind, counted and timed, over 60 lab matches whose
/// dials run from one extreme to the other.
///
/// The owner's 2026-11 playtest: "too many corners". The engine records
/// about ten corners a match, a real figure, and the picture stages only
/// those that lead to a shot; what made them loom was their length (7.5 s
/// each against an open-play shot's 3.5 s). Set pieces are now shorter,
/// and this pins the mix.
void main() {
  test('open play makes the clear majority of the highlights', () {
    var setPieces = 0;
    var all = 0;
    var setSecs = 0.0;
    var allSecs = 0.0;
    var engineCorners = 0;
    var stagedCorners = 0;
    var cornerShots = 0;
    for (var seed = 0; seed < 60; seed++) {
      final m = labMatch(seed);
      final s = labScript(m, PitchSpeed.values[seed % 3], seed: seed);
      for (final x in m.result.moments) {
        if (x is SetPieceMoment && x.kind == SetPieceKind.corner) {
          engineCorners++;
        }
        if (x is ShotMoment && x.origin == ShotOrigin.corner) cornerShots++;
      }
      for (final w in s.windows) {
        final f = w.moments.firstOrNull;
        if (f == null || f is SubMoment) continue;
        final len = w.end - w.start;
        all++;
        allSecs += len;
        if (f is SetPieceMoment) {
          setPieces++;
          setSecs += len;
          if (f.kind == SetPieceKind.corner) stagedCorners++;
        }
      }
    }
    // ignore: avoid_print
    print(
      'highlights: $all, set pieces ${(setPieces / all * 100).round()}% of '
      'them and ${(setSecs / allSecs * 100).round()}% of their time; '
      'corners: engine $engineCorners, with a shot $cornerShots, '
      'staged $stagedCorners',
    );
    // The picture adds no corner the engine did not have, and stages only
    // those that led to a shot.
    expect(stagedCorners, cornerShots);
    expect(stagedCorners, lessThanOrEqualTo(engineCorners));
    expect(setPieces / all, lessThan(0.30));
    expect(setSecs / allSecs, lessThan(0.38));
  });
}
