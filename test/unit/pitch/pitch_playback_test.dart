import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/pitch_match_lab.dart';

final _l = AppLocalizationsEn();

/// A name for every player a lab match's moments and events name.
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

Duration _at(double s) => Duration(microseconds: (s * 1e6).round());

PitchPlayback _playback(int seed) => PitchPlayback(
  labScript(labMatch(seed), PitchSpeed.values[seed % 3], seed: seed),
);

void main() {
  test('the position reads like the Timeline clock', () {
    for (var seed = 0; seed < 12; seed++) {
      final pb = _playback(seed);
      expect(pb.positionAt(Duration.zero), (minute: 0, added: 0));
      // Kick-off is minute 1 the moment the clock runs.
      expect(pb.positionAt(const Duration(milliseconds: 1)).minute, 1);
      // The half-time whistle still reads 45, as does its last instant.
      expect(pb.positionAt(pb.halfTime), (minute: 45, added: 0));
      expect(
        pb.positionAt(pb.halfTime + const Duration(milliseconds: 1)),
        (minute: 46, added: 0),
      );
      // The end of every minute is that minute.
      final r = pb.result;
      for (var m = 1; m <= 90; m++) {
        expect(pb.positionAt(pb.endOf(m, 0)), (minute: m, added: 0));
      }
      for (var a = 1; a <= r.stoppage; a++) {
        expect(pb.positionAt(pb.endOf(90, a)), (minute: 90, added: a));
      }
      if (r.extraTime != null) {
        expect(pb.positionAt(pb.extraTimeStart!), (
          minute: 90,
          added: r.stoppage,
        ));
        expect(pb.positionAt(pb.extraTimeHalf!), (minute: 105, added: 0));
        expect(pb.positionAt(pb.pacer.total), (minute: 120, added: 0));
      } else {
        expect(pb.extraTimeStart, isNull);
        expect(pb.positionAt(pb.pacer.total), (
          minute: 90,
          added: r.stoppage,
        ));
      }
    }
  });

  test('every event shows inside its own minute, a goal as it goes in', () {
    var goals = 0;
    var cards = 0;
    for (var seed = 0; seed < 40; seed++) {
      final pb = _playback(seed);
      final r = pb.result;
      final s = pb.script;
      for (var i = 0; i < r.events.length; i++) {
        final e = r.events[i];
        final t = _at(pb.revealAt(i));
        expect(
          pb.positionAt(t),
          (minute: e.minute, added: e.stoppage),
          reason: 'match $seed event $i (${e.type.name} ${e.minute})',
        );
      }
      for (final w in s.windows) {
        for (final m in w.moments) {
          if (m is ShotMoment && m.goalEventIndex != null) {
            final cue = w.cues.where((c) => c.kind == PitchCueKind.goal);
            if (cue.isEmpty) continue;
            goals++;
            expect(pb.revealAt(m.goalEventIndex!), cue.first.t);
          }
          if (m is FoulMoment && m.cardEventIndex != null) {
            final cue = w.cues.where(
              (c) =>
                  c.kind == PitchCueKind.yellowCard ||
                  c.kind == PitchCueKind.redCard,
            );
            if (cue.isEmpty) continue;
            cards++;
            expect(pb.revealAt(m.cardEventIndex!), cue.first.t);
          }
        }
      }
    }
    expect(goals, greaterThan(40));
    expect(cards, greaterThan(40));
  });

  test('the commentary never runs ahead of the score', () {
    // Wherever a goal's line is up, the goals shown by then make exactly
    // the score it reads.
    var checked = 0;
    for (var seed = 0; seed < 40; seed++) {
      final pb = _playback(seed);
      final r = pb.result;
      final names = _names(r);
      for (var i = 0; i < r.events.length; i++) {
        final e = r.events[i];
        if (e.type != MatchEventType.goal) continue;
        final t = _at(pb.revealAt(i));
        var home = 0;
        var away = 0;
        for (var j = 0; j < r.events.length; j++) {
          final g = r.events[j];
          if (g.type != MatchEventType.goal || !pb.shown(j, t)) continue;
          if (g.teamNationId == pb.script.homeNationId) {
            home++;
          } else {
            away++;
          }
        }
        final line = pb.lineAt(_l, t, names, seed);
        final shot = r.moments.whereType<ShotMoment>().firstWhere(
          (m) => m.goalEventIndex == i,
        );
        expect(
          line,
          pitchLine(
            _l,
            shot,
            names,
            seed,
            events: r.events,
            score: (home: home, away: away),
          ),
          reason: 'match $seed goal $i',
        );
        // Just before it goes in, the line is not the goal's.
        final before = pb.lineAt(
          _l,
          t - const Duration(milliseconds: 50),
          names,
          seed,
        );
        expect(before, isNot(line));
        checked++;
      }
    }
    expect(checked, greaterThan(40));
  });

  test('a penalty is given, then taken; a set piece, then its shot', () {
    var penalties = 0;
    var folded = 0;
    for (var seed = 0; seed < 80; seed++) {
      final pb = _playback(seed);
      final r = pb.result;
      final names = _names(r);
      String? lineAt(double t) => pb.lineAt(_l, _at(t), names, seed);
      for (final w in pb.script.windows) {
        if (w.moments.isEmpty) {
          expect(
            lineAt(w.start),
            pitchInjuryLine(_l, w.injury!, names, seed),
          );
          continue;
        }
        final first = w.moments.first;
        final strike = w.cues.where((c) => c.kind == PitchCueKind.shot);
        if (first is ShotMoment &&
            first.origin == ShotOrigin.penalty &&
            strike.isNotEmpty) {
          // A foul in the box with no card has no window of its own: its
          // award is said as the kick's window opens.
          final fouls = r.moments.whereType<FoulMoment>().where(
            (f) =>
                f.minute == first.minute &&
                f.stoppage == first.stoppage &&
                f.teamNationId == first.teamNationId &&
                f.seq < first.seq &&
                f.cardEventIndex == null &&
                !isRoutineMoment(f),
          );
          if (fouls.isNotEmpty) {
            expect(
              lineAt(w.start),
              pitchLine(_l, fouls.last, names, seed, events: r.events),
            );
          }
          final shotLine = pitchLine(
            _l,
            first,
            names,
            seed,
            events: r.events,
          );
          if (first.outcome != ShotOutcome.goal) {
            expect(lineAt(strike.first.t), shotLine);
            penalties++;
          }
        }
        if (first is SetPieceMoment &&
            w.moments.length > 1 &&
            strike.isNotEmpty &&
            !isRoutineMoment(first)) {
          final shot = w.moments[1] as ShotMoment;
          expect(
            lineAt(w.start),
            pitchLine(_l, first, names, seed, events: r.events),
          );
          if (shot.outcome != ShotOutcome.goal) {
            expect(
              lineAt(strike.first.t),
              pitchLine(_l, shot, names, seed, events: r.events),
            );
            folded++;
          }
        }
      }
    }
    expect(penalties, greaterThan(0));
    expect(folded, greaterThan(10));
  });
}
