import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// Saves carried over from 1.0.5 must keep working: briefs are derived, not
/// stored, so retuning the rules would rewrite a cycle's brief mid-cycle,
/// even one already announced as met. A cycle opened before the retune keeps
/// its old briefs until it ends; the next one, opened by this version, follows
/// the new rules.
void main() {
  test('a cycle opened before 1.0.6 keeps the briefs it opened with', () async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    // Europe's 20th: inside the world's top fifty, outside Europe's sixteen
    // World Championship places. 1.0.5 told it to qualify; 1.0.6 asks for the
    // top half of its qualifying group.
    final europe =
        nations.where((n) => n.confederation == Confederation.europe).toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    final nation = europe[19];
    expect(nation.ranking, lessThanOrEqualTo(50));
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nation.id, managerName: 'M'))
            .valueOrNull!;

    Future<int> worldTarget() async {
      c.invalidate(cycleObjectiveOutcomesProvider);
      return (await c.read(
        cycleObjectiveOutcomesProvider(career.id).future,
      )).singleWhere((o) => o.tier == TournamentTier.world).target;
    }

    // A new save: the current rules.
    expect(await worldTarget(), 1);

    // A cycle the previous version opened (no mark on it): its brief as it was.
    final repo = c.read(careerRepositoryProvider);
    await repo.advanceCycle(career.id, 1, DateTime(2030, 9));
    await repo.recordStint(career.id, 1, nation.id);
    expect(await worldTarget(), 2);
  });
}
