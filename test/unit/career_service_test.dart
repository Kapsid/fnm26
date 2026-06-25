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

  test('free tier allows 2 saves then blocks the 3rd', () async {
    container = build(premium: false);
    final service = container.read(careerServiceProvider);

    expect((await service.create(nationId: 1, managerName: 'A')).isSuccess, isTrue);
    expect((await service.create(nationId: 1, managerName: 'B')).isSuccess, isTrue);

    final third = await service.create(nationId: 1, managerName: 'C');
    expect(third.isFailure, isTrue);
    third.fold(
      (_) => fail('expected failure'),
      (f) => expect(f.code, 'slots_full'),
    );
  });

  test('pro tier allows 5 saves then blocks the 6th', () async {
    container = build(premium: true);
    final service = container.read(careerServiceProvider);

    for (var i = 0; i < 5; i++) {
      final r = await service.create(nationId: 1, managerName: 'M$i');
      expect(r.isSuccess, isTrue, reason: 'save ${i + 1}');
    }
    expect((await service.create(nationId: 1, managerName: 'X')).isFailure, isTrue);
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

    final career =
        (await service.create(nationId: 1, managerName: '   ')).valueOrNull!;
    expect(career.managerName, 'Manager');
  });
}
