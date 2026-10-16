import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/db/career_bundle.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_transfer_providers.dart';
import 'package:path/path.dart' as p;

/// Importing a career is held to the free tier's two limits: it takes a save
/// slot, and a career past the free cycle is what the purchase sells.
void main() {
  late AppDatabase db;
  late Directory root;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    root = Directory.systemTemp.createTempSync('fnm-import-gate');
  });

  tearDown(() async {
    await db.close();
    root.deleteSync(recursive: true);
  });

  ProviderContainer container({required bool premium}) {
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => premium),
      ],
    );
    addTearDown(c.dispose);
    return c;
  }

  Future<int> aCareer(String manager, {int cyclePointer = 0}) => db
      .into(db.careers)
      .insert(
        CareersCompanion.insert(
          nationId: 1,
          managerName: manager,
          createdAt: DateTime.utc(2030),
          inGameDate: DateTime.utc(2030, 6, 1),
          rngSeed: 7,
          cyclePointer: Value(cyclePointer),
        ),
      );

  /// A bundle file of a career in [cyclePointer], written from a scratch
  /// database so the one under test starts empty.
  Future<String> aBundle({required int cyclePointer}) async {
    final other = AppDatabase.forTesting(NativeDatabase.memory());
    final id = await other
        .into(other.careers)
        .insert(
          CareersCompanion.insert(
            nationId: 1,
            managerName: 'Sent',
            createdAt: DateTime.utc(2030),
            inGameDate: DateTime.utc(2030, 6, 1),
            rngSeed: 7,
            cyclePointer: Value(cyclePointer),
          ),
        );
    final bundle = await CareerBundle.export(other, id);
    await other.close();
    final file = File(p.join(root.path, 'c$cyclePointer.fnmcareer'));
    await file.writeAsBytes(CareerBundle.encode(bundle));
    return file.path;
  }

  Future<int> saves() async => (await db.select(db.careers).get()).length;

  test('a free player takes in a career still in its first cycle', () async {
    final c = container(premium: false);
    final path = await aBundle(cyclePointer: 0);
    expect(await c.read(careerTransferServiceProvider).import(path), isNull);
    expect(await saves(), 1);
  });

  test('a free player is refused a career past the free cycle', () async {
    final c = container(premium: false);
    final path = await aBundle(cyclePointer: 2);
    expect(
      await c.read(careerTransferServiceProvider).import(path),
      BundleRejection.needsPremium,
    );
    expect(await saves(), 0);
  });

  test('a free player with every slot full is refused', () async {
    for (var i = 0; i < kFreeSaveSlots; i++) {
      await aCareer('Mine $i');
    }
    final c = container(premium: false);
    final path = await aBundle(cyclePointer: 0);
    expect(
      await c.read(careerTransferServiceProvider).import(path),
      BundleRejection.slotsFull,
    );
    expect(await saves(), kFreeSaveSlots);
  });

  test('a paid player takes in any cycle, past any count', () async {
    for (var i = 0; i < kFreeSaveSlots + 3; i++) {
      await aCareer('Mine $i');
    }
    final c = container(premium: true);
    final path = await aBundle(cyclePointer: 4);
    expect(await c.read(careerTransferServiceProvider).import(path), isNull);
    expect(await saves(), kFreeSaveSlots + 4);
  });

  test('the bundle says which cycle its career is in', () async {
    final path = await aBundle(cyclePointer: 3);
    final read = await CareerBundle.readFile(File(path));
    expect(CareerBundle.cyclePointerOf(read.bundle!), 3);
    expect(CareerBundle.cyclePointerOf(const {'tables': {}}), 0);
  });

  test('the import rule: only the first cycle is free', () {
    expect(
      importNeedsPremium(cyclePointer: 0, premiumUnlocked: false),
      isFalse,
    );
    expect(importNeedsPremium(cyclePointer: 1, premiumUnlocked: false), isTrue);
    expect(importNeedsPremium(cyclePointer: 1, premiumUnlocked: true), isFalse);
  });
}
