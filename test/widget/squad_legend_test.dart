import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/features/player/player_detail_screen.dart'
    show describeTrait;
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';

/// The key to the marks on a squad row.
///
/// A tester read the form arrows, guessed the flame and could not work out the
/// star, the tick or the trait glyphs. The icons are not the problem, a
/// hundred-player list cannot spell each state out on every line; having
/// nowhere to look them up was.
void main() {
  Future<AppLocalizations> loc(Locale l) => AppLocalizations.delegate.load(l);

  for (final locale in [const Locale('en'), const Locale('cs')]) {
    testWidgets('${locale.languageCode}: every trait is named and explained', (
      tester,
    ) async {
      final l = await loc(locale);
      for (final t in PlayerTrait.values) {
        final (icon, name, blurb, _) = describeTrait(l, t);
        expect(icon, isNotNull);
        expect(name.trim(), isNotEmpty, reason: '$t has no name');
        expect(blurb.trim(), isNotEmpty, reason: '$t has no explanation');
      }
    });

    testWidgets('${locale.languageCode}: no two traits share a glyph', (
      tester,
    ) async {
      final l = await loc(locale);
      final seen = <IconData, PlayerTrait>{};
      for (final t in PlayerTrait.values) {
        final (icon, _, _, _) = describeTrait(l, t);
        expect(
          seen[icon],
          isNull,
          reason: 'the legend cannot tell $t from ${seen[icon]}: same icon',
        );
        seen[icon] = t;
      }
    });

    for (final width in [320.0, 360.0, 400.0]) {
      testWidgets(
        '${locale.languageCode}: the legend fits at ${width.toInt()}px',
        (tester) async {
          tester.view
            ..physicalSize = Size(width, 1600)
            ..devicePixelRatio = 1.0;
          addTearDown(tester.view.reset);

          final l = await loc(locale);
          await tester.pumpWidget(
            MaterialApp(
              theme: AppTheme.theme,
              locale: locale,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l.squadLegendTitle),
                      Text(l.squadLegendStarting),
                      Text(l.squadLegendCalledUp),
                      Text(l.squadLegendRatingUp),
                      Text(l.squadLegendRatingDown),
                      Text(l.squadLegendInjured),
                      Text(l.squadLegendSuspended),
                      Text(l.squadLegendTraits),
                      for (final t in PlayerTrait.values) ...[
                        Text(describeTrait(l, t).$2),
                        Text(describeTrait(l, t).$3),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          );
          await tester.pumpAndSettle();
          expect(tester.takeException(), isNull);
          expectNothingCut(tester);
          // The blurbs are allowed to wrap, so expectNothingCut cannot fail on
          // them. What must not happen is a single word too long for the
          // column, which is what this catches.
          expectNoBrokenWord(
            find.byType(Text),
            'the legend in ${locale.languageCode} at ${width.toInt()}px',
          );
        },
      );
    }
  }
}
