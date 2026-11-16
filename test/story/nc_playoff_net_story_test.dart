import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/calendar2.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart' show ncPlayoffNetKind;
import 'package:fnm/features/tournaments/euro_playoff_providers.dart';

import 'driver.dart';

/// The Nations Cup's way into the play-offs, told and shown (calendar2).
///
/// A European side is played through a cycle to the World Championship's
/// play-off draw. Each European Nations Cup league phase, once played out,
/// is checked once: the side hears it holds a play-off place exactly when
/// the tables then put it on course for one (the first edition's for the
/// EURO, the second's for the World Championship). The second edition's
/// tables mark a pot 4's worth of sides (never a host), and once the paths
/// are drawn the marks are the drawn pot 4.
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  const europe = Confederation.europe;

  test('a Nations Cup play-off place is told and marked', () async {
    final db = storyDb();
    final c = storyContainer(db);
    addTearDown(c.dispose);
    final europeans = [
      for (final n in storyNations)
        if (n.confederation == europe) n,
    ]..sort((a, b) => a.ranking.compareTo(b.ranking));
    final me = europeans[24].id;
    final d = await StoryDriver.start(c, 33, nationId: me);
    final id = d.careerId;
    final comp = c.read(competitionRepositoryProvider);
    final careers = c.read(careerRepositoryProvider);
    final nations = {
      for (final n in await c.read(nationRepositoryProvider).forCareer(id))
        n.id: n,
    };
    final seed = (await careers.byId(id))!.rngSeed;
    Future<Set<int>> marks(int edition) => edition == Calendar2.firstEdition
        ? euroPlayoffMarks(
            comp,
            careerId: id,
            cycle: 0,
            rngSeed: seed,
            nations: nations,
          )
        : wcPlayoffMarks(
            comp,
            careerId: id,
            cycle: 0,
            rngSeed: seed,
            nations: nations,
          );
    Future<bool> checked(int edition) =>
        comp.hasWatchedDraw(id, 0, '$ncPlayoffNetKind:$edition');
    Future<bool> wcDrawn() async => (await comp.drawSlots(
      id,
      0,
      CompetitionKind.worldCupPlayoffEurope,
      confederation: europe,
    )).isNotEmpty;

    final told = <int, bool>{};
    var steps = 0;
    while (!await wcDrawn()) {
      if (++steps > 6000) fail('no World Championship play-off draw');
      await d.step(stopAtRollover: true);
      for (final edition in const [
        Calendar2.firstEdition,
        Calendar2.secondEdition,
      ]) {
        if (told.containsKey(edition) || !await checked(edition)) continue;
        // The step that played the league phase out checked it: the news
        // follows the marks of that day.
        final on = (await marks(edition)).contains(me);
        final keys = await comp.messageKeys(id);
        told[edition] = keys.contains('ncnet:0:$edition');
        expect(told[edition], on, reason: 'edition $edition');
        if (edition == Calendar2.secondEdition) {
          final m = await marks(edition);
          expect(m.length, inInclusiveRange(1, 4));
          final hosts = WorldCupHosts.hostsFor(
            year: CareerService.worldCupYear(0),
            nations: nations.values.toList(),
            seed: seed,
          );
          expect(m.intersection(hosts.toSet()), isEmpty);
          for (final n in m) {
            expect(nations[n]!.confederation, europe);
          }
        }
      }
    }
    expect(told, hasLength(2), reason: 'both editions checked');
    // At least the EURO's: this side went through a path (see
    // euro_playoffs_story_test).
    expect(told[Calendar2.firstEdition], isTrue);

    // Once drawn, the marks are the paths' pot 4.
    final drawn = EuroPlayoffs.fromSlots(
      await comp.drawSlots(
        id,
        0,
        CompetitionKind.worldCupPlayoffEurope,
        confederation: europe,
      ),
    );
    expect(await marks(Calendar2.secondEdition), {
      for (final p in drawn) p.seeds[3],
    });
  }, timeout: const Timeout(Duration(minutes: 30)));
}
