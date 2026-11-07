import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/features/match/match_providers.dart';

import 'driver.dart';

/// Everything the engine is handed for the manager's match, as text: two
/// previews that agree here play the same match.
String _inputs(MatchPreview p) {
  String team(MatchTeam t) =>
      '${t.xi.map((p) => '${p.id}:${p.overall}').toList()} ${t.formation} '
      '${t.instructions} ${t.conditionByPlayer} ${t.roles} '
      '${t.penaltyTakerId}/${t.deadBallTakerId} ${t.ratingBonus}';
  return 'H ${team(p.homeTeam)}\nA ${team(p.awayTeam)}\n'
      'chem ${p.chemistryByNation} inj ${p.injuryFactorByNation} '
      'bench ${p.bench.map((b) => '${b.id}:${b.overall}').toList()} '
      'score ${p.result.homeScore}-${p.result.awayScore}';
}

/// The promo run's Italy (seed 7) recorded 2-1 against Bulgaria, and the same
/// save replayed 4-1 on the match screen. The session's career-development
/// starts and youth bonus were held from the session's start by the screens
/// that watch them, so the preview that recorded the result rated the squad
/// on stale numbers; a fresh start of the app (the replay) rated it on the
/// stored ones. The match the manager plays must be the match the save holds.
void main() {
  test(
    'the preview a session plays is the preview a fresh load of the save plays',
    () async {
      final db = storyDb();
      final c = storyContainer(db);
      addTearDown(c.dispose);
      final d = await StoryDriver.start(c, 7, nationId: 26);
      var checked = 0;
      final drift = <String>[];
      d.beforeMatch = (p) async {
        checked++;
        final fresh = storyContainer(db);
        final q = (await fresh.read(matchPreviewProvider(d.careerId).future))!;
        fresh.dispose();
        if (_inputs(p) != _inputs(q)) {
          drift.add('#$checked ${p.fixture.date} ${p.fixture.round}');
        }
      };
      var steps = 0;
      while (checked < 14 && await d.step(stopAtRollover: true)) {
        if (++steps > 4000) throw StateError('runaway');
      }
      expect(checked, greaterThanOrEqualTo(14));
      expect(drift, isEmpty);
    },
    timeout: const Timeout(Duration(minutes: 10)),
  );
}
