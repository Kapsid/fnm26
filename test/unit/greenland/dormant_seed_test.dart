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
import 'package:fnm/domain/services/rating/overall_rating.dart';

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
    // Without clubStars (1.1.x): a display field read at materialisation,
    // never part of the generated pool, so the pinned hashes stay valid.
    jsonEncode([
      for (final p in players) {...p.toJson()}..remove('clubStars'),
    ]),
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

  group('Isle of Man seed data', () {
    test('ids sit in their own fixed ranges', () {
      final pool = isleOfManPool();
      expect(pool, hasLength(23 + PoolGenerator.extraPerNation));
      expect(pool.every((p) => p.nationId == 214), isTrue);
      expect(
        [for (final p in isleOfManSquad) p.id],
        [for (var i = 21401; i <= 21423; i++) i],
      );
      expect(
        [for (final p in pool.skip(23)) p.id],
        [for (var i = 20214000; i <= 20214079; i++) i],
      );
      final taken = {
        for (final p in PoolGenerator.expand(_base)) p.id,
        for (final p in dormantPool())
          if (p.nationId != 214) p.id,
      };
      expect(pool.where((p) => taken.contains(p.id)), isEmpty);
    });

    test("the squad copies Andorra's positions and ages, scaled by the "
        'factor', () {
      final base = _base.where((p) => p.nationId == 2).toList();
      expect(
        [for (final p in isleOfManSquad) p.position],
        [for (final p in base) p.position],
      );
      expect(
        [for (final p in isleOfManSquad) p.age],
        [for (final p in base) p.age],
      );
      for (var i = 0; i < base.length; i++) {
        int scaled(int v) =>
            (v * isleOfManAttributeFactor).round().clamp(25, 99);
        final a = base[i].attributes;
        final z = isleOfManSquad[i].attributes;
        expect(z.physical, scaled(a.physical), reason: 'slot $i');
        expect(z.technical, scaled(a.technical), reason: 'slot $i');
        expect(z.stamina, scaled(a.stamina), reason: 'slot $i');
      }
    });

    test("Isle of Man starts at its level and in Andorra's place", () {
      double mean(List<Player> ps) =>
          ps.fold<int>(0, (s, p) => s + p.overall) / ps.length;
      final base = mean(_base.where((p) => p.nationId == 2).toList());
      expect(mean(isleOfManSquad) / base, inInclusiveRange(0.9, 1.1));
      final row = _nations.firstWhere((n) => n.id == 2);
      expect(DormantNations.isleOfMan.ranking, row.ranking);
      expect(DormantNations.isleOfMan.confederation, row.confederation);
      expect(DormantNations.replaces[214], 2);
    });

    test('the Dart name pools mirror country_names.json', () {
      expect(_names[214]!.first, isleOfManFirstNames);
      expect(_names[214]!.sur, isleOfManSurnames);
    });

    test('Isle of Man is in neither seed file', () {
      expect(
        _nations.where(
          (n) => n.id == 214 || n.code == DormantNations.isleOfMan.code,
        ),
        isEmpty,
      );
      expect(_base.where((p) => p.nationId == 214), isEmpty);
    });

    test('a fresh database gets Isle of Man and its 103 players', () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = 214'),
        1,
      );
      expect(
        await _count(
          db,
          'SELECT COUNT(*) AS c FROM players WHERE nation_id = 214',
        ),
        103,
      );
    });
  });

  group('Czechoslovakia seed data', () {
    test('ids sit in their own fixed ranges', () {
      final pool = czechoslovakiaPool();
      expect(pool, hasLength(23 + PoolGenerator.extraPerNation));
      expect(pool.every((p) => p.nationId == 215), isTrue);
      expect(
        [for (final p in czechoslovakiaSquad) p.id],
        [for (var i = 21501; i <= 21523; i++) i],
      );
      expect(
        [for (final p in pool.skip(23)) p.id],
        [for (var i = 20215000; i <= 20215079; i++) i],
      );
      final taken = {
        for (final p in PoolGenerator.expand(_base)) p.id,
        for (final p in dormantPool())
          if (p.nationId != 215) p.id,
      };
      expect(pool.where((p) => taken.contains(p.id)), isEmpty);
    });

    test("the squad copies Czechia's positions and ages, scaled by the "
        'factor', () {
      final base = _base.where((p) => p.nationId == 12).toList();
      expect(
        [for (final p in czechoslovakiaSquad) p.position],
        [for (final p in base) p.position],
      );
      expect(
        [for (final p in czechoslovakiaSquad) p.age],
        [for (final p in base) p.age],
      );
      for (var i = 0; i < base.length; i++) {
        int scaled(int v) =>
            (v * czechoslovakiaAttributeFactor).round().clamp(25, 99);
        final a = base[i].attributes;
        final z = czechoslovakiaSquad[i].attributes;
        expect(z.physical, scaled(a.physical), reason: 'slot $i');
        expect(z.technical, scaled(a.technical), reason: 'slot $i');
        expect(z.stamina, scaled(a.stamina), reason: 'slot $i');
      }
    });

    test("Czechoslovakia starts at its level and in Czechia's place", () {
      double mean(List<Player> ps) =>
          ps.fold<int>(0, (s, p) => s + p.overall) / ps.length;
      final base = mean(_base.where((p) => p.nationId == 12).toList());
      expect(mean(czechoslovakiaSquad) / base, inInclusiveRange(0.8, 0.95));
      final row = _nations.firstWhere((n) => n.id == 12);
      // Above both nations it is made of.
      expect(DormantNations.czechoslovakia.ranking, lessThan(row.ranking));
      expect(DormantNations.alsoReplaces[215], {48});
      expect(DormantNations.czechoslovakia.confederation, row.confederation);
      expect(DormantNations.replaces[215], 12);
    });

    test('the Dart name pools mirror country_names.json', () {
      expect(_names[215]!.first, czechoslovakiaFirstNames);
      expect(_names[215]!.sur, czechoslovakiaSurnames);
    });

    test('Czechoslovakia is in neither seed file', () {
      expect(
        _nations.where(
          (n) => n.id == 215 || n.code == DormantNations.czechoslovakia.code,
        ),
        isEmpty,
      );
      expect(_base.where((p) => p.nationId == 215), isEmpty);
    });

    test('a fresh database gets Czechoslovakia and its 103 players', () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = 215'),
        1,
      );
      expect(
        await _count(
          db,
          'SELECT COUNT(*) AS c FROM players WHERE nation_id = 215',
        ),
        103,
      );
    });
  });

  group('Texas seed data', () {
    test('ids sit in their own fixed ranges', () {
      final pool = texasPool();
      expect(pool, hasLength(23 + PoolGenerator.extraPerNation));
      expect(pool.every((p) => p.nationId == 216), isTrue);
      expect(
        [for (final p in texasSquad) p.id],
        [for (var i = 21601; i <= 21623; i++) i],
      );
      expect(
        [for (final p in pool.skip(23)) p.id],
        [for (var i = 20216000; i <= 20216079; i++) i],
      );
      final taken = {
        for (final p in PoolGenerator.expand(_base)) p.id,
        for (final p in dormantPool())
          if (p.nationId != 216) p.id,
      };
      expect(pool.where((p) => taken.contains(p.id)), isEmpty);
    });

    test("the squad copies Jamaica's positions and ages, scaled by the "
        'factor', () {
      final base = _base.where((p) => p.nationId == 87).toList();
      expect(
        [for (final p in texasSquad) p.position],
        [for (final p in base) p.position],
      );
      expect(
        [for (final p in texasSquad) p.age],
        [for (final p in base) p.age],
      );
      for (var i = 0; i < base.length; i++) {
        int scaled(int v) => (v * texasAttributeFactor).round().clamp(25, 99);
        final a = base[i].attributes;
        final z = texasSquad[i].attributes;
        expect(z.physical, scaled(a.physical), reason: 'slot $i');
        expect(z.technical, scaled(a.technical), reason: 'slot $i');
        expect(z.stamina, scaled(a.stamina), reason: 'slot $i');
      }
    });

    test("Texas starts a mid-strength side, about Honduras's level, in "
        "Anguilla's place, far above Anguilla's squad", () {
      double mean(List<Player> ps) =>
          ps.fold<int>(0, (s, p) => s + p.overall) / ps.length;
      double of(int id) => mean(_base.where((p) => p.nationId == id).toList());
      final texas = mean(texasSquad);
      // A little below Jamaica's, the squad it copies.
      expect(texas / of(87), inInclusiveRange(0.88, 0.97));
      // The best eleven of its whole pool: 69.
      expect(squadOverall(texasPool()), 69);
      // Far above Anguilla's, whose place it takes.
      expect(texas / of(66), greaterThan(1.4));
      // Below the region's big three, Costa Rica and Panama, about level
      // with Honduras.
      for (final big in [88, 99, 74, 76, 91]) {
        expect(texas, lessThan(of(big)), reason: 'nation $big');
      }
      expect(texas / of(86), inInclusiveRange(0.95, 1.05));
      // Its rank sits between Honduras (65th) and Jamaica (70th).
      final rank = DormantNations.texas.ranking;
      expect(rank, greaterThan(_nations.firstWhere((n) => n.id == 86).ranking));
      expect(rank, lessThan(_nations.firstWhere((n) => n.id == 87).ranking));
      final row = _nations.firstWhere((n) => n.id == 66);
      expect(DormantNations.texas.confederation, row.confederation);
      expect(DormantNations.replaces[216], 66);
      expect(DormantNations.alsoReplaces[216], isNull);
    });

    test('the Dart name pools mirror country_names.json', () {
      expect(_names[216]!.first, texasFirstNames);
      expect(_names[216]!.sur, texasSurnames);
    });

    test('Texas is in neither seed file', () {
      expect(
        _nations.where(
          (n) => n.id == 216 || n.code == DormantNations.texas.code,
        ),
        isEmpty,
      );
      expect(_base.where((p) => p.nationId == 216), isEmpty);
    });

    test("no stored Texas name is any seeded player's", () {
      final seeded = {for (final p in _base) p.name};
      expect(texasPool().where((p) => seeded.contains(p.name)), isEmpty);
    });

    test('a fresh database gets Texas and its 103 players', () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = 216'),
        1,
      );
      expect(
        await _count(
          db,
          'SELECT COUNT(*) AS c FROM players WHERE nation_id = 216',
        ),
        103,
      );
    });
  });

  group('Vatican City seed data', () {
    test('ids sit in their own fixed ranges', () {
      final pool = vaticanPool();
      expect(pool, hasLength(23 + PoolGenerator.extraPerNation));
      expect(pool.every((p) => p.nationId == 217), isTrue);
      expect(
        [for (final p in vaticanSquad) p.id],
        [for (var i = 21701; i <= 21723; i++) i],
      );
      expect(
        [for (final p in pool.skip(23)) p.id],
        [for (var i = 20217000; i <= 20217079; i++) i],
      );
      final taken = {
        for (final p in PoolGenerator.expand(_base)) p.id,
        for (final p in dormantPool())
          if (p.nationId != 217) p.id,
      };
      expect(pool.where((p) => taken.contains(p.id)), isEmpty);
    });

    test("the squad copies San Marino's positions and ages, scaled by the "
        'factor', () {
      final base = _base.where((p) => p.nationId == 45).toList();
      expect(
        [for (final p in vaticanSquad) p.position],
        [for (final p in base) p.position],
      );
      expect(
        [for (final p in vaticanSquad) p.age],
        [for (final p in base) p.age],
      );
      for (var i = 0; i < base.length; i++) {
        int scaled(int v) => (v * vaticanAttributeFactor).round().clamp(25, 99);
        final a = base[i].attributes;
        final z = vaticanSquad[i].attributes;
        expect(z.physical, scaled(a.physical), reason: 'slot $i');
        expect(z.technical, scaled(a.technical), reason: 'slot $i');
        expect(z.stamina, scaled(a.stamina), reason: 'slot $i');
      }
    });

    test('Vatican City is rated 35, nine below San Marino, the weakest side '
        "in the world, last on the ranking, in San Marino's place", () {
      final deep = PoolGenerator.expand(_base);
      final byNation = <int, List<Player>>{};
      for (final p in deep) {
        (byNation[p.nationId] ??= []).add(p);
      }
      // The best eleven of the whole stored pool: 35, against San Marino's
      // 44 (its 23 and its fringe, as every nation is stored).
      expect(squadOverall(vaticanPool()), 35);
      expect(squadOverall(byNation[45]!), 44);
      // Over the 23 alone: 33 against San Marino's 43.
      expect(squadOverall(vaticanSquad), 33);
      expect(squadOverall(_base.where((p) => p.nationId == 45).toList()), 43);
      // Below every nation in the world, the weakest included.
      final weakest = byNation.values
          .map(squadOverall)
          .reduce((a, b) => a < b ? a : b);
      expect(squadOverall(vaticanPool()), lessThan(weakest));
      for (final d in dormantPool().map((p) => p.nationId).toSet()) {
        if (d == 217) continue;
        expect(
          squadOverall(dormantPool().where((p) => p.nationId == d).toList()),
          greaterThan(35),
          reason: 'dormant $d',
        );
      }
      // The very bottom of the starting ranking, San Marino's place.
      final row = _nations.firstWhere((n) => n.id == 45);
      expect(
        DormantNations.vatican.ranking,
        _nations.map((n) => n.ranking).reduce((a, b) => a > b ? a : b),
      );
      expect(DormantNations.vatican.ranking, row.ranking);
      expect(DormantNations.vatican.confederation, row.confederation);
      expect(DormantNations.replaces[217], 45);
      expect(DormantNations.alsoReplaces[217], isNull);
    });

    test('the Dart name pools mirror country_names.json', () {
      expect(_names[217]!.first, vaticanFirstNames);
      expect(_names[217]!.sur, vaticanSurnames);
    });

    test('Vatican City is in neither seed file', () {
      expect(
        _nations.where(
          (n) => n.id == 217 || n.code == DormantNations.vatican.code,
        ),
        isEmpty,
      );
      expect(_base.where((p) => p.nationId == 217), isEmpty);
    });

    test("no stored Vatican City name is any seeded player's", () {
      final seeded = {for (final p in _base) p.name};
      expect(vaticanPool().where((p) => seeded.contains(p.name)), isEmpty);
    });

    test('a fresh database gets Vatican City and its 103 players', () async {
      final db = createTestDatabase();
      addTearDown(db.close);
      await SeedLoader(db, _source(players: _base)).ensureSeeded();
      expect(
        await _count(db, 'SELECT COUNT(*) AS c FROM nations WHERE id = 217'),
        1,
      );
      expect(
        await _count(
          db,
          'SELECT COUNT(*) AS c FROM players WHERE nation_id = 217',
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
