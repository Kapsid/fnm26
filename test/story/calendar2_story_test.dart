@Tags(['slow'])
library;

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import 'driver.dart';

/// England, a new career on the calendar2 rhythm, played through its whole
/// first cycle as the hub offers it (every ceremony, call-up and match) and
/// into the next: both Nations Cups are drawn, watched and played, the board
/// grades the second, and the cycle rolls into another calendar2 cycle.
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  test('a new career plays a whole calendar2 cycle through the hub', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, 31);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    expect(await comp.hasWatchedDraw(id, 0, calendar2Kind), isTrue);

    // Every hub event, with the day it came on.
    final seen = <(HubEventKind, String?, DateTime)>[];
    d.beforeEvent = (e) async {
      seen.add((e.kind, e.route, (await careers.byId(id))!.inGameDate));
    };
    var steps = 0;
    while (await d.step(stopAtRollover: true)) {
      if (++steps > 6000) fail('runaway');
    }
    expect(await comp.worldChampion(id), isNotNull);

    // The Nations Cup ceremony came twice: autumn 2026 and autumn 2028.
    final ncDraws = [
      for (final (kind, route, at) in seen)
        if (kind == HubEventKind.draw && (route ?? '').contains('nations-cup'))
          at,
    ];
    expect(ncDraws.map((d) => d.year).toSet(), {2026, 2028});
    expect(await comp.hasWatchedDraw(id, 0, nationsCupDrawKind), isTrue);

    // Both editions crowned, filed under their league phases' years.
    final cup = NationsCups.forConfederation(Confederation.europe)!.name;
    final years = [
      for (final h in await comp.honours(id))
        if (h.competition == cup) h.year,
    ];
    expect(years, containsAll([2026, 2028]));

    // England's qualifying for the EURO in 2027, no June match while in
    // the Finals Four.
    final mine = await comp.fixturesForNation(id, england);
    final cq = [
      for (final f in mine)
        if (f.round == 'CQ') f,
    ];
    if (cq.isNotEmpty) {
      expect(cq.every((f) => f.date.year == 2027), isTrue);
      final inFour = mine.any(
        (f) => f.round == 'NSF' && f.date.year == 2027,
      );
      if (inFour) {
        expect(cq.where((f) => f.date.month == 6), isEmpty);
      }
    }

    // The board graded the second cup (filed once the cup was settled).
    final outcomes = await c.read(cycleObjectiveOutcomesProvider(id).future);
    final nc = outcomes
        .where((o) => o.tier == TournamentTier.nationsCup)
        .firstOrNull;
    expect(nc, isNotNull, reason: 'a Nations Cup brief');
    expect(nc!.decided, isTrue);
    final graded =
        await (db.select(db.competitions)..where(
              (t) =>
                  t.careerId.equals(id) &
                  t.kind.equalsValue(CompetitionKind.nationsLeague) &
                  t.confederation.equalsValue(Confederation.europe) &
                  t.edition.equals(1),
            ))
            .getSingle();
    final ownSecond = [
      for (final f in mine)
        if (f.competitionId == graded.id) f,
    ];
    expect(ownSecond, isNotEmpty, reason: 'England played the second cup');

    // Into the next cycle, still on calendar2.
    await d.step();
    expect((await careers.byId(id))!.cyclePointer, 1);
    expect(await comp.hasWatchedDraw(id, 1, calendar2Kind), isTrue);
    for (var i = 0; i < 40; i++) {
      await d.step(stopAtRollover: true);
    }
  }, timeout: const Timeout(Duration(minutes: 60)));
}
