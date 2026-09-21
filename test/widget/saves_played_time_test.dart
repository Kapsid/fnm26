import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/features/career/saves_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// What the saves list says about how long a career has had of your life.
void main() {
  late AppLocalizations l;

  Future<void> pumpL10n(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            l = AppLocalizations.of(context);
            return const SizedBox();
          },
        ),
      ),
    );
  }

  testWidgets('a save just started says nothing yet', (tester) async {
    await pumpL10n(tester);
    // A row reading "0m" beside a clock looks like a bug, not a new save.
    expect(playedLabel(l, 0), isNull);
    expect(playedLabel(l, 59), isNull);
  });

  testWidgets('minutes up to an hour', (tester) async {
    await pumpL10n(tester);
    expect(playedLabel(l, 60), '1m');
    expect(playedLabel(l, 90), '1m');
    expect(playedLabel(l, 45 * 60), '45m');
  });

  testWidgets('hours and minutes beyond that', (tester) async {
    await pumpL10n(tester);
    expect(playedLabel(l, 3600), '1h 0m');
    expect(playedLabel(l, 3600 * 3 + 60 * 24), '3h 24m');
    // A long career reads in hours, never in days — a manager counts hours.
    expect(playedLabel(l, 3600 * 40), '40h 0m');
  });

  testWidgets('the seconds are never shown', (tester) async {
    await pumpL10n(tester);
    expect(playedLabel(l, 3600 * 2 + 60 * 14 + 37), '2h 14m');
  });
}
