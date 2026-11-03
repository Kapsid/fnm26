import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Variable;
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/dormant_seed.dart';
import 'package:fnm/data/seed/frozen_name_pools.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/nation/dormant_nations.dart';

import '../../helpers/test_database.dart';

final List<Nation> _nations =
    (jsonDecode(File('assets/data/nations.json').readAsStringSync()) as List)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

final List<Player> _base =
    (jsonDecode(File('assets/data/players.json').readAsStringSync()) as List)
        .map((e) => Player.fromJson(e as Map<String, Object?>))
        .toList();

final Map<int, ({List<String> first, List<String> sur})> _names = {
  for (final e
      in (jsonDecode(File('assets/data/country_names.json').readAsStringSync())
              as Map<String, Object?>)
          .entries)
    int.parse(e.key): (
      first: ((e.value! as Map)['first'] as List).cast<String>(),
      sur: ((e.value! as Map)['sur'] as List).cast<String>(),
    ),
};

/// FNV-1a (64-bit) of the players' JSON, with the count: a cheap fingerprint
/// of an entire generated pool.
String _fingerprint(List<Player> players) {
  // VM-only arithmetic (64-bit wrap-around); never compiled to JS.
  // ignore: avoid_js_rounded_ints
  var h = 0xcbf29ce484222325;
  for (final c in utf8.encode(
    jsonEncode([for (final p in players) p.toJson()]),
  )) {
    h = (h ^ c) * 0x100000001b3;
  }
  return '${players.length}:${h.toRadixString(16)}';
}

InMemorySeedSource _source({
  required List<Player> players,
  bool dormant = true,
}) => InMemorySeedSource(
  nationList: _nations,
  playerList: players,
  dormantNations: dormant ? DormantNations.all : const [],
  dormantPlayers: dormant ? dormantPool() : const [],
);

Future<int> _count(
  AppDatabase db,
  String sql, [
  List<Object> args = const [],
]) async {
  final row = await db
      .customSelect(sql, variables: [for (final a in args) Variable(a)])
      .getSingle();
  return row.read<int>('c');
}

Future<int> _greenlandPlayers(AppDatabase db) =>
    _count(db, 'SELECT COUNT(*) AS c FROM players WHERE nation_id = ?', [212]);

Future<int> _greenlandRows(AppDatabase db) =>
    _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = ?', [212]);

void main() {
  group('PoolGenerator refactor', () {
    // Taken from expand() BEFORE fringeFor was split out of it. Every saved
    // world's fringe players (ids, names, attributes, clubs) come from here,
    // so the refactor must not move a single byte.
    test('expand(players.json) is byte-identical to the pre-refactor pool', () {
      // On the pools as 1.0.8 shipped them: Croatia's, Central Asia's and Chinese Taipei's lists
      // moved in 1.0.9,
      // and older careers read the frozen copy (frozen_name_pools.dart).
      final namesV4 = {
        ..._names,
        10: (first: croatiaFirstNamesV4, sur: croatiaSurnamesV4),
        196: (first: turkmenistanFirstNamesV4, sur: turkmenistanSurnamesV4),
        173: (first: kyrgyzstanFirstNamesV4, sur: kyrgyzstanSurnamesV4),
        193: (first: tajikistanFirstNamesV4, sur: tajikistanSurnamesV4),
        198: (first: uzbekistanFirstNamesV4, sur: uzbekistanSurnamesV4),
        27: (first: kazakhstanFirstNamesV4, sur: kazakhstanSurnamesV4),
        155: (first: afghanistanFirstNamesV4, sur: afghanistanSurnamesV4),
        163: (first: chineseTaipeiFirstNamesV4, sur: chineseTaipeiSurnamesV4),
      };
      expect(
        _fingerprint(PoolGenerator.expand(_base, namesByNation: namesV4)),
        '21527:5ddea999ee5ad37c',
      );
      expect(
        _fingerprint(PoolGenerator.expand(_base)),
        '21527:2c421ebcdcb1596e',
      );
    });
  });

  group('Greenland seed data', () {
    test('ids sit in their own fixed ranges', () {
      final pool = greenlandPool();
      expect(pool, hasLength(23 + PoolGenerator.extraPerNation));
      expect(pool.every((p) => p.nationId == 212), isTrue);
      expect(
        [for (final p in greenlandSquad) p.id],
        [for (var i = 21201; i <= 21223; i++) i],
      );
      expect(
        [for (final p in pool.skip(23)) p.id],
        [for (var i = 20212000; i <= 20212079; i++) i],
      );
      // None of them collides with anything the seed already holds.
      final taken = {for (final p in PoolGenerator.expand(_base)) p.id};
      expect(pool.where((p) => taken.contains(p.id)), isEmpty);
    });

    test("the squad copies San Marino's positions, scaled by the factor", () {
      final sm = _base.where((p) => p.nationId == 45).toList();
      expect(
        [for (final p in greenlandSquad) p.position],
        [for (final p in sm) p.position],
      );
      for (var i = 0; i < sm.length; i++) {
        int scaled(int v) =>
            (v * greenlandAttributeFactor).round().clamp(25, 99);
        final a = sm[i].attributes;
        final g = greenlandSquad[i].attributes;
        expect(g.physical, scaled(a.physical), reason: 'slot $i');
        expect(g.technical, scaled(a.technical), reason: 'slot $i');
        expect(g.stamina, scaled(a.stamina), reason: 'slot $i');
      }
      expect(
        greenlandSquad.every((p) => p.age >= 18 && p.age <= 34),
        isTrue,
      );
    });

    test("the base mean overall is a little above Andorra's and San "
        "Marino's, while the ranking stays last", () {
      double mean(List<Player> ps) =>
          ps.fold<int>(0, (s, p) => s + p.overall) / ps.length;
      double meanOf(int id) =>
          mean(_base.where((p) => p.nationId == id).toList());
      final greenland = mean(greenlandSquad);
      final stronger = [meanOf(2), meanOf(45)].reduce((a, b) => a > b ? a : b);
      // The owner's ruling: about 3 to 5% above the stronger of the two.
      expect(greenland / stronger, inInclusiveRange(1.03, 1.05));
      // Strength is the squad; the starting ranking is still the very bottom.
      expect(
        DormantNations.greenland.ranking,
        _nations.map((n) => n.ranking).reduce((a, b) => a > b ? a : b),
      );
    });

    test('the Dart name pools mirror country_names.json', () {
      expect(_names[212]!.first, greenlandFirstNames);
      expect(_names[212]!.sur, greenlandSurnames);
    });

    test('AssetSeedSource supplies the dormant nations', () async {
      final d = await AssetSeedSource(rootBundle).dormant();
      expect(d.nations, DormantNations.all);
      expect(d.players, dormantPool());
    });

    test('Greenland is in neither seed file', () {
      expect(_nations.where((n) => n.id == 212 || n.code == 'GRL'), isEmpty);
      expect(_base.where((p) => p.nationId == 212), isEmpty);
    });
  });

  group('Zanzibar seed data', () {
    test('ids sit in their own fixed ranges', () {
      final pool = zanzibarPool();
      expect(pool, hasLength(23 + PoolGenerator.extraPerNation));
      expect(pool.every((p) => p.nationId == 213), isTrue);
      expect(
        [for (final p in zanzibarSquad) p.id],
        [for (var i = 21301; i <= 21323; i++) i],
      );
      expect(
        [for (final p in pool.skip(23)) p.id],
        [for (var i = 20213000; i <= 20213079; i++) i],
      );
      final taken = {
        for (final p in PoolGenerator.expand(_base)) p.id,
        for (final p in greenlandPool()) p.id,
      };
      expect(pool.where((p) => taken.contains(p.id)), isEmpty);
    });

    test("the squad copies Chad's positions and ages, scaled by the "
        'factor', () {
      final chad = _base.where((p) => p.nationId == 110).toList();
      expect(
        [for (final p in zanzibarSquad) p.position],
        [for (final p in chad) p.position],
      );
      expect(
        [for (final p in zanzibarSquad) p.age],
        [for (final p in chad) p.age],
      );
      for (var i = 0; i < chad.length; i++) {
        int scaled(int v) =>
            (v * zanzibarAttributeFactor).round().clamp(25, 99);
        final a = chad[i].attributes;
        final z = zanzibarSquad[i].attributes;
        expect(z.physical, scaled(a.physical), reason: 'slot $i');
        expect(z.technical, scaled(a.technical), reason: 'slot $i');
        expect(z.stamina, scaled(a.stamina), reason: 'slot $i');
      }
    });

    test("Zanzibar starts near Chad's level and on Chad's ranking", () {
      double mean(List<Player> ps) =>
          ps.fold<int>(0, (s, p) => s + p.overall) / ps.length;
      final chad = mean(_base.where((p) => p.nationId == 110).toList());
      expect(mean(zanzibarSquad) / chad, inInclusiveRange(0.9, 1.1));
      final chadRow = _nations.firstWhere((n) => n.id == 110);
      expect(DormantNations.zanzibar.ranking, chadRow.ranking);
      expect(DormantNations.zanzibar.confederation, chadRow.confederation);
      expect(DormantNations.replaces[DormantNations.zanzibarId], 110);
    });

    test('the Dart name pools mirror country_names.json', () {
      expect(_names[213]!.first, zanzibarFirstNames);
      expect(_names[213]!.sur, zanzibarSurnames);
    });

    test('Zanzibar is in neither seed file', () {
      expect(_nations.where((n) => n.id == 213 || n.code == 'ZAN'), isEmpty);
      expect(_base.where((p) => p.nationId == 213), isEmpty);
    });

    test('a fresh database gets Zanzibar and its 103 players', () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = 213'),
        1,
      );
      expect(
        await _count(
          db,
          'SELECT COUNT(*) AS c FROM players WHERE nation_id = 213',
        ),
        103,
      );
    });
  });

  group('Belarus seed data', () {
    test('ids sit in their own fixed ranges, the squad on its old 601-623', () {
      final pool = belarusPool();
      expect(pool, hasLength(23 + PoolGenerator.extraPerNation));
      expect(pool.every((p) => p.nationId == 6), isTrue);
      expect(
        [for (final p in belarusSquad) p.id],
        [for (var i = 601; i <= 623; i++) i],
      );
      expect(
        [for (final p in pool.skip(23)) p.id],
        [for (var i = 20006000; i <= 20006079; i++) i],
      );
      final taken = {
        for (final p in PoolGenerator.expand(_base)) p.id,
        for (final p in greenlandPool()) p.id,
        for (final p in zanzibarPool()) p.id,
      };
      expect(pool.where((p) => taken.contains(p.id)), isEmpty);
    });

    test("the squad copies Luxembourg's positions and ages, scaled by the "
        'factor', () {
      final lux = _base.where((p) => p.nationId == 32).toList();
      expect(
        [for (final p in belarusSquad) p.position],
        [for (final p in lux) p.position],
      );
      expect(
        [for (final p in belarusSquad) p.age],
        [for (final p in lux) p.age],
      );
      for (var i = 0; i < lux.length; i++) {
        int scaled(int v) => (v * belarusAttributeFactor).round().clamp(25, 99);
        final a = lux[i].attributes;
        final b = belarusSquad[i].attributes;
        expect(b.physical, scaled(a.physical), reason: 'slot $i');
        expect(b.technical, scaled(a.technical), reason: 'slot $i');
        expect(b.stamina, scaled(a.stamina), reason: 'slot $i');
      }
    });

    test('Belarus is European, an addition, ranked beside Palestine', () {
      expect(DormantNations.belarus.confederation, Confederation.europe);
      expect(
        DormantNations.replaces.containsKey(DormantNations.belarusId),
        isFalse,
      );
      expect(DormantNations.additions, contains(DormantNations.belarusId));
      final palestine = _nations.firstWhere((n) => n.code == 'PLE');
      expect(DormantNations.belarus.ranking, palestine.ranking);
    });

    test('the Dart name pools mirror country_names.json', () {
      expect(_names[6]!.first, belarusFirstNames);
      expect(_names[6]!.sur, belarusSurnames);
    });

    test('Belarus is in neither seed file', () {
      expect(_nations.where((n) => n.id == 6 || n.code == 'BLR'), isEmpty);
      expect(_base.where((p) => p.nationId == 6), isEmpty);
    });

    test('a fresh database gets Belarus and its 103 players, and an old one '
        'that pruned it gets them back', () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      // An old database: seeded before Belarus came back.
      await SeedLoader(
        db,
        _source(players: _base, dormant: false),
      ).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = 6'),
        0,
      );
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = 6'),
        1,
      );
      expect(
        await _count(
          db,
          'SELECT COUNT(*) AS c FROM players WHERE nation_id = 6',
        ),
        103,
      );
      // The prune keeps it on the next launch.
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = 6'),
        1,
      );
    });
  });

  group('SeedLoader', () {
    late AppDatabase db;
    setUp(() => db = createTestDatabase());
    tearDown(() => db.close());

    test('a fresh database gets Greenland and its 103 players', () async {
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      expect(await _greenlandRows(db), 1);
      expect(await _greenlandPlayers(db), 103);
    });

    test(
      'an existing database gains Greenland on the next launch, once',
      () async {
        await SeedLoader(
          db,
          _source(players: _base, dormant: false),
        ).ensureSeeded();
        expect(await _greenlandRows(db), 0);

        final loader = SeedLoader(db, _source(players: _base));
        await loader.ensureSeeded();
        expect(await _greenlandRows(db), 1);
        expect(await _greenlandPlayers(db), 103);
        final players = await _count(db, 'SELECT COUNT(*) AS c FROM players');

        await loader.ensureSeeded();
        expect(await _greenlandRows(db), 1);
        expect(await _count(db, 'SELECT COUNT(*) AS c FROM players'), players);
      },
    );

    test(
      'reconcile never prunes Greenland, even with no dormant source',
      () async {
        await SeedLoader(db, _source(players: _base)).ensureSeeded();
        await SeedLoader(
          db,
          _source(players: _base, dormant: false),
        ).ensureSeeded();
        expect(await _greenlandRows(db), 1);
        expect(await _greenlandPlayers(db), 103);
      },
    );

    test(
      "an older build's Greenland is rewritten to the current data",
      () async {
        await SeedLoader(db, _source(players: _base)).ensureSeeded();
        // What an earlier build left behind: a different squad (weaker
        // attributes, another name), a stale nation row and a player the
        // current pool no longer has.
        await db.customStatement(
          'UPDATE players SET physical = 10, technical = 10, stamina = 10 '
          'WHERE nation_id = 212',
        );
        await db.customStatement(
          "UPDATE players SET name = 'Old Name' WHERE id = 21201",
        );
        await db.customStatement(
          'UPDATE nations SET ranking = 999 WHERE id = 212',
        );
        await db.customStatement(
          'INSERT INTO players (id, nation_id, name, age, position, physical, '
          "technical, stamina, club) VALUES (20212999, 212, 'Gone', 20, "
          "'st', 30, 30, 30, 'X')",
        );
        final nationCount = await _count(
          db,
          'SELECT COUNT(*) AS c FROM nations',
        );

        // A new source object: a fresh launch of the current build.
        await SeedLoader(db, _source(players: _base)).ensureSeeded();
        final stored = await db
            .customSelect(
              'SELECT id, name, physical, technical, stamina FROM players '
              'WHERE nation_id = 212 ORDER BY id',
            )
            .get();
        final want = [...greenlandPool()]..sort((a, b) => a.id.compareTo(b.id));
        expect(stored.map((r) => r.read<int>('id')), want.map((p) => p.id));
        for (var i = 0; i < want.length; i++) {
          expect(stored[i].read<String>('name'), want[i].name);
          expect(
            stored[i].read<int>('physical'),
            want[i].attributes.physical,
          );
          expect(
            stored[i].read<int>('technical'),
            want[i].attributes.technical,
          );
          expect(stored[i].read<int>('stamina'), want[i].attributes.stamina);
        }
        expect(
          await _count(
            db,
            'SELECT COUNT(*) AS c FROM nations WHERE id = 212 AND ranking = ?',
            [209],
          ),
          1,
        );
        expect(
          await _count(db, 'SELECT COUNT(*) AS c FROM nations'),
          nationCount,
        );
      },
    );

    test("a deep-pool rebuild still ends with Greenland's players", () async {
      // A pre-v10 database: the base 23 per nation only.
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      final shallow = await _count(db, 'SELECT COUNT(*) AS c FROM players');
      expect(shallow, _base.length + dormantPool().length);

      // The next launch rebuilds the pool, deleting every player first.
      final deep = PoolGenerator.expand(_base, namesByNation: _names);
      await SeedLoader(db, _source(players: deep)).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM players'),
        deep.length + dormantPool().length,
      );
      expect(await _greenlandPlayers(db), 103);
    });
  });
}
