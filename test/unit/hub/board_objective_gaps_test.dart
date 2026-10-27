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

const int _montenegro = 35;

/// b8 item 4: a Montenegro career had three board objectives in its first
/// cycle and one in its second.
///
/// The second cycle follows the 1.0.6 rules, under which a side outside the
/// top three-fifths of its confederation (Montenegro is 37th of Europe's 53)
/// gets no World Championship or continental brief and is judged on its
/// results. A first cycle opened by 1.0.5 or earlier (no brief-rules mark)
/// keeps the old briefs, which asked everyone for something, until it ends.
/// Both are by design; what was broken is that the board screen simply left
/// the two competitions out. They now come back as "no target set" rows.
void main() {
  late ProviderContainer c;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final db = createTestDatabase();
    addTearDown(db.close);
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        // Past the free cycle: a save there is only opened with Pro.
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
  });

  Future<T> read<T>(AutoDisposeFutureProvider<T> p) async {
    c
      ..invalidate(cycleObjectiveOutcomesProvider)
      ..invalidate(cycleObjectiveGapsProvider);
    final sub = c.listen(p.future, (_, _) {});
    try {
      return await sub.read();
    } finally {
      sub.close();
    }
  }

  test('Montenegro in cycle 2: one brief, and the other two said', () async {
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: _montenegro, managerName: 'M'))
            .valueOrNull!;
    final repo = c.read(careerRepositoryProvider);
    final comp = c.read(competitionRepositoryProvider);

    // Cycle 2 (pointer 1), opened without the rules mark, as a cycle a 1.0.5
    // build opened: the old briefs, all three of them.
    await repo.advanceCycle(career.id, 1, DateTime(2030, 9));
    await repo.recordStint(career.id, 1, _montenegro);
    // Every finals competition of the cycle has a row: an objective, or a gap
    // that says why there is none. The Nations Cup has a row only while its
    // league holds the nation (a brief) or its draw is still to come.
    Future<Map<TournamentTier, Object>> rows() async {
      final outcomes = await read(cycleObjectiveOutcomesProvider(career.id));
      final gaps = await read(cycleObjectiveGapsProvider(career.id));
      return {
        for (final o in outcomes) o.tier: 'brief',
        for (final g in gaps) g.tier: g.reason,
      };
    }

    final old = await rows();
    expect(old[TournamentTier.continental], 'brief');
    expect(old[TournamentTier.world], 'brief');

    // The same cycle opened by this version, as the rollover marks it.
    await comp.markDrawWatched(career.id, 1, briefRulesV2Kind);
    await comp.markDrawWatched(career.id, 1, briefRulesV3Kind);
    final now = await rows();
    expect(now[TournamentTier.continental], ObjectiveGapReason.noBrief);
    expect(now[TournamentTier.world], ObjectiveGapReason.noBrief);
    expect(now[TournamentTier.nationsCup], old[TournamentTier.nationsCup]);
    // LOW-1: a cycle with no Nations Cup league of its own (this bare world
    // opened cycle 2 without building one) gets no "after the draw" row: no
    // draw is coming to set a target.
    final cupThisCycle = await comp.hasTournament(
      career.id,
      CompetitionKind.nationsLeague,
      confederation: Confederation.europe,
    );
    if (!cupThisCycle) {
      expect(now.containsKey(TournamentTier.nationsCup), isFalse);
    }
    final gaps = await read(cycleObjectiveGapsProvider(career.id));
    expect(
      gaps.firstWhere((g) => g.tier == TournamentTier.continental).competition,
      'European Championship',
    );
    expect(
      gaps.firstWhere((g) => g.tier == TournamentTier.world).competition,
      'World Championship',
    );
  });

  test('a side with both finals briefs has no no-target rows', () async {
    // England: briefs at the World Championship and the Euros.
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: 14, managerName: 'M'))
            .valueOrNull!;
    final briefs = await read(cycleObjectivesProvider(career.id));
    expect(
      {for (final o in briefs) o.tier},
      containsAll([TournamentTier.continental, TournamentTier.world]),
    );
    final gaps = await read(cycleObjectiveGapsProvider(career.id));
    expect(gaps.where((g) => g.reason == ObjectiveGapReason.noBrief), isEmpty);
    // LOW-2: the Nations Cup league exists from the cycle's first day, with
    // nothing played. Its brief claims no place yet, so the board screen
    // says "still to be decided" rather than "So far: top half".
    final nc = briefs.singleWhere((o) => o.tier == TournamentTier.nationsCup);
    expect(nc.decided, isFalse);
    expect(nc.actual, lessThan(2));
  });
}
