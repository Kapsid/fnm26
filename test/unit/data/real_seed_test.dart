import 'dart:convert';
import 'dart:io';

import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_loader.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';

/// Seeds a fresh database from the ACTUAL bundled JSON assets (the path that
/// runs on a real device after the schema wipe), to catch anything the static
/// data checks miss — a runtime insert error would surface here.
void main() {
  test('the real bundled seed data populates a fresh database', () async {
    final nations =
        (jsonDecode(
                  File('assets/data/nations.json').readAsStringSync(),
                )
                as List)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    final base =
        (jsonDecode(
                  File('assets/data/players.json').readAsStringSync(),
                )
                as List)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
    final namesRaw =
        jsonDecode(
              File('assets/data/country_names.json').readAsStringSync(),
            )
            as Map<String, Object?>;
    final namesByNation = <int, ({List<String> first, List<String> sur})>{
      for (final e in namesRaw.entries)
        int.parse(e.key): (
          first: ((e.value! as Map)['first'] as List).cast<String>(),
          sur: ((e.value! as Map)['sur'] as List).cast<String>(),
        ),
    };
    final players = PoolGenerator.expand(base, namesByNation: namesByNation);

    final db = AppDatabase.forTesting(NativeDatabase.memory());
    addTearDown(db.close);
    final loader = SeedLoader(
      db,
      InMemorySeedSource(nationList: nations, playerList: players),
    );

    await loader.ensureSeeded();

    expect(await db.select(db.nations).get(), hasLength(209));
    expect((await db.select(db.players).get()).length, greaterThan(4807));
  });
}
