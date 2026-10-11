import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/budget_setup_screen.dart';
import 'package:fnm/features/hub/hub_event.dart';
import 'package:fnm/features/settings/settings_providers.dart';
import 'package:fnm/features/tournaments/finals_draw_providers.dart';
import 'package:fnm/features/tournaments/host_draw_providers.dart';
import 'package:fnm/features/tournaments/nations_cup_draw_providers.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';

import '../../helpers/test_database.dart';

/// The hub's "play the next {cup} match" names the continental championship in
/// the manager's language. It used to pass the stored English name straight
/// through, so a Czech save read "Odehrát další zápas: European Championship".
void main() {
  test(
    'the watch-your-continental-finals event names the cup in Czech',
    () async {
      final nations =
          (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                  as List<dynamic>)
              .map((e) => Nation.fromJson(e as Map<String, Object?>))
              .toList();
      final byCode = {for (final n in nations) n.code: n};
      final db = createTestDatabase();
      final cs = AppLocalizationsCs();
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          appLocalizationsProvider.overrideWithValue(cs),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: const []),
          ),
        ],
      );
      addTearDown(c.dispose);
      addTearDown(db.close);
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: byCode['GER']!.id,
                    managerName: 'M',
                    rngSeed: 7,
                  ))
              .valueOrNull!;
      final comp = c.read(competitionRepositoryProvider);
      await comp.markDrawWatched(career.id, 0, budgetSetupKind);
      await comp.markDrawWatched(career.id, 0, skillsPromptKind);

      // Europe's championship under way without Germany, due before its next
      // fixture.
      final next = await comp.nextFixtureForNation(career.id, career.nationId);
      await db
          .into(db.competitions)
          .insert(
            CompetitionsCompanion.insert(
              careerId: career.id,
              name: 'European Championship',
              kind: const Value(CompetitionKind.continentalFinals),
              confederation: Confederation.europe,
              cycle: const Value(0),
            ),
          );
      await comp.addKnockoutFixtures(
        careerId: career.id,
        round: 'CQF',
        kind: CompetitionKind.continentalFinals,
        confederation: Confederation.europe,
        pairings: [
          for (final p in [
            ('FRA', 'ESP'),
            ('ENG', 'ITA'),
            ('NED', 'POR'),
            ('BEL', 'CRO'),
          ])
            (byCode[p.$1]!.id, byCode[p.$2]!.id),
        ],
        date: next!.date.subtract(const Duration(days: 1)),
      );
      for (final k in [
        worldCupHostDrawKind,
        continentalHostDrawKind,
        worldCupQualDrawKind,
        continentalQualDrawKind,
        worldCupDrawKind,
        continentalFinalsDrawKind,
        nationsCupDrawKind,
        worldCupPlayoffKind,
        continentalKickoffKind,
      ]) {
        await comp.markDrawWatched(career.id, 0, k);
      }

      final event = await c.read(nextEventProvider(career.id).future);
      expect(
        event.kind,
        HubEventKind.watchTournament,
        reason: "${event.label} ${event.route}",
      );
      expect(event.label, cs.hubEventPlayCupMatch(cs.compEuropeanChampionship));
      expect(event.label, isNot(contains('European Championship')));
    },
  );
}
