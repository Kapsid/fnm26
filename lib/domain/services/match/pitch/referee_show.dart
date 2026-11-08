/// The referee showing a red card on the 2D TV: drawn over the picture,
/// never part of the play the story layer stages, so nothing he does moves
/// a man, the ball or an outcome. He comes in at a run, stands beside the
/// man sent off and raises the card on the moment's red-card cue; the man
/// then walks (the script's own departure) and his side plays on a man
/// short. Pure Dart: no Flutter.
library;

import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

/// The referee at one instant: where he stands, how far the card is up
/// (0 down, 1 held high) and who it is shown to.
typedef RefereeFrame = ({Offset2 at, double card, int playerId});

abstract final class RefereeShow {
  /// How long before the cue he sets off toward the man.
  static const double approach = 1.4;

  /// How long after the cue the card stays up.
  static const double hold = 1.8;

  /// How far from the man he starts, and where he stands to show it.
  static const double startGap = 9;
  static const double standGap = 1.8;

  /// The referee at screen second [t] of [s], or null when no red card is
  /// being shown.
  static RefereeFrame? at(PitchScript s, double t) {
    for (final w in s.windows) {
      if (t < w.start - approach - 1 || t > w.end + hold + 1) continue;
      for (final c in w.cues) {
        if (c.kind != PitchCueKind.redCard) continue;
        // He sets off at the whistle, never before the foul.
        var from = c.t - approach;
        for (final f in w.cues) {
          if (f.kind == PitchCueKind.foul && f.t <= c.t && f.t > from) {
            from = f.t;
          }
        }
        if (t < from || t > c.t + hold + 0.4) continue;
        return _frame(s, c.t, c.playerId, t, from);
      }
    }
    return null;
  }

  static RefereeFrame? _frame(
    PitchScript s,
    double cue,
    int id,
    double t,
    double from,
  ) {
    final i = s.actorIndexOf(id);
    if (i == null) return null;
    // He comes to where the man is as the card is shown, from the side
    // of the pitch's middle, so he never runs in from off the field.
    final (at, _) = s.actorAt(i, cue);
    var away = PitchDims.centre - at;
    if (away.length < 1e-6) away = const Offset2(0, 1);
    final u = away.unit;
    final stand = _onPitch(at + u * standGap);
    final start = _onPitch(at + u * startGap);
    final runFor = (cue - 0.2 - from).clamp(0.3, approach);
    final run = ((t - from) / runFor).clamp(0.0, 1.0);
    final eased = 1 - (1 - run) * (1 - run);
    final pos = Offset2.lerp(start, stand, eased);
    final double card;
    if (t < cue - 0.2) {
      card = 0;
    } else if (t < cue + 0.2) {
      card = (t - (cue - 0.2)) / 0.4;
    } else if (t < cue + hold) {
      card = 1;
    } else {
      card = (1 - (t - cue - hold) / 0.4).clamp(0.0, 1.0);
    }
    return (at: pos, card: card, playerId: id);
  }

  static Offset2 _onPitch(Offset2 p) => Offset2(
    p.x.clamp(1.0, PitchDims.length - 1.0),
    p.y.clamp(1.0, PitchDims.width - 1.0),
  );
}
