@Tags(['slow'])
library;

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/euro_playoff_providers.dart';

import 'driver.dart';

/// Europe's play-offs on the calendar2 rhythm, played through the hub.
///
/// [entrant] misses direct qualification for the EURO, is drawn into a path
/// from its first Nations Cup league, sees its path winner's ball in the
/// December finals draw, plays its semi-final and final in March, and lands
/// in the exact slot its placeholder was drawn into. [watcher] qualifies
/// directly (its brief locked in at the draw) and steps the play-offs from
/// the stands.
///
/// Found with a seed search; if a change to the world moves them, re-find a
/// side that goes through a path (the first expectation says which half
/// broke).
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const europe = Confederation.europe;
  const entrantSeed = 33;
  const entrantIndex = 24;
  const watcherSeed = 31;

  Future<List<DrawSlot>> slotsOf(
    CompetitionRepository comp,
    int id,
    CompetitionKind kind,
  ) => comp.drawSlots(id, 0, kind, confederation: europe);

  test('a side through a path takes its December slot', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final europeans = [
      for (final n in storyNations)
        if (n.confederation == europe) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final me = europeans[entrantIndex].id;
    final d = await StoryDriver.start(c, entrantSeed, nationId: me);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final seen = <(HubEventKind, String?, DateTime)>[];
    d.beforeEvent = (e) async {
      seen.add((e.kind, e.route, (await careers.byId(id))!.inGameDate));
    };
    Future<({int ordinal, bool over})> run() async => continentalRun(
      comp: comp,
      careerId: id,
      nationId: me,
      confederation: europe,
      fixtures: await comp.cycleFixturesForNation(id, me),
      cycle: 0,
    );

    // To the end of qualifying: the paths are drawn and stored. On the way
    // the tables mark the sides on course for them: a full path's worth,
    // none of them a group's top two.
    final nations = {
      for (final n in await c.read(nationRepositoryProvider).forCareer(id))
        n.id: n,
    };
    Future<Set<int>> marks() async => euroPlayoffMarks(
      comp,
      careerId: id,
      cycle: 0,
      rngSeed: (await careers.byId(id))!.rngSeed,
      nations: nations,
    );
    var markedMidway = false;
    var steps = 0;
    while ((await slotsOf(
      comp,
      id,
      CompetitionKind.continentalPlayoff,
    )).isEmpty) {
      if (++steps > 4000) fail('no play-off draw');
      final today = (await careers.byId(id))!.inGameDate;
      if (!markedMidway && today.isAfter(DateTime(2027, 6, 30))) {
        markedMidway = true;
        final marked = await marks();
        expect(marked, isNotEmpty, reason: 'nothing marked mid-qualifying');
        expect(marked.length % 4, 0, reason: 'whole paths');
        for (final t in await comp.tournamentGroupTables(
          id,
          CompetitionKind.continentalQualifying,
          confederation: europe,
        )) {
          for (final s in t.standings.take(2)) {
            expect(marked, isNot(contains(s.nationId)));
          }
        }
      }
      await d.step(stopAtRollover: true);
    }
    expect(markedMidway, isTrue);
    final drawnOn = (await careers.byId(id))!.inGameDate;
    expect(drawnOn.year, 2027);
    expect(drawnOn.month, 11);
    // Once drawn, the marks are the paths' own sides.
    expect(await marks(), {
      for (final p in EuroPlayoffs.fromSlots(
        await slotsOf(comp, id, CompetitionKind.continentalPlayoff),
      ))
        ...p.seeds,
    });
    final path = EuroPlayoffs.fromSlots(
      await slotsOf(comp, id, CompetitionKind.continentalPlayoff),
    ).where((p) => p.seeds.contains(me)).firstOrNull;
    expect(path, isNotNull, reason: 'the entrant is in a path (re-find)');
    final key = EuroPlayoffs.placeholderKey(path!.letter);
    final placeholder = (await slotsOf(
      comp,
      id,
      CompetitionKind.continentalFinals,
    )).singleWhere((s) => s.placeholderKey == key);
    expect(placeholder.resolvedNationId, isNull);
    expect(
      await comp.hasTournament(
        id,
        CompetitionKind.continentalFinals,
        confederation: europe,
      ),
      isFalse,
    );
    // Not locked in: a rung below qualifying.
    expect(await run(), (ordinal: 1, over: false));

    // The two ceremonies, in order: the paths, then the finals draw, which
    // lights the path's ball in the group it was drawn into.
    final first = await d.nextEvent();
    expect(first.route, startsWith(Routes.euroPlayoffDraw));
    await d.step();
    final second = await d.nextEvent();
    expect(second.route, startsWith(Routes.continentalDraw));
    final draw = await c.read(
      continentalDrawProvider((careerId: id, confederation: europe)).future,
    );
    expect(draw, isNotNull);
    expect(draw!.playerPathLetter, path.letter);
    expect(draw.playerPathGroup, placeholder.groupName);
    await d.step();

    // On to the finals: the play-offs are played in March.
    while (!await comp.hasTournament(
      id,
      CompetitionKind.continentalFinals,
      confederation: europe,
    )) {
      if (++steps > 8000) fail('no EURO');
      await d.step(stopAtRollover: true);
    }
    final mine = [
      for (final f in await comp.cycleFixturesForNation(id, me))
        if (EuroPlayoffs.rounds.contains(f.round)) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    final plan = Calendar2.euroPlayoffs(CareerService.worldCupYear(0));
    expect(mine.map((f) => f.round), [
      EuroPlayoffs.semiRound,
      EuroPlayoffs.finalRound,
    ], reason: 'won the semi (re-find if not)');
    expect(mine.first.date, plan.semis);
    expect(mine.last.date, plan.finalDay);
    final semi = mine.first;
    expect(semi.homeNationId == me, path.seeds.indexOf(me) < 2);
    expect(mine.every((f) => f.hasResult), isTrue);
    // Played by the manager: a call-up and a match on the hub before each.
    expect(
      seen.where(
        (e) =>
            e.$1 == HubEventKind.callUp &&
            e.$3.isAfter(DateTime(2028, 2)) &&
            e.$3.isBefore(plan.semis),
      ),
      isNotEmpty,
    );
    expect(
      seen.where(
        (e) =>
            e.$1 == HubEventKind.match &&
            e.$3.isAfter(DateTime(2028, 3)) &&
            e.$3.isBefore(DateTime(2028, 4)),
      ),
      hasLength(greaterThanOrEqualTo(2)),
    );

    // Won the path: in the exact slot its placeholder was drawn into.
    final f = mine.last;
    final won = f.homeNationId == me
        ? f.homeScore! > f.awayScore!
        : f.awayScore! > f.homeScore!;
    expect(won, isTrue, reason: 'won the path final (re-find if not)');
    final resolved = (await slotsOf(
      comp,
      id,
      CompetitionKind.continentalFinals,
    )).singleWhere((s) => s.placeholderKey == key);
    expect(resolved.resolvedNationId, me);
    final groups = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalFinals,
      confederation: europe,
    );
    final group = groups.singleWhere((g) => g.name == placeholder.groupName);
    expect(group.standings.map((s) => s.nationId), contains(me));
    // Its place in the group's drawn order, as stored.
    final euroId = (await comp.competitionIdOf(
      id,
      CompetitionKind.continentalFinals,
      confederation: europe,
    ))!;
    final groupRow =
        await (db.select(db.qualifyingGroups)..where(
              (t) =>
                  t.name.equals(placeholder.groupName) &
                  t.competitionId.equals(euroId),
            ))
            .getSingle();
    final members = await db
        .customSelect(
          'SELECT nation_id FROM group_members WHERE group_id = ? '
          'ORDER BY rowid',
          variables: [Variable.withInt(groupRow.id)],
        )
        .get();
    expect(
      members
          .map((m) => m.read<int>('nation_id'))
          .toList()[placeholder.position],
      me,
    );
    // The EURO in June, the brief now locked in, the news filed once.
    expect(await run(), (ordinal: 2, over: false));
    final keys = await comp.messageKeys(id);
    expect(keys, contains('europlayoff:2030'));
    expect(keys, contains('qual:cont:2028'));
    expect(keys.where((k) => k.startsWith('contmiss:')), isEmpty);
  }, timeout: const Timeout(Duration(minutes: 30)));

  test('a direct qualifier is locked in at the draw and watches the '
      'play-offs', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, watcherSeed);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final seen = <(HubEventKind, String?, DateTime)>[];
    d.beforeEvent = (e) async {
      seen.add((e.kind, e.route, (await careers.byId(id))!.inGameDate));
    };

    var steps = 0;
    while ((await slotsOf(
      comp,
      id,
      CompetitionKind.continentalFinals,
    )).isEmpty) {
      if (++steps > 4000) fail('no finals draw');
      await d.step(stopAtRollover: true);
    }
    final slots = await slotsOf(comp, id, CompetitionKind.continentalFinals);
    expect(
      slots.any((s) => s.nationId == england),
      isTrue,
      reason: 'England qualified directly (re-find if not)',
    );
    // Locked in the day of the draw, months before the finals exist.
    final run = await continentalRun(
      comp: comp,
      careerId: id,
      nationId: england,
      confederation: europe,
      fixtures: await comp.cycleFixturesForNation(id, england),
      cycle: 0,
    );
    expect(run, (ordinal: 2, over: false));
    final outcome = (await c.read(
      cycleObjectiveOutcomesProvider(id).future,
    )).where((o) => o.tier == TournamentTier.continental).firstOrNull;
    if (outcome != null) expect(outcome.actual, 2);

    while (!await comp.hasTournament(
      id,
      CompetitionKind.continentalFinals,
      confederation: europe,
    )) {
      if (++steps > 8000) fail('no EURO');
      await d.step(stopAtRollover: true);
    }
    // The play-offs were stepped from the stands, a day at a time.
    final watched = [
      for (final e in seen)
        if (e.$1 == HubEventKind.watchTournament &&
            (e.$2 ?? '').startsWith(Routes.continental) &&
            e.$3.year == 2028 &&
            e.$3.month == 3)
          e.$3,
    ];
    // The clock stopped on the semi-finals' day, where the watch was offered,
    // and the next step played the finals on theirs, which made the EURO.
    final plan = Calendar2.euroPlayoffs(CareerService.worldCupYear(0));
    expect(watched, contains(plan.semis));
    expect((await careers.byId(id))!.inGameDate, plan.finalDay);
    final playoffs = [
      for (final r in EuroPlayoffs.rounds)
        ...await comp.fixturesByRound(
          id,
          r,
          kind: CompetitionKind.continentalPlayoff,
          confederation: europe,
        ),
    ];
    expect(playoffs, isNotEmpty);
    expect(playoffs.every((f) => f.hasResult), isTrue);
    expect(
      playoffs.any(
        (f) => f.homeNationId == england || f.awayNationId == england,
      ),
      isFalse,
    );
    // England's EURO group is the one it was drawn into in November.
    final drawn = slots.singleWhere((s) => s.nationId == england).groupName;
    final groups = await comp.tournamentGroupTables(
      id,
      CompetitionKind.continentalFinals,
      confederation: europe,
    );
    expect(
      groups
          .singleWhere((g) => g.name == drawn)
          .standings
          .map((s) => s.nationId),
      contains(england),
    );
  }, timeout: const Timeout(Duration(minutes: 30)));
}
