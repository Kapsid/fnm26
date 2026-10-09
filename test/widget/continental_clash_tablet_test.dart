import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/continental_clash_providers.dart';
import 'package:fnm/features/tournaments/continental_clash_screen.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the Clash in a panel, the tie centred, $size', (
      tester,
    ) async {
      final save = await seedSave(
        tester,
        formFactor: FormFactor.tablet,
        overrides: [
          continentalClashProvider(
            kSeededCareerId,
          ).overrideWith((ref) async => fakeClash(seededNationId)),
        ],
      );
      await pumpRoute(
        tester,
        save,
        '${Routes.continentalClash}?careerId=${save.careerId}',
        size: size,
      );
      expect(tester.takeException(), isNull);
      expect(
        find.byKey(ContinentalClashScreen.tabletLayoutKey),
        findsOneWidget,
      );
      expect(find.byType(ContinentalClashView), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      final me = realNationsById[seededNationId]!;
      expect(find.text(enL.tourContWinTheClash(me.name)), findsOneWidget);
      // This cycle's tie is held to a readable width in the middle of the
      // pane (the history tab's list is not built until it is shown).
      final list = find
          .descendant(
            of: find.byType(ContinentalClashView),
            matching: find.byType(ListView),
          )
          .first;
      final view = tester.getRect(find.byType(ContinentalClashView));
      final tie = tester.getRect(list);
      expect(tie.width, lessThanOrEqualTo(640));
      expect((tie.center.dx - view.center.dx).abs(), lessThan(1));
      await tester.pumpWidget(const SizedBox());
    });
  }
}
