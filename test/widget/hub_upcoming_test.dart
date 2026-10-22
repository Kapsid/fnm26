import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/match_schedule.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/hub/schedule_providers.dart';
import 'package:fnm/features/hub/schedule_screen.dart';
import 'package:fnm/features/hub/schedule_widgets.dart';

import '../helpers/seeded_save.dart';

String _hub(SeededSave save) => '${Routes.hub}?careerId=${save.careerId}';

/// A schedule with nothing current: one played group match and, optionally, a
/// stage still to be drawn after it.
Override _nothingCurrent({required bool pending}) =>
    scheduleProvider(kSeededCareerId).overrideWith((ref) async {
      final hub = (await ref.watch(hubDataProvider(kSeededCareerId).future))!;
      final f = Fixture(
        id: 1,
        careerId: kSeededCareerId,
        competitionId: 1,
        matchday: 3,
        date: DateTime(2030, 6, 17),
        homeNationId: hub.career.nationId,
        awayNationId: hub.career.nationId + 1,
        round: 'GROUP',
        played: true,
        homeScore: 1,
        awayScore: 0,
      );
      return (
        nationId: hub.career.nationId,
        blocks: <ScheduleBlock>[
          (
            year: 2030,
            month: 6,
            fixtures: [f],
            pending: pending
                ? (knockoutStage: true, from: DateTime(2030, 6, 18))
                : null,
          ),
        ],
        currentIndex: -1,
        nations: hub.nations,
        watchedDrawKinds: <String>{},
      );
    });

void main() {
  testWidgets('the hub lists the current window and opens the schedule', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, _hub(save));
    expect(find.text(enL.hubUpcoming), findsOneWidget);
    final d = (await tester.runAsync(
      () => save.container.read(scheduleProvider(save.careerId).future),
    ))!;
    expect(
      find.byType(ScheduleFixtureRow),
      findsNWidgets(d.blocks[d.currentIndex].fixtures.length),
    );
    await tester.ensureVisible(find.text(enL.hubFullSchedule));
    await tester.tap(find.text(enL.hubFullSchedule));
    await settle(tester);
    expect(find.byType(ScheduleScreen), findsOneWidget);
  });

  testWidgets('the card moves on after the window is played', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, _hub(save));
    final d = (await tester.runAsync(
      () => save.container.read(scheduleProvider(save.careerId).future),
    ))!;
    expect(d.blocks.length, greaterThan(1));
    await tester.runAsync(() async {
      final comp = save.container.read(competitionRepositoryProvider);
      for (final f in d.blocks[d.currentIndex].fixtures) {
        await comp.recordResult(fixtureId: f.id, homeScore: 1, awayScore: 0);
      }
    });
    save.container.invalidate(hubDataProvider(save.careerId));
    await settle(tester);
    expect(
      find.byType(ScheduleFixtureRow),
      findsNWidgets(d.blocks[d.currentIndex + 1].fixtures.length),
    );
    expect(find.text('1–0'), findsNothing);
  });

  testWidgets('a finished cycle says there is nothing more', (tester) async {
    final save = await seedSave(tester);
    await tester.runAsync(() async {
      final comp = save.container.read(competitionRepositoryProvider);
      for (final f in await comp.cycleFixturesForNation(
        save.careerId,
        save.nationId,
      )) {
        await comp.recordResult(fixtureId: f.id, homeScore: 1, awayScore: 0);
      }
    });
    await pumpRoute(tester, save, _hub(save));
    expect(find.byType(ScheduleFixtureRow), findsNothing);
    expect(find.text(enL.hubNoMoreFixtures), findsOneWidget);
  });

  testWidgets('nothing current but a stage to come shows the pending row', (
    tester,
  ) async {
    final save = await seedSave(
      tester,
      overrides: [_nothingCurrent(pending: true)],
    );
    await pumpRoute(tester, save, _hub(save));
    expect(find.text(enL.scheduleKnockoutPending), findsOneWidget);
    expect(find.byType(ScheduleFixtureRow), findsNothing);
    expect(find.text(enL.hubNoMoreFixtures), findsNothing);
  });

  testWidgets('nothing current and nothing to come says so', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [_nothingCurrent(pending: false)],
    );
    await pumpRoute(tester, save, _hub(save));
    expect(find.text(enL.hubNoMoreFixtures), findsOneWidget);
    expect(find.text(enL.scheduleKnockoutPending), findsNothing);
  });

  testWidgets('the tablet panel shows the window and a full schedule link', (
    tester,
  ) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, _hub(save), size: kTabletSize);
    final panel = find.byKey(HubScreen.nextMatchPanelKey);
    expect(
      find.descendant(
        of: panel,
        matching: find.text(enL.hubUpcoming.toUpperCase()),
      ),
      findsOneWidget,
    );
    expect(
      find.descendant(of: panel, matching: find.byType(ScheduleFixtureRow)),
      findsWidgets,
    );
    await tester.tap(
      find.descendant(of: panel, matching: find.text(enL.hubFullSchedule)),
    );
    await settle(tester);
    expect(find.byType(ScheduleScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
