/// Rebounds in the Pitch view: some open-play goals in the box are drawn as
/// a shot the keeper parries and the recorded scorer follows up. Display
/// only: the engine's result (score, events, xG, ratings, shots) is the
/// same as before the picture learned rebounds, the man who puts it in is
/// the recorded scorer, and no shot is drawn that the record does not have.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/match_moments.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/features/match/pitch/pitch_commentary.dart';
import 'package:fnm/features/match/pitch/pitch_playback.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../../helpers/pitch_match_lab.dart';

/// A stable hash of everything the engine decided in [r].
int _fingerprint(MatchResult r) {
  final b = StringBuffer()
    ..write('${r.homeScore}-${r.awayScore} ${r.extraTime} ')
    ..write('${r.homeShots}/${r.awayShots} ${r.stoppage} ')
    ..write('${r.homeXg.toStringAsFixed(9)} ${r.awayXg.toStringAsFixed(9)} ')
    ..write('${r.homePossession} ');
  for (final e in r.events) {
    b.write(
      '${e.minute}+${e.stoppage}:${e.type.name}:${e.teamNationId}:'
      '${e.playerId}:${e.secondaryPlayerId}:${e.assistPlayerId}:'
      '${e.penalty}:${e.setPiece}:${e.ownGoal};',
    );
  }
  for (final p in r.ratings) {
    b.write('${p.playerId}=${p.rating.toStringAsFixed(6)};');
  }
  for (final m in r.moments) {
    b.write('${m.runtimeType}@${m.minute}+${m.stoppage}#${m.seq};');
    if (m is ShotMoment) {
      b.write(
        '${m.shooterId}>${m.assistId}>${m.keeperId}:${m.zone.name}:'
        '${m.outcome.name}:${m.origin.name}:${m.header}:'
        '${m.xg.toStringAsFixed(9)};',
      );
    }
  }
  var h = 0x811C9DC5;
  for (final c in b.toString().codeUnits) {
    h = ((h ^ c) * 0x01000193) & 0xFFFFFFFF;
  }
  return h;
}

bool _inBox(PitchZone z) =>
    z == PitchZone.sixYard ||
    z == PitchZone.boxCentre ||
    z == PitchZone.boxLeft ||
    z == PitchZone.boxRight;

void main() {
  test('about one goal in seven is drawn as a rebound, finished by the '
      'recorded scorer', () {
    var goals = 0;
    var eligible = 0;
    var rebounds = 0;
    var own = 0;
    final fails = <String>[];
    for (var seed = 0; seed < 240; seed++) {
      final m = labMatch(seed);
      final s = labScript(m, PitchSpeed.values[seed % 3], seed: seed);
      for (final w in s.windows) {
        if (w.moments.isEmpty) continue;
        final first = w.moments.first;
        if (first is! ShotMoment || first.outcome != ShotOutcome.goal) {
          continue;
        }
        final goal = w.cues.where((c) => c.kind == PitchCueKind.goal);
        if (goal.isEmpty) continue;
        goals++;
        final g = first.goalEventIndex!;
        if (first.origin == ShotOrigin.openPlay &&
            !first.header &&
            _inBox(first.zone) &&
            !m.result.events[g].ownGoal) {
          eligible++;
        }
        final rb = w.cues.where((c) => c.kind == PitchCueKind.rebound);
        // The ball that goes in: the last one struck before the goal.
        final si = s.actorIndexOf(first.shooterId);
        final last = s.ballPhases
            .whereType<FlightPhase>()
            .where((p) => !p.resting && p.t1 <= goal.first.t + 1e-6)
            .lastOrNull;
        if (last?.fromActor != si) {
          fails.add(
            'match $seed min ${first.minute}: last touch '
            '${last?.fromActor} not scorer $si',
          );
        }
        if (rb.isEmpty) continue;
        rebounds++;
        expect(first.origin, ShotOrigin.openPlay);
        expect(first.header, isFalse);
        expect(_inBox(first.zone), isTrue);
        expect(m.result.events[g].ownGoal, isFalse);
        final from = rb.single.playerId;
        if (from == first.shooterId) own++;
        expect(
          s.actorList[s.actorIndexOf(from)!].teamNationId,
          first.teamNationId,
        );
        // The first shot at the keeper, then his parry to the scorer.
        final ki = s.actorIndexOf(first.keeperId ?? -1);
        final flights = s.ballPhases
            .whereType<FlightPhase>()
            .where(
              (p) =>
                  !p.resting &&
                  p.t0 >= rb.single.t - 1e-6 &&
                  p.t1 <= goal.first.t + 1e-6,
            )
            .toList();
        final parry = flights.where(
          (p) =>
              p.fromActor != null &&
              p.toActor == si &&
              s.actorList[p.fromActor!].keeper,
        );
        if (parry.isEmpty || ki == null) {
          fails.add('match $seed min ${first.minute}: no parry to the scorer');
        }
      }
    }
    final share = rebounds / goals;
    // The measured share, for the record of a run.
    // ignore: avoid_print
    print(
      'goals $goals, eligible $eligible, rebounds $rebounds '
      '(${(share * 100).toStringAsFixed(1)}% of goals, '
      '${(rebounds / eligible * 100).toStringAsFixed(1)}% of eligible), '
      'own follow-ups $own',
    );
    expect(fails.take(10), isEmpty);
    expect(share, inInclusiveRange(0.10, 0.18));
  });

  test('the commentary tells a drawn rebound as a follow-up', () {
    final l = AppLocalizationsEn();
    var told = 0;
    for (var seed = 0; seed < 60; seed++) {
      final m = labMatch(seed);
      final pb = PitchPlayback(
        labScript(m, PitchSpeed.values[seed % 3], seed: seed),
      );
      final r = m.result;
      final names = <int, String>{
        for (final a in pb.script.actorList) a.playerId: 'P${a.playerId}',
        for (final e in r.events) e.playerId: 'P${e.playerId}',
        for (final e in r.events)
          if (e.secondaryPlayerId != null)
            e.secondaryPlayerId!: 'P${e.secondaryPlayerId}',
      };
      for (final w in pb.script.windows) {
        final rb = w.cues.where((c) => c.kind == PitchCueKind.rebound);
        final goal = w.cues.where((c) => c.kind == PitchCueKind.goal);
        if (rb.isEmpty || goal.isEmpty) continue;
        final shot = w.moments.first as ShotMoment;
        final at = Duration(microseconds: (goal.first.t * 1e6).round() + 1);
        final g = shot.goalEventIndex!;
        var home = 0;
        var away = 0;
        for (var i = 0; i <= g; i++) {
          final e = r.events[i];
          if (e.type != MatchEventType.goal) continue;
          if (e.teamNationId == pb.script.homeNationId) {
            home++;
          } else {
            away++;
          }
        }
        expect(
          pb.lineAt(l, at, names, seed),
          pitchLine(
            l,
            shot,
            names,
            seed,
            events: r.events,
            score: (home: home, away: away),
            reboundFrom: rb.single.playerId,
          ),
        );
        told++;
      }
    }
    expect(told, greaterThan(5));
  });

  test('the engine result is unchanged (fingerprint of 80 lab matches)', () {
    var h = 0;
    for (var seed = 0; seed < 80; seed++) {
      final m = labMatch(seed);
      final before = _fingerprint(m.result);
      // Staging the picture reads the result and never changes it.
      labScript(m, PitchSpeed.values[seed % 3], seed: seed);
      expect(_fingerprint(m.result), before, reason: 'match $seed');
      h = ((h * 31) ^ before) & 0xFFFFFFFF;
    }
    // Measured on main before rebounds were drawn: the same 80 results.
    expect(h, 1000692943);
  });
}
