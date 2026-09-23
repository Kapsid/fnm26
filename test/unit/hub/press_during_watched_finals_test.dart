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
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import '../../helpers/test_database.dart';

/// The press do not stop a manager on his way into somebody else's final.
///
/// A tournament he is not in is one he steps through from the stands, round by
/// round — and between those rounds the conference kept opening, so he was
/// asked to face a room at a tournament he had not travelled to. His own
/// fixtures are what the room turns up for; the questions wait.
void main() {
  test('no press conference while a finals he is not in is being watched', () async {
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
    // The weakest European nation won't qualify, so the finals are watched
    // rather than played.
    final player = nations
        .where((n) => n.confederation == Confederation.europe)
        .reduce((a, b) => a.ranking >= b.ranking ? a : b);
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: player.id, managerName: 'M'))
            .valueOrNull!;

    final season = container.read(seasonServiceProvider);
    var watchedRounds = 0;
    var last = DateTime(1900);

    for (var i = 0; i < 400; i++) {
      await season.advance(career.id);
      container
        ..invalidate(hubDataProvider)
        ..invalidate(nextEventProvider);
      final hub = await container.read(hubDataProvider(career.id).future);
      if (hub == null) break;
      // The ceremonies — the budget, the skill points, every draw — are
      // one-shot steps this test has nothing to say about. Take them, so what
      // is really next comes through.
      var event = await container.read(nextEventProvider(career.id).future);
      var guard = 0;
      while (_ceremonies.contains(event.kind) && guard++ < 40) {
        for (final kind in _ceremonyKinds) {
          await container
              .read(competitionRepositoryProvider)
              .markDrawWatched(career.id, hub.career.cyclePointer, kind);
        }
        container.invalidate(nextEventProvider);
        event = await container.read(nextEventProvider(career.id).future);
      }
      if (event.kind == HubEventKind.watchTournament) watchedRounds++;
      if (event.kind == HubEventKind.press) {
        // A conference is fine — but not while a tournament is waiting to be
        // watched, which is exactly the moment it used to turn up.
        final stillToWatch = await container
            .read(competitionRepositoryProvider)
            .earliestUnplayedFinalsDate(
              career.id,
              playerConfederation: player.confederation,
            );
        expect(
          stillToWatch,
          isNull,
          reason:
              'the press stopped the manager between rounds of a tournament '
              'he was only watching',
        );
      }
      if (hub.championNationId != null) break;
      if (!hub.career.inGameDate.isAfter(last)) break;
      last = hub.career.inGameDate;
    }

    expect(
      watchedRounds,
      greaterThan(0),
      reason: 'the save must actually reach a tournament he only watches',
    );
  }, timeout: const Timeout(Duration(minutes: 6)));
}

/// The one-shot steps a cycle forces on the manager, and the keys that record
/// them as taken.
const Set<HubEventKind> _ceremonies = {
  HubEventKind.budget,
  HubEventKind.managerSkills,
  HubEventKind.draw,
  HubEventKind.tournamentKickoff,
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
