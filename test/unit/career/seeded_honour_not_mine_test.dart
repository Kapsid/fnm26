import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/competition/real_history.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/press/press.dart';
import 'package:fnm/features/achievements/achievement_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_summary_providers.dart';
import 'package:fnm/features/manager/manager_providers.dart';
import 'package:fnm/features/press/press_providers.dart';

import '../../helpers/test_database.dart';

/// The roll of honour is seeded with the real world's, and that history now
/// runs to the 2026 World Championship — the same calendar year a save opens
/// in, on 1 July, after that tournament has been decided. Every screen that
/// asked "is this honour mine?" with `year >= cycleStart.year` therefore handed
/// the 2026 champion's new manager a World Championship before a ball was
/// kicked.
void main() {
  late List<Nation> nations;
  late List<Player> players;
  // The seeded champion, read from the history itself: a change to the seeded
  // result must move this test with it rather than quietly voiding it.
  late String championName;

  setUpAll(() {
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    final seeded = RealHistory.editions
        .where(
          (e) =>
              e.competition == RealHistory.worldChampionship &&
              e.year == CareerService.cycleStart.year,
        )
        .toList();
    expect(
      seeded,
      hasLength(1),
      reason:
          'the history is expected to carry exactly one World Championship '
          'for the year a save opens in',
    );
    championName = seeded.single.champion;
  });

  test(
    "the seeded champion's new manager holds no trophies on day one",
    () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      final container = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: players),
          ),
        ],
      );
      addTearDown(container.dispose);
      await container.read(seedLoaderProvider).ensureSeeded();

      final nation = nations.firstWhere(
        (n) => (n.englishName.isEmpty ? n.name : n.englishName) == championName,
      );
      final career =
          (await container
                  .read(careerServiceProvider)
                  .create(nationId: nation.id, managerName: 'M'))
              .valueOrNull!;

      // The career summary's trophy cabinet is empty.
      final summary = await container.read(
        careerSummaryProvider(career.id).future,
      );
      expect(
        summary!.titles,
        isEmpty,
        reason:
            'the trophy cabinet listed ${summary.titles.map((t) => t.competition)}'
            ' before the manager had played a match',
      );

      // The World Championship achievement is not unlocked.
      final views = await container.read(
        achievementsViewProvider(career.id).future,
      );
      final wc = views.firstWhere((v) => v.def.id == 'title_wc');
      expect(
        wc.earned,
        isFalse,
        reason: 'a seeded title unlocked the platinum achievement',
      );

      // The manager page hands out no skill points: no cycle completed and no
      // trophy won means nothing earned yet.
      final view = await container.read(managerViewProvider(career.id).future);
      expect(
        view!.pointsEarned,
        0,
        reason: 'a seeded title paid out manager skill points',
      );

      // And the press room does not congratulate him on it.
      final question = await container.read(
        pressQuestionProvider(career.id).future,
      );
      expect(
        question?.topic,
        isNot(PressTopic.triumph),
        reason: 'the manager was asked about a triumph that predates his job',
      );
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );
}
