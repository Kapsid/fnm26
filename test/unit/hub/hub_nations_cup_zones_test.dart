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
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';

import '../../helpers/test_database.dart';

/// The hub's group card must colour a Nations Cup group the way the Nations Cup
/// standings screen does: one green (the winner, who goes up / to the Finals
/// Four) and one red (the bottom side, relegated) — never two green.
void main() {
  test(
    'a Nations Cup group on the hub is 1 up, 1 down — never 2 up',
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
      final player = nations
          .where((n) => n.confederation == Confederation.europe)
          .reduce((a, b) => a.ranking <= b.ranking ? a : b);
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(
                    nationId: player.id,
                    managerName: 'M',
                  ))
              .valueOrNull!;

      // The hub shows whichever competition is live, so advance into the Nations
      // Cup's own window rather than reading at career start (when continental
      // qualifying owns the card).
      final season = container.read(seasonServiceProvider);
      var last = DateTime(1900);
      HubData? ncHub;
      for (var i = 0; i < 200; i++) {
        final hub = await container.read(hubDataProvider(career.id).future);
        if (hub == null) break;
        if (hub.group?.kind == CompetitionKind.nationsLeague) {
          ncHub = hub;
          break;
        }
        await season.advance(career.id);
        container.invalidate(hubDataProvider);
        final moved = await container.read(hubDataProvider(career.id).future);
        if (moved == null || !moved.career.inGameDate.isAfter(last)) break;
        last = moved.career.inGameDate;
      }

      expect(
        ncHub,
        isNotNull,
        reason: 'the Nations Cup should reach the hub during its own window',
      );
      expect(ncHub!.group!.competition, 'Nations Cup');

      // The card the user reported says NATIONS CUP, so these are its zones.
      expect(
        ncHub.groupDirectCount,
        1,
        reason: 'only the group winner goes up — never two',
      );
      expect(
        ncHub.groupRelegateCount,
        1,
        reason: "League A's bottom side is relegated, so one row is red",
      );
      expect(ncHub.groupContentionPos, isNull);

      // And the table stays hidden until the draw has actually been watched.
      expect(
        ncHub.groupDrawWatched,
        isFalse,
        reason: 'the groups must not be shown before the draw ceremony',
      );
      await container
          .read(competitionRepositoryProvider)
          .markDrawWatched(
            career.id,
            ncHub.career.cyclePointer,
            nationsCupDrawKind,
          );
      container.invalidate(hubDataProvider);
      final after = await container.read(hubDataProvider(career.id).future);
      expect(after!.groupDrawWatched, isTrue);
    },
    timeout: const Timeout(Duration(minutes: 5)),
  );
}
