import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';

import '../../helpers/test_database.dart';

/// A manager whose nation misses the continental championship must still be
/// able to watch its draw.
///
/// Watching is the ONLY thing that reveals the finals groups, and the event
/// used to require a fixture in the group stage — so a non-qualifier's group
/// tab stayed locked behind "watch the finals draw from the hub" forever, and
/// the tournament appeared to have no group stage at all, only knockouts.
void main() {
  // continentalDetailProvider loads city data from rootBundle.
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'a non-qualifier is still offered their continent\'s finals draw',
    () async {
      final db = createTestDatabase();
      final nations =
          (jsonDecode(
                    File('assets/data/nations.json').readAsStringSync(),
                  )
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
      // The weakest European nation: it won't reach the Euro finals.
      final player = nations
          .where((n) => n.confederation == Confederation.europe)
          .reduce((a, b) => a.ranking >= b.ranking ? a : b);
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(
                    nationId: player.id,
                    managerName: 'M',
                  ))
              .valueOrNull!;

      final comp = container.read(competitionRepositoryProvider);
      final season = container.read(seasonServiceProvider);

      // Advance until the continental finals have been drawn.
      var last = DateTime(1900);
      var drawn = false;
      for (var i = 0; i < 120; i++) {
        // THIS nation's cup. Every confederation's championship is drawn for the
        // cycle now, so an unqualified check is true from the first day and this
        // loop would never advance the save at all.
        if (await comp.hasTournament(
          career.id,
          CompetitionKind.continentalFinals,
          confederation: player.confederation,
        )) {
          drawn = true;
          break;
        }
        await season.advance(career.id);
        final hub = await container.read(hubDataProvider(career.id).future);
        if (hub == null) break;
        if (!hub.career.inGameDate.isAfter(last)) break;
        last = hub.career.inGameDate;
      }
      expect(drawn, isTrue, reason: 'the continental finals should be drawn');

      // The player is NOT in the finals — that's the case this is about.
      final ownFinalsGames =
          (await comp.fixturesByRound(
                career.id,
                'CGROUP',
                kind: CompetitionKind.continentalFinals,
              ))
              .where(
                (f) =>
                    f.homeNationId == player.id || f.awayNationId == player.id,
              )
              .toList();
      expect(ownFinalsGames, isEmpty, reason: 'this nation did not qualify');

      // The finals groups exist and are real — the tournament is not "knockouts
      // only", whatever the screen used to imply.
      final allFinalsGames = await comp.fixturesByRound(
        career.id,
        'CGROUP',
        kind: CompetitionKind.continentalFinals,
      );
      expect(allFinalsGames, isNotEmpty, reason: 'a group stage was generated');

      // The budget is the forced first event of the cycle; set it so the flow
      // moves on to the draw this test is about.
      await comp.markDrawWatched(
        career.id,
        career.cyclePointer,
        budgetSetupKind,
      );

      // The draw is offered anyway.
      final event = await container.read(nextEventProvider(career.id).future);
      expect(
        event.kind,
        HubEventKind.draw,
        reason: 'a non-qualifier must still be offered the draw',
      );
      expect(event.label, 'Watch the finals draw');

      // And watching it unlocks the groups tab.
      await comp.markDrawWatched(
        career.id,
        career.cyclePointer,
        continentalFinalsDrawKind,
      );
      container.invalidate(continentalDetailProvider);
      final view = await container.read(
        continentalDetailProvider((
          careerId: career.id,
          confederation: Confederation.europe,
        )).future,
      );
      expect(view!.finalsDrawWatched, isTrue);
      expect(view.groups, isNotEmpty, reason: 'the group tables are revealed');
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
