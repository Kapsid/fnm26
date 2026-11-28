import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/legends_screen.dart';
import 'package:fnm/features/shell/tablet_shell.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';
import 'legends_phone_test.dart' show expectReadOnlyDiscs, xiDiscs;

Future<SeededSave> _open(
  WidgetTester tester,
  Size size, {
  bool fake = true,
}) async {
  final save = await seedSave(
    tester,
    formFactor: FormFactor.tablet,
    overrides: fake ? [fakeLegendsOverride()] : const [],
  );
  await pumpRoute(
    tester,
    save,
    '${Routes.legends}?careerId=${save.careerId}',
    size: size,
  );
  return save;
}

/// The player the tablet now shows: on his own page, as the legends have no
/// pane beside them.
int _shownPlayer(WidgetTester tester) =>
    tester.widget<PlayerDetailScreen>(find.byType(PlayerDetailScreen)).playerId;

void main() {
  for (final size in kTabletSizes) {
    testWidgets('the XI on the pitch, the hall of fame beside it, $size', (
      tester,
    ) async {
      await _open(tester, size);
      expect(tester.takeException(), isNull);
      expect(find.byKey(LegendsScreen.tabletLayoutKey), findsOneWidget);
      expect(find.byType(PhoneWidthFrame), findsNothing);
      expect(find.byType(AppBar), findsNothing);
      expect(xiDiscs(), findsNWidgets(11));
      expectReadOnlyDiscs();
      expect(find.text(enL.recordsAllTimeXiSubtitle), findsOneWidget);
      expect(
        find.descendant(
          of: find.byKey(LegendsScreen.formationKey),
          matching: find.text('4-3-3'),
        ),
        findsOneWidget,
      );
      // The pitch on one side, the cards on the other, two abreast.
      final pitch = tester.getRect(find.byKey(LegendsScreen.xiPitchKey));
      final hall = fakeLegends().hallOfFame;
      Rect card(int i) =>
          tester.getRect(find.byKey(LegendsScreen.cardKey(hall[i].playerId)));
      expect(card(0).left, greaterThan(pitch.right));
      expect(card(0).top, card(1).top);
      expect(card(1).left, greaterThan(card(0).right));
      expect(find.text(enL.recordsHallOfFame), findsOneWidget);
      await tester.pumpWidget(const SizedBox());
    });
  }

  testWidgets('the whole hall of fame scrolls into view', (tester) async {
    await _open(tester, kTabletSize);
    final last = fakeLegends().hallOfFame.last;
    await tester.scrollUntilVisible(
      find.byKey(LegendsScreen.cardKey(last.playerId)),
      200,
      scrollable: find
          .descendant(
            of: find.byKey(LegendsScreen.tabletLayoutKey),
            matching: find.byType(Scrollable),
          )
          .last,
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a card opens its legend', (tester) async {
    await _open(tester, kTabletSize);
    final first = fakeLegends().hallOfFame.first;
    await tester.tap(find.byKey(LegendsScreen.cardKey(first.playerId)));
    await settle(tester);
    expect(_shownPlayer(tester), first.playerId);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a disc of the XI opens its legend', (tester) async {
    await _open(tester, kTabletSize);
    final pitch = tester.widget<TacticsPitch>(find.byType(TacticsPitch));
    final id = pitch.lineup[0]!;
    await tester.tap(
      find.byKey(const ValueKey('pitchDisc0')),
      warnIfMissed: false,
    );
    await settle(tester);
    expect(_shownPlayer(tester), id);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a fresh save has no legends yet', (tester) async {
    final save = await _open(tester, kTabletSize, fake: false);
    expect(find.byKey(LegendsScreen.tabletLayoutKey), findsOneWidget);
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsNoLegends(me.name)), findsOneWidget);
    expect(find.byKey(LegendsScreen.xiPitchKey), findsNothing);
    await tester.pumpWidget(const SizedBox());
  });
}
