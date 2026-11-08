import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/continental_cups.dart';
import 'package:fnm/domain/services/competition/hosts.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/domain/services/competition/venues.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/federation/national_stadium_providers.dart';
import 'package:fnm/features/tournaments/city_providers.dart';
import 'package:sqlite3/sqlite3.dart';

/// Saves written by earlier builds (see tool/fixture_saves/README.md), one
/// folder per build.
const String kFixtureSavesDir = 'test/fixtures/saves';

/// The builds with fixture saves: 1.0.9 (21), 1.1.0 (37), and main just
/// before schema 55.
const List<String> kFixtureBuilds = ['v109', 'v110_37', 'pre55'];

/// The columns of existing rows a rollover may legitimately rewrite, by
/// table, each for the reason given. Every other column of every existing
/// row (a career's `rng_seed` and `nation_id`, a tier row's key) must come
/// through a rollover unchanged. Fixed against the code at 1.1.0 (38); no
/// later task may grow it (save_upgrade_test pins it).
const Map<String, Set<String>> kRolloverMutableColumns = {
  // The career's own row moves on to the next cycle: its pointer and date,
  // the new cycle's budget, and the board's verdict on the cycle just ended.
  'careers': {
    'cycle_pointer',
    'in_game_date',
    'budget',
    'last_cycle_board',
  },
  // Nations Cup promotion and relegation rewrite each nation's tier
  // (`SeasonRollover`, `setNationsCupTiers`).
  'nations_cup_tiers': {'tier'},
};

/// The tables of [kRolloverMutableColumns].
const Set<String> kRolloverMutableTables = {'careers', 'nations_cup_tiers'};

/// What an old build said about one of its saves: its career, its cycle, the
/// hosts and venues of every edition of cycles 0 and 1 it could name (keys
/// `wc:<cycle>` and `cont:<CONF>:<cycle>`, venues as `"<name>|<capacity>"`),
/// and the pool names of a few nations at the save's date.
typedef SaveManifest = ({
  int careerId,
  int cyclePointer,
  Map<String, List<int>> hosts,
  Map<String, List<String>> venues,
  Map<int, List<String>> names,
});

/// Gunzips the fixture [name] of [build] into a fresh temp directory, so the
/// committed original is never written.
Future<File> unpackFixture(String build, String name) async {
  final src = File('$kFixtureSavesDir/$build/$name.db.gz');
  final dir = Directory.systemTemp.createTempSync('fnm_fixture_$build');
  final out = File('${dir.path}/$name.db');
  await out.writeAsBytes(gzip.decode(await src.readAsBytes()), flush: true);
  return out;
}

/// The schema the old build wrote the fixture [name] of [build] at, as its
/// manifest records it.
int manifestSchemaVersion(String build, String name) =>
    (jsonDecode(
              File(
                '$kFixtureSavesDir/$build/$name.manifest.json',
              ).readAsStringSync(),
            )
            as Map<String, Object?>)['schemaVersion']!
        as int;

/// The schema of the database file at [dbPath], unopened by drift.
int fileSchemaVersion(String dbPath) {
  final db = sqlite3.open(dbPath, mode: OpenMode.readOnly);
  try {
    return db.select('PRAGMA user_version').single.values.single! as int;
  } finally {
    db.close();
  }
}

/// The schema of main when the pre55 fixtures were written: today's until
/// Task 2 bumps it to 55.
const int kPre55Schema = 54;

/// The manifest beside the fixture [name] of [build].
SaveManifest readManifest(String build, String name) => manifestFromJson(
  jsonDecode(
        File('$kFixtureSavesDir/$build/$name.manifest.json').readAsStringSync(),
      )
      as Map<String, Object?>,
);

SaveManifest manifestFromJson(Map<String, Object?> j) => (
  careerId: j['careerId']! as int,
  cyclePointer: j['cyclePointer']! as int,
  hosts: {
    for (final e in (j['hosts']! as Map).entries)
      e.key as String: (e.value as List).cast<int>(),
  },
  venues: {
    for (final e in (j['venues']! as Map).entries)
      e.key as String: (e.value as List).cast<String>(),
  },
  names: {
    for (final e in (j['names']! as Map).entries)
      int.parse(e.key as String): (e.value as List).cast<String>(),
  },
);

/// Every user table of the database at [dbPath] ([only], when given), each
/// row as read by `SELECT * ... ORDER BY rowid`. Blobs read as base64, so
/// rows compare with `==`.
Future<Map<String, List<Map<String, Object?>>>> dumpTables(
  String dbPath, {
  Set<String>? only,
}) async {
  final db = sqlite3.open(dbPath, mode: OpenMode.readOnly);
  try {
    final names = [
      for (final r in db.select(
        "SELECT name FROM sqlite_master WHERE type = 'table' "
        "AND name NOT LIKE 'sqlite_%' ORDER BY name",
      ))
        r['name'] as String,
    ];
    return {
      for (final t in names)
        if (only == null || only.contains(t))
          t: [
            for (final r in db.select('SELECT * FROM "$t" ORDER BY rowid'))
              {
                for (final k in r.keys)
                  k: r[k] is Uint8List ? base64Encode(r[k] as Uint8List) : r[k],
              },
          ],
    };
  } finally {
    db.close();
  }
}

/// [row] cut to [columns]: an old row compared with its migrated self, which
/// may carry columns the old build did not have.
Map<String, Object?> rowOn(
  Map<String, Object?> row,
  Iterable<String> columns,
) => {for (final c in columns) c: row[c]};

/// A row as a stable string, for set comparisons.
String rowKey(Map<String, Object?> row) {
  final keys = row.keys.toList()..sort();
  return jsonEncode([
    for (final k in keys) [k, row[k]],
  ]);
}

// ---------------------------------------------------------------------------
// The manifest, recomputed on today's code. Must stay identical to `_manifest`
// in tool/fixture_saves/make_fixture_saves_test.dart.
// ---------------------------------------------------------------------------

const List<int> _nameNations = [1, 23, 140];

final AutoDisposeFutureProviderFamily<Map<int, List<Venue>>, (int, String)>
_estatesProvider = FutureProvider.autoDispose
    .family<Map<int, List<Venue>>, (int, String)>(
      (ref, k) => hostEstatesFor(ref, k.$1, [
        for (final s in k.$2.split(',')) int.parse(s),
      ]),
    );

String _venueKey(Venue v) => '${v.stadium}, ${v.city}|${v.capacity}';

/// What the old build's manifest recorded, as today's code reads [careerId].
Future<SaveManifest> computeManifest(ProviderContainer c, int careerId) async {
  final career = (await c.read(careerRepositoryProvider).byId(careerId))!;
  final nations = await c.read(nationRepositoryProvider).forCareer(careerId);
  final cities = await c.read(countryCitiesProvider.future);
  final comp = c.read(competitionRepositoryProvider);
  final hosts = <String, List<int>>{};
  final venues = <String, List<String>>{};

  Future<void> edition(String key, int cycle, List<int> ids, int field) async {
    if (ids.isEmpty) return;
    hosts[key] = ids;
    final estates = await c.read(
      _estatesProvider((careerId, ids.join(','))).future,
    );
    final byHost = VenueGenerator.forHosts(
      hostIds: ids,
      citiesByHost: {
        for (final h in ids)
          if (cities[h] != null) h: cities[h]!,
      },
      count: VenueGenerator.countForField(field),
      estates: estates,
      rules: await venueRulesFor(comp, careerId, cycle),
    );
    venues[key] = [
      for (final h in ids)
        for (final v in byHost[h] ?? const <Venue>[]) '$h:${_venueKey(v)}',
    ];
  }

  for (final cycle in [0, 1]) {
    await edition(
      'wc:$cycle',
      cycle,
      WorldCupHosts.hostsFor(
        year: CareerService.worldCupYear(cycle),
        nations: nations,
        seed: career.rngSeed,
      ),
      QualificationFormat.totalFinalsBerths + QualificationFormat.playoffBerths,
    );
    for (final conf in Confederation.values) {
      final cup = ContinentalCups.byConfederation[conf];
      if (cup == null) continue;
      await edition(
        'cont:${conf.name}:$cycle',
        cycle,
        WorldCupHosts.continentalHostsFor(
          confederation: conf,
          cycle: cycle,
          seed: career.rngSeed,
          nations: nations,
        ),
        cup.size,
      );
    }
  }

  final names = <int, List<String>>{};
  for (final nid in {career.nationId, ..._nameNations}) {
    final pool = await c
        .read(playerRepositoryProvider)
        .byNation(
          nid,
          agingYears: CareerService.agingYears(career),
          saveSeed: career.rngSeed,
          careerId: career.id,
        );
    pool.sort((a, b) => a.id.compareTo(b.id));
    names[nid] = [for (final p in pool) '${p.id} ${p.name}'];
  }

  return (
    careerId: careerId,
    cyclePointer: career.cyclePointer,
    hosts: hosts,
    venues: venues,
    names: names,
  );
}
