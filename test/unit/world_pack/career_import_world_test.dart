import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:drift/drift.dart' show Value;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/trophy_normaliser.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

Future<Uint8List> _png(int w, int h) async {
  final rec = ui.PictureRecorder();
  ui.Canvas(rec).drawRect(
    ui.Rect.fromLTWH(0, 0, w.toDouble(), h.toDouble()),
    ui.Paint()..color = const ui.Color(0xFFC81E1E),
  );
  final image = await rec.endRecording().toImage(w, h);
  return (await image.toByteData(
    format: ui.ImageByteFormat.png,
  ))!.buffer.asUint8List();
}

/// A bundle of a career on a custom world with a European trophy of
/// [trophy] (stored as it is, not normalised), passed through [tamper]
/// before it is written to a file.
Future<File> _bundleFile(
  Directory dir, {
  Uint8List? trophy,
  void Function(Map<String, Object?> tables)? tamper,
}) async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final a = greenlandContainer(db);
  addTearDown(a.dispose);
  await a.read(seedLoaderProvider).ensureSeeded();
  final career =
      (await a
              .read(careerServiceProvider)
              .create(nationId: 1, managerName: 'M', rngSeed: 7))
          .valueOrNull!;
  await db
      .into(db.careerWorlds)
      .insert(
        CareerWorldsCompanion.insert(
          careerId: Value(career.id),
          packName: 'Imp',
          json: jsonEncode(
            WorldPack(
              uuid: 'imp',
              name: 'Imp',
              author: '',
              formatVersion: kPackFormatVersion,
              madeWithVersion: '1.1.0',
              nations: const {1: (name: 'Renamed', code: 'RNM')},
              trophies: {if (trophy != null) 'europe'},
            ).toJson(),
          ),
        ),
      );
  if (trophy != null) {
    await db
        .into(db.careerWorldTrophies)
        .insert(
          CareerWorldTrophiesCompanion.insert(
            careerId: career.id,
            key: 'europe',
            png: trophy,
          ),
        );
  }
  final bundle = await CareerBundle.export(db, career.id);
  tamper?.call((bundle['tables']! as Map).cast<String, Object?>());
  return File('${dir.path}/w-${dir.listSync().length}.fnmcareer')
    ..writeAsBytesSync(CareerBundle.encode(bundle));
}

/// A fresh seeded device to import into.
Future<({ProviderContainer c, AppDatabase db})> _device() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return (c: c, db: db);
}

Future<void> _expectNothingWritten(AppDatabase db) async {
  expect(await db.select(db.careers).get(), isEmpty);
  expect(await db.select(db.careerWorlds).get(), isEmpty);
  expect(await db.select(db.careerWorldTrophies).get(), isEmpty);
}

void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

  late Directory dir;
  setUp(() => dir = Directory.systemTemp.createTempSync('fnm-career-world'));
  tearDown(() => dir.deleteSync(recursive: true));

  testWidgets('a bundle whose world has a 10,000-character name is refused '
      'and writes nothing', (tester) async {
    await tester.runAsync(() async {
      final file = await _bundleFile(
        dir,
        tamper: (t) =>
            ((t['career_worlds']! as List).single as Map)['pack_name'] =
                'x' * 10000,
      );
      final d = await _device();
      expect(
        await d.c.read(careerTransferServiceProvider).import(file.path),
        BundleRejection.unreadable,
      );
      await _expectNothingWritten(d.db);
    });
  });

  testWidgets('a bundle whose world json breaks the editor rules is refused', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final file = await _bundleFile(
        dir,
        tamper: (t) {
          final row = (t['career_worlds']! as List).single as Map;
          final pack = jsonDecode(row['json']! as String) as Map;
          pack['name'] = 'y' * 10000;
          row['json'] = jsonEncode(pack);
        },
      );
      final d = await _device();
      expect(
        await d.c.read(careerTransferServiceProvider).import(file.path),
        BundleRejection.unreadable,
      );
      await _expectNothingWritten(d.db);
    });
  });

  testWidgets("a bundle whose world's pool holds another nation's fringe id "
      'is refused; its own nation\'s imports', (tester) async {
    await tester.runAsync(() async {
      final d = await _device();
      final ranges = await d.c.read(playerRepositoryProvider).fringeRanges();
      final own = ranges[1]!;
      Future<File> withPool(int playerId) => _bundleFile(
        dir,
        tamper: (t) {
          final row = (t['career_worlds']! as List).single as Map;
          final pack = jsonDecode(row['json']! as String) as Map;
          pack['pools'] = {
            '1': [
              PackPlayer(
                id: playerId,
                name: 'Pool Man',
                age: 24,
                position: PlayerPosition.cm,
                attributes: const PlayerAttributes(
                  physical: 50,
                  technical: 50,
                  stamina: 50,
                ),
                potential: 60,
              ).toJson(),
            ],
          };
          row['json'] = jsonEncode(pack);
        },
      );
      expect(
        await d.c
            .read(careerTransferServiceProvider)
            .import((await withPool(own.last + 1000000)).path),
        BundleRejection.unreadable,
      );
      await _expectNothingWritten(d.db);
      expect(
        await d.c
            .read(careerTransferServiceProvider)
            .import((await withPool(own.first)).path),
        isNull,
      );
    });
  });

  testWidgets('a bundle carrying a garbage trophy picture is refused', (
    tester,
  ) async {
    await tester.runAsync(() async {
      final file = await _bundleFile(
        dir,
        trophy: Uint8List.fromList(List.generate(64, (i) => i)),
      );
      final d = await _device();
      expect(
        await d.c.read(careerTransferServiceProvider).import(file.path),
        BundleRejection.unreadable,
      );
      await _expectNothingWritten(d.db);
    });
  });

  testWidgets('a valid bundle with a world imports, its trophy redrawn by the '
      'normaliser', (tester) async {
    await tester.runAsync(() async {
      final raw = await _png(100, 100);
      final file = await _bundleFile(dir, trophy: raw);
      final d = await _device();
      expect(
        await d.c.read(careerTransferServiceProvider).import(file.path),
        isNull,
      );
      final world = (await d.db.select(d.db.careerWorlds).get()).single;
      expect(world.packName, 'Imp');
      final stored = (await d.db.select(d.db.careerWorldTrophies).get()).single;
      final expected = (await TrophyNormaliser.normalise(raw, 'europe'))!.png;
      expect(stored.png, isNot(raw));
      expect(stored.png, expected);
    });
  });

  test(
    'importing a career bundle with a world tells the active-world sync',
    () async {
      final dir = Directory.systemTemp.createTempSync('fnm-career-world');
      addTearDown(() => dir.deleteSync(recursive: true));

      final db = createTestDatabase();
      addTearDown(db.close);
      final a = greenlandContainer(db);
      addTearDown(a.dispose);
      await a.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await a
                  .read(careerServiceProvider)
                  .create(nationId: 1, managerName: 'M', rngSeed: 7))
              .valueOrNull!;
      final packs = a.read(worldPackRepositoryProvider);
      final packId = await packs.insert(
        const WorldPack(
          uuid: 'imp',
          name: 'Imp',
          author: '',
          formatVersion: kPackFormatVersion,
          madeWithVersion: '1.1.0',
          nations: {1: (name: 'Renamed', code: 'RNM')},
        ),
        const {},
      );
      await packs.copyToCareer(packId, career.id);
      final file = File('${dir.path}/w.fnm')
        ..writeAsBytesSync(
          CareerBundle.encode(await CareerBundle.export(db, career.id)),
        );

      final db2 = createTestDatabase();
      addTearDown(db2.close);
      final b = greenlandContainer(db2);
      addTearDown(b.dispose);
      await b.read(seedLoaderProvider).ensureSeeded();
      expect(
        await b.read(careerTransferServiceProvider).import(file.path),
        isNull,
      );
      final imported = (await b.read(careerRepositoryProvider).all()).single;

      // The sync knows the career has a world without being primed again, so
      // entering it waits for and loads the world.
      final entering = b.read(activeWorldSyncProvider).enter(imported.id);
      expect(entering, isNotNull);
      await entering;
      expect(b.read(activeWorldProvider).pack?.name, 'Imp');
    },
  );
}
