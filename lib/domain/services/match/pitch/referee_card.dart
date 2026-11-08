/// The referee's part in a sending-off on the 2D TV: he runs in to the man
/// he is sending off, shows the card (a second yellow's yellow first, then
/// the red), holds it up while the man starts his walk, and jogs away.
///
/// Read off the script's own cues (the foul's whistle and the card the
/// foul plan times), so it is the same for the same script, every time,
/// and it touches nothing the players or the ball do: a picture drawn over
/// the match, like a final's confetti. Pure Dart: no Flutter.
library;

import 'dart:math' as math;

import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';

/// The card in the referee's hand.
enum RefereeCard { yellow, red }

/// The referee at one instant: where he stands, how strongly he is drawn
/// (he fades in and out at the ends of his run), and the card he holds up,
/// `raise` of the way up (0 at his side, 1 at full stretch).
typedef RefereeFrame = ({
  Offset2 at,
  double alpha,
  RefereeCard? card,
  double raise,
});

/// One sending-off, as the referee shows it.
class RefereeCardShow {
  const RefereeCardShow({
    required this.playerId,
    required this.cardAt,
    required this.from,
    required this.spot,
    required this.yellowFirst,
    required this.start,
    required this.until,
    this.foulAt = double.negativeInfinity,
  });

  /// The man sent off.
  final int playerId;

  /// The screen second the red card is up: the script's red card cue, when
  /// the event is revealed (the commentary line, the banner).
  final double cardAt;

  /// Where he runs in from and back to.
  final Offset2 from;

  /// Where he stands to show the card: a couple of metres from the man,
  /// on the side nearer the middle of the pitch.
  final Offset2 spot;

  /// A second booking: the yellow goes up first, then the red.
  final bool yellowFirst;

  /// The screen second he appears, running in: [runIn] before he is at
  /// [spot], or straight after a cut or a restart that falls in his run.
  final double start;

  /// The foul's whistle (the script's foul cue): no card goes up before it.
  final double foulAt;

  /// The screen second he is gone: the end of his run away, or a cut or a
  /// restart that takes the picture somewhere else first.
  final double until;

  /// How long his run in takes.
  static const double runIn = 1;

  /// How long the red card is held up: about a second and three quarters
  /// of match pace, the man already on his way by the end of it.
  static const double hold = 1.8;

  /// How long a card takes to go up, or come down.
  static const double lift = 0.14;

  /// A second booking's yellow: up this long before the red...
  static const double yellowLead = 0.5;

  /// ...and down this long before it.
  static const double yellowGap = 0.1;

  /// How long his run away takes, fading as it ends.
  static const double runOut = 0.9;

  /// How long he takes to fade in at the start of his run.
  static const double fadeIn = 0.25;

  /// How long he fades over when a cut or a restart cuts him short.
  static const double _cutFade = 0.12;

  /// How far from the man he stands, and how far off he starts.
  static const double standOff = 2.4;
  static const double runFrom = 11;

  /// When he is at [spot]: in time for the first card.
  double get arrive => _arriveFor(cardAt, yellowFirst);

  static double _arriveFor(double cardAt, bool yellowFirst) =>
      cardAt - (yellowFirst ? yellowLead + 0.05 : lift + 0.05);

  /// When he is gone, when nothing cuts him short.
  double get _gone => cardAt + hold + lift + runOut;

  /// Every sending-off [script] stages, in time order. A red card the
  /// script does not stage (no card cue) shows no referee: the man simply
  /// walks, as before.
  static List<RefereeCardShow> of(PitchScript script) {
    final out = <RefereeCardShow>[];
    final events = script.result.events;
    final breaks = [...script.cuts, ...script.resets]..sort();
    for (final w in script.windows) {
      final m = w.moments.isEmpty ? null : w.moments.first;
      if (m is! FoulMoment) continue;
      final idx = m.cardEventIndex;
      if (idx == null || idx < 0 || idx >= events.length) continue;
      final e = events[idx];
      if (e.type != MatchEventType.redCard) continue;
      PitchCue? card;
      PitchCue? foul;
      for (final c in w.cues) {
        if (c.kind == PitchCueKind.redCard) card ??= c;
        if (c.kind == PitchCueKind.foul) foul ??= c;
      }
      if (card == null) continue;
      final c = card.t;
      // A second booking's yellow only when there is time for it after
      // the whistle: never a card before the foul.
      final yellow =
          e.secondYellow && (foul == null || c - yellowLead >= foul.t + 0.05);
      final man = script.sample(_dur(c)).players[card.playerId];
      if (man == null) continue;
      var toMiddle = PitchDims.centre - man;
      if (toMiddle.length < 1) toMiddle = const Offset2(0, 1);
      final spot = _inside(man + toMiddle.unit * standOff);
      // In from further towards the middle, a little to one side: which
      // side is the man's own (his id), so it never changes between runs.
      final turn = (card.playerId.isEven ? 1 : -1) * 0.6;
      final from = _inside(
        spot + Offset2.fromAngle(toMiddle.angle + turn, runFrom),
      );
      // A cut or a restart before the card: he appears after it, already
      // on his way. One after: he goes with the picture.
      var start = _arriveFor(c, yellow) - runIn;
      var until = c + hold + lift + runOut;
      for (final b in breaks) {
        if (b > start && b <= c) start = b;
        if (b > c && b < until) until = b;
      }
      out.add(
        RefereeCardShow(
          playerId: card.playerId,
          cardAt: c,
          from: from,
          spot: spot,
          yellowFirst: yellow,
          start: start,
          until: until,
          foulAt: foul?.t ?? double.negativeInfinity,
        ),
      );
    }
    out.sort((a, b) => a.cardAt.compareTo(b.cardAt));
    return out;
  }

  /// The referee at screen second [t], or null when he is not on show.
  RefereeFrame? frameAt(double t) {
    if (t < start || t >= until) return null;
    final down = cardAt + hold;
    final leave = down + lift;
    Offset2 at;
    var alpha = 1.0;
    if (t < arrive) {
      final span = arrive - start;
      final u = span <= 0 ? 1.0 : _easeOut((t - start) / span);
      at = Offset2.lerp(from, spot, u);
      alpha = ((t - start) / fadeIn).clamp(0.0, 1.0);
    } else if (t < leave) {
      at = spot;
    } else {
      final u = ((t - leave) / runOut).clamp(0.0, 1.0);
      at = Offset2.lerp(spot, from, _easeIn(u));
      alpha = 1 - _easeIn(u);
    }
    // Cut short by a cut or a restart: gone with the picture's own fade.
    if (until < _gone) {
      alpha = math.min(alpha, ((until - t) / _cutFade).clamp(0.0, 1.0));
    }
    RefereeCard? card;
    var raise = 0.0;
    double up(double from) => ((t - from) / lift).clamp(0.0, 1.0);
    double downAt(double to) => ((to - t) / lift).clamp(0.0, 1.0);
    if (yellowFirst) {
      final yUp = cardAt - yellowLead;
      final yDown = cardAt - yellowGap;
      if (t >= yUp && t < yDown) {
        card = RefereeCard.yellow;
        raise = math.min(up(yUp), downAt(yDown));
      }
    }
    // Up as the card is shown, never before the whistle.
    final redUp = math.max(cardAt - lift, foulAt);
    if (t >= redUp && t < leave) {
      card = RefereeCard.red;
      raise = math.min(up(redUp), downAt(leave));
    }
    return (at: at, alpha: alpha, card: card, raise: raise);
  }

  static double _easeOut(double u) {
    final v = u.clamp(0.0, 1.0);
    return 1 - (1 - v) * (1 - v);
  }

  static double _easeIn(double u) {
    final v = u.clamp(0.0, 1.0);
    return v * v;
  }

  static Offset2 _inside(Offset2 p) => Offset2(
    p.x.clamp(1.0, PitchDims.length - 1),
    p.y.clamp(1.0, PitchDims.width - 1),
  );

  static Duration _dur(double s) => Duration(microseconds: (s * 1e6).round());
}
