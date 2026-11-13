import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/services/competition/match_schedule.dart';
import 'package:fnm/features/hub/hub_event.dart';
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

/// Every match still to come this cycle, in order, from the current window.
List<Fixture> _upcoming(ScheduleData d) => [
  if (d.currentIndex >= 0)
    for (var i = d.currentIndex; i < d.blocks.length; i++)
      for (final f in d.blocks[i].fixtures)
        if (!f.hasResult) f,
];

List<int> _cardIds(WidgetTester tester) => [
  for (final c in tester.widgetList<UpcomingFixtureCard>(
    find.byType(UpcomingFixtureCard),
  ))
    c.fixture.id,
];

Override _nextEvent(HubEvent event) =>
    nextEventProvider(kSeededCareerId).overrideWith((ref) async => event);

void main() {
  testWidgets('the hub shows the next two matches and opens the schedule', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, _hub(save));
    expect(find.text(enL.hubUpcoming.toUpperCase()), findsOneWidget);
    final d = (await tester.runAsync(
      () => save.container.read(scheduleProvider(save.careerId).future),
    ))!;
    final upcoming = _upcoming(d);
    expect(upcoming.length, greaterThan(UpcomingStrip.cards));
    expect(_cardIds(tester), [
      for (final f in upcoming.take(UpcomingStrip.cards)) f.id,
    ]);
    // The rest of the cycle is summed up in one dashed card: the month that
    // comes next and how many more matches it holds.
    final rest = upcoming.skip(UpcomingStrip.cards).toList();
    final more = rest
        .where(
          (f) =>
              f.date.year == rest.first.date.year &&
              f.date.month == rest.first.date.month,
        )
        .length;
    expect(
      find.descendant(
        of: find.byKey(UpcomingStrip.nextWindowKey),
        matching: find.text('+$more'),
      ),
      findsOneWidget,
    );
    await tester.ensureVisible(find.text(enL.hubFullSchedule));
    await tester.tap(find.text(enL.hubFullSchedule));
    await settle(tester);
    expect(find.byType(ScheduleScreen), findsOneWidget);
  });

  testWidgets('the strip moves on after the window is played', (
    tester,
  ) async {
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
      _cardIds(tester).first,
      d.blocks[d.currentIndex + 1].fixtures.first.id,
    );
    expect(find.text('1–0'), findsNothing);
  });

  // b8 item 2: the current window's first match, once played, used to stay
  // under UPCOMING with its score beside it until the whole window was done.
  testWidgets('a match played leaves the upcoming strip at once', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, _hub(save));
    final before = (await tester.runAsync(
      () => save.container.read(scheduleProvider(save.careerId).future),
    ))!;
    // The first window that holds more than one match: playing its first
    // keeps the window current.
    final b = before.blocks.indexWhere((x) => x.fixtures.length > 1);
    expect(b, greaterThanOrEqualTo(0));
    await tester.runAsync(() async {
      final comp = save.container.read(competitionRepositoryProvider);
      for (var i = 0; i < b; i++) {
        for (final f in before.blocks[i].fixtures) {
          await comp.recordResult(fixtureId: f.id, homeScore: 0, awayScore: 0);
        }
      }
      await comp.recordResult(
        fixtureId: before.blocks[b].fixtures.first.id,
        homeScore: 3,
        awayScore: 1,
      );
    });
    save.container.invalidate(hubDataProvider(save.careerId));
    await settle(tester);
    final after = (await tester.runAsync(
      () => save.container.read(scheduleProvider(save.careerId).future),
    ))!;
    expect(
      after.currentIndex,
      b,
      reason: 'the window is still the current one',
    );
    final played = before.blocks[b].fixtures.first;
    final ids = _cardIds(tester);
    expect(ids.first, before.blocks[b].fixtures[1].id);
    expect(ids, isNot(contains(played.id)));
    expect(find.text('3–1'), findsNothing);
    expect(find.text('1–3'), findsNothing);
  });

  testWidgets('an open call-up says how many days are left', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        _nextEvent(
          const HubEvent(
            kind: HubEventKind.callUp,
            label: 'Call up',
            icon: Icons.groups,
            route: '${Routes.callUps}?careerId=$kSeededCareerId',
          ),
        ),
      ],
    );
    await pumpRoute(tester, save, _hub(save));
    final d = (await tester.runAsync(
      () => save.container.read(scheduleProvider(save.careerId).future),
    ))!;
    final days = DateUtils.dateOnly(
      _upcoming(d).first.date,
    ).difference(DateUtils.dateOnly(save.career.inGameDate)).inDays;
    expect(
      find.descendant(
        of: find.byKey(UpcomingStrip.callUpWarningKey),
        matching: find.text(enL.hubCallUpClosesIn(days).toUpperCase()),
      ),
      findsOneWidget,
    );
  });

  testWidgets('no warning line once the squad is named', (tester) async {
    final save = await seedSave(
      tester,
      overrides: [
        _nextEvent(
          const HubEvent(
            kind: HubEventKind.match,
            label: 'Play',
            icon: Icons.play_arrow,
          ),
        ),
      ],
    );
    await pumpRoute(tester, save, _hub(save));
    expect(find.byType(UpcomingFixtureCard), findsWidgets);
    expect(find.byKey(UpcomingStrip.callUpWarningKey), findsNothing);
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
    expect(find.byType(UpcomingFixtureCard), findsNothing);
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
    expect(find.byType(UpcomingFixtureCard), findsNothing);
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

  testWidgets('the tablet panel shows the strip and a full schedule link', (
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
      find.descendant(of: panel, matching: find.byType(UpcomingFixtureCard)),
      findsNWidgets(UpcomingStrip.cards),
    );
    await tester.tap(
      find.descendant(of: panel, matching: find.text(enL.hubFullSchedule)),
    );
    await settle(tester);
    expect(find.byType(ScheduleScreen), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
