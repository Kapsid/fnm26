import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/match/match_conditions.dart';
import 'package:fnm/features/match/conditions_note.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/pump_app.dart';

// Bolivia (57) hosting Argentina (56) in La Paz, with the manager away: the
// longest set of lines (altitude, plus the advice).
final _laPaz = MatchConditions.at(
  groundNationId: 57,
  city: 'La Paz',
  month: 10,
  homeNationId: 57,
  awayNationId: 56,
);

// England (14) against Germany (20) at a June finals in Doha (Qatar, 187):
// heat for both, and the advice.
final _doha = MatchConditions.at(
  groundNationId: 187,
  city: 'Doha',
  month: 6,
  homeNationId: 14,
  awayNationId: 20,
);

Future<void> _pump(
  WidgetTester tester,
  MatchConditions c, {
  required bool playerIsHome,
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = const Size(360, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Scaffold(
      body: MediaQuery(
        data: const MediaQueryData(
          size: Size(360, 900),
          textScaler: TextScaler.linear(1.4),
        ),
        // As the preview lays it out: the ground card, the note under it.
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const GroundCard(
                ground: (
                  stadium: 'Estadio Metropolitano Hernando Siles',
                  city: 'La Paz',
                  groundNationId: 57,
                  capacity: 42000,
                  attendance: 41800,
                  soldOut: false,
                ),
                neutral: true,
                groundNationCode: 'BOL',
              ),
              ConditionsNote(conditions: c, playerIsHome: playerIsHome),
            ],
          ),
        ),
      ),
    ),
    locale: locale,
  );
  await tester.pumpAndSettle();
}

void main() {
  test("who tires is said from the manager's side", () {
    final l = lookupAppLocalizations(const Locale('en'));
    final away = ConditionsNote.linesFor(l, _laPaz, playerIsHome: false);
    expect(away.first.$2, l.matchAltitudeYouTire(3640));
    expect(away.last.$2, l.matchConditionsAdvice);
    final home = ConditionsNote.linesFor(l, _laPaz, playerIsHome: true);
    expect(home.single.$2, l.matchAltitudeOpponentsTire(3640));
    expect(l.matchAltitudeYouTire(3640), contains('3,640'));
    final sea = MatchConditions.at(
      groundNationId: 39,
      city: 'Oslo',
      month: 6,
      homeNationId: 39,
      awayNationId: 14,
    );
    expect(ConditionsNote.linesFor(l, sea, playerIsHome: true), isEmpty);
  });

  for (final code in ['en', 'de', 'fi', 'hu', 'el', 'pt', 'fil']) {
    testWidgets('fits at 360 and 1.4 in $code', (tester) async {
      await _pump(tester, _laPaz, playerIsHome: false, locale: Locale(code));
      expect(tester.takeException(), isNull);
      await _pump(tester, _doha, playerIsHome: true, locale: Locale(code));
      expect(tester.takeException(), isNull);
      // The heat line and the advice under the ground card.
      expect(find.byIcon(Icons.thermostat_outlined), findsOneWidget);
      expect(find.byIcon(Icons.swap_horiz_rounded), findsOneWidget);
    });
  }
}
