import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/match/opponent_scouting.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/features/match/scout_report_view.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/tactics/squad_legend_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/fixtures.dart';

/// The community traits (1.1.5) on screen: named, explained and coloured as
/// the older ones are, in the squad legend, on the player and in the scout's
/// report, in every language.
const _community = {
  PlayerTrait.twelfthMan: true,
  PlayerTrait.consistent: true,
  PlayerTrait.inconsistent: false,
  PlayerTrait.injuryProne: false,
  PlayerTrait.easilyTired: false,
  PlayerTrait.poorUnderPressure: false,
  PlayerTrait.individualistic: false,
};

void main() {
  test('every language names and explains each, apart from English', () async {
    final en = await AppLocalizations.delegate.load(const Locale('en'));
    for (final locale in AppLocalizations.supportedLocales) {
      final l = await AppLocalizations.delegate.load(locale);
      for (final t in _community.keys) {
        final (_, name, blurb, positive) = describeTrait(l, t);
        expect(name.trim(), isNotEmpty, reason: '$locale $t');
        expect(blurb.trim(), isNotEmpty, reason: '$locale $t');
        expect(positive, _community[t], reason: '$t');
        if (locale.languageCode != 'en') {
          expect(blurb, isNot(describeTrait(en, t).$3), reason: '$locale $t');
        }
      }
      for (final n in ScoutTraitNote.values) {
        final line = scoutReportLines(
          l,
          ScoutReport(depth: ScoutDepth.detailed, traitNote: n),
          0,
        ).last;
        expect(line.trim(), isNotEmpty, reason: '$locale $n');
      }
    }
  });

  Widget app(Widget child) => MaterialApp(
    theme: AppTheme.theme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );

  testWidgets('the squad glyphs colour them as the older traits are', (
    tester,
  ) async {
    final good = player(
      id: 1,
      nationId: 1,
    ).copyWith(fixedTraits: const [PlayerTrait.twelfthMan]);
    final bad = player(
      id: 2,
      nationId: 1,
    ).copyWith(fixedTraits: const [PlayerTrait.injuryProne]);
    await tester.pumpWidget(
      app(
        Column(
          children: [
            PlayerTraitGlyphs(player: good, saveSeed: 0),
            PlayerTraitGlyphs(player: bad, saveSeed: 0),
          ],
        ),
      ),
    );
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    Icon iconOf(PlayerTrait t) =>
        tester.widget<Icon>(find.byIcon(describeTrait(l, t).$1));
    expect(iconOf(PlayerTrait.twelfthMan).color, AppColors.positive);
    expect(iconOf(PlayerTrait.injuryProne).color, AppColors.warning);
    expect(find.byTooltip(l.traitTwelfthMan), findsOneWidget);
    expect(find.byTooltip(l.traitInjuryProne), findsOneWidget);
  });

  testWidgets('the squad legend lists every one', (tester) async {
    tester.view
      ..physicalSize = const Size(400, 4000)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      app(
        Builder(
          builder: (context) => TextButton(
            onPressed: () => showSquadLegend(context),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    for (final t in _community.keys) {
      final (_, name, blurb, _) = describeTrait(l, t);
      expect(find.text(name), findsOneWidget, reason: '$t');
      expect(find.text(blurb), findsOneWidget, reason: '$t');
    }
  });

  test("the scout's report says it from a good scout up", () async {
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    final lines = scoutReportLines(
      l,
      const ScoutReport(
        depth: ScoutDepth.detailed,
        traitNote: ScoutTraitNote.easilyTired,
      ),
      0,
    );
    expect(lines, contains(l.matchScoutTraitEasilyTired));
  });
}
