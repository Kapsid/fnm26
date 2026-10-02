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

import '../../helpers/test_database.dart';

/// The African Finals Eight stays in November for an African manager whose
/// side has a bye on the cup's last group matchday.
///
/// North Africa plays groups of three, so one side in each sits out every
/// matchday. When the manager's did on the LAST one, `advance` jumped straight
/// to his next fixture in the spring, the groups finished inside that one
/// catch-up, and his quarter-final was drawn from a clock already in March.
void main() {
  test(
    "a bye on the last group matchday keeps the manager's Finals Eight in "
    'November',
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

      // Morocco, seed 12345: group N1 with Egypt and Mauritania, sitting out
      // the last matchday (12 October) — and strong enough to win the group,
      // which in the two-group North zone is a Finals Eight place.
      final morocco = nations.firstWhere((n) => n.code == 'MAR');
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(
                    nationId: morocco.id,
                    managerName: 'M',
                    rngSeed: 12345,
                  ))
              .valueOrNull!;
      final comp = container.read(competitionRepositoryProvider);
      final season = container.read(seasonServiceProvider);
      final year = CareerService.worldCupYear(0) - 2;

      final groups = await comp.fixturesByRound(
        career.id,
        'NGROUP',
        kind: CompetitionKind.nationsLeague,
        confederation: Confederation.africa,
      );
      final groupEnd = groups
          .map((f) => f.date)
          .reduce((a, b) => a.isAfter(b) ? a : b);
      final mine = groups.where(
        (f) => f.homeNationId == morocco.id || f.awayNationId == morocco.id,
      );
      expect(
        mine.every((f) => f.date.isBefore(groupEnd)),
        isTrue,
        reason: 'the scenario: Morocco sits out the last matchday',
      );

      var last = DateTime(1900);
      for (var i = 0; i < 400; i++) {
        final qf = await comp.fixturesByRound(
          career.id,
          'NQF',
          kind: CompetitionKind.nationsLeague,
          confederation: Confederation.africa,
        );
        if (qf.isNotEmpty) break;
        await season.advance(career.id);
        final hub = await container.read(hubDataProvider(career.id).future);
        final date = hub!.career.inGameDate;
        if (!date.isAfter(last) || date.year > year) break;
        last = date;
      }

      final qf = await comp.fixturesByRound(
        career.id,
        'NQF',
        kind: CompetitionKind.nationsLeague,
        confederation: Confederation.africa,
      );
      expect(qf, hasLength(4), reason: 'the Finals Eight was drawn');
      expect(
        qf.any(
          (f) => f.homeNationId == morocco.id || f.awayNationId == morocco.id,
        ),
        isTrue,
        reason: 'the scenario: Morocco won its group and plays a quarter-final',
      );
      for (final f in qf) {
        expect(f.date, DateTime(year, 11, 12), reason: 'never the spring');
      }
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
