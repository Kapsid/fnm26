import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/services/world_pack/active_world.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

void main() {
  tearDown(() => ActiveWorld.current = ActiveWorld.none);

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
