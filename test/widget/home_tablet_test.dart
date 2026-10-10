import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/career.dart';
import 'package:fnm/features/home/home_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// A save on a tablet's home screen, and (when [second]) a second one on the
/// rival nation, played more recently, whose id comes back with it.
Future<(SeededSave, int?)> _open(
  WidgetTester tester,
  Size size, {
  bool second = false,
}) async {
  final save = await seedSave(tester, formFactor: FormFactor.tablet);
  final secondId = second ? await addSecondSave(tester, save) : null;
  await pumpRoute(tester, save, Routes.home, size: size);
  return (save, secondId);
}

Uri _uri(SeededSave save) =>
    save.container.read(routerProvider).routeInformationProvider.value.uri;

Future<Career?> _career(WidgetTester tester, SeededSave save, int id) async {
  Career? career;
  await tester.runAsync(() async {
    career = await save.container.read(careerRepositoryProvider).byId(id);
  });
  return career;
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the title left, the way in right, $size', (tester) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(HomeScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(FullScreenPhoneFrame), findsNothing);
      final title = tester.getRect(find.text('Football Nations\nManager'));
      final newGame = tester.getRect(
        find.widgetWithText(PrimaryButton, enL.homeNewGame),
      );
      expect(newGame.left, greaterThan(title.right));
      expect(find.text(enL.homeContinue), findsOneWidget);
      expect(find.byTooltip(enL.homeSettings), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('Continue opens the last save and stamps only it', (
    tester,
  ) async {
    final (save, second) = await _open(tester, kTabletSize, second: true);
    // A save is stamped when it is made; addSecondSave stamped the first 2
    // minutes ago and the second 1 minute ago, so the second is the last
    // played and the stamp Continue writes (now) is a change on it.
    final lastBefore = (await _career(tester, save, second!))!.lastPlayedAt;
    final otherBefore = (await _career(
      tester,
      save,
      save.careerId,
    ))!.lastPlayedAt;
    expect(lastBefore, isNotNull);
    expect(otherBefore, isNotNull);
    await tester.tap(find.text(enL.homeContinue));
    await settle(tester);
    expect(_uri(save).path, Routes.hub);
    expect(_uri(save).queryParameters['careerId'], '$second');
    expect(
      (await _career(tester, save, second))!.lastPlayedAt,
      isNot(lastBefore),
    );
    expect(
      (await _career(tester, save, save.careerId))!.lastPlayedAt,
      otherBefore,
    );
    await stopPlayClock(tester, save);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets("the other buttons go where the phone's do (Review Focus 7)", (
    tester,
  ) async {
    final (save, _) = await _open(tester, kTabletSize);
    final router = save.container.read(routerProvider);
    final buttons = {
      find.widgetWithText(PrimaryButton, enL.homeNewGame): Routes.nations,
      find.text(enL.homeAllSaves): Routes.saves,
      find.byTooltip(enL.homeSettings): Routes.settings,
    };
    for (final e in buttons.entries) {
      router.go(Routes.home);
      await settle(tester);
      expect(find.byKey(HomeScreen.tabletLayoutKey), findsOneWidget);
      await tester.tap(e.key);
      await settle(tester);
      expect(_uri(save).path, e.value);
    }
    await tester.pumpWidget(const SizedBox());
  });
}
