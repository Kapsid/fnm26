/// Penalty rebounds: now and then a penalty the keeper saves or that comes
/// back off the woodwork stays live. The taker or a team-mate rushing in
/// from the edge of the area follows it up (a [ShotOrigin.penaltyRebound]
/// shot of its own: goal, save, miss or block), or a defender gets there
/// first and clears it. It is the engine's outcome (shots, xG, the goal,
/// the ratings) and the Pitch view plays it: the spill, the men rushing in,
/// the second shot or the clearance, each with its commentary line.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_geometry.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/pitch_match_lab.dart';

const int _matches = 1500;

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

/// The lab matches with a penalty that stayed live, and the counts behind
/// the rates.
final ({
  int penalties,
  int notScored,
  int followUps,
  int cleared,
  int followGoals,
  List<int> live,
})
_scan = () {
  var penalties = 0;
  var notScored = 0;
  var followUps = 0;
  var cleared = 0;
  var followGoals = 0;
  final live = <int>[];
  for (var seed = 0; seed < _matches; seed++) {
    final r = labMatch(seed).result;
    var any = false;
    for (final m in r.moments.whereType<ShotMoment>()) {
      if (m.origin == ShotOrigin.penalty) {
        penalties++;
        if (m.outcome != ShotOutcome.goal) notScored++;
        if (m.reboundClearedById != null) {
          cleared++;
          any = true;
        }
      } else if (m.origin == ShotOrigin.penaltyRebound) {
        followUps++;
        any = true;
        if (m.outcome == ShotOutcome.goal) followGoals++;
      }
    }
    if (any) live.add(seed);
  }
  return (
    penalties: penalties,
    notScored: notScored,
    followUps: followUps,
    cleared: cleared,
    followGoals: followGoals,
    live: live,
  );
}();

void main() {
  group('the engine', () {
    test('about one penalty in five that does not go in stays live, and '
        'about two in five of those end in a goal', () {
      final s = _scan;
      final rebounds = s.followUps + s.cleared;
      expect(s.penalties, greaterThan(300), reason: 'too few penalties');
      final share = rebounds / s.notScored;
      expect(share, inInclusiveRange(0.14, 0.27), reason: '$s');
      expect(s.followGoals / rebounds, inInclusiveRange(0.3, 0.5));
      expect(s.cleared, greaterThan(0));
    });

    test('a follow-up comes straight after its penalty, which was saved or '
        'hit the woodwork, and counts as a shot of its own; its goal is no '
        'penalty goal', () {
      for (final seed in _scan.live) {
        final r = labMatch(seed).result;
        final shots = r.moments.whereType<ShotMoment>().toList();
        for (var i = 0; i < shots.length; i++) {
          final f = shots[i];
          if (f.origin == ShotOrigin.penalty && f.reboundClearedById != null) {
            expect(f.outcome, anyOf(ShotOutcome.saved, ShotOutcome.woodwork));
            expect(
              i + 1 < shots.length &&
                  shots[i + 1].origin == ShotOrigin.penaltyRebound &&
                  shots[i + 1].minute == f.minute,
              isFalse,
              reason: 'cleared and followed up',
            );
          }
          if (f.origin != ShotOrigin.penaltyRebound) continue;
          final k = shots[i - 1];
          expect(k.origin, ShotOrigin.penalty, reason: 'seed $seed');
          expect(k.outcome, anyOf(ShotOutcome.saved, ShotOutcome.woodwork));
          expect(
            (k.minute, k.stoppage, k.teamNationId, k.seq + 1),
            (
              f.minute,
              f.stoppage,
              f.teamNationId,
              f.seq,
            ),
          );
          expect(f.zone, anyOf(PitchZone.sixYard, PitchZone.boxCentre));
          if (f.outcome == ShotOutcome.goal) {
            final g = r.events[f.goalEventIndex!];
            expect(g.type, MatchEventType.goal);
            expect(g.penalty, isFalse);
            expect(g.playerId, f.shooterId);
          }
        }
        // Every shot the moments hold is in the side's total.
        final home = shots.where((m) => m.teamNationId == 1).length;
        expect(r.homeShots, greaterThanOrEqualTo(home));
      }
    });
  });

  test('a cleared loose ball has three wordings, each naming the man who '
      'cleared it', () {
    final en = AppLocalizationsEn();
    const k = ShotMoment(
      minute: 30,
      stoppage: 0,
      seq: 1,
      teamNationId: 1,
      shooterId: 101,
      keeperId: 200,
      zone: PitchZone.boxCentre,
      xg: 0.78,
      outcome: ShotOutcome.saved,
      origin: ShotOrigin.penalty,
      reboundClearedById: 204,
    );
    final names = {101: 'Taker', 200: 'Keeper', 204: 'Stopper'};
    final lines = {
      for (var seed = 0; seed < 64; seed++)
        pitchLine(en, k, names, seed, events: const [], clearance: true),
    };
    expect(lines, {
      en.pitchComPenaltyReboundCleared1('Stopper'),
      en.pitchComPenaltyReboundCleared2('Stopper'),
      en.pitchComPenaltyReboundCleared3('Stopper'),
    });
    // Without the flag it is the penalty's own line.
    expect(
      pitchLine(en, k, names, 3, events: const []),
      isNot(contains('Stopper')),
    );
  });

  group('the Pitch view', () {
    final en = AppLocalizationsEn();

    test('plays the loose ball: the men rush in from the edge of the area, '
        'the man the record names gets there first and follows it up or '
        'clears it, and the commentary says so', () {
      var followUps = 0;
      var clearances = 0;
      final fails = <String>[];
      for (final seed in _scan.live.take(40)) {
        final m = labMatch(seed);
        final speed = PitchSpeed.values[seed % PitchSpeed.values.length];
        final s = labScript(m, speed, seed: seed);
        final pb = PitchPlayback(s);
        final names = {
          for (final a in s.actorList) a.playerId: 'P${a.playerId}',
        };
        final lines = pb.linesUpTo(en, _at(s.totalSeconds), names, seed);
        for (final w in s.windows) {
          if (w.moments.isEmpty) continue;
          final k = w.moments.first;
          if (k is! ShotMoment || k.origin != ShotOrigin.penalty) continue;
          final f = w.moments.skip(1).whereType<ShotMoment>().firstOrNull;
          final clearer = k.reboundClearedById;
          if (f == null && clearer == null) continue;
          final label = 'seed $seed ($speed) ${s.minuteLabel(w.start)}';
          final kick = w.cues
              .where(
                (c) => c.kind == PitchCueKind.shot && c.playerId == k.shooterId,
              )
              .firstOrNull;
          if (kick == null) {
            fails.add('$label: no kick');
            continue;
          }
          final dir = attackDir(
            home: k.teamNationId == s.homeNationId,
            minute: s.pacer.matchAt(_at(w.start)).minute,
          );
          if (f != null) {
            followUps++;
            final c = w.cues
                .where(
                  (c) =>
                      c.kind == PitchCueKind.followUp &&
                      c.playerId == f.shooterId,
                )
                .firstOrNull;
            if (c == null || c.t <= kick.t) {
              fails.add('$label: no follow-up after the kick');
              continue;
            }
            // Struck from close range, with men in the area around him.
            final at = s.sample(_at(c.t));
            final sp = at.players[f.shooterId]!;
            final depth = xToDepth(sp.x, dir);
            if (depth < PitchDims.length - 13) {
              fails.add('$label: follow-up from ${depth.toStringAsFixed(1)}');
            }
            final inBox = at.players.entries.where((e) {
              final d = xToDepth(e.value.x, dir);
              return e.key != f.shooterId &&
                  !at.keepers.contains(e.key) &&
                  d > PitchDims.length - PitchDims.boxDepth;
            }).length;
            if (inBox < 3) fails.add('$label: only $inBox rushed in');
            if (f.outcome == ShotOutcome.goal &&
                !w.cues.any(
                  (c) =>
                      c.kind == PitchCueKind.goal && c.playerId == f.shooterId,
                )) {
              fails.add('$label: the follow-up goal never went in');
            }
            final pn = names[f.shooterId]!;
            final kn = names[f.keeperId] ?? '';
            final want = switch (f.outcome) {
              ShotOutcome.goal => [
                en.pitchComPenaltyReboundGoal1(pn),
                en.pitchComPenaltyReboundGoal2(pn),
                en.pitchComPenaltyReboundGoal3(pn),
              ],
              ShotOutcome.saved => [
                en.pitchComPenaltyReboundSaved1(pn, kn),
                en.pitchComPenaltyReboundSaved2(pn),
                en.pitchComPenaltyReboundSaved3(pn, kn),
              ],
              ShotOutcome.wide => [
                en.pitchComPenaltyReboundWide1(pn),
                en.pitchComPenaltyReboundWide2(pn),
                en.pitchComPenaltyReboundWide3(pn),
              ],
              ShotOutcome.blocked => [
                en.pitchComPenaltyReboundBlocked1(pn),
                en.pitchComPenaltyReboundBlocked2(pn),
                en.pitchComPenaltyReboundBlocked3(pn),
              ],
              ShotOutcome.woodwork => [
                en.pitchComPenaltyReboundWoodwork1(pn),
                en.pitchComPenaltyReboundWoodwork2(pn),
                en.pitchComPenaltyReboundWoodwork3(pn),
              ],
            };
            final line = pitchLine(
              en,
              f,
              names,
              seed,
              events: m.result.events,
            )!;
            if (!want.any(line.startsWith)) fails.add('$label: line "$line"');
            if (!lines.any((l) => l.startsWith(line))) {
              fails.add('$label: "$line" never shown');
            }
          } else {
            clearances++;
            final c = w.cues
                .where(
                  (c) =>
                      c.kind == PitchCueKind.clearance && c.playerId == clearer,
                )
                .firstOrNull;
            if (c == null || c.t <= kick.t) {
              fails.add('$label: no clearance after the kick');
              continue;
            }
            final line = pitchLine(
              en,
              k,
              names,
              seed,
              events: m.result.events,
              clearance: true,
            )!;
            final dn = names[clearer]!;
            if (![
              en.pitchComPenaltyReboundCleared1(dn),
              en.pitchComPenaltyReboundCleared2(dn),
              en.pitchComPenaltyReboundCleared3(dn),
            ].contains(line)) {
              fails.add('$label: "$line"');
            }
            if (!lines.contains(line)) fails.add('$label: "$line" not shown');
          }
        }
        final v = PitchScriptValidator.validate(s);
        if (v.isNotEmpty) fails.add('seed $seed: ${v.take(3).join('; ')}');
      }
      expect(followUps, greaterThan(10));
      expect(clearances, greaterThan(0));
      expect(fails, isEmpty, reason: fails.take(15).join('\n'));
    }, timeout: const Timeout(Duration(minutes: 5)));
  });
}
