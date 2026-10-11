import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/core/theme/app_typography.dart';
import 'package:fnm/core/util/career_label.dart';
import 'package:fnm/core/util/competition_label.dart';
import 'package:fnm/domain/services/competition/nations_cups.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/app_card.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// The North American and African Nations Cups brought two new cup names and
/// four zone names, and each lands in a heading on the cup's screen: the
/// app-bar title (upper-cased, beside a back button, two lines allowed because
/// "COUPE DES NATIONS D’AMÉRIQUE DU NORD" cannot fit one at 320px) and the
/// manager's own zone heading, which stays on one line. "CENTRAL AND SOUTHERN
/// ZONE · YOUR ZONE" did not fit even in English, so it is starred instead.
///
/// Both are built here the way `nations_cup_screen.dart` builds them, with the
/// words read out of [AppLocalizations], in all five languages.
const _widths = [320.0, 360.0, 400.0];
const _locales = ['en', 'cs', 'fr', 'it', 'pl', 'es', 'de'];

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

/// The cup screen's app bar. Mirrors `_NationsCupScreenState.build`.
class _CupTitle extends StatelessWidget {
  const _CupTitle(this.stored);

  final String stored;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.primary),
          onPressed: () {},
        ),
        title: Text(
          competitionLabel(l, stored).toUpperCase(),
          maxLines: 2,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: AppTypography.labelMedium.copyWith(color: AppColors.primary),
        ),
        centerTitle: true,
      ),
    );
  }
}

/// The ZONES tab's heading for the manager's own zone. Mirrors `_ZonesTab`.
class _ZoneHeading extends StatelessWidget {
  const _ZoneHeading(this.zone);

  final AfricaZone zone;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Text(
            l.tourContZoneHeadingYours(
              africaZoneLabel(l, zone).toUpperCase(),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.labelMedium.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

/// A tile on the tournaments screen: half the list's width, the name on up to
/// two lines under the trophy. Mirrors `_tileGrid` and `_ChampionshipTile`,
/// which print a Nations Cup tile as plain "Nations Cup" over a continent strap
/// because the full names need three lines there even in English.
class _CupTile extends StatelessWidget {
  const _CupTile(this.stored);

  final String stored;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context);
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.marginMobile),
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppCard(
                  child: Text(
                    NationsCups.isNationsCup(stored)
                        ? l.compNationsCup
                        : competitionLabel(l, stored),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.labelLarge,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Expanded(child: SizedBox.shrink()),
            ],
          ),
        ],
      ),
    );
  }
}

void main() {
  group('the tournaments tile names the new cups in full', () {
    for (final stored in [NationsCups.northAmerica, NationsCups.africa]) {
      for (final width in _widths) {
        for (final locale in _locales) {
          testWidgets('$stored at $width in $locale', (tester) async {
            await _pump(
              tester,
              _CupTile(stored),
              width: width,
              locale: locale,
            );
            expectLocale(tester, find.byType(_CupTile), locale);
            final l = AppLocalizations.of(
              tester.element(find.byType(_CupTile)),
            );
            final finder = find.text(l.compNationsCup);
            expect(finder, findsOneWidget);
            expectWhole(finder, 'the cup tile name');
            expectNoBrokenWord(finder, 'the cup tile name');
          });
        }
      }
    }
  });

  group('the cup screen names the new cups in full', () {
    for (final stored in [NationsCups.northAmerica, NationsCups.africa]) {
      for (final width in _widths) {
        for (final locale in _locales) {
          testWidgets('$stored at $width in $locale', (tester) async {
            await _pump(
              tester,
              _CupTitle(stored),
              width: width,
              locale: locale,
            );
            expectLocale(tester, find.byType(_CupTitle), locale);
            final l = AppLocalizations.of(
              tester.element(find.byType(_CupTitle)),
            );
            final title = competitionLabel(l, stored).toUpperCase();
            // Translated, not fallen through as the stored English.
            if (locale != 'en') {
              expect(title, isNot(stored.toUpperCase()));
            }
            final finder = find.text(title);
            expect(finder, findsOneWidget, reason: '"$title" is not on screen');
            expectWhole(finder, 'the cup title');
          });
        }
      }
    }
  });

  group("the manager's zone heading is whole", () {
    for (final zone in AfricaZone.values) {
      for (final width in _widths) {
        for (final locale in _locales) {
          testWidgets('${zone.name} at $width in $locale', (tester) async {
            await _pump(
              tester,
              _ZoneHeading(zone),
              width: width,
              locale: locale,
            );
            expectLocale(tester, find.byType(_ZoneHeading), locale);
            final l = AppLocalizations.of(
              tester.element(find.byType(_ZoneHeading)),
            );
            final heading = l.tourContZoneHeadingYours(
              africaZoneLabel(l, zone).toUpperCase(),
            );
            final finder = find.text(heading);
            expect(
              finder,
              findsOneWidget,
              reason: '"$heading" is not on screen',
            );
            expectWhole(finder, 'the zone heading');
          });
        }
      }
    }
  });
}
