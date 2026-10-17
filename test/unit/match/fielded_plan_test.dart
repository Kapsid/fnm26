import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/match/match_engine.dart';

import '../../helpers/fixtures.dart';

MatchTeam _team(int nationId, {TacticalInstructions? instructions}) {
  final positions = Formation.f433.positions;
  return MatchTeam(
    nationId: nationId,
    formation: Formation.f433,
    instructions: instructions ?? const TacticalInstructions(),
    xi: [
      for (var i = 0; i < 11; i++)
        player(
          id: nationId * 100 + i,
          nationId: nationId,
          position: positions[i],
          attributes: flatAttributes(80),
        ),
    ],
  );
}

/// The plan a side is recorded as having played is the one it held for most
/// of the match, live changes included: a decoy plan on the team sheet,
/// switched away from at 1', is not what the opposition has on video.
void main() {
  const engine = MatchEngine();
  const sheet = TacticalInstructions();
  const live = TacticalInstructions(directness: 20, tempo: 40);

  MatchResult playWithSwitchAt(int? minute) {
    final mine = _team(1, instructions: sheet);
    return engine.play(
      home: mine,
      away: _team(2),
      rng: SeededRng.forFixture(5, 5),
      changes: [
        if (minute != null)
          TacticalChange(
            teamNationId: 1,
            minute: minute,
            formation: Formation.f4231,
            instructions: live,
            xi: mine.xi,
          ),
      ],
    );
  }

  group('MatchResult.homePlan', () {
    test('no change: the team sheet', () {
      final r = playWithSwitchAt(null);
      expect(r.homePlan, (formation: Formation.f433, instructions: sheet));
      expect(r.awayPlan, (formation: Formation.f433, instructions: sheet));
    });

    test('a decoy switched away from at 1\' is not the plan', () {
      final r = playWithSwitchAt(1);
      expect(r.homePlan, (formation: Formation.f4231, instructions: live));
    });

    test('a switch at 60\' leaves the sheet plan dominant', () {
      final r = playWithSwitchAt(60);
      expect(r.homePlan, (formation: Formation.f433, instructions: sheet));
    });

    test('an even split goes to the plan held later', () {
      // 45 minutes each: 1-45 on the sheet, 46-90 on the live plan.
      final r = playWithSwitchAt(46);
      expect(r.homePlan, (formation: Formation.f4231, instructions: live));
    });

    test('a nudge within the same band is the same plan', () {
      final mine = _team(1, instructions: sheet);
      final r = engine.play(
        home: mine,
        away: _team(2),
        rng: SeededRng.forFixture(5, 5),
        changes: [
          // Tempo 50 -> 52 at 30', then a real change at 70'. The nudged
          // minutes count towards the sheet plan, which is the plan the
          // first 69 minutes held; it keeps the instructions first held.
          TacticalChange(
            teamNationId: 1,
            minute: 30,
            formation: Formation.f433,
            instructions: sheet.copyWith(tempo: 52),
            xi: mine.xi,
          ),
          TacticalChange(
            teamNationId: 1,
            minute: 70,
            formation: Formation.f4231,
            instructions: live,
            xi: mine.xi,
          ),
        ],
      );
      expect(r.homePlan, (formation: Formation.f433, instructions: sheet));
    });
  });

  test('a change after a red card does not charge the missing man again', () {
    // The man sent off is paid for by the short-handed penalty. A live change
    // that keeps everything as it was (same shape, same plan, same men) must
    // leave the match exactly as it would have been without it; before
    // 2026-10-17 it recounted the shape from the ten remaining slots, so the
    // missing defender or forward was charged a second time.
    final positions = Formation.f433.positions;
    var checked = 0;
    for (var seed = 0; seed < 4000 && checked < 6; seed++) {
      final mine = _team(1);
      final theirs = _team(2);
      final plain = engine.play(
        home: mine,
        away: theirs,
        rng: SeededRng.forFixture(77, seed),
      );
      final red = plain.events.where(
        (e) =>
            e.type == MatchEventType.redCard &&
            e.teamNationId == 1 &&
            e.minute < 75 &&
            e.stoppage == 0,
      );
      if (red.isEmpty) continue;
      final off = positions[red.first.playerId % 100];
      final counted =
          off.category == PositionCategory.defender ||
          off.category == PositionCategory.forward;
      if (!counted) continue;
      final touched = engine.play(
        home: mine,
        away: theirs,
        rng: SeededRng.forFixture(77, seed),
        changes: [
          TacticalChange(
            teamNationId: 1,
            minute: red.first.minute + 1,
            formation: Formation.f433,
            instructions: const TacticalInstructions(),
            xi: mine.xi,
          ),
        ],
      );
      expect(
        (touched.homeScore, touched.awayScore, touched.homeXg, touched.awayXg),
        (plain.homeScore, plain.awayScore, plain.homeXg, plain.awayXg),
        reason: 'seed $seed: red to a ${off.name} at ${red.first.minute}\'',
      );
      checked++;
    }
    expect(checked, 6, reason: 'too few red cards to a counted position');
  });
}
