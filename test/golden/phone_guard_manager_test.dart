import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/federation/staff_card.dart';

import '../helpers/federation_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone manager page, pinned before the tablet layout is added: as a
/// fresh save shows it, and with points to spend (the + buttons lit).
void main() {
  for (final (name, size, points) in [
    ('manager_phone', kPhoneSize, 0),
    ('manager_phone_tall', const Size(390, 2400), 0),
    ('manager_points_phone_tall', const Size(390, 2400), 2),
  ]) {
    testWidgets(name, (tester) async {
      final save = await seedSave(
        tester,
        overrides: [if (points > 0) managerWithPoints(points)],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.manager}?careerId=${save.careerId}',
        size: size,
      );
      expect(find.byType(StaffCard), findsOneWidget);
      await expectAppGolden('goldens/$name.png');
    });
  }
}
