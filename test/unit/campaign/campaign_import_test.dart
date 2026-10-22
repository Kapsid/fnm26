import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/services/campaign/campaigns.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/player/golden_generation.dart';
import 'package:fnm/features/campaign/campaign_providers.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:path/path.dart' as p;

/// A bundle carries its campaign markers, so importing one must respect the
/// campaign rules: one run per campaign, and an unmoved run holds no slot.
void main() {
  late AppDatabase db;
  late Directory root;
  late ProviderContainer c;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    root = Directory.systemTemp.createTempSync('fnm-campaign-import');
    c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => false),
      ],
    );
    addTearDown(c.dispose);
  });

  tearDown(() async {
    await db.close();
    root.deleteSync(recursive: true);
  });

  Future<int> aCareer(AppDatabase d, {List<String> kinds = const []}) async {
    final id = await d
        .into(d.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: 'M',
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
            cyclePointer: const Value(0),
          ),
        );
    for (final k in kinds) {
      await d
          .into(d.drawsWatched)
          .insert(
            DrawsWatchedCompanion.insert(careerId: id, cycle: 0, kind: k),
          );
    }
    return id;
  }

  Future<String> aBundle(List<String> kinds) async {
    final other = AppDatabase.forTesting(NativeDatabase.memory());
    final id = await aCareer(other, kinds: kinds);
    final bundle = await CareerBundle.export(other, id);
    await other.close();
    final file = File(p.join(root.path, 'b${kinds.length}${kinds.join()}.f'));
    await file.writeAsBytes(CareerBundle.encode(bundle));
    return file.path;
  }

  final grudge = campaignMarker(Campaigns.grudge.id);

  test('a second run of the same campaign is refused, DB unchanged', () async {
    await aCareer(db, kinds: [grudge]);
    final before = (await db.select(db.careers).get()).length;
    final r = await c
        .read(careerTransferServiceProvider)
        .import(await aBundle([grudge]));
    expect(r, BundleRejection.campaignRunExists);
    expect((await db.select(db.careers).get()).length, before);
  });

  test('an unmoved campaign imports with slots full and stays one', () async {
    await aCareer(db);
    await aCareer(db);
    final r = await c
        .read(careerTransferServiceProvider)
        .import(await aBundle([grudge]));
    expect(r, isNull);
    expect(await c.read(savesProvider.future), hasLength(2));
    expect(await c.read(campaignRunsProvider.future), contains('grudge'));
  });

  test('a moved campaign bundle counts as a save', () async {
    await aCareer(db);
    await aCareer(db);
    final r = await c
        .read(careerTransferServiceProvider)
        .import(await aBundle([grudge, campaignMovedKind]));
    expect(r, BundleRejection.slotsFull);
  });

  test('a Young Finns run keeps its golden generation through a bundle',
      () async {
    final r = await c
        .read(careerTransferServiceProvider)
        .import(
          await aBundle([
            campaignMarker(Campaigns.youngFinns.id),
            GoldenGeneration.markerFor(Campaigns.youngFinns.nationId),
          ]),
        );
    expect(r, isNull);
    final run = (await c.read(campaignRunsProvider.future))['youngFinns']!;
    final finns = await c
        .read(playerRepositoryProvider)
        .byNation(
          Campaigns.youngFinns.nationId,
          saveSeed: 7,
          careerId: run.id,
          minAge: 15,
        );
    expect(
      finns.where((p) => GoldenGeneration.isGoldenId(p.id)).length,
      GoldenGeneration.cohort(Campaigns.youngFinns.nationId).length,
    );
  });
}
