import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/repositories/drift_nation_repository.dart';
import 'package:fnm/data/seed/legacy_seed_ranking.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

/// Why a career bundle cannot be imported.
enum BundleRejection {
  /// Not readable as a bundle at all.
  unreadable,

  /// A later build wrote it. Its rows may name columns this build has never
  /// heard of, and there is no migration path for a bundle — only for a
  /// database.
  fromANewerBuild,

  /// Every save slot this entitlement allows is in use. An import takes a slot
  /// like a new game does, so the same ceiling applies.
  slotsFull,

  /// The career is past the free cycle and this player has not bought the
  /// upgrade. Taking it in would hand him a cycle the trial does not cover.
  needsPremium,

  /// An unmoved campaign run, and that campaign already has a run here. A
  /// campaign holds one run at a time (the player resumes or abandons it).
  campaignRunExists,
}

/// Moving ONE career between devices, as a file.
///
/// The counterpart to `save_backup.dart`, which copies the whole database.
/// This is the sharing shape: a single career, small, and it MERGES on import
/// rather than replacing anything — you end up with one more save, not a
/// different set of saves.
///
/// The awkward part, and the reason this is more than a `SELECT *`: the save is
/// not cleanly partitioned by career. Twenty-seven tables carry `career_id`
/// and can be filtered directly, but `qualifying_groups` belongs to a career
/// only through its competition and `group_members` only through its group.
/// And the ids of competitions, groups and fixtures are referenced by other
/// rows, so importing has to renumber them and rewrite every reference — a
/// straight insert would attach the incoming career's fixtures to whatever
/// competition already happened to hold that id.
abstract final class CareerBundle {
  /// The bundle format. Bumped only if the FILE shape changes; the game's
  /// schema version travels separately inside it.
  static const int formatVersion = 1;

  /// The extension a shared career carries.
  static const String extension = 'fnmcareer';

  /// Reference data, identical in every install of a given build, and so never
  /// written into a bundle: the importing app already has it.
  static const Set<String> seedTables = {'nations', 'players'};

  /// The manager's own things, belonging to no career (the tactics library).
  /// Never written into a bundle: sharing one save must not hand over, or on
  /// import overwrite, what the manager keeps across all of them. The
  /// whole-database backup still carries them.
  static const Set<String> globalTables = {'tactic_library'};

  /// The career's own row.
  static const String rootTable = 'careers';

  /// Tables reached NOT by `career_id` but through another table. The value is
  /// the (column, table it points into) pair that scopes them.
  static const Map<String, (String column, String parent)> derivedScope = {
    'qualifying_groups': ('competition_id', 'competitions'),
    'group_members': ('group_id', 'qualifying_groups'),
  };

  /// Whose `id` is pointed at by what. These are the only ids renumbered on
  /// import; everything else ending in `_id` names seed data (a nation, a
  /// player), which is stable across installs and must NOT be touched.
  static const Map<String, List<(String table, String column)>> references = {
    'competitions': [
      ('fixtures', 'competition_id'),
      ('qualifying_groups', 'competition_id'),
      ('goal_events', 'competition_id'),
      ('tournament_appearances', 'competition_id'),
    ],
    'qualifying_groups': [
      ('group_members', 'group_id'),
      ('fixtures', 'group_id'),
    ],
    'fixtures': [
      ('goal_events', 'fixture_id'),
      ('player_ratings', 'fixture_id'),
      ('match_team_stats', 'fixture_id'),
      ('match_incidents', 'fixture_id'),
      ('press_statements', 'made_after_fixture_id'),
      ('press_conferences', 'fixture_id'),
    ],
  };

  /// The order tables must be written in, so a row is always inserted after
  /// whatever it points at.
  static const List<String> insertOrder = [
    rootTable,
    'competitions',
    'qualifying_groups',
    'fixtures',
    'group_members',
  ];

  /// Every table a bundle carries, in insert order.
  static List<String> tablesOf(AppDatabase db) {
    final all = db.allTables.map((t) => t.actualTableName).toList();
    final rest =
        all
            .where(
              (t) =>
                  !seedTables.contains(t) &&
                  !globalTables.contains(t) &&
                  !insertOrder.contains(t),
            )
            .toList()
          ..sort();
    return [...insertOrder.where(all.contains), ...rest];
  }

  /// Reads [careerId] out of [db] as a bundle.
  static Future<Map<String, Object?>> export(
    AppDatabase db,
    int careerId,
  ) async {
    final tables = <String, List<Map<String, Object?>>>{};
    // The ids of the parents whose children are scoped through them, collected
    // as we go so the derived tables can be filtered without a second pass.
    final parentIds = <String, List<Object?>>{};

    for (final table in tablesOf(db)) {
      final rows = await _selectFor(db, table, careerId, parentIds);
      tables[table] = rows;
      if (references.containsKey(table) || table == rootTable) {
        parentIds[table] = [
          for (final row in rows)
            if (row['id'] case final id?) id,
        ];
      }
    }

    // Self-describing: a career on the nations' own ranking carries it as
    // its cycle-0 seed ranking, so no later import can mistake it for one
    // begun on an older ranking (see [_keepLegacyRanking]).
    final seeded = tables['seed_rankings'];
    if (seeded != null &&
        tables[rootTable]?.singleOrNull != null &&
        !seeded.any((r) => r['cycle'] == 0)) {
      tables['seed_rankings'] = [
        ...seeded,
        for (final n in await DriftNationRepository(db).forCareer(careerId))
          {
            'career_id': careerId,
            'cycle': 0,
            'nation_id': n.id,
            'rank': n.ranking,
          },
      ];
    }

    final career = tables[rootTable]?.singleOrNull;
    return {
      'format': formatVersion,
      'schemaVersion': AppDatabase.currentSchemaVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'managerName': career?['manager_name'],
      'tables': tables,
    };
  }

  static Future<List<Map<String, Object?>>> _selectFor(
    AppDatabase db,
    String table,
    int careerId,
    Map<String, List<Object?>> parentIds,
  ) async {
    if (table == rootTable) {
      return _rows(db, 'SELECT * FROM $rootTable WHERE id = ?', [
        Variable<int>(careerId),
      ]);
    }
    if (derivedScope[table] case final scope?) {
      final ids = parentIds[scope.$2] ?? const [];
      if (ids.isEmpty) return const [];
      final slots = List.filled(ids.length, '?').join(', ');
      return _rows(
        db,
        'SELECT * FROM $table WHERE ${scope.$1} IN ($slots)',
        [for (final id in ids) Variable<int>(id! as int)],
      );
    }
    return _rows(db, 'SELECT * FROM $table WHERE career_id = ?', [
      Variable<int>(careerId),
    ]);
  }

  static Future<List<Map<String, Object?>>> _rows(
    AppDatabase db,
    String sql,
    List<Variable<Object>> variables,
  ) async {
    final result = await db.customSelect(sql, variables: variables).get();
    return [for (final row in result) Map<String, Object?>.from(row.data)];
  }

  /// Writes [bundle] into [db] as a NEW career, and returns its id.
  ///
  /// Nothing existing is touched: the incoming career is renumbered on the way
  /// in, so it lands alongside whatever is already saved.
  static Future<int> import(AppDatabase db, Map<String, Object?> bundle) async {
    final tables = (bundle['tables']! as Map).cast<String, Object?>();
    // old id → new id, per table whose ids are referenced.
    final remap = <String, Map<Object?, int>>{
      for (final table in [rootTable, ...references.keys]) table: {},
    };

    return db.transaction(() async {
      var newCareerId = 0;
      for (final table in tablesOf(db)) {
        final rows = (tables[table] as List?)?.cast<Map<String, Object?>>();
        if (rows == null) continue;
        for (final row in rows) {
          final written = Map<String, Object?>.from(row);
          final oldId = written.remove('id');

          if (table != rootTable) {
            written['career_id'] = newCareerId;
          }
          // Point every reference at the row's new number.
          for (final MapEntry(key: parent, value: pointers)
              in references.entries) {
            for (final (pointingTable, column) in pointers) {
              if (pointingTable != table) continue;
              if (written[column] case final old?) {
                written[column] = remap[parent]![old] ?? old;
              }
            }
          }

          final id = await _insert(db, table, written);
          if (table == rootTable) newCareerId = id;
          if (remap.containsKey(table) && oldId != null) {
            remap[table]![oldId] = id;
          }
        }
      }
      await _keepLegacyRanking(db, bundle, tables, newCareerId);
      return newCareerId;
    });
  }

  /// Gives a career with no cycle-0 seed ranking, from a bundle of schema
  /// [lastSchemaWithoutStartingRanks] or older, [legacySeedRanking] as its
  /// own (in its own world, see [careerWorldRanks]). Every bundle this build
  /// exports carries one (see [export]), so a bundle without one was
  /// written before the starting ranking moved: by 1.0.6, or by an early
  /// 1.0.7 build, both on [legacySeedRanking]. The career must keep the
  /// ranking its draws were made on (see `SeedLoader._reconcileRanking`,
  /// which does the same for the careers already in a database).
  static Future<void> _keepLegacyRanking(
    AppDatabase db,
    Map<String, Object?> bundle,
    Map<String, Object?> tables,
    int careerId,
  ) async {
    final schemaVersion = bundle['schemaVersion'];
    if (schemaVersion is! int ||
        schemaVersion > lastSchemaWithoutStartingRanks) {
      return;
    }
    final seeded = (tables['seed_rankings'] as List?) ?? const [];
    if (seeded.any((r) => r is Map && r['cycle'] == 0)) return;
    final world = careerWorldRanks(
      legacySeedRanking,
      watchedKindsOf(bundle),
      dormantRank: (d) =>
          d == DormantNations.greenlandId ? legacyGreenlandRank : null,
    );
    await db.batch((batch) {
      batch.insertAll(db.seedRankings, [
        for (final e in world.entries)
          SeedRankingsCompanion.insert(
            careerId: careerId,
            cycle: 0,
            nationId: e.key,
            rank: e.value,
          ),
      ], mode: InsertMode.insertOrIgnore);
    });
  }

  /// Inserts [row] into [table], keeping only the columns this build still
  /// has.
  ///
  /// Dropping unknown columns is what lets a bundle from an older build import
  /// into a newer one: a column that has since been removed is ignored, and
  /// one that has since been added takes its default. A bundle from a NEWER
  /// build is refused earlier — see [inspect] — because the reverse is not
  /// safe to guess at.
  static Future<int> _insert(
    AppDatabase db,
    String table,
    Map<String, Object?> row,
  ) async {
    final known = db.allTables
        .firstWhere((t) => t.actualTableName == table)
        .$columns
        .map((c) => c.$name)
        .toSet();
    final columns = [
      for (final entry in row.entries)
        if (known.contains(entry.key)) entry.key,
    ];
    final values = [
      for (final column in columns) Variable<Object>(row[column]),
    ];
    final slots = List.filled(columns.length, '?').join(', ');
    await db.customInsert(
      'INSERT INTO $table (${columns.join(', ')}) VALUES ($slots)',
      variables: values,
    );
    final id = await db
        .customSelect('SELECT last_insert_rowid() AS id')
        .map((r) => r.read<int>('id'))
        .getSingle();
    return id;
  }

  /// Turns a bundle into the bytes written to a file: JSON, gzipped. A long
  /// career is mostly fixtures and ratings, which compress to a fraction.
  static List<int> encode(Map<String, Object?> bundle) =>
      gzip.encode(utf8.encode(jsonEncode(bundle)));

  /// Reads a bundle back, or says why it cannot be used.
  static ({Map<String, Object?>? bundle, BundleRejection? rejection}) decode(
    List<int> bytes,
  ) {
    try {
      final decoded =
          jsonDecode(utf8.decode(gzip.decode(bytes))) as Map<String, Object?>;
      final schemaVersion = decoded['schemaVersion'];
      if (decoded['format'] is! int || decoded['tables'] is! Map) {
        return (bundle: null, rejection: BundleRejection.unreadable);
      }
      if (schemaVersion is! int) {
        return (bundle: null, rejection: BundleRejection.unreadable);
      }
      if (schemaVersion > AppDatabase.currentSchemaVersion) {
        return (bundle: null, rejection: BundleRejection.fromANewerBuild);
      }
      return (bundle: decoded, rejection: null);
    } on Object {
      return (bundle: null, rejection: BundleRejection.unreadable);
    }
  }

  /// The cycle the bundled career is sitting in. A bundle that does not say
  /// (an old one, or a hand-edited one) reads as 0, the cycle every career
  /// starts in.
  static int cyclePointerOf(Map<String, Object?> bundle) {
    final tables = bundle['tables'];
    if (tables is! Map) return 0;
    final rows = tables[rootTable];
    if (rows is! List || rows.isEmpty) return 0;
    final career = rows.first;
    if (career is! Map) return 0;
    final pointer = career['cycle_pointer'];
    return pointer is int ? pointer : 0;
  }

  /// The draw-watched kinds the bundled career carries (its markers, among
  /// them any campaign tag). Empty for a bundle that has none.
  static List<String> watchedKindsOf(Map<String, Object?> bundle) {
    final tables = bundle['tables'];
    if (tables is! Map) return const [];
    final rows = tables['draws_watched'];
    if (rows is! List) return const [];
    return [
      for (final r in rows)
        if (r is Map && r['kind'] is String) r['kind'] as String,
    ];
  }

  /// A name that says which career it holds.
  static String suggestedFileName(String managerName, DateTime on) {
    final safe = managerName.replaceAll(RegExp(r'[^A-Za-z0-9]+'), '-');
    return 'fnm-$safe-${on.year}-${on.month.toString().padLeft(2, '0')}'
        '-${on.day.toString().padLeft(2, '0')}.$extension';
  }

  /// Reads a bundle file.
  static Future<({Map<String, Object?>? bundle, BundleRejection? rejection})>
  readFile(File file) async {
    try {
      return decode(await file.readAsBytes());
    } on Object {
      return (bundle: null, rejection: BundleRejection.unreadable);
    }
  }
}
