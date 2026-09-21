import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';

/// A fixed-seed passive advance, timed. Same world every run, so two builds
/// of the app can be compared directly.
void main() {
  test('bench: passive advance', () async {
    // A FILE-backed database, like the phone's — an in-memory one hides
    // every per-statement cost that makes an advance feel long on glass.
    final dir = Directory.systemTemp.createTempSync('fnm_bench');
    addTearDown(() => dir.deleteSync(recursive: true));
    final db = AppDatabase.forTesting(
      NativeDatabase(File('${dir.path}/bench.sqlite')),
    );
    final nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final base =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    final namesRaw =
        jsonDecode(File('assets/data/country_names.json').readAsStringSync())
            as Map<String, Object?>;
    final namesByNation = <int, ({List<String> first, List<String> sur})>{
      for (final e in namesRaw.entries)
        int.parse(e.key): (
          first: ((e.value! as Map)['first'] as List).cast<String>(),
          sur: ((e.value! as Map)['sur'] as List).cast<String>(),
        ),
    };
    final players = PoolGenerator.expand(base, namesByNation: namesByNation);

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
    addTearDown(db.close);

    await container.read(seedLoaderProvider).ensureSeeded();
    final europeans =
        nations.where((n) => n.confederation == Confederation.europe).toList()
          ..sort((a, b) => a.ranking.compareTo(b.ranking));
    final career =
        (await container.read(careerServiceProvider).create(
              nationId: europeans.first.id,
              managerName: 'M',
              rngSeed: 20260921,
            ))
            .valueOrNull!;

    final season = container.read(seasonServiceProvider);
    final comp = container.read(competitionRepositoryProvider);

    var fixtures = 0;
    var steps = 0;
    final total = Stopwatch();
    for (var i = 0; i < 300; i++) {
      steps = i + 1;
      final before =
          (await comp.allFixtures(career.id)).where((f) => f.hasResult).length;
      total.start();
      await season.advance(career.id);
      total.stop();
      final after =
          (await comp.allFixtures(career.id)).where((f) => f.hasResult).length;
      fixtures = after;
      if (after == before) break;
      if (await comp.worldChampion(career.id) != null) break;
    }
    // ignore: avoid_print — the whole point of this harness is its number.
    print(
      'BENCH ${total.elapsedMilliseconds}ms for $fixtures fixtures '
      'in $steps advances',
    );
  }, timeout: const Timeout(Duration(minutes: 10)));
}
