import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/career/manager_history_providers.dart';
import 'package:fnm/features/career/manager_history_screen.dart';
import 'package:fnm/features/stats/stats_providers.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/pump_app.dart';

/// The trophy cabinet sits centred in its card.
///
/// A `Wrap` packs from the start and leaves every bit of the remainder at the
/// END of the run, so with fixed-width slots that do not divide into the card
/// exactly the whole cabinet sat left. A tester reported the gap to the right
/// of the trophies as much bigger than the one to the left, and it was.
///
/// Measured rather than asserted on the property: a later change that keeps
/// `WrapAlignment.center` but pads one side would pass a property check and
/// still look wrong.
void main() {
  for (final width in [320.0, 390.0, 430.0]) {
    testWidgets('the cabinet is centred at ${width.toInt()}px', (tester) async {
      tester.view
        ..physicalSize = Size(width, 1400)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(
        const ManagerHistoryScreen(careerId: 1),
        overrides: [
          managerHistoryProvider(1).overrideWith(
            (ref) async => ManagerHistory(
              managerName: 'Tester',
              cycles: const <ManagerCycle>[],
              played: 0,
              won: 0,
              drawn: 0,
              lost: 0,
              goalsFor: 0,
              goalsAgainst: 0,
              titles: 0,
            ),
          ),
          teamOverallHistoryProvider(
            1,
          ).overrideWith((ref) async => const <TeamOverallPoint>[]),
        ],
      );
      await tester.pumpAndSettle();

      final wrap = find.byType(Wrap);
      expect(wrap, findsWidgets, reason: 'the cabinet is a Wrap');

      // Measured against the CARD, not against the Wrap. A Wrap shrink-wraps
      // to its children, so its own box has no spare width in it and every
      // gap measured against it is zero whatever the alignment says.
      final card = find.ancestor(
        of: wrap.first,
        matching: find.byType(AppCard),
      );
      expect(card, findsWidgets, reason: 'the cabinet sits in a card');
      final box = tester.getRect(card.first);
      // The slots are the cabinet's fixed-width children.
      final slots = find.descendant(
        of: wrap.first,
        matching: find.byWidgetPredicate((w) => w is SizedBox && w.width == 90),
      );
      expect(slots, findsWidgets);

      final rects = [
        for (final e in slots.evaluate())
          tester.getRect(find.byWidget(e.widget)),
      ];
      final top = rects.map((r) => r.top).reduce((a, b) => a < b ? a : b);
      final firstRow = rects.where((r) => (r.top - top).abs() < 1).toList()
        ..sort((a, b) => a.left.compareTo(b.left));
      expect(firstRow.length, greaterThan(1), reason: 'a row of trophies');

      final leftGap = firstRow.first.left - box.left;
      final rightGap = box.right - firstRow.last.right;
      expect(
        (leftGap - rightGap).abs(),
        lessThan(2.0),
        reason:
            'the cabinet leans: $leftGap on the left, $rightGap on the right',
      );
    });
  }
}
