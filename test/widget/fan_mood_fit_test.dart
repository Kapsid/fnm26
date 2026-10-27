import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/domain/services/match/attendance.dart';
import 'package:fnm/domain/services/press/fan_mood.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/features/match/ground_card.dart';
import 'package:fnm/features/y/fan_mood_text.dart';
import 'package:fnm/features/y/y_screen.dart';
import 'package:fnm/l10n/app_localizations.dart';

/// The stands' copy at the narrowest phone (360 wide) and the app's text-size
/// ceiling, in the long languages, Czech and English: the protest and
/// sell-out posts, the venue card's mood line and the finances line. A
/// RenderFlex overflow is a Flutter error and fails the test.
void main() {
  const nation = 'Bosnia and Herzegovina';
  const manager = 'Papadopoulos-Konstantinidis';
  final longest = YFeed.castNames.reduce(
    (a, b) => a.length >= b.length ? a : b,
  );
  const ground = (
    stadium: 'Stadion Maksimir Narodni Stadion',
    city: 'Ciudad de los Deportes',
    groundNationId: 1,
    capacity: 65000,
    attendance: 64500,
    soldOut: true,
  );

  for (final code in const [
    'de',
    'fi',
    'hu',
    'el',
    'pt',
    'cs',
    'en',
    'ro',
    'uk',
    'fil',
    'ms',
  ]) {
    testWidgets('$code: the stands fit at 360 and 1.4', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      late AppLocalizations l;
      Widget host(Widget Function() child) => MaterialApp(
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
              child: Scaffold(body: SingleChildScrollView(child: child())),
            );
          },
        ),
      );

      for (final t in const [YTemplate.fansProtest, YTemplate.fansSellOut]) {
        final count = YFeed.variantsFor(t);
        final args = t == YTemplate.fansProtest
            ? const [nation, manager]
            : const [nation];
        await tester.pumpWidget(
          host(
            () => Column(
              children: [
                for (var v = 0; v < count; v++)
                  YPostTile(
                    post: (
                      voice: YVoice.fan,
                      handle: '@$longest',
                      displayName: longest,
                      template: t,
                      variant: v,
                      args: args,
                      date: DateTime(2030, 6, 10),
                      key: 'fans:fx:$v|fan|${t.name}',
                      replyTo: null,
                      mood: null,
                    ),
                    onAccountTap: () {},
                  ),
              ],
            ),
          ),
        );
        await tester.pump();
        expect(tester.takeException(), isNull, reason: '$code ${t.name}');
        for (var v = 0; v < count; v++) {
          final body = yPostBody(l, (
            voice: YVoice.fan,
            handle: '@x',
            displayName: 'x',
            template: t,
            variant: v,
            args: args,
            date: DateTime(2030),
            key: 'k',
            replyTo: null,
            mood: null,
          ));
          expect(body.trim(), isNotEmpty, reason: '$code ${t.name} v$v');
          expect(body, isNot(contains('{')), reason: '$code ${t.name} v$v');
          expect(body, isNot(contains('—')), reason: '$code ${t.name}');
        }
      }

      // The venue card and the finances line, in every band.
      await tester.pumpWidget(
        host(
          () => Column(
            children: [
              for (final band in FanMoodBand.values) ...[
                GroundCard(ground: ground, groundNationCode: 'BIH', fans: band),
                // Both badges at once: neutral ground and sold out.
                GroundCard(
                  ground: ground,
                  neutral: true,
                  groundNationCode: 'BIH',
                  fans: band,
                ),
                GroundCard(
                  ground: ground,
                  compact: true,
                  groundNationCode: 'BIH',
                  fans: band,
                ),
                FanMoodRow(
                  band: band,
                  label: l.federationFans(fanMoodLabel(l, band)),
                  detail: l.federationFansIncome('-20%'),
                ),
              ],
            ],
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull, reason: '$code ground card');
      for (final band in FanMoodBand.values) {
        expect(
          find.text(l.matchHomeFans(fanMoodLabel(l, band))),
          findsNWidgets(3),
        );
      }
    });
  }

  test('the income change is written the way each language writes it', () {
    expect(signedPercent(10, 'en'), '+10%');
    expect(signedPercent(-20, 'en'), '-20%');
    expect(signedPercent(10, 'fr'), '+10\u00a0%');
    expect(signedPercent(10, 'tr'), '+%10');
    for (final code in AppLocalizations.supportedLocales) {
      final s = signedPercent(-10, code.toLanguageTag());
      expect(s, contains('10'), reason: '$code');
      expect(s, isNot(contains('{')), reason: '$code');
    }
  });

  testWidgets('no mood line where the crowd is not ours', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: GroundCard(ground: ground)),
      ),
    );
    expect(find.byType(FanMoodRow), findsNothing);
    expect(Attendance.atmosphere(ground), greaterThan(1));
  });
}
