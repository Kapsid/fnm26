/// A picture told again from mid-match at a new speed (the match screen does
/// it at every change of speed): the man the old picture already had walking
/// off hands his place on, so his substitute steps on and every moment
/// naming the substitute finds him there. And a moment whose staging fails
/// anyway is shown plainly: the build never fails for it.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/pitch/moment_staging.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/pitch_match_lab.dart';

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

PitchScript _resumed(LabMatch m, int seed, ScriptState from, PitchSpeed to) =>
    StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, to),
      seed: seed,
      resumeFrom: from,
    );

void main() {
  final errors = <String>[];
  setUp(() {
    errors.clear();
    StoryLayer.onStagingError = (e, st) => errors.add('$e\n$st');
  });
  tearDown(() => StoryLayer.onStagingError = null);

  test('5x to 1x as a substitute is called: the man going off already on '
      'his way gives up his place, and the substitute comes on', () {
    // Lab match 9: 150 on for 110 at 50'. The 5x picture (turbo) has 110
    // walking off at the half-way point of its screen time; 1x pacing has
    // the change a little later, and a moment of 150's (an offside) soon
    // after it. Before the fix 150 never stepped on and the offside's
    // staging hit a null check: the whole build failed.
    const seed = 9;
    final m = labMatch(seed);
    final s0 = labScript(m, PitchSpeed.turbo, seed: seed);
    // Read while he walks and before 150 is on (it was the screen's
    // half-way point until the video referee's checks moved the timings,
    // 1.1.4).
    var from = s0.stateAt(_at(s0.totalSeconds / 2));
    for (var t = s0.departures[110]!; t < s0.totalSeconds; t += 0.05) {
      from = s0.stateAt(_at(t));
      if (from.walking.contains(110) && !from.players.containsKey(150)) break;
    }
    expect(from.walking, contains(110), reason: 'the case the test needs');
    expect(from.players.containsKey(150), isFalse);

    final s = _resumed(m, seed, from, PitchSpeed.slow);
    expect(errors, isEmpty);
    expect(s.arrivals[150], isNotNull, reason: 'the substitute came on');
    expect(s.departures[110], isNotNull);
  });

  test('resumed at any point at a new speed, every moment is staged as '
      'it is, and every substitute comes on', () {
    for (var seed = 0; seed < 16; seed++) {
      final m = labMatch(seed);
      for (final (a, b) in [
        (PitchSpeed.turbo, PitchSpeed.slow),
        (PitchSpeed.slow, PitchSpeed.turbo),
      ]) {
        final s0 = labScript(m, a, seed: seed);
        for (var k = 1; k < 12; k++) {
          final from = s0.stateAt(_at(s0.totalSeconds * k / 12));
          final s = _resumed(m, seed, from, b);
          final label = "seed $seed, $a to $b, ${from.minute}'";
          expect(errors, isEmpty, reason: label);
          for (final e in m.result.events) {
            if (e.type != MatchEventType.substitution) continue;
            if (from.players.containsKey(e.playerId)) continue;
            expect(
              s.arrivals[e.playerId],
              isNotNull,
              reason: "$label: ${e.playerId} (${e.minute}') came on",
            );
          }
        }
      }
    }
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('a moment whose staging throws is shown plainly, and the rest of '
      'the match is staged as usual', () {
    final m = labMatch(3);
    var staged = 0;
    final s = StoryLayer.build(
      result: m.result,
      lineups: m.lineups,
      pacer: PitchPacer(m.result, PitchSpeed.slow),
      seed: 3,
      stager: _Flaky(() => ++staged),
    );
    expect(staged, greaterThan(4));
    expect(errors, hasLength(2), reason: 'one at staging, one mid-moment');
    // Played to the end.
    expect(s.keyframes.last.t, closeTo(s.totalSeconds, 1e-6));
  });
}

/// The real stager, but its second window cannot be staged and its fourth
/// throws once it is under way.
class _Flaky implements MomentStager {
  _Flaky(this.count);
  final int Function() count;

  @override
  StagedPlan stage(StagingContext context) {
    final n = count();
    if (n == 2) throw StateError('cannot stage this one');
    final plan = const MomentStaging().stage(context);
    return n == 4 ? _ThrowsLater(plan) : plan;
  }
}

class _ThrowsLater implements StagedPlan {
  _ThrowsLater(this.plan);
  final StagedPlan plan;
  int calls = 0;

  @override
  BallAction? ball(double t, ScriptState now) {
    if (++calls == 3) throw StateError('a man who is not there');
    return plan.ball(t, now);
  }

  @override
  PlayerDrive? drive(int playerId, double t, ScriptState now) =>
      plan.drive(playerId, t, now);

  @override
  bool settled(double t, ScriptState now) => plan.settled(t, now);
}
