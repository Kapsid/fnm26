import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/pitch/pitch_pacer.dart';
import 'package:fnm/domain/services/match/pitch/pitch_script.dart';
import 'package:fnm/domain/services/match/pitch/referee_show.dart';

import '../../helpers/pitch_match_lab.dart';

Duration _at(double t) => Duration(microseconds: (t * 1e6).round());

void main() {
  test('a red card: the referee runs to the man, shows it, and he walks', () {
    var shown = 0;
    for (var seed = 0; seed < 120 && shown < 6; seed++) {
      final s = labScript(
        labMatch(seed),
        PitchSpeed.values[seed % 3],
        seed: seed,
      );
      for (final w in s.windows) {
        for (final c in w.cues) {
          if (c.kind != PitchCueKind.redCard) continue;
          shown++;
          final where = 'match $seed ${s.minuteLabel(c.t)}';
          final i = s.actorIndexOf(c.playerId)!;
          // Nobody there long before, nor long after.
          expect(RefereeShow.at(s, c.t - 3), isNull, reason: where);
          expect(RefereeShow.at(s, c.t + 4), isNull, reason: where);
          // Set off at the whistle: the foul comes first.
          final foul = w.cues.firstWhere((f) => f.kind == PitchCueKind.foul);
          expect(RefereeShow.at(s, foul.t - 0.05), isNull, reason: where);
          final early = RefereeShow.at(s, foul.t + 0.01)!;
          final (man, _) = s.actorAt(i, c.t);
          // He arrives beside the man and holds the card up.
          final up = RefereeShow.at(s, c.t + 0.4)!;
          expect(up.playerId, c.playerId);
          expect(up.card, 1.0, reason: where);
          expect(up.at.distanceTo(man), lessThan(2.5), reason: where);
          expect(
            early.at.distanceTo(man),
            greaterThan(up.at.distanceTo(man)),
            reason: '$where: he runs in',
          );
          // Before the card is up it is down.
          expect(RefereeShow.at(s, foul.t + 0.01)!.card, 0, reason: where);
          // The man walks: his departure starts by the window's end.
          final dep = s.departures[c.playerId];
          expect(dep, isNotNull, reason: where);
          expect(dep!, lessThanOrEqualTo(w.end + 1e-6), reason: where);
          expect(dep, greaterThanOrEqualTo(c.t - 1e-6), reason: where);
          // His side plays a man short from then on.
          final later = s.sample(_at(dep + 8));
          final side = s.actorList[i].teamNationId;
          final on = later.players.keys.where(
            (id) =>
                s.actorList[s.actorIndexOf(id)!].teamNationId == side &&
                (s.departures[id] ?? double.infinity) > dep + 8,
          );
          expect(on.length, lessThanOrEqualTo(10), reason: where);
        }
      }
    }
    expect(shown, greaterThan(2));
  });
}
