import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/match_schedule.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/federation/sponsor_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/hub/schedule_providers.dart';
import 'package:fnm/features/hub/schedule_screen.dart';
import 'package:fnm/features/hub/schedule_widgets.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/seeded_save.dart';

final AppLocalizations enL = lookupAppLocalizations(const Locale('en'));

String _location(SeededSave save) => save.container
    .read(routerProvider)
    .routerDelegate
    .currentConfiguration
    .last
    .matchedLocation;

String get _scheduleUrl => '${Routes.schedule}?careerId=$kSeededCareerId';

/// Watches everything that stands between the seeded save and its first match
/// (budget, the qualifying draw, the first window's call-up).
Future<void> _readyForMatch(WidgetTester tester, SeededSave save) async {
  await watchContinentalQualifyingDraw(tester, save);
  await tester.runAsync(() async {
    final comp = save.container.read(competitionRepositoryProvider);
    final career = (await save.container.read(
      hubDataProvider(save.careerId).future,
    ))!.career;
    await comp.markDrawWatched(
      save.careerId,
      career.cyclePointer,
      budgetSetupKind,
    );
    await comp.markDrawWatched(
      save.careerId,
      career.cyclePointer,
      continentalHostDrawKind,
    );
    // The cycle's sponsor would otherwise be the next step.
    await save.container.read(sponsorServiceProvider).decline(save.careerId);
    final fixtures = await comp.cycleFixturesForNation(
      save.careerId,
      save.nationId,
    );
    await comp.markDrawWatched(
      save.careerId,
      career.cyclePointer,
      'callup:${fixtures.first.id}',
    );
    // The preview press conference is the last step before kick-off.
    final careers = save.container.read(careerRepositoryProvider);
    final id = await careers.recordConference(
      careerId: save.careerId,
      cycle: career.cyclePointer,
      reason: ConferenceReason.preview,
      fixtureId: fixtures.first.id,
      triggeredOn: career.inGameDate,
    );
    await careers.setConferenceStatus(id, ConferenceStatus.held);
    save.container
      ..invalidate(hubDataProvider(save.careerId))
      ..invalidate(nextEventProvider(save.careerId))
      ..invalidate(scheduleProvider(save.careerId));
  });
}

void main() {
  testWidgets('opens at today with the first window', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, _scheduleUrl);
    expect(find.byKey(ScheduleScreen.todayKey), findsOneWidget);
    expect(find.text(enL.scheduleTitle), findsOneWidget);
    expect(find.byType(ScheduleFixtureRow), findsWidgets);
  });

  testWidgets('an unwatched draw hides the opponent and the tap', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await pumpRoute(tester, save, _scheduleUrl);
    final pending = find.text(enL.topBarDrawPending);
    expect(pending, findsWidgets);
    final before = _location(save);
    await tester.tap(pending.first);
    await settle(tester);
    expect(_location(save), before);
  });

  testWidgets('the next match opens the preview only when it is next', (
    tester,
  ) async {
    // Draws watched but no call-up named: the next step is the call-up, so
    // the row opens the opponent and the squad step is not skipped.
    final save = await seedSave(tester);
    await watchContinentalQualifyingDraw(tester, save);
    await tester.runAsync(() async {
      final comp = save.container.read(competitionRepositoryProvider);
      final cycle = save.career.cyclePointer;
      await comp.markDrawWatched(save.careerId, cycle, budgetSetupKind);
      await comp.markDrawWatched(save.careerId, cycle, continentalHostDrawKind);
    });
    await pumpRoute(tester, save, _scheduleUrl);
    await tester.tap(find.byType(ScheduleFixtureRow).first);
    await settle(tester);
    expect(_location(save), startsWith(Routes.nationVitrine));
  });

  testWidgets('the next match opens the preview when nothing else is due', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await _readyForMatch(tester, save);
    await pumpRoute(tester, save, _scheduleUrl);
    await tester.tap(find.byType(ScheduleFixtureRow).first);
    await settle(tester);
    expect(_location(save), startsWith(Routes.matchPreview));
  });

  testWidgets('tablet uses the TabletPage layout', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(tester, save, _scheduleUrl, size: kTabletSize);
    expect(find.byKey(ScheduleScreen.tabletLayoutKey), findsOneWidget);
    expect(find.byKey(ScheduleScreen.todayKey), findsOneWidget);
  });

  testWidgets('a finished cycle shows no today marker', (tester) async {
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
    await pumpRoute(tester, save, _scheduleUrl);
    expect(find.byKey(ScheduleScreen.todayKey), findsNothing);
    // Nothing is current, so the list opens on the last block, not the oldest:
    // the closing line is in view without scrolling.
    expect(find.text(enL.hubNoMoreFixtures), findsOneWidget);
  });

  testWidgets('a stage still to come shows no closing line', (tester) async {
    final data = _data([_fx(1, DateTime(2030, 6, 11), 'GROUP', played: true)]);
    await _pumpScreen(
      tester,
      scheduleProvider.overrideWith(
        (ref, id) async => data,
      ),
    );
    expect(find.text(enL.scheduleKnockoutPending), findsOneWidget);
    expect(find.text(enL.hubNoMoreFixtures), findsNothing);
  });

  testWidgets('a schedule that failed to load ends in the empty line', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      scheduleProvider.overrideWith(
        (ref, id) async => throw StateError('boom'),
      ),
    );
    expect(find.byType(CircularProgressIndicator), findsNothing);
    expect(find.text(enL.hubNoMoreFixtures), findsOneWidget);
  });

  group('month cards and filters', () {
    // Two qualifiers (one in September, one in October), a friendly in
    // October, the qualifying draw unwatched so the qualifiers wait on it.
    ScheduleData calendar() => _data([
      _fx(1, DateTime(2030, 9, 5), 'CQ', group: 7),
      _fx(2, DateTime(2030, 10, 8), 'FRIENDLY'),
      _fx(3, DateTime(2030, 10, 11), 'CQ', group: 7),
    ]);

    Future<void> pump(WidgetTester tester) => _pumpScreen(
      tester,
      scheduleProvider.overrideWith((ref, id) async => calendar()),
    );

    testWidgets('one header per month, opening on today', (tester) async {
      await pump(tester);
      expect(find.text('SEPTEMBER 2030'), findsOneWidget);
      expect(find.text('OCTOBER 2030'), findsOneWidget);
      expect(find.byKey(ScheduleScreen.todayKey), findsOneWidget);
      expect(find.byType(ScheduleFixtureRow), findsNWidgets(3));
    });

    testWidgets('an unwatched draw is a dashed row before its matches', (
      tester,
    ) async {
      await pump(tester);
      final title = enL.scheduleDrawOf(
        enL.resultsCategoryContinentalQualifying,
      );
      expect(find.widgetWithText(ScheduleDrawRow, title), findsOneWidget);
      expect(
        tester.getTopLeft(find.byType(ScheduleDrawRow)).dy,
        lessThan(tester.getTopLeft(find.byType(ScheduleFixtureRow).first).dy),
      );
      // The group is a draw result too: not named before the ceremony.
      expect(find.textContaining('GROUP'), findsNothing);
    });

    testWidgets('Competitions leaves the friendly out', (tester) async {
      await pump(tester);
      await tester.tap(
        find.byKey(ScheduleScreen.filterKey(ScheduleFilter.competitions)),
      );
      await tester.pump();
      final ids = tester
          .widgetList<ScheduleFixtureRow>(find.byType(ScheduleFixtureRow))
          .map((r) => r.fixture.id);
      expect(ids, [1, 3]);
      expect(find.byType(ScheduleDrawRow), findsOneWidget);
    });

    testWidgets('Draws shows the draws alone', (tester) async {
      await pump(tester);
      await tester.tap(
        find.byKey(ScheduleScreen.filterKey(ScheduleFilter.draws)),
      );
      await tester.pump();
      expect(find.byType(ScheduleFixtureRow), findsNothing);
      expect(find.byType(ScheduleDrawRow), findsOneWidget);
    });

    testWidgets('Draws with none to come says so', (tester) async {
      final data = _data([_fx(1, DateTime(2030, 6, 11), 'FRIENDLY')]);
      await _pumpScreen(
        tester,
        scheduleProvider.overrideWith((ref, id) async => data),
      );
      await tester.tap(
        find.byKey(ScheduleScreen.filterKey(ScheduleFilter.draws)),
      );
      await tester.pump();
      expect(find.text(enL.scheduleNoDraws), findsOneWidget);
    });

    testWidgets('a watched draw names the group in the mono line', (
      tester,
    ) async {
      final d = calendar();
      final watched = (
        nationId: d.nationId,
        blocks: d.blocks,
        currentIndex: d.currentIndex,
        nations: d.nations,
        watchedDrawKinds: {continentalQualDrawKind},
      );
      await _pumpScreen(
        tester,
        scheduleProvider.overrideWith((ref, id) async => watched),
      );
      expect(find.byType(ScheduleDrawRow), findsNothing);
      final line = scheduleMetaLine(
        enL,
        _fx(1, DateTime(2030, 9, 5), 'CQ', group: 7),
        nationId: 1,
        // A grouped qualifier: the matchday gives way to the group.
        competition: enL.resultsCategoryContinentalQualifyingShort
            .toUpperCase(),
        groupName: 'B',
      );
      expect(line, contains(enL.scheduleGroupTag('B').toUpperCase()));
      expect(line, endsWith(enL.scheduleHome.toUpperCase()));
      expect(find.text(line), findsNWidgets(2));
    });
  });

  group('the score reads from the nation side', () {
    Future<void> pumpRow(WidgetTester tester, Fixture f) => tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: ScheduleFixtureRow(
            fixture: f,
            nationId: 1,
            opponent: null,
            opponentKnown: false,
          ),
        ),
      ),
    );

    testWidgets('away: a 3-0 win prints 3-0', (tester) async {
      await pumpRow(
        tester,
        _fx(
          1,
          DateTime(2030, 6, 11),
          'GROUP',
          played: true,
          home: 0,
          away: 3,
          nationHome: false,
        ),
      );
      expect(find.text('3–0'), findsOneWidget);
    });

    testWidgets('home: a 2-1 win prints 2-1', (tester) async {
      await pumpRow(
        tester,
        _fx(1, DateTime(2030, 6, 11), 'GROUP', played: true, home: 2, away: 1),
      );
      expect(find.text('2–1'), findsOneWidget);
    });
  });
}

Fixture _fx(
  int id,
  DateTime date,
  String round, {
  bool played = false,
  int home = 0,
  int away = 0,
  bool nationHome = true,
  int? group,
}) => Fixture(
  id: id,
  careerId: 1,
  competitionId: 1,
  matchday: 1,
  date: date,
  homeNationId: nationHome ? 1 : 2,
  awayNationId: nationHome ? 2 : 1,
  round: round,
  groupId: group,
  played: played,
  homeScore: played ? home : null,
  awayScore: played ? away : null,
);

ScheduleData _data(List<Fixture> fixtures) {
  final blocks = MatchSchedule.blocks(fixtures, nationId: 1);
  return (
    nationId: 1,
    blocks: blocks,
    currentIndex: MatchSchedule.currentIndex(blocks),
    nations: <int, Nation>{},
    watchedDrawKinds: <String>{},
  );
}

Future<void> _pumpScreen(WidgetTester tester, Override schedule) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        schedule,
        scheduleGroupNamesProvider.overrideWith(
          (ref, id) async => const {7: 'B'},
        ),
        nextEventProvider.overrideWith(
          (ref, id) async => throw StateError('none'),
        ),
      ],
      child: const MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: ScheduleScreen(careerId: 1),
      ),
    ),
  );
  await tester.pump();
  await tester.pump();
}
