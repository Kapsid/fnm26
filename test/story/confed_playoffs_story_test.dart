@Tags(['slow'])
library;

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/confed_playoffs.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';

import 'driver.dart';

/// Africa's, Asia's and Oceania's World Championship qualifying play-off
/// steps on the calendar2 rhythm, played out by the world itself on seed
/// 31's world (the World Championship play-off stories' world), the manager
/// England watching from Europe: every step is a November fixture played in
/// order, the second leg of Asia's fifth round settled on aggregate, and
/// the play-off and finals draws made once all of them are decided, with
/// their winners and entrants where they belong.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const seed = 31;
  const kind = ConfedPlayoffs.kind;
  final wcYear = CareerService.worldCupYear(0);

  Future<List<Fixture>> stepFixtures(
    CompetitionRepository comp,
    int id,
    Confederation conf,
    String round,
  ) => comp.fixturesByRound(id, round, kind: kind, confederation: conf);

  test('the world plays every step in November, then the draws', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final d = await StoryDriver.start(c, seed);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final stepsSeenAt = <DateTime>[];
    d.beforeEvent = (e) async {
      if (e.kind == HubEventKind.watchTournament) {
        stepsSeenAt.add((await careers.byId(id))!.inGameDate);
      }
    };
    var steps = 0;
    while ((await comp.drawSlots(
      id,
      0,
      CompetitionKind.worldCupFinals,
    )).isEmpty) {
      if (++steps > 6000) fail('no finals draw');
      if (!await d.step(stopAtRollover: true)) fail('rollover');
    }

    final caf = [
      ...await stepFixtures(comp, id, Confederation.africa, 'AFSF'),
      ...await stepFixtures(comp, id, Confederation.africa, 'AFFINAL'),
    ];
    final afc4 = await stepFixtures(comp, id, Confederation.asia, 'AQ4');
    final leg1 = await stepFixtures(comp, id, Confederation.asia, 'AQ5L1');
    final leg2 = await stepFixtures(comp, id, Confederation.asia, 'AQ5L2');
    final ofc = await stepFixtures(comp, id, Confederation.oceania, 'OFINAL');
    expect(caf, hasLength(3));
    expect(afc4, hasLength(6));
    expect(leg1, hasLength(1));
    expect(leg2, hasLength(1));
    expect(ofc, hasLength(1));
    final all = [...caf, ...afc4, ...leg1, ...leg2, ...ofc];
    expect(all.every((f) => f.hasResult), isTrue);
    for (final f in all) {
      expect(f.date.year, wcYear - 1, reason: '${f.round} ${f.date}');
      expect(f.date.month, 11, reason: '${f.round} ${f.date}');
    }
    // One-off knockouts always have a winner; the second leg never leaves
    // its tie level.
    for (final f in [...caf, ...ofc]) {
      expect(f.homeScore, isNot(f.awayScore));
    }
    final (h, a) = TwoLegged.aggregate(leg1.single, leg2.single);
    expect(h, isNot(a));
    if (leg2.single.afterExtraTime) {
      // Extra time only when the ninety had levelled it: the stored margin
      // differs from the level margin by what extra time or the kicks
      // added.
      expect(
        leg2.single.homeScore! - leg2.single.awayScore! !=
            TwoLegged.levelMargin(leg1.single),
        isTrue,
      );
    }

    // The intercontinental play-off holds each step's entrant.
    final icSides = {
      for (final p in IcPlayoffs.fromSlots(
        await comp.drawSlots(id, 0, CompetitionKind.worldCupPlayoff),
      ))
        ...IcPlayoffs.members(p),
    };
    final cafFinal = caf.singleWhere((f) => f.round == 'AFFINAL');
    int winner(Fixture f) =>
        f.homeScore! > f.awayScore! ? f.homeNationId : f.awayNationId;
    int loser(Fixture f) =>
        winner(f) == f.homeNationId ? f.awayNationId : f.homeNationId;
    expect(icSides, contains(winner(cafFinal)));
    expect(icSides, contains(TwoLegged.winner(leg1.single, leg2.single)));
    expect(icSides, contains(loser(ofc.single)));
    final named = {
      for (final s in await comp.drawSlots(
        id,
        0,
        CompetitionKind.worldCupFinals,
      ))
        if (s.nationId != null) s.nationId!,
    };
    expect(named, contains(winner(ofc.single)));
    // The draws are made after the last step day.
    final lastStep = all
        .map((f) => f.date)
        .reduce((x, y) => x.isAfter(y) ? x : y);
    final career = (await careers.byId(id))!;
    expect(career.inGameDate.isBefore(lastStep), isFalse);
    // A European manager is not walked through other continents' steps.
    expect(
      stepsSeenAt.where((t) => t.year == wcYear - 1 && t.month == 11),
      isEmpty,
    );
  }, timeout: const Timeout(Duration(minutes: 40)));
}
