import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The live scoreboard carries no team rating: the pre-match screen shows it,
/// and once the game is on the score is what matters.
void main() {
  for (final code in const ['en', 'cs', 'fr', 'it', 'pl', 'es', 'de']) {
    testWidgets('$code: no rating on the live scoreboard', (tester) async {
      tester.view
        ..physicalSize = const Size(320, 800)
        ..devicePixelRatio = 1.0;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.theme,
          locale: Locale(code),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const Scaffold(
            body: MatchScoreboard(
              homeCode: 'POL',
              awayCode: 'POR',
              homeName: 'Polska',
              awayName: 'Portugalia',
              homeScore: 1,
              awayScore: 2,
              clock: "67'",
              live: true,
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final l = await AppLocalizations.delegate.load(Locale(code));
      expect(find.textContaining(l.teamOverall), findsNothing);
      expect(tester.takeException(), isNull);
    });
  }
}
