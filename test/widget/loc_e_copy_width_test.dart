import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations_cs.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// The width of the copy this batch added, in both languages, at 320/360/400.
///
/// A widget test renders in Flutter's fallback face, which draws every glyph a
/// full em wide where the app's own faces are nearer six tenths;
/// `expect_whole.dart` says so at the top and warns that a whole-screen sweep
/// at 320 therefore fails on ALL-CAPS headings that fit a phone perfectly
/// well. Nearly every string this batch added is ALL-CAPS in a narrow box, so
/// the sweep is asked three questions instead of one, each in the place where
/// its answer means something:
///
/// * copy that CANNOT wrap (an app-bar title, the clock plate) is judged on
///   the width it will want on a phone, converted off the fallback face by the
///   ratio that file states;
/// * copy that CAN wrap is asked only whether any single word is too long to
///   fit, which is the failure that actually reads as a rendering fault;
/// * copy in the narrowest box of all — a competition tile's zone strap — is
///   also asked whether the Czech grew against the English, which the fallback
///   face cannot distort because both sides are measured in it.
void main() {
  /// The fallback face against the app's own: a test measurement times this is
  /// roughly what a phone will want. Stated in `expect_whole.dart`.
  const phoneFace = 0.6;

  /// The width a competition tile really gives its text: two tiles per row
  /// inside the page margin, with the card's own padding taken off.
  double tileColumn(double screen) =>
      (screen - 2 * AppSpacing.marginMobile - AppSpacing.sm) / 2 -
      2 * AppSpacing.md;

  /// The width an [AppBar] title really gets: the bar less the close button on
  /// one side and the symmetry Flutter reserves on the other.
  double appBarTitle(double screen) => screen - 2 * 56;

  /// The width the clock plate's text gets: the page margin, the card's
  /// padding and the plate's own padding, all taken off.
  double clockPlate(double screen) =>
      screen - 2 * AppSpacing.marginMobile - 2 * AppSpacing.md - 2 * 16;

  /// The width a card in the page gives a paragraph.
  double cardBody(double screen) =>
      screen - 2 * AppSpacing.marginMobile - 2 * AppSpacing.md;

  /// Lays out [text] in [style] at unbounded width and returns what it wants.
  Future<double> wants(
    WidgetTester tester,
    String text,
    TextStyle style,
  ) async {
    await tester.pumpApp(Align(child: Text(text, style: style)));
    final paragraph =
        find.text(text).evaluate().single.renderObject! as RenderParagraph;
    return paragraph.getMaxIntrinsicWidth(double.infinity);
  }

  /// Pumps [strings] each on its own line in a [width]-wide column.
  Future<void> pumpColumn(
    WidgetTester tester,
    List<String> strings,
    TextStyle style,
    double width,
    String locale, {
    int? maxLines,
  }) => tester.pumpApp(
    Align(
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final s in strings)
              Text(
                s,
                style: style,
                maxLines: maxLines,
                overflow: maxLines == null ? null : TextOverflow.ellipsis,
              ),
          ],
        ),
      ),
    ),
    locale: Locale(locale),
  );

  final en = AppLocalizationsEn();
  final cs = AppLocalizationsCs();

  final screens = [320.0, 360.0, 400.0];

  group('copy that cannot wrap fits the box it is given', () {
    /// (what, the string, its style, the box it sits in).
    final oneLine =
        <
          ({
            String what,
            String text,
            TextStyle style,
            double Function(double) box,
          })
        >[
          for (final l in [en, cs]) ...[
            (
              what: 'the shootout clock plate (${l.localeName})',
              text: l.matchClockFullTimePenalties,
              style: AppTypography.labelMedium,
              box: clockPlate,
            ),
            (
              what: 'the extra-time clock plate (${l.localeName})',
              text: l.matchClockAfterExtraTime,
              style: AppTypography.labelMedium,
              box: clockPlate,
            ),
            (
              what: 'the full-time clock plate (${l.localeName})',
              text: l.matchClockFullTime,
              style: AppTypography.labelMedium,
              box: clockPlate,
            ),
            (
              what: 'the penalties clock plate (${l.localeName})',
              text: l.matchClockPenalties,
              style: AppTypography.labelMedium,
              box: clockPlate,
            ),
            (
              what: 'the world qualifying draw title (${l.localeName})',
              text: l.tourContWorldQualifyingDraw,
              style: AppTypography.labelMedium,
              box: appBarTitle,
            ),
            (
              what: 'the qualifying draw title (${l.localeName})',
              text: l.tourContQualifyingDraw,
              style: AppTypography.labelMedium,
              box: appBarTitle,
            ),
            (
              what: 'the finals draw title (${l.localeName})',
              text: l.tourContFinalsDraw,
              style: AppTypography.labelMedium,
              box: appBarTitle,
            ),
            (
              what: 'the seeding pots title (${l.localeName})',
              text: l.tourContSeedingPots,
              style: AppTypography.labelMedium,
              box: appBarTitle,
            ),
          ],
        ];

    for (final screen in screens) {
      for (final one in oneLine) {
        testWidgets('${one.what} at ${screen.toInt()}', (tester) async {
          final measured = await wants(tester, one.text, one.style);
          final onAPhone = measured * phoneFace;
          expect(
            onAPhone,
            lessThanOrEqualTo(one.box(screen)),
            reason:
                '${one.what}: "${one.text}" wants about '
                '${onAPhone.round()}pt on a phone in a '
                '${one.box(screen).round()}pt box, so it wraps out of a place '
                'that has room for one line. Write it shorter.',
          );
        });
      }
    }
  });

  group('copy that wraps never breaks a word', () {
    for (final screen in screens) {
      for (final l in [en, cs]) {
        testWidgets(
          'the ladder line at ${screen.toInt()} in ${l.localeName}',
          (tester) async {
            final lines = [
              l.tourThirdsAdvance(8, l.tourCupDestKnockouts),
              l.tourThirdsAdvance(8, l.tourCupDestFinals),
              l.tourThirdsAdvance(8, l.tourCupDestFinalsPlayoff),
              l.tourThirdsAdvance(8, l.tourCupDestIntercontPlayoff),
            ];
            await pumpColumn(
              tester,
              lines,
              AppTypography.labelSmall,
              cardBody(screen),
              l.localeName,
            );
            for (final line in lines) {
              expectNoBrokenWord(find.text(line), '"$line"');
            }
          },
        );
      }
    }

    for (final screen in screens) {
      testWidgets('the Czech zone straps at ${screen.toInt()}', (tester) async {
        final straps = [
          cs.tourZoneGlobal,
          cs.tourZoneEurope,
          cs.tourZoneSouthAmerica,
          cs.tourZoneNorthAmerica,
          cs.tourZoneAfrica,
          cs.tourZoneAsia,
          cs.tourZoneOceania,
          cs.tourZoneIntercontinental,
          cs.tourZoneLeague('A'),
        ];
        await pumpColumn(
          tester,
          straps,
          AppTypography.labelSmall,
          tileColumn(screen),
          'cs',
        );
        for (final strap in straps) {
          expectNoBrokenWord(find.text(strap), 'the "$strap" strap');
        }
      });
    }
  });

  group('a tile name is printed whole', () {
    // The one string on a tile with a maxLines, so the one that is cut outright
    // rather than wrapped.
    for (final screen in screens) {
      for (final names in [
        (locale: 'en', values: ['World Championship', 'European Championship']),
        (locale: 'cs', values: ['Světový šampionát', 'Evropský šampionát']),
      ]) {
        testWidgets('at ${screen.toInt()} in ${names.locale}', (tester) async {
          await pumpColumn(
            tester,
            names.values,
            AppTypography.labelLarge,
            tileColumn(screen),
            names.locale,
            maxLines: 2,
          );
          for (final name in names.values) {
            expectWhole(find.text(name), '"$name" in a ${screen.toInt()} tile');
          }
        });
      }
    }
  });

  group('the Czech never grew against the English', () {
    // Only for the narrowest boxes, where a longer Czech string has nowhere to
    // go. Elsewhere Czech is simply the longer language and that is allowed.
    final narrow = <({String what, String en, String cs, TextStyle style})>[
      (
        what: 'the shootout clock plate',
        en: en.matchClockFullTimePenalties,
        cs: cs.matchClockFullTimePenalties,
        style: AppTypography.labelMedium,
      ),
      (
        what: 'the full-time clock plate',
        en: en.matchClockFullTime,
        cs: cs.matchClockFullTime,
        style: AppTypography.labelMedium,
      ),
      (
        what: 'the extra-time clock plate',
        en: en.matchClockAfterExtraTime,
        cs: cs.matchClockAfterExtraTime,
        style: AppTypography.labelMedium,
      ),
      (
        what: 'the penalties clock plate',
        en: en.matchClockPenalties,
        cs: cs.matchClockPenalties,
        style: AppTypography.labelMedium,
      ),
      for (final zone in [
        ('global', en.tourZoneGlobal, cs.tourZoneGlobal),
        ('Europe', en.tourZoneEurope, cs.tourZoneEurope),
        ('South America', en.tourZoneSouthAmerica, cs.tourZoneSouthAmerica),
        ('North America', en.tourZoneNorthAmerica, cs.tourZoneNorthAmerica),
        ('Africa', en.tourZoneAfrica, cs.tourZoneAfrica),
        ('Asia', en.tourZoneAsia, cs.tourZoneAsia),
        ('Oceania', en.tourZoneOceania, cs.tourZoneOceania),
        (
          'intercontinental',
          en.tourZoneIntercontinental,
          cs.tourZoneIntercontinental,
        ),
        ('league', en.tourZoneLeague('A'), cs.tourZoneLeague('A')),
      ])
        (
          what: 'the ${zone.$1} zone strap',
          en: zone.$2,
          cs: zone.$3,
          style: AppTypography.labelSmall,
        ),
    ];

    for (final pair in narrow) {
      testWidgets(pair.what, (tester) async {
        final english = await wants(tester, pair.en, pair.style);
        final czech = await wants(tester, pair.cs, pair.style);
        expect(
          czech,
          lessThanOrEqualTo(english),
          reason:
              '${pair.what}: "${pair.cs}" wants ${czech.round()}px against '
              '"${pair.en}" at ${english.round()}px, and this box has no room '
              'to spare. Write the Czech shorter.',
        );
      });
    }
  });

  test('the copy really is in both languages', () {
    // Cheap insurance against a key added to the English arb and forgotten in
    // the Czech one: gen-l10n falls back silently to English, and the
    // comparisons above would then pass by comparing English with itself.
    expect(cs.matchClockFullTime, isNot(en.matchClockFullTime));
    expect(cs.tourContSeedingPots, isNot(en.tourContSeedingPots));
    expect(cs.tourContFinalsDraw, isNot(en.tourContFinalsDraw));
    expect(
      cs.tourContWorldQualifyingDraw,
      isNot(en.tourContWorldQualifyingDraw),
    );
    expect(cs.tourZoneGlobal, isNot(en.tourZoneGlobal));
    expect(cs.tourZoneIntercontinental, isNot(en.tourZoneIntercontinental));
    expect(cs.tourCupDestKnockouts, isNot(en.tourCupDestKnockouts));
  });
}
