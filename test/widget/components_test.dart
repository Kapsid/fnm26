import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

void main() {
  group('PrimaryButton', () {
    testWidgets('renders label and fires onPressed', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        Scaffold(
          body: PrimaryButton(label: 'Play', onPressed: () => taps++),
        ),
      );

      expect(find.text('Play'), findsOneWidget);
      await tester.tap(find.text('Play'));
      expect(taps, 1);
    });

    testWidgets('a long label fits the button instead of overflowing', (
      tester,
    ) async {
      // The label sat in a Row with nothing constraining it, so a long one —
      // "Pozice plné — pořiďte si Pro pro 10" on a narrow phone — ran straight
      // out of the button and painted the yellow overflow stripes. A call to
      // action that cannot be read is not one.
      tester.view
        ..physicalSize = const Size(360, 780)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);

      await tester.pumpApp(
        Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: PrimaryButton(
              label: 'Pozice plné — pořiďte si Pro pro 10',
              icon: Icons.add,
              onPressed: () {},
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(
        tester.takeException(),
        isNull,
        reason: 'the label must not overflow the button',
      );
      expectNothingCut(tester);
    });

    testWidgets('the icon stays beside its label, centred, at any length', (
      tester,
    ) async {
      // The icon and the label are one group in the middle of the button.
      // Constraining the LABEL to stop it overflowing is the obvious fix and
      // the wrong one: a flex child forces a Row to take all the width it is
      // offered, defeating mainAxisSize.min — the label then spread across the
      // whole button and the icon was pinned to the far left of it, on every
      // screen with a primary button.
      for (final label in [
        'Go',
        'New Game',
        'Pozice plné — pořiďte si Pro pro 10',
      ]) {
        await tester.pumpApp(
          Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: PrimaryButton(
                label: label,
                icon: Icons.add,
                onPressed: () {},
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();

        final button = tester.getRect(find.byType(PrimaryButton));
        final icon = tester.getRect(find.byIcon(Icons.add));
        final text = tester.getRect(find.text(label));

        expect(
          (icon.left + text.right) / 2,
          closeTo(button.center.dx, 1.5),
          reason: '"$label": the icon and label should be centred together',
        );
        expect(
          icon.left,
          greaterThan(button.left + 4),
          reason: '"$label": the icon is jammed against the button edge',
        );
        expect(
          text.left - icon.right,
          lessThan(24),
          reason: '"$label": the icon drifted away from its label',
        );
        expect(tester.takeException(), isNull, reason: '"$label" overflowed');
        expectNothingCut(tester);
      }
    });

    testWidgets('does not fire while loading', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        Scaffold(
          body: PrimaryButton(
            label: 'Play',
            isLoading: true,
            onPressed: () => taps++,
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      await tester.tap(find.byType(PrimaryButton));
      expect(taps, 0);
    });
  });

  group('TacticalChip', () {
    testWidgets('uppercases its label', (tester) async {
      await tester.pumpApp(const Scaffold(body: TacticalChip('st')));
      expect(find.text('ST'), findsOneWidget);
    });
  });

  group('AppListRow', () {
    testWidgets('shows title/subtitle and responds to tap', (tester) async {
      var tapped = false;
      await tester.pumpApp(
        Scaffold(
          body: AppListRow(
            title: 'Alisson',
            subtitle: 'Goalkeeper',
            onTap: () => tapped = true,
          ),
        ),
      );

      expect(find.text('Alisson'), findsOneWidget);
      expect(find.text('Goalkeeper'), findsOneWidget);
      await tester.tap(find.byType(AppListRow));
      expect(tapped, isTrue);
    });
  });

  group('NationBadge', () {
    testWidgets('falls back to the country code', (tester) async {
      await tester.pumpApp(const Scaffold(body: NationBadge(code: 'bra')));
      expect(find.text('BRA'), findsOneWidget);
    });
  });

  group('StatBar', () {
    testWidgets('renders label and value', (tester) async {
      await tester.pumpApp(
        const Scaffold(body: StatBar(label: 'Pace', value: 88)),
      );
      expect(find.text('Pace'), findsOneWidget);
      expect(find.text('88'), findsOneWidget);
    });
  });

  group('AppTextField', () {
    testWidgets('shows label and forwards input', (tester) async {
      String? value;
      await tester.pumpApp(
        Scaffold(
          body: AppTextField(
            label: 'Manager name',
            hint: 'name',
            onChanged: (v) => value = v,
          ),
        ),
      );

      expect(find.text('MANAGER NAME'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'Alex');
      expect(value, 'Alex');
    });
  });
}
