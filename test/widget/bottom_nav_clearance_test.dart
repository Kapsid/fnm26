import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/shared/widgets/app_bottom_nav.dart';

import '../helpers/seeded_save.dart';

/// The bottom navigation floats over the content as a dock, so the content
/// runs on beneath it. Every screen that carries it must still let its LAST
/// item scroll fully clear of the dock, or that item could never be read or
/// tapped. Checked on an iPhone-shaped screen, home indicator included, with
/// the list scrolled all the way to its end.
void main() {
  for (final (name, route) in const [
    ('hub', Routes.hub),
    ('squad', Routes.tactics),
    ('standings', Routes.tournaments),
    ('world ranking', Routes.ranking),
    ('career', Routes.careers),
  ]) {
    testWidgets('$name: the last item scrolls clear of the dock', (
      tester,
    ) async {
      final save = await seedSave(tester);
      tester.view
        ..padding = const FakeViewPadding(top: 59, bottom: 34)
        ..viewPadding = const FakeViewPadding(top: 59, bottom: 34);
      await pumpRoute(
        tester,
        save,
        '$route?careerId=${save.careerId}',
        size: const Size(393, 852),
      );
      expect(tester.takeException(), isNull);

      final list = find
          .byWidgetPredicate(
            (w) => w is ListView && w.scrollDirection == Axis.vertical,
          )
          .first;
      final scrollable = tester.state<ScrollableState>(
        find.descendant(of: list, matching: find.byType(Scrollable)).first,
      );
      final position = scrollable.position;
      // Long enough to run under the dock, or this checks nothing.
      expect(position.maxScrollExtent, greaterThan(0), reason: name);
      position.jumpTo(position.maxScrollExtent);
      await tester.pump();

      final sliver = tester.renderObject<RenderSliverMultiBoxAdaptor>(
        find
            .descendant(
              of: list,
              matching: find.byWidgetPredicate(
                (w) => w is SliverMultiBoxAdaptorWidget,
              ),
            )
            .first,
      );
      final last = sliver.lastChild!;
      final lastBottom = last.localToGlobal(Offset(0, last.size.height)).dy;
      final dockTop =
          tester.getRect(find.byType(AppBottomNav)).top +
          AppBottomNav.fadeHeight;
      expect(
        lastBottom,
        lessThanOrEqualTo(dockTop + 0.5),
        reason:
            '$name: the last item ends at $lastBottom, under the dock '
            'from $dockTop',
      );
    });
  }
}
