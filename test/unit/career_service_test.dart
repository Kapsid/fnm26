import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';

import '../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late ProviderContainer container;

  ProviderContainer build({required bool premium}) {
    db = createTestDatabase();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => premium),
      ],
    );
    addTearDown(c.dispose);
    addTearDown(db.close);
    return c;
  }

  test('a free player gets two saves, and the third is refused', () async {
    container = build(premium: false);
    final service = container.read(careerServiceProvider);

    for (var i = 0; i < kFreeSaveSlots; i++) {
      final r = await service.create(nationId: 1, managerName: 'M$i');
      expect(r.isSuccess, isTrue, reason: 'save ${i + 1}');
    }

    final over = await service.create(nationId: 1, managerName: 'X');
    expect(over.isFailure, isTrue);
    over.fold(
      (_) => fail('expected failure'),
      (f) => expect(f.code, 'slots_full'),
    );
  });

  test('a buyer is never told the slots are full', () async {
    container = build(premium: true);
    final service = container.read(careerServiceProvider);

    // Well past both the free limit and the ten-slot cap this used to carry:
    // the purchase is sold as unlimited, so there is nothing left to hit.
    for (var i = 0; i < 12; i++) {
      final r = await service.create(nationId: 1, managerName: 'M$i');
      expect(r.isSuccess, isTrue, reason: 'save ${i + 1}');
    }
  });

  test('created save starts in July 2026 with cycle 0', () async {
    container = build(premium: true);
    final service = container.read(careerServiceProvider);

    final result = await service.create(nationId: 7, managerName: 'Alex');
    final career = result.valueOrNull!;
    expect(career.inGameDate, DateTime(2026, 7));
    expect(career.cyclePointer, 0);
    expect(career.managerName, 'Alex');
  });

  test('blank manager name falls back to "Manager"', () async {
    container = build(premium: true);
    final service = container.read(careerServiceProvider);

    final career = (await service.create(
      nationId: 1,
      managerName: '   ',
    )).valueOrNull!;
    expect(career.managerName, 'Manager');
  });
}
