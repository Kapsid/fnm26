import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/shared/tablet/tablet.dart';

void main() {
  Future<void> pump(WidgetTester tester, Widget row) => tester.pumpWidget(
    MaterialApp(
      home: Scaffold(body: Column(children: [row])),
    ),
  );

  /// The row's own fill: the first Material inside it.
  Color? fill(WidgetTester tester) => tester
      .widget<Material>(
        find
            .descendant(
              of: find.byType(TabletListRow),
              matching: find.byType(Material),
            )
            .first,
      )
      .color;

  testWidgets('the label, the count, an icon, a tap', (tester) async {
    var taps = 0;
    await pump(
      tester,
      TabletListRow(
        label: 'Wins',
        trailing: '3/12',
        leading: const Icon(Icons.star),
        onTap: () => taps++,
      ),
    );
    expect(find.text('Wins'), findsOneWidget);
    expect(find.text('3/12'), findsOneWidget);
    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(
      tester.getSize(find.byType(TabletListRow)).height,
      TabletListRow.height,
    );
    await tester.tap(find.text('Wins'));
    expect(taps, 1);
    expect(fill(tester), Colors.transparent);
  });

  testWidgets('the one open beside the list is lit', (tester) async {
    await pump(
      tester,
      TabletListRow(label: 'Goals', selected: true, onTap: () {}),
    );
    expect(fill(tester), AppColors.surfaceContainerHighest);
  });

  testWidgets('a screen reader hears a button, and which one is open', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await pump(tester, TabletListRow(label: 'Goals', onTap: () {}));
    expect(
      tester.getSemantics(find.byType(TabletListRow)),
      isSemantics(
        label: 'Goals',
        isButton: true,
        hasSelectedState: true,
        isSelected: false,
        hasTapAction: true,
      ),
    );
    await pump(
      tester,
      TabletListRow(label: 'Goals', selected: true, onTap: () {}),
    );
    expect(
      tester.getSemantics(find.byType(TabletListRow)),
      isSemantics(
        label: 'Goals',
        isButton: true,
        hasSelectedState: true,
        isSelected: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });
}
