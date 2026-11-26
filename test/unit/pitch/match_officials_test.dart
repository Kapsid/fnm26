import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/match_officials.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/referee_card.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/pitch_match_lab.dart';

/// The officials on the 2D TV: the referee out on the pitch all match,
/// clear of play, showing every card by the man; the assistants on their
/// touchlines, a flag up for every offside; and the video referee's check
/// after a goal, its call the engine's.

final _l = AppLocalizationsEn();

Duration _at(double s) => Duration(microseconds: (s * 1e6).round());

/// A name for every player a lab match names.
Map<int, String> _names(MatchResult r) => {
  for (final m in r.moments)
    for (final id in switch (m) {
      final ShotMoment s => [s.shooterId, ?s.assistId, ?s.keeperId],
      final SetPieceMoment p => [p.takerId],
      final FoulMoment f => [f.foulerId, f.fouledId],
      final OffsideMoment o => [o.playerId],
      final SubMoment s => [s.onId, ?s.offId],
    })
      id: 'P$id',
  for (final e in r.events) e.playerId: 'P${e.playerId}',
  for (final e in r.events)
    if (e.secondaryPlayerId != null)
      e.secondaryPlayerId!: 'P${e.secondaryPlayerId}',
};

/// Lab scripts, at every speed.
final List<(int, PitchScript)> _scripts = [
  for (var seed = 0; seed < 10; seed++)
    (seed, labScript(labMatch(seed), PitchSpeed.values[seed % 4], seed: seed)),
];

/// Lab matches with a goal the video referee checks, and the ones with a
/// goal he chalks off, staged.
final List<(int, PitchScript)> _checked = () {
  final out = <(int, PitchScript)>[];
  var denied = 0;
  for (var seed = 0; seed < 400 && (out.length < 8 || denied < 3); seed++) {
    final m = labMatch(seed);
    final ev = m.result.events;
    final has = ev.any((e) => e.varReview != null);
    final no = ev.any((e) => e.type == MatchEventType.disallowedGoal);
    if (!has || (out.length >= 8 && !no)) continue;
    if (no) denied++;
    out.add((seed, labScript(m, PitchSpeed.values[seed % 3], seed: seed)));
  }
  return out;
}();

void main() {
  test('the referee is on the pitch every instant, clear of the ball and '
      'of the men in open play', () {
    var frames = 0;
    var tight = 0;
    final sw = Stopwatch();
    for (final (seed, s) in _scripts) {
      sw.start();
      final o = MatchOfficials.of(s);
      sw.stop();
      for (var t = s.start; t < s.totalSeconds; t += 0.37) {
        final f = o.frameAt(t);
        final why = 'match $seed at $t';
        expect(f.referee.x, inInclusiveRange(0, PitchDims.length), reason: why);
        expect(f.referee.y, inInclusiveRange(0, PitchDims.width), reason: why);
        // The assistants on their own touchlines, each in his half.
        expect(f.assistantA.y, lessThan(0), reason: why);
        expect(f.assistantB.y, greaterThan(PitchDims.width), reason: why);
        expect(
          f.assistantA.x,
          lessThanOrEqualTo(PitchDims.length / 2 + 1e-3),
          reason: why,
        );
        expect(
          f.assistantB.x,
          greaterThanOrEqualTo(PitchDims.length / 2 - 1e-3),
          reason: why,
        );
        final busy =
            f.card != null ||
            o.checkAt(t) != null ||
            o.cards.any((c) => t >= c.start - 1.5 && t < c.until);
        if (busy || s.windowAt(t) != null) continue;
        frames++;
        final p = s.sample(_at(t));
        final near = p.players.values.any(
          (q) => q.distanceTo(f.referee) < 1.0,
        );
        if (near || p.ball.distanceTo(f.referee) < 3) tight++;
      }
    }
    // ignore: avoid_print
    print(
      'officials for ${_scripts.length} scripts in '
      '${sw.elapsedMilliseconds} ms; $tight of $frames open-play frames '
      'tight',
    );
    // Read off a coarse grid, so between two instants a man can run by
    // him; never more than now and then.
    expect(tight / frames, lessThan(0.03));
  });

  test('every card is shown by the referee, by the man, on its cue', () {
    var yellows = 0;
    var reds = 0;
    for (final (seed, s) in [..._scripts, ..._checked]) {
      final o = MatchOfficials.of(s);
      for (final w in s.windows) {
        for (final c in w.cues) {
          final card = switch (c.kind) {
            PitchCueKind.yellowCard => RefereeCard.yellow,
            PitchCueKind.redCard => RefereeCard.red,
            _ => null,
          };
          if (card == null) continue;
          final show = o.cards.firstWhere((x) => x.cardAt == c.t);
          // Held up for as long as no cut takes the picture away.
          final f = o.frameAt(c.t + RefereeCardShow.lift);
          final why = 'match $seed card at ${c.t}';
          if (show.until > c.t + RefereeCardShow.lift) {
            expect(f.card, card, reason: why);
            expect(f.raise, closeTo(1, 1e-6), reason: why);
            final man = s.sample(_at(c.t)).players[c.playerId]!;
            expect(
              f.referee.distanceTo(man),
              lessThan(RefereeCardShow.standOff + 0.01),
              reason: why,
            );
          }
          if (card == RefereeCard.yellow) yellows++;
          if (card == RefereeCard.red) reds++;
        }
      }
    }
    expect(yellows, greaterThan(5));
    expect(reds, greaterThan(0));
  });

  test('every offside: the assistant of that half raises his flag on the '
      'line', () {
    var flags = 0;
    for (final (seed, s) in _scripts) {
      final o = MatchOfficials.of(s);
      for (final w in s.windows) {
        for (final c in w.cues) {
          if (c.kind != PitchCueKind.offsideFlag) continue;
          final show = o.flags.firstWhere((x) => x.at == c.t);
          if (show.until <= c.t + 0.3) continue;
          final f = o.frameAt(c.t + 0.3);
          final why = 'match $seed flag at ${c.t}';
          final man = s.sample(_at(c.t)).players[c.playerId]!;
          final half = man.x < PitchDims.length / 2;
          expect(show.nearHalf, half, reason: why);
          expect(half ? f.flagA : f.flagB, closeTo(1, 1e-6), reason: why);
          expect(half ? f.flagB : f.flagA, 0, reason: why);
          final ar = half ? f.assistantA : f.assistantB;
          // Level with the line, near enough: he gets there at a run.
          expect((ar.x - man.x).abs(), lessThan(6), reason: why);
          flags++;
        }
        // No flag before the play: down a breath before the cue.
      }
      for (final fl in o.flags) {
        expect(fl.raiseAt(fl.at - OffsideFlagShow.lift - 0.01), 0);
      }
    }
    expect(flags, greaterThan(3));
  });

  test('a goal the video referee checks: the check, the call, the score as '
      'the engine has it', () {
    expect(_checked, isNotEmpty);
    var denied = 0;
    for (final (seed, s) in _checked) {
      expect(PitchScriptValidator.validate(s), isEmpty, reason: 'match $seed');
      final pb = PitchPlayback(s);
      final o = MatchOfficials.of(s);
      final names = _names(s.result);
      expect(pb.varChecks, isNotEmpty, reason: 'match $seed');
      for (final v in pb.varChecks) {
        final why = 'match $seed goal at ${v.goalAt}';
        final e = s.result.events[v.eventIndex];
        expect(e.varReview, v.review, reason: why);
        expect(v.goalAt, lessThan(v.checkFrom), reason: why);
        expect(v.checkFrom, lessThan(v.decisionAt), reason: why);
        expect(v.decisionAt, lessThan(v.until), reason: why);
        final mid = (v.checkFrom + v.decisionAt) / 2;
        expect(o.frameAt(mid).signal, RefereeSignal.ear, reason: why);
        expect(
          o.frameAt((v.decisionAt + v.until) / 2).signal,
          v.disallowed ? RefereeSignal.armUp : RefereeSignal.toCentre,
          reason: why,
        );
        // The commentary has the check and the call.
        final lines = pb.linesUpTo(_l, _at(v.until - 1e-3), names, seed);
        final check = [
          _l.pitchComVarCheck1,
          _l.pitchComVarCheck2('P${e.playerId}'),
        ];
        expect(lines.any(check.contains), isTrue, reason: why);
        if (v.disallowed) {
          denied++;
          expect(e.type, MatchEventType.disallowedGoal, reason: why);
          // Shown on the call, never as a goal.
          expect(pb.revealAt(v.eventIndex), closeTo(v.decisionAt, 1e-6));
          expect(v.shot.outcome, ShotOutcome.disallowed, reason: why);
          final w = s.windows.firstWhere((w) => w.moments.contains(v.shot));
          // The ball went in...
          expect(
            w.cues.any((c) => c.kind == PitchCueKind.goal),
            isTrue,
            reason: why,
          );
          // ...and play restarts with the defending side's free kick, not
          // a kick-off.
          // (Unless the match ends there, an interval does, or the next
          // moment opens on it and cuts to itself.)
          if (w.end < s.totalSeconds - 1e-6 &&
              !s.resets.any((r) => (r - w.end).abs() < 1e-6) &&
              !s.windows.any((o) => (o.start - w.end).abs() < 1e-6)) {
            expect(s.cutKinds[w.end], PitchCutKind.setPiece, reason: why);
            final after = s.sample(_at(w.end + 0.05));
            expect(after.ball.distanceTo(PitchDims.centre), greaterThan(30));
          }
          final call = lines.last;
          expect(
            call.contains(_l.pitchComVarOffside1) ||
                call.contains(_l.pitchComVarFoul1) ||
                call.contains('P${e.playerId}'),
            isTrue,
            reason: why,
          );
        } else {
          expect(e.type, MatchEventType.goal, reason: why);
          expect(pb.revealAt(v.eventIndex), lessThan(v.checkFrom));
        }
      }
    }
    expect(denied, greaterThan(0));
  });

  test('the same script, the same officials', () {
    final (seed, s) = _scripts.first;
    final again = labScript(
      labMatch(seed),
      PitchSpeed.values[seed % 4],
      seed: seed,
    );
    final a = MatchOfficials.of(s);
    final b = MatchOfficials.of(again);
    for (var t = s.start; t < s.totalSeconds; t += 1.3) {
      expect(b.frameAt(t), a.frameAt(t));
    }
  });
}
