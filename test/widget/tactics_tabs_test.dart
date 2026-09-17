import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Reaching the tab controller from the wrong side of it.
///
/// The instructions moved from a bottom sheet to a tab, and two controls now
/// switch to it: the app-bar icon and the playstyle card on the lineup. Both
/// were first written against the screen's OWN context — which sits above the
/// DefaultTabController the screen creates, so the lookup throws the moment
/// either is tapped. A Builder is what puts them underneath it.
void main() {
  testWidgets('a control above the controller cannot reach it', (tester) async {
    Object? thrown;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (outer) => DefaultTabController(
            length: 2,
            child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () {
                      // The mistake: `outer` is the context ABOVE.
                      try {
                        DefaultTabController.of(outer).animateTo(1);
                      } catch (e) {
                        thrown = e;
                      }
                    },
                  ),
                ],
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'A'),
                    Tab(text: 'B'),
                  ],
                ),
              ),
              body: const TabBarView(children: [Text('A'), Text('B')]),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    expect(
      thrown,
      isNotNull,
      reason: 'this is the bug the Builder exists to prevent',
    );
  });
  testWidgets('a Builder puts the control underneath, and it moves', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.tune),
                    onPressed: () =>
                        DefaultTabController.of(context).animateTo(1),
                  ),
                ),
              ],
              bottom: const TabBar(
                tabs: [
                  Tab(text: 'A'),
                  Tab(text: 'B'),
                ],
              ),
            ),
            // Distinct from the tab LABELS, or one finder matches both.
            body: const TabBarView(
              children: [Text('lineup body'), Text('instructions body')],
            ),
          ),
        ),
      ),
    );
    final controller = DefaultTabController.of(
      tester.element(find.text('lineup body')),
    );
    expect(controller.index, 0);
    await tester.tap(find.byIcon(Icons.tune));
    await tester.pumpAndSettle();
    expect(
      controller.index,
      1,
      reason: 'the icon is a shortcut to the instructions tab',
    );
  });
}
