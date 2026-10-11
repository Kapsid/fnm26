import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/squad/training_camp_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import '../../helpers/test_database.dart';

const Set<HubEventKind> _ceremonies = {
  HubEventKind.budget,
  HubEventKind.managerSkills,
  HubEventKind.draw,
  HubEventKind.tournamentKickoff,
  HubEventKind.trainingCamp,
};

const List<String> _ceremonyKinds = [
  budgetSetupKind,
  skillsPromptKind,
  worldCupHostDrawKind,
  continentalHostDrawKind,
  worldCupQualDrawKind,
  continentalQualDrawKind,
  worldCupDrawKind,
  continentalFinalsDrawKind,
  nationsCupDrawKind,
  worldCupPlayoffKind,
  worldCupKickoffKind,
  continentalKickoffKind,
];

/// Three Nations Cups run side by side every cycle. Drive careers managed in
/// the two newly added confederations through two full cycles: the hub must
/// always have a next action, and each cycle must crown three distinct cups.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  for (final entry in [
    (Confederation.northAmerica, 12345),
    (Confederation.africa, 7),
  ]) {
    final conf = entry.$1;
    final seed = entry.$2;
    test(
      'a ${conf.name}-managed career: two cycles, three champions each',
      () async {
        final db = createTestDatabase();
        final nations =
            (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                    as List<dynamic>)
                .map((e) => Nation.fromJson(e as Map<String, Object?>))
                .toList();
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
                      rngSeed: seed,
                    ))
                .valueOrNull!;
        final season = container.read(seasonServiceProvider);
        final comp = container.read(competitionRepositoryProvider);

        const cycles = 2;
        final summary = <String>[];
        var last = DateTime(1900);
        var done = 0;
        for (var i = 0; i < 4000 && done < cycles; i++) {
          container
            ..invalidate(hubDataProvider)
            ..invalidate(nextEventProvider)
            ..invalidate(trainingCampPlanProvider);
          final hub = await container.read(hubDataProvider(career.id).future);
          if (hub == null) break;
          var event = await container.read(nextEventProvider(career.id).future);
          var guard = 0;
          while (_ceremonies.contains(event.kind) && guard++ < 60) {
            if (event.kind == HubEventKind.trainingCamp) {
              final plan = await container.read(
                trainingCampPlanProvider(career.id).future,
              );
              if (plan != null && plan.options.isNotEmpty) {
                await container
                    .read(trainingCampServiceProvider)
                    .choose(career.id, plan, plan.options.first);
              }
            } else {
              for (final kind in _ceremonyKinds) {
                await comp.markDrawWatched(
                  career.id,
                  hub.career.cyclePointer,
                  kind,
                );
              }
            }
            container
              ..invalidate(nextEventProvider)
              ..invalidate(trainingCampPlanProvider);
            event = await container.read(nextEventProvider(career.id).future);
          }
          final c0 = (await container
              .read(careerRepositoryProvider)
              .byId(career.id))!;
          if (event.kind == HubEventKind.cycleRollover) {
            final cycle = c0.cyclePointer;
            final year = CareerService.worldCupYear(cycle) - 2;
            final honours = [
              for (final h in await comp.honours(career.id))
                if (h.year == year && NationsCups.isNationsCup(h.competition))
                  h,
            ];
            expect(
              honours.map((h) => h.competition).toSet(),
              NationsCups.allNames.toSet(),
              reason: 'cycle $cycle: each cup crowns its own champion',
            );
            expect(honours.length, 3, reason: 'cycle $cycle: one per cup');
            expect(
              honours.map((h) => h.championId).toSet().length,
              3,
              reason: 'cycle $cycle: three distinct champions',
            );
            summary.add(
              'cycle $cycle: ${{for (final h in honours) h.competition: h.championId}}',
            );

            // The Finals Eight sits in November of its year.
            final qf = [
              for (final f in await comp.fixturesByRound(
                career.id,
                'NQF',
                kind: CompetitionKind.nationsLeague,
                confederation: Confederation.africa,
              ))
                if (f.date.year == year) f,
            ];
            expect(qf.length, 4, reason: 'cycle $cycle: Africa Finals Eight');
            final qfTeams = {
              for (final f in qf) ...[f.homeNationId, f.awayNationId],
            };
            if (!qfTeams.contains(player.id)) {
              expect(
                qf.first.date,
                DateTime(year, 11, 12),
                reason: 'cycle $cycle: Finals Eight date',
              );
            } else {
              expect(qf.first.date.month, greaterThanOrEqualTo(11));
            }

            done++;
            if (done >= cycles) break;
            await season.startNextCycle(career.id);
            final c1 = (await container
                .read(careerRepositoryProvider)
                .byId(career.id))!;
            expect(
              c1.cyclePointer,
              isNot(c0.cyclePointer),
              reason: 'the rollover must move the cycle on',
            );
            last = DateTime(1900);
            continue;
          }
          await season.advance(career.id);
          container.invalidate(hubDataProvider);
          final now = await container.read(hubDataProvider(career.id).future);
          if (now == null) break;
          expect(
            now.career.inGameDate.isAfter(last),
            isTrue,
            reason: 'stalled on ${event.kind} / ${event.label}',
          );
          last = now.career.inGameDate;
        }
        // ignore: avoid_print
        print('${conf.name}: ${summary.join(' | ')}');
        expect(done, cycles, reason: 'both cycles reached their rollover');
      },
      timeout: const Timeout(Duration(minutes: 10)),
    );
  }
}
