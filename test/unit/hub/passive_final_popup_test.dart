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
import 'package:fnm/features/hub/round_popup.dart';

import '../../helpers/test_database.dart';

/// Following a tournament you're not in must end with the final.
///
/// The whole point of stepping round by round is to watch it decided — if the
/// last thing shown is the third-place play-off, the tournament just ends.
void main() {
  test(
    'the final is reported by the round popup, not skipped',
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
      // The weakest European nation won't qualify, so the finals are followed.
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

      final season = container.read(seasonServiceProvider);
      // Every stage the popup would have shown, in order.
      final stages = <String>[];
      var last = DateTime(1900);

      for (var i = 0; i < 400; i++) {
        await season.advance(career.id);
        container
          ..invalidate(hubDataProvider)
          ..invalidate(latestRoundPopupProvider);
        final popup = await container.read(
          latestRoundPopupProvider(career.id).future,
        );
        if (popup != null &&
            (stages.isEmpty ||
                stages.last != '${popup.competition}/${popup.stage}')) {
          stages.add('${popup.competition}/${popup.stage}');
        }
        final hub = await container.read(hubDataProvider(career.id).future);
        if (hub == null) break;
        if (hub.championNationId != null) break;
        if (!hub.career.inGameDate.isAfter(last)) break;
        last = hub.career.inGameDate;
      }

      // ignore: avoid_print
      print('POPUP STAGES: $stages');

      expect(
        stages.any((s) => s.startsWith('World Cup/')),
        isTrue,
        reason: 'the World Cup should have been followed',
      );
      expect(
        stages,
        contains('World Cup/Final'),
        reason: 'the final must be reported — it is the whole point',
      );
      // And it should be the last thing the tournament says.
      final wc = stages.where((s) => s.startsWith('World Cup/')).toList();
      expect(
        wc.last,
        'World Cup/Final',
        reason: 'the final is the last word, not the third-place play-off',
      );
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );
}
