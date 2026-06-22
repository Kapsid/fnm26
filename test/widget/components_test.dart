import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/shared/widgets/widgets.dart';

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
