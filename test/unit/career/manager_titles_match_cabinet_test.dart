import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/manager_history_providers.dart';

import '../../helpers/test_database.dart';

/// Italy's manager history read "1 title" beside a cabinet holding two (the
/// European Championship and the Continental Clash): the count added up the
/// cycles' World Championship and continental finishes, the cabinet read the
/// honours. Both now read the honours.
void main() {
  test('the titles count is the trophy cabinet, every shelf of it', () async {
    final db = createTestDatabase();
    addTearDown(db.close);
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
    await container.read(seedLoaderProvider).ensureSeeded();
    final italy = nations.firstWhere((n) => n.name == 'Italy');
    final colombia = nations.firstWhere((n) => n.name == 'Colombia');
    final spain = nations.firstWhere((n) => n.name == 'Spain');
    final career =
        (await container
                .read(careerServiceProvider)
                .create(nationId: italy.id, managerName: 'M'))
            .valueOrNull!;
    final comp = container.read(competitionRepositoryProvider);
    await comp.recordHonour(
      careerId: career.id,
      year: 2028,
      competition: ContinentalCups.byConfederation[Confederation.europe]!.name,
      championId: italy.id,
      runnerUpId: spain.id,
    );
    await comp.recordHonour(
      careerId: career.id,
      year: 2028,
      competition: 'Continental Clash',
      championId: italy.id,
      runnerUpId: colombia.id,
    );

    final h = (await container.read(
      managerHistoryProvider(career.id).future,
    ))!;
    expect(h.trophyCounts.values.fold<int>(0, (a, b) => a + b), 2);
    expect(h.titles, 2);
  });
}
