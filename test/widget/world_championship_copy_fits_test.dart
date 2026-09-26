import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// "WORLD CHAMPIONSHIP" is eight letters longer than the name it replaced, and
/// the four headings that were still saying the old one are the four that had
/// never been measured against the new one.
///
/// Each case below builds the heading the way its screen builds it — same type
/// style, same container, same padding — and reads the words out of
/// [AppLocalizations] rather than repeating them, so lengthening the copy
/// lengthens what is measured. `WORLD CHAMPIONSHIP QUALIFYING DRAW` is the
/// wording this test rejected: at 320px it is 309px of heading in a 288px
/// column, which is why that one key says "WORLD QUALIFYING DRAW" instead.
///
/// Czech is measured alongside English because it is the longer language
/// nearly everywhere else, and because its counterparts here were left alone:
/// a heading that only ever grew in English still has to be checked in both.
const _widths = [320.0, 360.0, 400.0];
const _locales = ['en', 'cs'];

/// The year the ceremony headings print beside themselves. Four digits wide in
/// every language, so which year it is does not matter to a width.
const _year = 2030;

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  required double width,
  required String locale,
}) async {
  await tester.binding.setSurfaceSize(Size(width, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpApp(child, locale: Locale(locale));
  await tester.pump();
}

/// The record book's board heading: a standalone label above the card, in the
/// list's mobile margin. Mirrors `_Board` in `all_time_records_screen.dart`.
class _BoardHeading extends StatelessWidget {
  const _BoardHeading();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l.recordsMostWcStarts,
                style: AppTypography.labelMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// The host-draw plate: the competition name and the edition year on one
/// heading, at the top of the ceremony's list. Mirrors `host_draw_screen.dart`.
class _HostDrawHeading extends StatelessWidget {
  const _HostDrawHeading();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Text(
            '${l.tourDrawWcHost} · $_year',
            style: AppTypography.headlineMedium,
          ),
        ],
      ),
    );
  }
}

/// The qualifying-draw heading. `QualifyingDrawData.title` carries it, and the
/// tightest place it can land is the ceremony's centred app-bar title, beside
/// [AppLocalizations.tourContWorldQualifyingDraw] — which an app bar will
/// ellipsise rather than wrap, so this is the case with the least room of the
/// four.
class _QualifyingDrawHeading extends StatelessWidget {
  const _QualifyingDrawHeading();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          l.tourDrawWcQualifying,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
    );
  }
}

/// The opening-ceremony banner plate: the competition and its year in the
/// largest type any of the four appears in.
class _CeremonyBanner extends StatelessWidget {
  const _CeremonyBanner();

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Text(
            l.ceremonyWorldCupYear(_year),
            style: AppTypography.headlineMedium,
          ),
        ],
      ),
    );
  }
}

void main() {
  group('the record book says how many World Championship starts', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('the board heading is whole at $width in $locale', (
          tester,
        ) async {
          await _pump(
            tester,
            const _BoardHeading(),
            width: width,
            locale: locale,
          );
          expectLocale(tester, find.byType(_BoardHeading), locale);
          final l = AppLocalizations.of(
            tester.element(find.byType(_BoardHeading)),
          );
          final finder = find.text(l.recordsMostWcStarts);
          expect(
            finder,
            findsOneWidget,
            reason: '"${l.recordsMostWcStarts}" is not on screen',
          );
          expectWhole(finder, 'the starts board heading');
          // A board heading sits directly on top of its card; wrapping it
          // would push the first name down and read as a layout fault, so the
          // one line is the assertion, not just "nothing was cut".
          expectOneLine(finder, 'the starts board heading');
          expectNoBrokenWord(finder, 'the starts board heading');
        });
      }
    }
  });

  group('the host-draw plate names the competition in full', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('the host heading is whole at $width in $locale', (
          tester,
        ) async {
          await _pump(
            tester,
            const _HostDrawHeading(),
            width: width,
            locale: locale,
          );
          expectLocale(tester, find.byType(_HostDrawHeading), locale);
          final l = AppLocalizations.of(
            tester.element(find.byType(_HostDrawHeading)),
          );
          final heading = '${l.tourDrawWcHost} · $_year';
          final finder = find.text(heading);
          expect(finder, findsOneWidget, reason: '"$heading" is not on screen');
          // This one is ALLOWED to wrap — the continental heading beside it
          // already takes three lines at 320px, and there is nothing under it
          // to push out of the way. What it may not do is lose letters or
          // break CHAMPIONSHIP across two lines.
          expectWhole(finder, 'the host-draw heading');
          expectNoBrokenWord(finder, 'the host-draw heading');
        });
      }
    }
  });

  group('the qualifying-draw heading fits the tightest place it can land', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('the qualifying heading is whole at $width in $locale', (
          tester,
        ) async {
          await _pump(
            tester,
            const _QualifyingDrawHeading(),
            width: width,
            locale: locale,
          );
          expectLocale(tester, find.byType(_QualifyingDrawHeading), locale);
          final l = AppLocalizations.of(
            tester.element(find.byType(_QualifyingDrawHeading)),
          );
          final finder = find.text(l.tourDrawWcQualifying);
          expect(
            finder,
            findsOneWidget,
            reason: '"${l.tourDrawWcQualifying}" is not on screen',
          );
          // An app bar does not wrap: too wide here means letters gone.
          expectWhole(finder, 'the qualifying-draw heading');
          expectOneLine(finder, 'the qualifying-draw heading');
          expectNoBrokenWord(finder, 'the qualifying-draw heading');
        });
      }
    }
  });

  group('the ceremony banner names the competition and its year', () {
    for (final width in _widths) {
      for (final locale in _locales) {
        testWidgets('the banner plate is whole at $width in $locale', (
          tester,
        ) async {
          await _pump(
            tester,
            const _CeremonyBanner(),
            width: width,
            locale: locale,
          );
          expectLocale(tester, find.byType(_CeremonyBanner), locale);
          final l = AppLocalizations.of(
            tester.element(find.byType(_CeremonyBanner)),
          );
          final banner = l.ceremonyWorldCupYear(_year);
          final finder = find.text(banner);
          expect(finder, findsOneWidget, reason: '"$banner" is not on screen');
          expectWhole(finder, 'the ceremony banner');
          expectNoBrokenWord(finder, 'the ceremony banner');
        });
      }
    }
  });
}
