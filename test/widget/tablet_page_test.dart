import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/shared/tablet/tablet.dart';

void main() {
  testWidgets('the heading, then the child filling what is left', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 600);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      const MaterialApp(
        home: TabletPage(
          scaffoldKey: Key('page'),
          title: 'Finances',
          child: SizedBox.expand(key: Key('body')),
        ),
      ),
    );
    expect(find.byKey(const Key('page')), findsOneWidget);
    expect(find.text('Finances'), findsOneWidget);
    // Reached from the sidebar there is nowhere to go back to.
    expect(find.byKey(TabletScreenHeader.backKey), findsNothing);
    final header = tester.getRect(find.byType(TabletScreenHeader));
    final body = tester.getRect(find.byKey(const Key('body')));
    expect(body.top, greaterThanOrEqualTo(header.bottom));
    expect(body.bottom, 600 - AppSpacing.md);
    expect(body.width, 800 - 2 * AppSpacing.md);
  });

  testWidgets('a back arrow when there is somewhere to go, and an action', (
    tester,
  ) async {
    var back = 0;
    await tester.pumpWidget(
      MaterialApp(
        home: TabletPage(
          scaffoldKey: const Key('page'),
          title: 'Youth',
          onBack: () => back++,
          trailing: const Text('call-ups'),
          child: const SizedBox(),
        ),
      ),
    );
    await tester.tap(find.byKey(TabletScreenHeader.backKey));
    expect(back, 1);
    expect(find.text('call-ups'), findsOneWidget);
  });

  testWidgets('the back arrow keeps the default tooltip unless given one', (
    tester,
  ) async {
    Widget page({String? tooltip}) => MaterialApp(
      home: TabletPage(
        scaffoldKey: const Key('page'),
        title: 'Budget',
        onBack: () {},
        backTooltip: tooltip,
        child: const SizedBox(),
      ),
    );
    await tester.pumpWidget(page());
    final fallback = MaterialLocalizations.of(
      tester.element(find.byType(TabletScreenHeader)),
    ).backButtonTooltip;
    expect(
      tester.widget<IconButton>(find.byKey(TabletScreenHeader.backKey)).tooltip,
      fallback,
    );
    await tester.pumpWidget(page(tooltip: 'Later'));
    expect(
      tester.widget<IconButton>(find.byKey(TabletScreenHeader.backKey)).tooltip,
      'Later',
    );
  });
}
