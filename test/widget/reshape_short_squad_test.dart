import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import '../helpers/seeded_save.dart';

/// The reshape soft-lock: fewer than eleven named men are fit for the next
/// match. The call-up screen allows it (a man banned for one game of a
/// three-match camp still counts), but the forced "reshape your XI" event
/// fired whenever the XI was short of eleven, and no reshape can make ten fit
/// men into eleven. The manager was sent back to tactics for ever and never
/// reached the match. Short is only worth asking about when a fit man could
/// fill the gap.
void main() {
  testWidgets('ten fit men: the auto-picked ten do not trap the hub', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await tester.runAsync(() async {
      final c = save.container;
      final comp = c.read(competitionRepositoryProvider);
      final career = await c.read(careerRepositoryProvider).byId(save.careerId);
      final cycle = career!.cyclePointer;
      for (final k in [
        budgetSetupKind,
        skillsPromptKind,
        worldCupHostDrawKind,
        continentalHostDrawKind,
        continentalQualDrawKind,
        worldCupQualDrawKind,
        nationsCupDrawKind,
      ]) {
        await comp.markDrawWatched(save.careerId, cycle, k);
      }
      final fixtures = await comp.cycleFixturesForNation(
        save.careerId,
        save.nationId,
      );
      final period = Nomination.currentPeriod(fixtures);
      await comp.markDrawWatched(
        save.careerId,
        cycle,
        'callup:${period.first.id}',
      );
      final sub = c.listen(squadDataProvider(save.careerId).future, (_, _) {});
      final squad = (await sub.read())!;
      sub.close();
      // Sixteen named, with a keeper; six of them banned for the next match.
      final keeper = squad.pool.firstWhere(
        (p) => p.position == PlayerPosition.gk,
      );
      final named = [
        keeper.id,
        ...squad.pool
            .where((p) => p.id != keeper.id && p.age >= 17)
            .take(kMinSquadSize - 1)
            .map((p) => p.id),
      ];
      expect(
        await c.read(squadServiceProvider).setCallUps(save.careerId, {
          ...named,
        }),
        isTrue,
      );
      await c.read(absenceRepositoryProvider).replace(save.careerId, [
        for (final id in named.skip(10))
          PlayerAbsence(playerId: id, banMatches: 1),
      ]);
      // He does what the event asks: re-picks the side from who is fit.
      await c
          .read(tacticServiceProvider)
          .setFormation(save.careerId, Formation.f433);
      final tactic = await c
          .read(tacticsRepositoryProvider)
          .tacticForCareer(save.careerId);
      expect(
        tactic!.lineup.whereType<int>().length,
        10,
        reason: 'ten fit men make a side of ten',
      );
      final events = c.listen(
        nextEventProvider(save.careerId).future,
        (_, _) {},
      );
      final event = await events.read();
      events.close();
      expect(
        event.label,
        isNot(enL.hubEventReshapeXi),
        reason: 'nothing he can do fills the eleventh slot',
      );
    });
  });
}
