/// The keeper-giveaway scan: seeded matches run through the Pitch view's
/// staging (no UI), and every pass a keeper makes read off the script. A
/// short pass (under 35 metres) that an opponent receives is a keeper
/// rolling the ball to a forward, which a tester saw time and again: the
/// ball had to change hands before the next moment and a save had left it
/// in his gloves. He plays it out to his own men now, or kicks it long,
/// bar the odd keeper's error.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/pitch_match_lab.dart';

const int _seeds = 60;

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

void main() {
  test(
    'a keeper gives the ball to a forward only as a rare error: $_seeds seeded matches',
    () {
      var keeperPasses = 0;
      final giveaways = <String>[];
      for (var seed = 0; seed < _seeds; seed++) {
        final r = SeededRng(seed * 31 + 5);
        const fs = Formation.values;
        final home = labTeam(
          1,
          r.rangeInt(62, 84),
          fs[seed % fs.length],
          labDials(r),
        );
        final away = labTeam(
          2,
          r.rangeInt(62, 84),
          fs[(seed * 7 + 3) % fs.length],
          labDials(r),
        );
        final result = labEngine.play(
          home: home,
          away: away,
          rng: SeededRng.forFixture(0xC0DE, seed),
          bigMatch: true,
        );
        final s = StoryLayer.build(
          result: result,
          lineups: matchLineupsOf(home: home, away: away, result: result),
          pacer: PitchPacer(result, PitchSpeed.values[seed % 3]),
          seed: seed,
        );
        for (final p in s.ballPhases) {
          if (p is! FlightPhase || !p.pass) continue;
          final from = p.fromActor;
          final to = p.toActor;
          if (from == null || to == null) continue;
          final passer = s.actorList[from];
          final keepers = s.sample(_at(p.t0)).keepers;
          if (!keepers.contains(passer.playerId)) continue;
          keeperPasses++;
          final receiver = s.actorList[to];
          if (receiver.teamNationId == passer.teamNationId) continue;
          final d = p.from.distanceTo(p.to);
          if (d < 35) {
            giveaways.add(
              'seed $seed, ${s.minuteLabel(p.t0)}: keeper ${passer.playerId} '
              'to ${receiver.playerId}, ${d.toStringAsFixed(1)} m',
            );
          }
        }
      }
      expect(keeperPasses, greaterThan(200), reason: 'the scan barely ran');
      // A keeper's error now and then: the owner's ceiling is 1-2% of his
      // passes. Before the fix it was 40%.
      expect(
        giveaways.length / keeperPasses,
        lessThanOrEqualTo(0.02),
        reason:
            '${giveaways.length} of $keeperPasses keeper passes went short to '
            'an opponent; the first:\n${giveaways.take(10).join('\n')}',
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
