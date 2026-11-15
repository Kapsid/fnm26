import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../../helpers/calendar2_draws.dart';
import '../../helpers/test_database.dart';

/// A new career's qualifying and Nations Cup groups never send a side home
/// (or away) three times running (a player saw three home qualifiers in a
/// row).
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('no side plays three home or three away group games running', () async {
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final AppDatabase db = createTestDatabase();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: const []),
        ),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    await c.read(seedLoaderProvider).ensureSeeded();
    final career =
        (await c
                .read(careerServiceProvider)
                .create(nationId: 18, managerName: 'M', rngSeed: 5))
            .valueOrNull!;
    await drawEuroQualifyingNow(c, career.id);
    await drawSecondNationsCupNow(c, career.id);
    await drawWcQualifyingNow(c, career.id);
    final fixtures = await c
        .read(competitionRepositoryProvider)
        .allFixtures(career.id);
    final byGroup = <int, List<dynamic>>{};
    for (final f in fixtures) {
      // Qualifying and the Nations Cup: a finals group is on neutral ground.
      if (f.groupId == null || !{null, 'CQ', 'NGROUP'}.contains(f.round)) {
        continue;
      }
      (byGroup[f.groupId!] ??= []).add(f);
    }
    var checked = 0;
    for (final games in byGroup.values) {
      games.sort((a, b) => a.date.compareTo(b.date) as int);
      final sides = {
        for (final g in games) ...[
          g.homeNationId as int,
          g.awayNationId as int,
        ],
      };
      if (sides.length > 6) continue;
      checked++;
      for (final t in sides) {
        bool? last;
        var run = 0;
        for (final g in games) {
          if (g.homeNationId != t && g.awayNationId != t) continue;
          final home = g.homeNationId == t;
          run = home == last ? run + 1 : 1;
          last = home;
          expect(
            run,
            lessThanOrEqualTo(2),
            reason: 'nation $t group ${g.groupId}',
          );
        }
      }
    }
    expect(checked, greaterThan(20));
  });
}
