import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/call_up_screen.dart';

import '../helpers/seeded_save.dart';

void main() {
  // The shell used to frame its whole navigator by the CURRENT location, so
  // a tablet page leaving for a phone-width one was laid out at 600 wide
  // (568 inside its padding) while it was still on screen.
  testWidgets('a tablet page keeps its full width while it leaves for a '
      'phone-framed one', (tester) async {
    final save = await seedSave(tester, formFactor: FormFactor.tablet);
    await pumpRoute(
      tester,
      save,
      '${Routes.callUps}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    expect(tester.takeException(), isNull);
    final before = tester.getSize(find.byKey(CallUpScreen.tabletLayoutKey));

    save.container
        .read(routerProvider)
        .go('${Routes.manager}?careerId=${save.careerId}');
    for (var i = 0; i < 20; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 10)),
      );
      await tester.pump(const Duration(milliseconds: 20));
      expect(tester.takeException(), isNull, reason: 'frame $i');
      final leaving = find.byKey(
        CallUpScreen.tabletLayoutKey,
        skipOffstage: false,
      );
      if (leaving.evaluate().isNotEmpty) {
        expect(tester.getSize(leaving.first).width, before.width);
      }
    }
    await settle(tester);
    // The destination is the phone layout, held at 600.
    expect(find.byType(PhoneWidthFrame), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
    'and the reverse: a phone-framed page leaving for a tablet one lays out',
    (tester) async {
      final save = await seedSave(tester, formFactor: FormFactor.tablet);
      await pumpRoute(
        tester,
        save,
        '${Routes.manager}?careerId=${save.careerId}',
        size: kTabletSize,
      );
      final frame = tester.getSize(find.byType(PhoneWidthFrame));
      expect(frame.width, greaterThan(PhoneWidthFrame.maxWidth));
      save.container
          .read(routerProvider)
          .go('${Routes.callUps}?careerId=${save.careerId}');
      for (var i = 0; i < 20; i++) {
        await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)),
        );
        await tester.pump(const Duration(milliseconds: 20));
        expect(tester.takeException(), isNull, reason: 'frame $i');
      }
      await tester.pumpWidget(const SizedBox());
    },
  );
}
