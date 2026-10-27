import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/qualification_format.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_bracket.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_providers.dart';
import 'package:fnm/features/tournaments/intercontinental_playoff_screen.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/pump_app.dart';

/// Playtest: "I qualified automatically for the World Championship but was not
/// able to see how the European play-offs played out."
///
/// There is no European play-off to show. Europe sends nobody to the
/// intercontinental play-off, and all sixteen of its places are decided in
/// its qualifying groups. The play-off views now say so, so the manager looking
/// for one is told where Europe's places were really won.
void main() {
  final l = AppLocalizationsEn();

  test('Europe is the confederation with no play-off, and says so', () {
    expect(
      QualificationFormat.forConfederation(
        Confederation.europe,
      ).playoffEntrants,
      0,
    );
    expect(noPlayoffNotes(l), [l.tourCupPlayoffNoEntrants(l.confEurope)]);
  });

  test('every confederation without a play-off entrant gets a note', () {
    final without = [
      for (final c in Confederation.values)
        if (QualificationFormat.forConfederation(c).playoffEntrants == 0) c,
    ];
    expect(noPlayoffNotes(l), hasLength(without.length));
  });

  testWidgets('the play-off screen tells a European manager why Europe is '
      'not in it', (tester) async {
    await tester.pumpApp(
      const IntercontinentalPlayoffScreen(careerId: 1),
      overrides: [
        intercontinentalPlayoffProvider(
          1,
        ).overrideWith((ref) async => fakePlayoff(1)),
      ],
    );
    await tester.pumpAndSettle();
    expect(find.byType(IntercontinentalPlayoffBracket), findsOneWidget);
    expect(find.text(l.tourCupPlayoffNoEntrants(l.confEurope)), findsOneWidget);
  });
}
