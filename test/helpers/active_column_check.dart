import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/tablet/tablet.dart';
import 'package:fnm/shared/widgets/active_badge.dart';

import 'seeded_save.dart';

/// Every "active" badge on screen stands clear of the tally before it and
/// starts where its header does: the one column every all-time board shares.
void expectActiveBadgesClear(WidgetTester tester, String valueLabel) {
  final header = find.byKey(DataGrid.headerKey).first;
  final value = tester.getRect(
    find.descendant(of: header, matching: find.text(valueLabel)),
  );
  final active = tester.getRect(
    find.descendant(of: header, matching: find.text(enL.gridColActive)),
  );
  final badges = find.byType(ActiveBadge);
  expect(badges, findsWidgets);
  for (final e in badges.evaluate()) {
    // The badges are one const widget: measure each by its own element.
    final box = e.renderObject! as RenderBox;
    final badge = box.localToGlobal(Offset.zero) & box.size;
    expect(badge.left - value.right, greaterThanOrEqualTo(activeColumnGap));
    expect((badge.left - active.left).abs(), lessThan(1));
  }
}
