import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

import '../../helpers/test_database.dart';

/// Every confederation's Nations Cup progresses on its own and crowns its own
/// champion: with three cups of the same competition kind in one cycle, an
/// unscoped lookup used to advance an arbitrary one and leave the rest
/// unfinished (or mix two ladders' Finals Fours).
void main() {
  for (final conf in [Confederation.europe, Confederation.africa]) {
    test(
      'a ${conf.name}-managed cycle crowns three Nations Cup champions',
      () async {
        final db = createTestDatabase();
        final nations =
            (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                    as List<dynamic>)
                .map((e) => Nation.fromJson(e as Map<String, Object?>))
                .toList();
        final byId = {for (final n in nations) n.id: n};
        final container = ProviderContainer(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            premiumUnlockedProvider.overrideWith((ref) => true),
            seedSourceProvider.overrideWithValue(
              InMemorySeedSource(nationList: nations, playerList: const []),
            ),
          ],
        );
        addTearDown(container.dispose);
        addTearDown(db.close);
        await container.read(seedLoaderProvider).ensureSeeded();

        final player = nations
            .where((n) => n.confederation == conf)
            .reduce((a, b) => a.ranking <= b.ranking ? a : b);
        final career =
            (await container
                    .read(careerServiceProvider)
                    .create(
                      nationId: player.id,
                      managerName: 'M',
                      rngSeed: 12345,
                    ))
                .valueOrNull!;
        final comp = container.read(competitionRepositoryProvider);
        final season = container.read(seasonServiceProvider);
        final year = CareerService.worldCupYear(0) - 2;

        Future<Set<String>> crowned() async => {
          for (final h in await comp.honours(career.id))
            if (h.year == year && NationsCups.isNationsCup(h.competition))
              h.competition,
        };

        var last = DateTime(1900);
        for (var i = 0; i < 400; i++) {
          if ((await crowned()).length == 3) break;
          await season.advance(career.id);
          final hub = await container.read(hubDataProvider(career.id).future);
          final date = hub!.career.inGameDate;
          if (!date.isAfter(last)) break;
          if (date.year > year + 1) break;
          last = date;
        }

        final honours = [
          for (final h in await comp.honours(career.id))
            if (h.year == year && NationsCups.isNationsCup(h.competition)) h,
        ];
        expect(
          honours.map((h) => h.competition).toSet(),
          NationsCups.allNames.toSet(),
          reason: 'each cup crowns its own champion',
        );
        expect(honours.length, 3, reason: 'one honour per cup, no doubles');
        for (final h in honours) {
          final cupConf = NationsCups.confederations.firstWhere(
            (c) => NationsCups.forConfederation(c)!.name == h.competition,
          );
          expect(byId[h.championId]!.confederation, cupConf);
          expect(byId[h.runnerUpId]!.confederation, cupConf);
        }

        // Each ladder's Finals Four holds only its own confederation's nations.
        for (final c in [Confederation.europe, Confederation.northAmerica]) {
          final finals = [
            for (final r in ['NSF', 'NFINAL'])
              ...await comp.fixturesByRound(
                career.id,
                r,
                kind: CompetitionKind.nationsLeague,
                confederation: c,
              ),
          ];
          expect(finals, isNotEmpty, reason: '${c.name} has a final');
          for (final f in finals) {
            expect(byId[f.homeNationId]!.confederation, c);
            expect(byId[f.awayNationId]!.confederation, c);
          }
          expect(
            await comp.fixturesByRound(
              career.id,
              'NQF',
              kind: CompetitionKind.nationsLeague,
              confederation: c,
            ),
            isEmpty,
          );
        }

        // Africa: a Round of 16 of every group winner and the two best
        // runners-up, then the last eight.
        Future<List<Fixture>> africa(String r) => comp.fixturesByRound(
          career.id,
          r,
          kind: CompetitionKind.nationsLeague,
          confederation: Confederation.africa,
        );
        final r16 = await africa('NR16');
        final qf = await africa('NQF');
        final sf = await africa('NSF');
        final fin = await africa('NFINAL');
        expect(r16.length, 8);
        expect(qf.length, 4);
        expect(sf.length, 2);
        expect(fin.length, 1);

        final tables = await comp.tournamentGroupTables(
          career.id,
          CompetitionKind.nationsLeague,
          confederation: Confederation.africa,
        );
        expect(tables, hasLength(14));
        final groupWinners = {
          for (final t in tables) t.standings.first.nationId,
        };
        final r16Teams = {
          for (final f in r16) ...[f.homeNationId, f.awayNationId],
        };
        expect(r16Teams, hasLength(16));
        expect(r16Teams.containsAll(groupWinners), isTrue);
        final field = NationsCups.knockoutField(
          [for (final t in tables) t.standings],
          (id) => byId[id]!.ranking,
        );
        // The two best runners-up, exactly as the screen ranks them.
        final runnersUpIn = r16Teams.difference(groupWinners);
        expect(runnersUpIn, {
          for (final s in field.runnersUp.take(2)) s.nationId,
        });
        final qfTeams = {
          for (final f in qf) ...[f.homeNationId, f.awayNationId],
        };

        // The same rule the progression uses to advance a tie.
        int winner(Fixture f) =>
            f.homeScore! >= f.awayScore! ? f.homeNationId : f.awayNationId;

        expect(qfTeams, {for (final f in r16) winner(f)});
        final qfWinners = {for (final f in qf) winner(f)};
        final sfTeams = {
          for (final f in sf) ...[f.homeNationId, f.awayNationId],
        };
        expect(sfTeams, qfWinners);
        final sfWinners = {for (final f in sf) winner(f)};
        expect({fin.first.homeNationId, fin.first.awayNationId}, sfWinners);
        final africaHonour = honours.firstWhere(
          (h) => h.competition == NationsCups.africa,
        );
        expect(africaHonour.championId, winner(fin.first));
        // The knockouts keep their November dates. Only a tie the manager
        // plays may move later: a side with a bye on the last group matchday
        // is already past November when its group is settled, and its own
        // tie must still lie ahead of it.
        final groupEnd = (await africa(
          'NGROUP',
        )).map((f) => f.date).reduce((a, b) => a.isAfter(b) ? a : b);
        if (r16Teams.contains(player.id)) {
          expect(r16.first.date.isAfter(groupEnd), isTrue);
        } else {
          expect(r16.first.date, DateTime(year, 11, 9));
          expect(qf.first.date, DateTime(year, 11, 12));
        }
        expect(qf.first.date.isAfter(r16.first.date), isTrue);
        expect(fin.first.date.isAfter(sf.first.date), isTrue);
        expect(sf.first.date.isAfter(qf.first.date), isTrue);
      },
      timeout: const Timeout(Duration(minutes: 8)),
    );
  }
}
