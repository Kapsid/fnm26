/// The keeper-giveaway scan: seeded matches run through the Pitch view's
/// staging (no UI), and every pass a keeper makes read off the script.
///
/// A keeper's pass an opponent receives is a keeper giving the ball away,
/// which testers saw time and again: the ball had to change hands before
/// the next moment, and the picture had the keeper kick it straight to the
/// other side (1.1.4: "in 2D the goalkeeper passes to an opponent quite
/// often again"; about one match in three, mostly a long kick landing on
/// an opponent). He plays it to his own men now, and when the ball has to
/// change hands soon it is won off the man it was for as it comes down.
///
/// The one exception is the keeper's error the quiet play stages now and
/// then, on purpose (`StoryLayer.debugOnKeeperError` names each one): a
/// few in a hundred of his passes at most. The engine records no keeper
/// error of its own, so these are the only giveaways the picture may show.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/story_layer.dart';

import '../../helpers/pitch_match_lab.dart';

const int _seeds = 100;

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

void main() {
  tearDown(() => StoryLayer.debugOnKeeperError = null);

  test(
    'a keeper gives the ball to an opponent only as his rare error: '
    '$_seeds seeded matches',
    () {
      var keeperPasses = 0;
      final errors = <String>[];
      final artefacts = <String>[];
      // A man the keeper played it to who passed it to the other side the
      // moment he had it: the keeper's pass to an opponent by another name.
      final passedOn = <String>[];
      final staged = <double>[];
      StoryLayer.debugOnKeeperError = staged.add;
      for (var seed = 0; seed < _seeds; seed++) {
        staged.clear();
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
        final phases = s.ballPhases;
        for (var i = 0; i < phases.length; i++) {
          final p = phases[i];
          if (p is! FlightPhase || !p.pass) continue;
          final from = p.fromActor;
          final to = p.toActor;
          if (from == null || to == null) continue;
          final passer = s.actorList[from];
          if (!s.sample(_at(p.t0)).keepers.contains(passer.playerId)) continue;
          keeperPasses++;
          final receiver = s.actorList[to];
          final where =
              'seed $seed, ${s.minuteLabel(p.t0)}: keeper ${passer.playerId} '
              'to ${receiver.playerId}, '
              '${p.from.distanceTo(p.to).toStringAsFixed(1)} m';
          if (receiver.teamNationId != passer.teamNationId) {
            final error = staged.any((e) => (e - p.t0).abs() < 1e-6);
            (error ? errors : artefacts).add(where);
            continue;
          }
          // His team-mate's next touch.
          for (var j = i + 1; j < phases.length; j++) {
            final q = phases[j];
            if (q is! FlightPhase) continue;
            if (q.t0 > p.t1 + 0.6) break;
            final next = q.toActor;
            if (q.pass &&
                q.fromActor == to &&
                next != null &&
                s.actorList[next].teamNationId != passer.teamNationId) {
              passedOn.add(where);
            }
            break;
          }
        }
      }
      expect(keeperPasses, greaterThan(400), reason: 'the scan barely ran');
      // Measured over these matches: 36 keeper passes to an opponent
      // before (none of them an error), and 46 more played on to one the
      // moment they arrived; 0 and 3 after, with 3 errors.
      expect(
        artefacts.length,
        lessThanOrEqualTo(_seeds ~/ 50),
        reason:
            '${artefacts.length} keeper passes in $_seeds matches went '
            'straight to an opponent with no error staged; the first:\n'
            '${artefacts.take(10).join('\n')}',
      );
      expect(
        passedOn.length,
        lessThanOrEqualTo(_seeds ~/ 10),
        reason:
            '${passedOn.length} keeper passes were given away the moment '
            'they arrived; the first:\n${passedOn.take(10).join('\n')}',
      );
      // His errors: the owner's ceiling is 1-2% of his passes.
      expect(
        errors.length / keeperPasses,
        lessThanOrEqualTo(0.02),
        reason: '${errors.length} errors in $keeperPasses keeper passes',
      );
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
