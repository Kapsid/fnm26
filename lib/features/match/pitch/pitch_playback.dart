/// What the match screen reads off a match's picture to run its own clock in
/// Pitch mode: where the match stands at a screen time, when each event
/// shows, where play stops for an interval, and the commentary line.
library;

import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// A match's [script] as the match screen plays it.
///
/// **Position.** The screen's clock reads a match position: the minute and
/// the added minute. At screen time 0 it is (0, 0), before kick-off. After
/// that it is the minute being played, except exactly on a minute's end,
/// which still reads that minute: the clock stopped for half time at
/// [halfTime] reads 45, as the Timeline's does.
///
/// **Events.** Each of the result's events shows at a screen time
/// ([revealAt]) inside its own minute: a goal as the ball goes in, a card as
/// the referee shows it, an injury once its moment has played. The screen
/// holds back the events of the minute being played until then, so the
/// score, the Timeline and the goal flash never run ahead of the picture.
/// Nothing here decides an outcome: every event is the engine's.
class PitchPlayback {
  PitchPlayback(this.script)
    : _reveal = _revealTimes(script),
      _lines = _commentaryCues(script);

  /// The picture for [result] at [speed], told from kick-off, or, with
  /// [resumeState] (`PitchScript.stateAt` of the picture on show), from
  /// there (a re-simulated match or a new speed: no jump).
  factory PitchPlayback.build({
    required MatchResult result,
    required MatchLineups lineups,
    required PitchSpeed speed,
    required int seed,
    bool isFinal = false,
    ScriptState? resumeState,
  }) => PitchPlayback(
    StoryLayer.build(
      result: result,
      lineups: lineups,
      pacer: PitchPacer(result, speed),
      seed: seed,
      isFinal: isFinal,
      resumeFrom: resumeState,
    ),
  );

  final PitchScript script;
  final List<double> _reveal;
  final List<_Cue> _lines;

  MatchResult get result => script.result;
  PitchPacer get pacer => script.pacer;

  /// Where the picture begins: kick-off, or the resume point.
  Duration get start => _dur(script.start);

  static Duration _dur(double s) => Duration(microseconds: (s * 1e6).round());
  static double _secs(Duration d) => d.inMicroseconds / 1e6;

  /// The match position at screen time [t] (see the class comment).
  ({int minute, int added}) positionAt(Duration t) {
    if (t <= Duration.zero) return (minute: 0, added: 0);
    final m = pacer.matchAt(t - const Duration(microseconds: 2));
    return (minute: m.minute, added: m.stoppage);
  }

  /// The last screen instant of position ([minute], [added]): where the
  /// clock stands once that whole minute has been shown. Before kick-off
  /// (minute 0), zero.
  Duration endOf(int minute, int added) {
    if (minute <= 0) return Duration.zero;
    return pacer.screenAt(minute, added, within: 1) -
        const Duration(microseconds: 1);
  }

  /// The half-time whistle: the end of the 45th minute.
  Duration get halfTime => pacer.screenAt(46, 0);

  /// The whistle for the huddle before extra time (the end of stoppage),
  /// when the match has extra time.
  Duration? get extraTimeStart =>
      result.extraTime == null ? null : pacer.screenAt(91, 0);

  /// The whistle for the extra-time turnaround (the end of the 105th).
  Duration? get extraTimeHalf =>
      result.extraTime == null ? null : pacer.screenAt(106, 0);

  /// The screen second at which `result.events[i]` shows.
  double revealAt(int i) => _reveal[i];

  /// Whether `result.events[i]` has shown by screen time [t].
  bool shown(int i, Duration t) => _reveal[i] <= _secs(t) + _slack;

  /// Half a microsecond either way: a screen second read back off a
  /// [Duration] is rounded to the microsecond.
  static const double _slack = 1e-6;

  static List<double> _revealTimes(PitchScript s) {
    final r = s.result;
    final out = <double>[
      for (final e in r.events) _secs(s.pacer.screenAt(e.minute, e.stoppage)),
    ];
    double? cue(StagedWindow w, Set<PitchCueKind> kinds) {
      for (final c in w.cues) {
        if (kinds.contains(c.kind)) return c.t;
      }
      return null;
    }

    bool valid(int? i) => i != null && i >= 0 && i < out.length;
    for (final w in s.windows) {
      for (final m in w.moments) {
        switch (m) {
          case ShotMoment(:final goalEventIndex) when valid(goalEventIndex):
            // As the ball goes in; a window played before a resumed
            // script began has no cues, and its end is safe.
            out[goalEventIndex!] = cue(w, {PitchCueKind.goal}) ?? w.end;
          case FoulMoment(:final cardEventIndex) when valid(cardEventIndex):
            out[cardEventIndex!] =
                cue(w, {PitchCueKind.yellowCard, PitchCueKind.redCard}) ??
                w.start;
          case SubMoment(:final eventIndex) when valid(eventIndex):
            out[eventIndex] = w.start;
          default:
            break;
        }
      }
      final injury = w.injury;
      if (injury != null) {
        final i = r.events.indexWhere((e) => identical(e, injury));
        if (i >= 0) out[i] = w.end;
      }
    }
    // Never outside its own minute: the minute rule and the screen time
    // must agree on which minute an event belongs to. (The first instant of
    // a minute still reads as the one before: see [positionAt].)
    for (var i = 0; i < out.length; i++) {
      final e = r.events[i];
      final from = _secs(s.pacer.screenAt(e.minute, e.stoppage)) + 5e-6;
      final to = _secs(s.pacer.screenAt(e.minute, e.stoppage, within: 1));
      out[i] = out[i].clamp(from, to);
    }
    return out;
  }

  // --- commentary ------------------------------------------------------------

  /// The commentary line showing at screen time [t]: the latest real
  /// moment's, or null before the first. Each line comes in when its moment
  /// is seen: a set piece, card, foul, offside, sub or injury as its window
  /// opens; a shot as it is struck (a goal as it goes in, with the score
  /// after it); a penalty's award as its window opens, then the kick.
  ///
  /// [names] must hold every player the moments name (both squads and
  /// benches); [seed] picks the wording (see `pitchLine`).
  String? lineAt(
    AppLocalizations l,
    Duration t,
    Map<int, String> names,
    int seed,
  ) {
    final c = _cueAt(_secs(t));
    if (c == null) return null;
    final injury = c.injury;
    if (injury != null) return pitchInjuryLine(l, injury, names, seed);
    return pitchLine(
      l,
      c.moment!,
      names,
      seed,
      events: result.events,
      score: c.score,
    );
  }

  /// The commentary cue at [t], by binary search.
  _Cue? _cueAt(double t) {
    var lo = 0;
    var hi = _lines.length - 1;
    _Cue? found;
    while (lo <= hi) {
      final mid = (lo + hi) ~/ 2;
      if (_lines[mid].t <= t + _slack) {
        found = _lines[mid];
        lo = mid + 1;
      } else {
        hi = mid - 1;
      }
    }
    return found;
  }

  static List<_Cue> _commentaryCues(PitchScript s) {
    final r = s.result;
    final inWindow = Set<MatchMoment>.identity();
    for (final w in s.windows) {
      inWindow.addAll(w.moments);
    }
    ({int home, int away}) scoreAfter(int goalIndex) {
      var home = 0;
      var away = 0;
      for (var i = 0; i <= goalIndex && i < r.events.length; i++) {
        final e = r.events[i];
        if (e.type != MatchEventType.goal) continue;
        if (e.teamNationId == s.homeNationId) {
          home++;
        } else {
          away++;
        }
      }
      return (home: home, away: away);
    }

    double? cue(StagedWindow w, PitchCueKind kind, int playerId) {
      for (final c in w.cues) {
        if (c.kind == kind && c.playerId == playerId) return c.t;
      }
      return null;
    }

    /// When a shot's line comes in: as it goes in when it scores, as it is
    /// struck otherwise, or (a window with no cues) at [fallback].
    double shotAt(StagedWindow w, ShotMoment m, double fallback) {
      final scored = m.outcome == ShotOutcome.goal
          ? cue(w, PitchCueKind.goal, m.shooterId)
          : null;
      return scored ?? cue(w, PitchCueKind.shot, m.shooterId) ?? fallback;
    }

    _Cue shotCue(double t, ShotMoment m) {
      final g = m.goalEventIndex;
      return _Cue(
        t,
        moment: m,
        score: m.outcome == ShotOutcome.goal && g != null
            ? scoreAfter(g)
            : null,
      );
    }

    /// The foul that gave penalty [shot] when it has no window of its own
    /// (no card): its award is said as the kick's window opens.
    FoulMoment? awardOf(ShotMoment shot) {
      FoulMoment? found;
      for (final m in r.moments) {
        if (m is! FoulMoment) continue;
        if (m.minute != shot.minute || m.stoppage != shot.stoppage) continue;
        if (m.teamNationId != shot.teamNationId || m.seq >= shot.seq) continue;
        if (m.cardEventIndex != null || isRoutineMoment(m)) continue;
        if (inWindow.contains(m)) continue;
        found = m;
      }
      return found;
    }

    final out = <_Cue>[];
    for (final w in s.windows) {
      final injury = w.injury;
      if (injury != null) out.add(_Cue(w.start, injury: injury));
      if (w.moments.isEmpty) continue;
      final first = w.moments.first;
      final mid = (w.start + w.end) / 2;
      if (first is ShotMoment) {
        if (first.origin == ShotOrigin.penalty) {
          final award = awardOf(first);
          if (award != null) out.add(_Cue(w.start, moment: award));
        }
        out.add(shotCue(shotAt(w, first, w.start), first));
      } else if (!isRoutineMoment(first)) {
        out.add(_Cue(w.start, moment: first));
      }
      // A set piece's folded shot: after the set piece's line.
      for (final m in w.moments.skip(1)) {
        if (m is ShotMoment) {
          final at = shotAt(w, m, mid);
          out.add(shotCue(at < w.start ? w.start : at, m));
        } else if (!isRoutineMoment(m)) {
          out.add(_Cue(mid, moment: m));
        }
      }
    }
    // Stable: lines of one window keep their order on a tie.
    final indexed = [for (var i = 0; i < out.length; i++) (i, out[i])]
      ..sort((a, b) {
        final c = a.$2.t.compareTo(b.$2.t);
        return c != 0 ? c : a.$1.compareTo(b.$1);
      });
    return [for (final e in indexed) e.$2];
  }
}

/// One commentary line's moment (or injury) and when it comes in.
class _Cue {
  const _Cue(this.t, {this.moment, this.injury, this.score});
  final double t;
  final MatchMoment? moment;
  final MatchEvent? injury;
  final ({int home, int away})? score;
}
