import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/continental_detail_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets('qualifying groups in columns, the cup named, $size', (
      tester,
    ) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await watchContinentalQualifyingDraw(tester, save);
      await pumpRoute(
        tester,
        save,
        '${Routes.continental}?careerId=${save.careerId}'
        '&conf=${Confederation.europe.name}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(ContinentalDetailScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(
        tester
            .widget<ContinentalDetailView>(find.byType(ContinentalDetailView))
            .confederation,
        Confederation.europe,
      );

      late ContinentalData data;
      await tester.runAsync(() async {
        final sub = save.container.listen(
          continentalDetailProvider((
            careerId: save.careerId,
            confederation: Confederation.europe,
          )).future,
          (_, _) {},
        );
        data = (await sub.read())!;
        sub.close();
      });
      // The manager's group first, the next beside it.
      final groups = data.qualifyingGroups;
      final mine = groups.firstWhere(
        (g) => g.standings.any((s) => s.nationId == save.nationId),
      );
      final next = groups.firstWhere((g) => g.name != mine.name);
      final a = tester.getRect(
        find.text(enL.tourContGroupHeading(mine.name)).hitTestable(),
      );
      final b = tester.getRect(
        find.text(enL.tourContGroupHeading(next.name)).hitTestable(),
      );
      expect(a.top, b.top);
      expect(b.left, greaterThan(a.right));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
