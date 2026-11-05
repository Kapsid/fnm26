/// Maps a match's minutes and its recorded moments onto on-screen time.
///
/// Real (staged) moments always get their full fixed length; quiet time is
/// compressed so a whole match fits the duration band of the chosen speed.
/// Pure Dart: no Flutter.
library;

import '../match_engine.dart';
import '../match_moments.dart';

/// How fast the Pitch view plays a match.
enum PitchSpeed { slow, mid, fast }

/// Pacing of one match on screen.
///
/// Match time is a run of positions ("slots"): minutes 1-90, then 90+1 to
/// 90+stoppage, then 91-120 when there is extra time. Half-time and other
/// breaks take no screen time here; the screen pauses for them separately.
///
/// A slot holding staged moments lasts exactly the sum of their lengths.
/// Every other slot is quiet and shares the remainder of the budget evenly,
/// never less than [minQuietSeconds]. When the moments alone overflow the
/// budget, quiet time drops to that minimum and the total simply runs over:
/// real moments are never rushed.
class PitchPacer {
  PitchPacer(MatchResult r, PitchSpeed speed) : _stoppage = r.stoppage {
    final extra = r.extraTime != null ? 30 : 0;
    final slotCount = 90 + _stoppage + extra;
    final staged = List<double>.filled(slotCount, 0);
    var stagedCount = 0;

    void add(int minute, int stoppage, double seconds) {
      staged[_slotOf(minute, stoppage, slotCount)] += seconds;
      stagedCount++;
    }

    for (final m in r.moments) {
      final seconds = _seconds(m);
      if (seconds > 0) add(m.minute, m.stoppage, seconds);
    }
    for (final e in r.events) {
      if (e.type == MatchEventType.injury) {
        add(e.minute, e.stoppage, _injurySeconds);
      }
    }

    final (lo, hi) = switch (speed) {
      PitchSpeed.slow => (180.0, 240.0),
      PitchSpeed.mid => (120.0, 180.0),
      PitchSpeed.fast => (60.0, 120.0),
    };
    final scale = slotCount / 90;
    final eventfulness = (stagedCount / 40).clamp(0.0, 1.0);
    final budget = (lo + (hi - lo) * eventfulness) * scale;

    var stagedTotal = 0.0;
    var quietSlots = 0;
    for (final s in staged) {
      stagedTotal += s;
      if (s == 0) quietSlots++;
    }
    final quiet = quietSlots == 0
        ? 0.0
        : ((budget - stagedTotal) / quietSlots).clamp(
            minQuietSeconds,
            double.infinity,
          );

    _start = List<double>.filled(slotCount + 1, 0);
    for (var i = 0; i < slotCount; i++) {
      _start[i + 1] = _start[i] + (staged[i] == 0 ? quiet : staged[i]);
    }
  }

  /// The least screen time a quiet minute gets.
  static const double minQuietSeconds = 0.25;

  static const double _shot = 3.5;
  static const double _corner = 6;
  static const double _freeKick = 6;
  static const double _penalty = 7;
  static const double _card = 3;
  static const double _sub = 2.5;
  static const double _offside = 2.5;
  static const double _injurySeconds = 3;
  static const double _goalExtra = 2.5;

  final int _stoppage;

  /// Screen seconds at the start of each slot; the last entry is the total.
  late final List<double> _start;

  /// Screen duration of the whole match, including stoppage and extra time.
  Duration get total => _dur(_start.last);

  /// The screen time at which [minute] (+[stoppage]) begins, [within] (0-1)
  /// of the way through it.
  Duration screenAt(int minute, int stoppage, {double within = 0}) {
    final i = _slotOf(minute, stoppage, _start.length - 1);
    final w = within.clamp(0.0, 1.0);
    return _dur(_start[i] + (_start[i + 1] - _start[i]) * w);
  }

  /// The inverse of [screenAt]: which minute the screen time falls in and how
  /// far through it.
  ({int minute, int stoppage, double within}) matchAt(Duration screen) {
    // A microsecond of slack keeps a boundary from rounding into the slot
    // before it.
    final s = ((screen.inMicroseconds + 1) / 1e6).clamp(0.0, _start.last);
    var lo = 0;
    var hi = _start.length - 2;
    while (lo < hi) {
      final mid = (lo + hi + 1) ~/ 2;
      if (_start[mid] <= s) {
        lo = mid;
      } else {
        hi = mid - 1;
      }
    }
    final len = _start[lo + 1] - _start[lo];
    final within = len <= 0 ? 0.0 : ((s - _start[lo]) / len).clamp(0.0, 1.0);
    final (minute, stoppage) = _positionOf(lo);
    return (minute: minute, stoppage: stoppage, within: within);
  }

  /// The fixed screen length of a moment, whatever the speed. A shot counts
  /// its own length (3.5 s, a penalty 7 s) plus 2.5 s for a goal; the set
  /// piece that delivered it is a moment of its own, so a shot from a set
  /// piece adds the two. Moments that are not staged (routine set pieces,
  /// fouls without a card, offsides that end nothing) have no length.
  Duration momentLength(MatchMoment m) => _dur(_seconds(m));

  static double _seconds(MatchMoment m) => switch (m) {
    ShotMoment s =>
      (s.origin == ShotOrigin.penalty ? _penalty : _shot) +
          (s.outcome == ShotOutcome.goal ? _goalExtra : 0),
    SetPieceMoment p when p.routine => 0,
    SetPieceMoment p => switch (p.kind) {
      SetPieceKind.corner => _corner,
      SetPieceKind.freeKick => _freeKick,
      // A long throw into the box is staged as a corner-length routine.
      SetPieceKind.longThrow => _corner,
      SetPieceKind.throwIn || SetPieceKind.goalKick => 0,
    },
    FoulMoment f => f.cardEventIndex != null ? _card : 0,
    OffsideMoment o => o.endsAttack ? _offside : 0,
    SubMoment _ => _sub,
  };

  static Duration _dur(double seconds) =>
      Duration(microseconds: (seconds * 1e6).round());

  int _slotOf(int minute, int stoppage, int slotCount) {
    int i;
    if (minute > 90) {
      i = 90 + _stoppage + (minute - 91);
    } else if (stoppage > 0) {
      i = 90 + stoppage - 1;
    } else {
      i = minute - 1;
    }
    return i.clamp(0, slotCount - 1);
  }

  (int, int) _positionOf(int slot) {
    if (slot < 90) return (slot + 1, 0);
    if (slot < 90 + _stoppage) return (90, slot - 89);
    return (91 + slot - 90 - _stoppage, 0);
  }
}
