import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// Every wording the big-match reactions added, at the narrowest phone (360
/// wide) and the app's text-size ceiling ([kMaxAppTextScale]), in the long
/// languages and Czech. A RenderFlex overflow is a Flutter error, so it fails
/// the test; a blank body fails it too.
///
/// Worst-case arguments throughout: the longest nation names the world
/// holds, a double-digit scoreline, a three-digit ranking gap, and the
/// longest handle the new casts can produce.
void main() {
  const added = <YTemplate>[
    YTemplate.winUpset,
    YTemplate.lostBadly,
    YTemplate.winRout,
    YTemplate.winShootout,
    YTemplate.knockoutWin,
    YTemplate.upsetGap,
    YTemplate.eatWords,
    YTemplate.awayFansWin,
    YTemplate.neutralWin,
    YTemplate.scorerHero,
    YTemplate.lostShock,
    YTemplate.lostRout,
    YTemplate.lostShootout,
    YTemplate.knockoutLoss,
    YTemplate.awayFansGloat,
    YTemplate.neutralLoss,
    YTemplate.downGap,
    YTemplate.drewHeroic,
    YTemplate.drewShame,
  ];

  const nation = 'Bosnia and Herzegovina';
  const opponent = 'Central African Republic';
  const player = 'Konstantinos Papadopoulos';

  List<String> argsFor(YTemplate t) => switch (t) {
    YTemplate.winShootout ||
    YTemplate.lostShootout ||
    YTemplate.eatWords => const [opponent],
    YTemplate.upsetGap || YTemplate.downGap => const [opponent, '146'],
    YTemplate.awayFansWin || YTemplate.awayFansGloat => const [nation, '10–0'],
    YTemplate.neutralWin ||
    YTemplate.neutralLoss => const [nation, opponent, '10–0'],
    YTemplate.scorerHero => const [player, opponent],
    _ => const [opponent, '10–0'],
  };

  // The longest name any account in the casts can carry, so the header row
  // is measured at its widest.
  final longest = YFeed.castNames.reduce(
    (a, b) => a.length >= b.length ? a : b,
  );

  for (final code in const ['de', 'fi', 'hu', 'el', 'pt', 'cs', 'en']) {
    testWidgets('$code: every big-match wording fits at 360 and 1.4', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      late AppLocalizations l;
      for (final t in added) {
        final count = YFeed.variantsFor(t);
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(code),
            theme: AppTheme.theme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                l = AppLocalizations.of(context);
                return MediaQuery(
                  data: MediaQuery.of(context).copyWith(
                    textScaler: const TextScaler.linear(kMaxAppTextScale),
                  ),
                  child: Scaffold(
                    body: SingleChildScrollView(
                      child: Column(
                        children: [
                          for (var v = 0; v < count; v++)
                            YPostTile(
                              post: (
                                voice: v.isEven ? YVoice.neutral : YVoice.away,
                                handle: '@$longest',
                                displayName: longest,
                                template: t,
                                variant: v,
                                args: argsFor(t),
                                date: DateTime(2030, 6, 10),
                                key: 'fx:$v|neutral|${t.name}',
                                replyTo: v % 3 == 2 ? 'fx:0' : null,
                                mood: null,
                              ),
                              onAccountTap: () {},
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$code ${t.name}');
        for (var v = 0; v < count; v++) {
          final body = yPostBody(l, (
            voice: YVoice.stats,
            handle: '@x',
            displayName: 'x',
            template: t,
            variant: v,
            args: argsFor(t),
            date: DateTime(2030),
            key: 'k',
            replyTo: null,
            mood: null,
          ));
          expect(body.trim(), isNotEmpty, reason: '$code ${t.name} v$v');
          // Every argument the wording takes actually reaches the screen.
          expect(body, isNot(contains('{')), reason: '$code ${t.name} v$v');
        }
      }
    });
  }
}
