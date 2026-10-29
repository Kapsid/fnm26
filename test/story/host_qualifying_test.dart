import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/tournaments/tournaments_providers.dart';

import 'driver.dart';

/// Playtest: "when I host a tournament, qualifying isn't played passively at
/// all". Every qualifier WAS simulated, but a host is in no draw, so the hub
/// never offered it the qualifying draw ceremony; the campaign's groups and
/// tables stayed behind "to be drawn" for its whole length, the tile read
/// "upcoming", and with nothing on the calendar the host was offered no
/// friendlies either, so one click carried it across the entire campaign.
void main() {
  const seed = 7;

  Future<T> read<T>(ProviderContainer c, AutoDisposeFutureProvider<T> p) async {
    final sub = c.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  test(
    'a World Championship host follows qualifying and fills its windows',
    () async {
      final wcYear = CareerService.worldCupYear(0);
      final hosts = WorldCupHosts.worldCupHostIds(
        year: wcYear,
        nations: storyNations,
        seed: seed,
      );
      final db = storyDb();
      final c = storyContainer(db);
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      // The manager's own nation hosts only through a bid under the current
      // rules: this is a world as an older save decided it.
      final d = await StoryDriver.start(
        c,
        seed,
        nationId: hosts.first,
        currentHostRules: false,
      );
      final careers = c.read(careerRepositoryProvider);
      final comp = c.read(competitionRepositoryProvider);
      var sawLiveTile = false;
      for (var steps = 0; steps < 3000; steps++) {
        final career = (await careers.byId(d.careerId))!;
        if (career.inGameDate.isAfter(DateTime(wcYear, 5, 31))) break;
        // Mid-campaign: the host can see it being played.
        if (career.inGameDate.year == wcYear - 1 &&
            career.inGameDate.month >= 7 &&
            !sawLiveTile) {
          expect(
            await comp.hasWatchedDraw(d.careerId, 0, worldCupQualDrawKind),
            isTrue,
            reason: 'qualifying groups hidden from the host',
          );
          final overview = await read(
            c,
            tournamentsOverviewProvider(d.careerId),
          );
          expect(overview!.statuses[null]!.phase, TournamentPhase.live);
          sawLiveTile = true;
        }
        await d.step();
      }
      expect(sawLiveTile, isTrue);

      // Every qualifying match was played.
      final quals = await (db.select(
        db.competitions,
      )..where((t) => t.careerId.equals(d.careerId))).get();
      final qualIds = {
        for (final q in quals)
          if (q.kind == CompetitionKind.worldCupQualifying) q.id,
      };
      expect(qualIds, hasLength(6));
      final fixtures = await (db.select(
        db.fixtures,
      )..where((t) => t.careerId.equals(d.careerId))).get();
      final qualFixtures = [
        for (final f in fixtures)
          if (qualIds.contains(f.competitionId)) f,
      ];
      expect(qualFixtures, isNotEmpty);
      expect(qualFixtures.every((f) => f.played), isTrue);

      // The finals field is the hosts plus sides that came through
      // qualifying, and no host was drawn into it.
      final qualified = {
        for (final t in await comp.allGroupTablesByConfederation(d.careerId))
          for (final s in t.standings) s.nationId,
      };
      expect(qualified.intersection(hosts), isEmpty);
      final field = {
        for (final t in await comp.finalsGroupTables(d.careerId))
          for (final s in t.standings) s.nationId,
      };
      expect(field, hasLength(48));
      expect(field.containsAll(hosts), isTrue);
      expect(qualified.containsAll(field.difference(hosts)), isTrue);

      // And the host played friendlies through the qualifying year.
      final career = (await careers.byId(d.careerId))!;
      final friendliesInQualifying = fixtures.where(
        (f) =>
            f.round == 'FRIENDLY' &&
            f.date.year == wcYear - 1 &&
            (f.homeNationId == career.nationId ||
                f.awayNationId == career.nationId),
      );
      expect(friendliesInQualifying, isNotEmpty);
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );

  test(
    'a continental host sees its qualifying and gets its first autumn',
    () async {
      final hosts = WorldCupHosts.continentalHostsFor(
        confederation: Confederation.europe,
        cycle: 0,
        seed: seed,
        nations: storyNations,
      );
      final contYear = CareerService.continentalFinalsYear(0);
      final db = storyDb();
      final c = storyContainer(db);
      addTearDown(() async {
        c.dispose();
        await db.close();
      });
      // The manager's own nation hosts only through a bid under the current
      // rules: this is a world as an older save decided it.
      final d = await StoryDriver.start(
        c,
        seed,
        nationId: hosts.first,
        currentHostRules: false,
      );
      final careers = c.read(careerRepositoryProvider);
      final comp = c.read(competitionRepositoryProvider);
      var checked = false;
      for (var steps = 0; steps < 3000; steps++) {
        final career = (await careers.byId(d.careerId))!;
        if (career.inGameDate.isAfter(DateTime(contYear, 5, 31))) break;
        if (!checked && career.inGameDate.year == contYear - 1) {
          expect(
            await comp.hasWatchedDraw(d.careerId, 0, continentalQualDrawKind),
            isTrue,
            reason: 'qualifying groups hidden from the host',
          );
          final overview = await read(
            c,
            tournamentsOverviewProvider(d.careerId),
          );
          expect(
            overview!.statuses[Confederation.europe]!.phase,
            TournamentPhase.live,
          );
          checked = true;
        }
        await d.step();
      }
      expect(checked, isTrue);
      expect(
        await comp.allPlayedForKind(
          d.careerId,
          CompetitionKind.continentalQualifying,
          confederation: Confederation.europe,
        ),
        isTrue,
      );
      // The first autumn of the cycle is no longer passed by on the way to
      // the 1 December vote: the friendlies are offered in time.
      final career = (await careers.byId(d.careerId))!;
      final mine = await comp.fixturesForNation(d.careerId, career.nationId);
      expect(
        mine.where(
          (f) => f.round == 'FRIENDLY' && f.date.isBefore(DateTime(2026, 12)),
        ),
        isNotEmpty,
      );
    },
    timeout: const Timeout(Duration(minutes: 20)),
  );
}
