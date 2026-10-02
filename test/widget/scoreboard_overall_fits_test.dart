import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/features/match/match_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The live scoreboard says what each side is rated under its name. Polish
/// wrote that label so long that the number fell off the end of the line.
void main() {
  for (final code in const ['en', 'cs', 'fr', 'it', 'pl']) {
    testWidgets('$code: both ratings are shown whole at 320', (tester) async {
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
              homeOverall: 82,
              awayOverall: 89,
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
      for (final n in [82, 89]) {
        final text = '${l.teamOverall} $n';
        expect(find.text(text), findsOneWidget, reason: text);
        final paragraph = tester.renderObject<RenderParagraph>(
          find.text(text),
        );
        expect(paragraph.didExceedMaxLines, isFalse, reason: text);
      }
      expect(tester.takeException(), isNull);
    });
  }
}
