@Tags(['slow'])
library;

import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_database.dart';

// A manager who only ever presses Advance (every match of his quick-simmed)
// still gets a transfer window for every calendar year he lives through.
// The window was written only when a match was PLAYED live, so a year whose
// first match of his was skipped, or that the world was simmed into, never
// got one: the clubs moved, and the news never said so.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('every year crossed by advancing has its transfer window', () async {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    final db = createTestDatabase();
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
    addTearDown(db.close);
    await c.read(seedLoaderProvider).ensureSeeded();
    final nation = nations.firstWhere((n) => n.code == 'POL');
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: nation.id, managerName: 'M', rngSeed: 515))
            .valueOrNull!;
    final season = c.read(seasonServiceProvider);
    var last = DateTime(1900);
    for (var i = 0; i < 600; i++) {
      await season.advance(career.id);
      final hub = await c.read(hubDataProvider(career.id).future);
      if (hub == null || hub.championNationId != null) break;
      if (!hub.career.inGameDate.isAfter(last)) break;
      last = hub.career.inGameDate;
    }
    final now = (await c.read(careerRepositoryProvider).byId(career.id))!;
    final windows = {
      for (final m
          in await c.read(competitionRepositoryProvider).messages(career.id))
        if (m.category == 'transfer') m.year,
    };
    final crossed = [
      for (
        var y = CareerService.cycleStart.year + 1;
        y <= now.inGameDate.year;
        y++
      )
        y,
    ];
    // A story's account of itself, read when it fails.
    // ignore: avoid_print
    print('years crossed $crossed, windows ${windows.toList()..sort()}');
    expect(crossed, isNotEmpty);
    expect(windows, containsAll(crossed));
  });
}
