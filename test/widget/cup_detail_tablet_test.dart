import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_screen.dart';
import 'package:fnm/features/tournaments/tournament_bracket.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

Future<void> _open(WidgetTester tester, Size size) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: [
      cupDetailProvider(
        kSeededCareerId,
      ).overrideWith((ref) async => fakeCupData(seededNationId)),
    ],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.cup}?careerId=${save.careerId}',
    size: size,
  );
}

/// Two group headings side by side: same top, the second to the right.
void _sideBySide(WidgetTester tester, String a, String b) {
  final ra = tester.getRect(find.text(a).hitTestable());
  final rb = tester.getRect(find.text(b).hitTestable());
  expect(ra.top, rb.top, reason: '$a and $b share a row');
  expect(rb.left, greaterThan(ra.right));
}

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the tabs fill the area, the bracket opens full width, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(CupDetailScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(CupDetailView), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(
        tester.widget<TournamentBracket>(find.byType(TournamentBracket)).wide,
        isTrue,
      );
      // Opened as the bracket, its columns wider than a phone's 150.
      final r16 = tester.getCenter(find.text('R16'));
      final last = tester.getCenter(find.text('Final'));
      expect(last.dx - r16.dx, greaterThan(3 * 158));
      await tester.pumpWidget(const SizedBox());
    });

    testWidgets('qualifying and finals groups sit in columns, $size', (
      tester,
    ) async {
      await _open(tester, size);
      await showTab(tester, 1);
      expect(tester.takeException(), isNull);
      _sideBySide(tester, enL.tourCupGroupName('A'), enL.tourCupGroupName('B'));
      await showTab(tester, 3);
      expect(tester.takeException(), isNull);
      _sideBySide(tester, enL.tourCupGroupName('A'), enL.tourCupGroupName('B'));
      await tester.pumpWidget(const SizedBox());
    });
  }

  // Stage 3 carry-over (liveTab re-key). A top-bar step invalidates this
  // provider under the open page; a refresh that leaves the stage where it
  // was must leave the manager on the tab he picked.
  testWidgets('a refresh keeps the tab the manager picked', (tester) async {
    final save = await seedSave(
      tester,
      formFactor: FormFactor.tablet,
      overrides: [
        cupDetailProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => fakeCupData(seededNationId)),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.cup}?careerId=${save.careerId}',
      size: kTabletSize,
    );
    TabController controller() =>
        DefaultTabController.of(tester.element(find.byType(TabBarView)));
    expect(controller().index, 4, reason: 'opens on the bracket');
    await showTab(tester, 7);
    save.container.invalidate(cupDetailProvider(save.careerId));
    await settle(tester);
    expect(controller().index, 7);
    await tester.pumpWidget(const SizedBox());
  });
}
