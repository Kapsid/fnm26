@Tags(['slow'])
library;

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/playoff_draw_note.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_providers.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';

import 'driver.dart';

/// The World Championship's play-offs on the calendar2 rhythm, played
/// through the hub on one world (seed 35, found with a seed search; if a
/// change to the world moves the sides below, re-find them: the first
/// expectation of each story says which half broke).
///
/// * Türkiye finishes second in its qualifying group, is drawn into a
///   European path, plays its semi-final and final in late March and lands
///   in the exact December slot its placeholder was drawn into. (Poland,
///   then Belgium, did until Africa's, Asia's and Oceania's own steps and
///   the balanced home and away draw moved the world.)
/// * Northern Ireland (seed 45) wins its League C group in the second
///   Nations Cup, misses qualifying and comes in through pot 4.
/// * Curacao (seed 39), one of CONCACAF's two best runners-up, plays the
///   intercontinental play-off in the finals' host nation.
/// * England (seed 31) qualifies directly, is locked in at the draw and
///   watches every path from the stands.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const europe = Confederation.europe;
  const seed = 35;
  const turkiye = 53;
  const northernIreland = 38;
  const curacao = 78;
  // Curacao's own world: on seed 35 no managed CONCACAF side reaches the
  // intercontinental play-off since the balanced home and away draw (seed
  // 39 since the regional cups moved the world).
  const curacaoSeed = 39;
  // Northern Ireland's: since the regional cups it misses pot 4 on seed 35
  // (seed 45 since the wonderkids no academy releases moved the world).
  const northernIrelandSeed = 45;
  // England's: on seed 35 it misses direct qualification since the 1.1.2
  // engine tuning.
  const englandSeed = 31;
  final wcYear = CareerService.worldCupYear(0);
  final dates = Calendar2.wcPlayoffs(wcYear);

  Future<List<DrawSlot>> finalsSlots(CompetitionRepository comp, int id) =>
      comp.drawSlots(id, 0, CompetitionKind.worldCupFinals);

  Future<List<PlayoffPath>> uefaPaths(
    CompetitionRepository comp,
    int id,
  ) async => EuroPlayoffs.fromSlots(
    await comp.drawSlots(
      id,
      0,
      CompetitionKind.worldCupPlayoffEurope,
      confederation: europe,
    ),
  );

  /// Steps [d] until the finals' stored draw exists.
  Future<void> toDraw(StoryDriver d, CompetitionRepository comp) async {
    var steps = 0;
    while ((await finalsSlots(comp, d.careerId)).isEmpty) {
      if (++steps > 6000) fail('no finals draw');
      if (!await d.step(stopAtRollover: true)) fail('rollover');
    }
  }

  /// Steps [d] until the finals exist.
  Future<void> toFinals(StoryDriver d, CompetitionRepository comp) async {
    var steps = 0;
    while (!await comp.hasFinals(d.careerId)) {
      if (++steps > 6000) fail('no finals');
      if (!await d.step(stopAtRollover: true)) fail('rollover');
    }
  }

  bool wonBy(Fixture f, int nation) =>
      (f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId) ==
      nation;

  test('(a) a European runner-up plays its path live and takes its '
      'December slot', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, seed, nationId: turkiye);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final seen = <(HubEventKind, String?, DateTime)>[];
    d.beforeEvent = (e) async {
      seen.add((e.kind, e.route, (await careers.byId(id))!.inGameDate));
    };

    await toDraw(d, comp);
    final drawnOn = (await careers.byId(id))!.inGameDate;
    expect(drawnOn.year, wcYear - 1);
    expect(drawnOn.month, greaterThanOrEqualTo(11));
    final path = (await uefaPaths(
      comp,
      id,
    )).where((p) => p.seeds.contains(turkiye)).firstOrNull;
    expect(path, isNotNull, reason: 'Türkiye is in a path (re-find)');
    // A runner-up: pots 1 to 3.
    expect(path!.seeds.indexOf(turkiye), lessThan(3));
    final key = UefaWcPlayoffs.placeholderKey(path.letter);
    final placeholder = (await finalsSlots(
      comp,
      id,
    )).singleWhere((s) => s.placeholderKey == key);
    Future<({int ordinal, bool over})> run() async => worldRun(
      comp: comp,
      careerId: id,
      nationId: turkiye,
      fixtures: await comp.cycleFixturesForNation(id, turkiye),
      cycle: 0,
    );
    expect(await run(), (ordinal: 1, over: false));

    // The ceremonies, in order: Europe's paths, the intercontinental paths,
    // then the finals draw lighting the path's ball where it was drawn.
    // (Whatever else is due on the day, the year's awards, comes first.)
    final draws = <String>[];
    for (var i = 0; i < 20 && draws.length < 3; i++) {
      final e = await d.nextEvent();
      if (e.kind == HubEventKind.draw) {
        draws.add(e.route!);
        if (e.route!.startsWith(Routes.finalsDraw)) {
          final draw = (await c.read(finalsDrawProvider(id).future))!;
          expect(draw.playerPathKey, key);
          expect(draw.playerPathGroup, placeholder.groupName);
        }
      }
      await d.step();
    }
    expect(draws, [
      '${Routes.wcPlayoffDraw}?careerId=$id',
      '${Routes.wcPlayoffDraw}?careerId=$id&ic=1',
      '${Routes.finalsDraw}?careerId=$id',
    ]);

    await toFinals(d, comp);
    final mine = [
      for (final f in await comp.cycleFixturesForNation(id, turkiye))
        if (UefaWcPlayoffs.rounds.contains(f.round)) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    expect(mine.map((f) => f.round), [
      UefaWcPlayoffs.semiRound,
      UefaWcPlayoffs.finalRound,
    ], reason: 'won the semi (re-find if not)');
    expect(mine.first.date, dates.semis);
    expect(mine.last.date, dates.finalDay);
    // The semi at the higher seed's home; the final where the draw said.
    expect(mine.first.homeNationId == turkiye, path.seeds.indexOf(turkiye) < 2);
    final semiIndex =
        path.seeds.indexOf(turkiye) == 0 || path.seeds.indexOf(turkiye) == 3
        ? 0
        : 1;
    expect(mine.last.homeNationId == turkiye, semiIndex == path.finalHostSemi);
    // Played by the manager: a call-up and the matches on the hub.
    expect(
      seen.where(
        (e) =>
            e.$1 == HubEventKind.callUp &&
            e.$3.isAfter(DateTime(wcYear, 2)) &&
            e.$3.isBefore(dates.semis),
      ),
      isNotEmpty,
    );
    expect(
      seen.where(
        (e) =>
            e.$1 == HubEventKind.match &&
            e.$3.year == wcYear &&
            e.$3.month == 3,
      ),
      hasLength(greaterThanOrEqualTo(2)),
    );
    expect(wonBy(mine.last, turkiye), isTrue, reason: 'won the path (re-find)');

    // In the exact slot its placeholder was drawn into.
    final resolved = (await finalsSlots(
      comp,
      id,
    )).singleWhere((s) => s.placeholderKey == key);
    expect(resolved.resolvedNationId, turkiye);
    final wcId =
        (await (db.select(db.competitions)..where(
                  (t) =>
                      t.careerId.equals(id) &
                      t.kind.equalsValue(CompetitionKind.worldCupFinals),
                ))
                .getSingle())
            .id;
    final groupRow =
        await (db.select(db.qualifyingGroups)..where(
              (t) =>
                  t.name.equals(placeholder.groupName) &
                  t.competitionId.equals(wcId),
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
      turkiye,
    );
    expect(await run(), (ordinal: 2, over: false));
    final keys = await comp.messageKeys(id);
    expect(keys, contains('wcplayoff:$wcYear'));
    expect(keys, contains('qual:wc:$wcYear'));
    expect(keys.where((k) => k.startsWith('wcmiss:')), isEmpty);
    // The draw left its day and the first opponent for the feed, and Y
    // talks about it.
    // (A Euro play-off from the first Nations Cup leaves its own.)
    final notes = [
      for (final m in await comp.watchedKindsWithPrefix(PlayoffDrawNote.prefix))
        if (m.careerId == id) PlayoffDrawNote.decode(m.kind)!,
    ].where((n) => n.competition == 'World Championship');
    expect(notes, hasLength(1));
    expect(notes.single.date.year, wcYear - 1);
    final feed = (await c.read(yFeedProvider(id).future)).posts;
    expect(
      feed.any((p) => p.template == YTemplate.playoffDrawn),
      isTrue,
    );
  }, timeout: const Timeout(Duration(minutes: 40)));

  test('(b) a League C group winner of the second Nations Cup comes in '
      'through pot 4', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(
      c,
      northernIrelandSeed,
      nationId: northernIreland,
    );
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    await toDraw(d, comp);

    final nc = await comp.tournamentGroupTables(
      id,
      CompetitionKind.nationsLeague,
      confederation: europe,
      edition: Calendar2.secondEdition,
    );
    final mine = nc.singleWhere(
      (t) => t.standings.any((s) => s.nationId == northernIreland),
    );
    expect(mine.name[0], anyOf('C', 'D'), reason: 'League C or D (re-find)');
    expect(mine.standings.first.nationId, northernIreland);
    final path = (await uefaPaths(
      comp,
      id,
    )).where((p) => p.seeds.contains(northernIreland)).firstOrNull;
    expect(path, isNotNull, reason: 'in a path (re-find)');
    expect(path!.seeds.last, northernIreland, reason: 'pot 4');
    // Its semi away at the pot 1 side.
    final semi = (await comp.cycleFixturesForNation(
      id,
      northernIreland,
    )).singleWhere((f) => f.round == UefaWcPlayoffs.semiRound);
    expect(semi.homeNationId, path.seeds.first);
    expect(semi.awayNationId, northernIreland);
    expect(semi.date, dates.semis);
    // Not in its qualifying group's top two.
    final groups = await comp.allGroupTablesByConfederation(id);
    final group = groups.singleWhere(
      (g) => g.standings.any((s) => s.nationId == northernIreland),
    );
    expect(
      group.standings.indexWhere((s) => s.nationId == northernIreland),
      greaterThan(1),
    );
    final keys = await comp.messageKeys(id);
    expect(keys, contains('wcplayoff:$wcYear'));
  }, timeout: const Timeout(Duration(minutes: 40)));

  test('(c) a CONCACAF runner-up plays the intercontinental play-off in '
      'the host nation', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, curacaoSeed, nationId: curacao);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final seen = <(HubEventKind, String?, DateTime)>[];
    d.beforeEvent = (e) async {
      seen.add((e.kind, e.route, (await careers.byId(id))!.inGameDate));
    };
    await toDraw(d, comp);
    final ic = IcPlayoffs.fromSlots(
      await comp.drawSlots(id, 0, CompetitionKind.worldCupPlayoff),
    );
    final path = ic
        .where((p) => IcPlayoffs.members(p).contains(curacao))
        .firstOrNull;
    expect(path, isNotNull, reason: 'Curacao in the play-off (re-find)');
    expect(
      (await finalsSlots(
        comp,
        id,
      )).where(
        (s) => s.placeholderKey == IcPlayoffs.placeholderKey(path!.path),
      ),
      hasLength(1),
    );

    await toFinals(d, comp);
    final mine = [
      for (final f in await comp.cycleFixturesForNation(id, curacao))
        if (IcPlayoffs.rounds.contains(f.round)) f,
    ]..sort((a, b) => a.date.compareTo(b.date));
    expect(mine, isNotEmpty);
    expect(
      mine.first.date,
      path!.seed == curacao ? dates.finalDay : dates.semis,
    );
    final career = (await careers.byId(id))!;
    final nations = await c.read(nationRepositoryProvider).forCareer(id);
    for (final f in mine) {
      expect(f.hasResult, isTrue);
      final venue = venueForFixture(
        fixture: f,
        nations: nations,
        seed: career.rngSeed,
        cycle: 0,
      );
      expect(venue.neutral, isTrue);
      expect(venue.tournamentHostIds, isNotEmpty);
    }
    expect(
      seen.where(
        (e) =>
            e.$1 == HubEventKind.match &&
            e.$3.year == wcYear &&
            e.$3.month == 3,
      ),
      isNotEmpty,
    );
    // Won or lost, it ends where the draw said: in its slot, or out once.
    final slot = (await finalsSlots(comp, id)).singleWhere(
      (s) => s.placeholderKey == IcPlayoffs.placeholderKey(path.path),
    );
    final through = slot.resolvedNationId == curacao;
    final keys = await comp.messageKeys(id);
    expect(keys.contains('wcmiss:$wcYear'), !through);
    final run = await worldRun(
      comp: comp,
      careerId: id,
      nationId: curacao,
      fixtures: await comp.cycleFixturesForNation(id, curacao),
      cycle: 0,
    );
    expect(run.ordinal, through ? 2 : 0);
  }, timeout: const Timeout(Duration(minutes: 40)));

  test('(d) a direct qualifier is locked in at the draw and watches every '
      'path', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, englandSeed);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final seen = <(HubEventKind, String?, DateTime)>[];
    d.beforeEvent = (e) async {
      seen.add((e.kind, e.route, (await careers.byId(id))!.inGameDate));
    };
    await toDraw(d, comp);
    final slots = await finalsSlots(comp, id);
    expect(
      slots.any((s) => s.nationId == england),
      isTrue,
      reason: 'England qualified directly (re-find if not)',
    );
    expect(
      await worldRun(
        comp: comp,
        careerId: id,
        nationId: england,
        fixtures: await comp.cycleFixturesForNation(id, england),
        cycle: 0,
      ),
      (ordinal: 2, over: false),
    );
    final outcome = (await c.read(
      cycleObjectiveOutcomesProvider(id).future,
    )).where((o) => o.tier.name == 'world').firstOrNull;
    if (outcome != null) expect(outcome.actual, 2);

    await toFinals(d, comp);
    final watched = [
      for (final e in seen)
        if (e.$1 == HubEventKind.watchTournament &&
            (e.$2 ?? '').startsWith(Routes.cup) &&
            e.$3.year == wcYear &&
            e.$3.month == 3)
          e.$3,
    ];
    expect(watched, contains(dates.semis));
    final playoffs = [
      for (final r in UefaWcPlayoffs.rounds)
        ...await comp.fixturesByRound(
          id,
          r,
          kind: CompetitionKind.worldCupPlayoffEurope,
          confederation: europe,
        ),
      for (final r in IcPlayoffs.rounds)
        ...await comp.fixturesByRound(
          id,
          r,
          kind: CompetitionKind.worldCupPlayoff,
        ),
    ];
    expect(playoffs, hasLength(greaterThanOrEqualTo(5)));
    expect(playoffs.every((f) => f.hasResult), isTrue);
    expect(
      playoffs.any(
        (f) => f.homeNationId == england || f.awayNationId == england,
      ),
      isFalse,
    );
    final drawn = slots.singleWhere((s) => s.nationId == england).groupName;
    final groups = await comp.finalsGroupTables(id);
    expect(
      groups
          .singleWhere((g) => g.name == drawn)
          .standings
          .map((s) => s.nationId),
      contains(england),
    );
  }, timeout: const Timeout(Duration(minutes: 40)));
}
