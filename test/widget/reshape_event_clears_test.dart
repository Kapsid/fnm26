import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/squad/nomination.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import '../helpers/seeded_save.dart';

/// "I got stuck on the reshape, even though I no longer have a sent-off or
/// injured player there."
///
/// The forced "Reshape your starting XI" event is worked out once and cached
/// by [nextEventProvider]. On a phone the hub is replaced by the tactics
/// screen, so the event is worked out afresh on the way back. The tablet keeps
/// the event button in the shell's top bar for the whole session, so the
/// event stayed alive across the fix and kept sending the manager back to a
/// lineup he had already repaired.
void main() {
  /// Takes the seeded save past every forced step before the XI check, then
  /// bans one starter: the next event is the forced reshape.
  Future<({int slot, int replacement})> banAStarter(
    WidgetTester tester,
    SeededSave save,
  ) async {
    late ({int slot, int replacement}) out;
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
      final sub = c.listen(tacticDataProvider(save.careerId).future, (_, _) {});
      final data = (await sub.read())!;
      sub.close();
      final lineup = data.tactic.lineup;
      final banned = lineup.whereType<int>().first;
      final replacement = data.pool
          .firstWhere((p) => !lineup.contains(p.id))
          .id;
      await c.read(absenceRepositoryProvider).replace(save.careerId, [
        PlayerAbsence(playerId: banned, banMatches: 1),
      ]);
      out = (slot: lineup.indexOf(banned), replacement: replacement);
    });
    return out;
  }

  Future<void> fix(WidgetTester tester, SeededSave save, int slot, int id) =>
      tester.runAsync(
        () => save.container
            .read(tacticServiceProvider)
            .setSlot(save.careerId, slot, id),
      );

  testWidgets('tablet: the top bar lets go of the reshape once it is fixed', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    final fixAt = await banAStarter(tester, save);
    await pumpRoute(
      tester,
      save,
      '${Routes.hub}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(find.text(enL.hubEventReshapeXi), findsOneWidget);

    save.container
        .read(routerProvider)
        .go('${Routes.tactics}?careerId=${save.careerId}');
    await settle(tester);
    // Still asked while the ban stands: the top bar is on every shell screen.
    expect(find.text(enL.hubEventReshapeXi), findsOneWidget);

    await fix(tester, save, fixAt.slot, fixAt.replacement);
    await settle(tester);
    expect(find.text(enL.hubEventReshapeXi), findsNothing);
  });

  testWidgets('phone: the hub lets go of the reshape once it is fixed', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final fixAt = await banAStarter(tester, save);
    await pumpRoute(tester, save, '${Routes.hub}?careerId=${save.careerId}');
    expect(find.text(enL.hubEventReshapeXi), findsOneWidget);

    final router = save.container.read(routerProvider)
      ..go('${Routes.tactics}?careerId=${save.careerId}');
    await settle(tester);
    await fix(tester, save, fixAt.slot, fixAt.replacement);
    await settle(tester);
    router.go('${Routes.hub}?careerId=${save.careerId}');
    await settle(tester);
    expect(find.text(enL.hubEventReshapeXi), findsNothing);
  });
}
