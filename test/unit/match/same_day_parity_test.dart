import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/same_day_results.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// The Summary's other matches of the day are the results the save stores.
///
/// They are played before the world gets to them, by the very function the
/// commit's catch-up stores them with ([SeasonService.sameDayResults]); this
/// plays a run of the manager's matches and checks, for each, that what was
/// shown before the commit (full time, half time, extra time, penalties) is
/// what the save holds after it. And that showing them changed nothing: the
/// same world played without ever asking holds the very same results.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  late List<Nation> nations;
  late List<Player> players;

  setUpAll(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
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
  });

  Future<(ProviderContainer, int)> open() async {
    final db = createTestDatabase();
    addTearDown(db.close);
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: nations.first.id,
                  managerName: 'M',
                  rngSeed: 20260922,
                ))
            .valueOrNull!;
    return (c, career.id);
  }

  /// Plays the manager's next [matches] matches as the match screen
  /// commits them, asking for the day's other results before each commit
  /// when [ask] is set. Returns what was shown, by fixture id.
  Future<Map<int, SameDayResult>> play(
    ProviderContainer c,
    int careerId, {
    required int matches,
    required bool ask,
  }) async {
    final shown = <int, SameDayResult>{};
    final held = c.listen(matchPreviewProvider(careerId), (_, _) {});
    addTearDown(held.close);
    final season = c.read(seasonServiceProvider);
    for (var i = 0; i < matches; i++) {
      final preview = await c.read(matchPreviewProvider(careerId).future);
      if (preview == null) break;
      if (ask) {
        for (final s in await season.sameDayResults(
          careerId,
          preview.fixture,
        )) {
          shown[s.fixture.id] = s;
        }
      }
      await season.playPlayerMatch(careerId, preview.fixture, preview.result);
    }
    return shown;
  }

  test(
    'shown before the commit == stored after it; asking moves nothing',
    () async {
      final (c, careerId) = await open();
      final comp = c.read(competitionRepositoryProvider);
      final shown = await play(c, careerId, matches: 6, ask: true);
      expect(
        shown,
        isNotEmpty,
        reason: 'the run must reach a group or round with other matches',
      );
      final stored = {
        for (final f in await comp.allFixtures(careerId)) f.id: f,
      };
      var halfTimeGoals = 0;
      for (final s in shown.values) {
        final f = stored[s.fixture.id]!;
        expect(f.hasResult, isTrue);
        expect(
          (
            f.homeScore,
            f.awayScore,
            f.afterExtraTime,
            f.homePenalties,
            f.awayPenalties,
          ),
          (
            s.fixture.homeScore,
            s.fixture.awayScore,
            s.fixture.afterExtraTime,
            s.fixture.homePenalties,
            s.fixture.awayPenalties,
          ),
          reason: 'fixture ${f.id}',
        );
        // Half time read back off the stored goals is the one shown.
        final back = SameDayResult.of(
          f,
          (await comp.goalTimeline(careerId, fixtureId: f.id))[f.id] ??
              const [],
        );
        expect(
          (back.homeHalfTime, back.awayHalfTime),
          (s.homeHalfTime, s.awayHalfTime),
          reason: 'fixture ${f.id} at half time',
        );
        halfTimeGoals += s.homeHalfTime + s.awayHalfTime;
      }
      expect(halfTimeGoals, greaterThan(0), reason: 'a real half-time check');

      // The same world, played without ever asking.
      final (c2, careerId2) = await open();
      await play(c2, careerId2, matches: 6, ask: false);
      final again = {
        for (final f
            in await c2
                .read(competitionRepositoryProvider)
                .allFixtures(careerId2))
          f.id: f,
      };
      expect(again.length, stored.length);
      Object? result(Fixture f) => f.hasResult
          ? (
              f.homeScore,
              f.awayScore,
              f.afterExtraTime,
              f.homePenalties,
              f.awayPenalties,
            )
          : null;
      for (final f in stored.values) {
        expect(result(again[f.id]!), result(f), reason: 'fixture ${f.id}');
      }
    },
    timeout: const Timeout(Duration(minutes: 6)),
  );

  test('asking writes nothing', () async {
    final (c, careerId) = await open();
    final comp = c.read(competitionRepositoryProvider);
    final held = c.listen(matchPreviewProvider(careerId), (_, _) {});
    addTearDown(held.close);
    final season = c.read(seasonServiceProvider);
    // Into the first match with other matches that day.
    for (var i = 0; i < 6; i++) {
      final preview = (await c.read(matchPreviewProvider(careerId).future))!;
      final before = await comp.allFixtures(careerId);
      final goals = await comp.goalTimeline(careerId);
      final shown = await season.sameDayResults(careerId, preview.fixture);
      expect(await comp.allFixtures(careerId), before);
      expect(
        (await comp.goalTimeline(careerId)).length,
        goals.length,
      );
      if (shown.isNotEmpty) {
        for (final s in shown) {
          expect(
            before.firstWhere((f) => f.id == s.fixture.id).hasResult,
            isFalse,
            reason: 'still to be played: the case worth checking',
          );
        }
        return;
      }
      await season.playPlayerMatch(careerId, preview.fixture, preview.result);
    }
    fail('no match with other matches that day');
  }, timeout: const Timeout(Duration(minutes: 4)));
}
