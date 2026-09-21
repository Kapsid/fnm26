import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/util/app_date.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/hub/hub_screen.dart';
import 'package:fnm/features/match/match_preview_screen.dart';
import 'package:fnm/features/results/results_providers.dart';
import 'package:fnm/features/results/results_screen.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

/// Dates in the manager's own language, and the room they take to say it.
///
/// A Czech save read "1 Sep 2030" on its dashboard because all twelve
/// `DateFormat`s in the app were built without a locale, and a locale-less
/// `DateFormat` asks `Intl.defaultLocale`, which nothing here has ever set.
/// They all go through [AppDate] now, so the first half of this file asks the
/// one question that matters: does the same date read Czech in Czech and
/// English in English? The second test of each pair is not a formality — it is
/// what fails if somebody "fixes" this by hard-coding `'cs'`.
///
/// The locale data itself needs no loading. `GlobalMaterialLocalizations`,
/// which `pumpApp` puts on the tree exactly as the real app does, registers
/// the date symbols for every locale it ships the moment it loads. Without it
/// `DateFormat('d MMM', 'cs')` throws `LocaleDataException`, which is worth
/// knowing before trusting a single line below.
void main() {
  /// Thirtieth of November 2030, a Saturday: two digits of day, and a month
  /// whose Czech abbreviation ("lis") is nothing like its English one.
  final day = DateTime(2030, 11, 30);

  /// Formats [date] with [write] in [locale], by pumping it.
  Future<String> written(
    WidgetTester tester,
    String locale,
    String Function(BuildContext, DateTime) write, {
    DateTime? date,
  }) async {
    late String out;
    await tester.pumpApp(
      Builder(
        builder: (context) {
          out = write(context, date ?? day);
          return const SizedBox.shrink();
        },
      ),
      locale: Locale(locale),
    );
    return out;
  }

  group('a date is written in the language the manager reads', () {
    testWidgets('a full date', (tester) async {
      expect(await written(tester, 'cs', AppDate.dayMonthYear), '30. lis 2030');
      expect(await written(tester, 'en', AppDate.dayMonthYear), '30 Nov 2030');
    });

    testWidgets('a day without its year', (tester) async {
      expect(await written(tester, 'cs', AppDate.dayMonth), '30. lis');
      expect(await written(tester, 'en', AppDate.dayMonth), '30 Nov');
    });

    testWidgets('a date squeezed into a narrow column', (tester) async {
      expect(
        await written(tester, 'cs', AppDate.dayMonthShortYear),
        '30. lis 30',
      );
      expect(
        await written(tester, 'en', AppDate.dayMonthShortYear),
        '30 Nov 30',
      );
    });

    testWidgets('a month on its own', (tester) async {
      expect(await written(tester, 'cs', AppDate.monthYear), 'lis 2030');
      expect(await written(tester, 'en', AppDate.monthYear), 'Nov 2030');
    });

    testWidgets('the kick-off stamp keeps its diacritics in upper case', (
      tester,
    ) async {
      // The one result `toUpperCase` could have ruined. Czech raises č to Č
      // and á to Á; a mapping that stripped the marks would read "PA 30. LIS",
      // which is not a word.
      expect(
        await written(
          tester,
          'cs',
          AppDate.weekdayDayMonthCaps,
          date: DateTime(2030, 6, 7),
        ),
        'PÁ 7. ČVN',
      );
      expect(
        await written(tester, 'cs', AppDate.weekdayDayMonthCaps),
        'SO 30. LIS',
      );
      expect(
        await written(tester, 'en', AppDate.weekdayDayMonthCaps),
        'SAT 30 NOV',
      );
    });

    testWidgets('a date follows the language the screen around it is in', (
      tester,
    ) async {
      // Portuguese is neither of the two languages this app speaks. Flutter
      // resolves an unknown one to the FIRST entry in `supportedLocales`,
      // which gen-l10n sorts alphabetically, so a Portuguese phone is shown
      // Czech. Whatever one thinks of that, the date has to agree with the
      // words around it rather than going off on its own — which is what it
      // did before [AppDate], when every screen in the game could be Czech
      // and every date on it English.
      late Locale resolved;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            resolved = Localizations.localeOf(context);
            return const SizedBox.shrink();
          },
        ),
        locale: const Locale('pt'),
      );
      expect(
        await written(tester, 'pt', AppDate.dayMonthYear),
        resolved.languageCode == 'cs' ? '30. lis 2030' : '30 Nov 2030',
      );
    });

    test('the ranking axis is the same in both languages', () {
      // Two digits, a slash, two digits: no word in it to translate, and it is
      // drawn inside a CustomPainter that has no BuildContext to ask.
      expect(AppDate.monthYearNumeric(day), '11/30');
    });
  });

  // ---------------------------------------------------------------- width --

  /// How much room the one date on screen is asking for.
  ///
  /// What this measures, beside [expectNothingCut], is how much MORE room
  /// Czech asks for than English. The answer has to be about one character:
  /// the full stop that makes the day an ordinal. A Czech date that grew to a
  /// full month name — "30. listopadu 2030" — would blow the budget by eight
  /// characters, and that is the change that would burst these rows on a real
  /// phone.
  ///
  /// Which language comes out WIDER is not asserted, and the reason is worth
  /// keeping: it depends on the face. In Flutter's fallback font every glyph
  /// is a full em, so the language with more characters always wins; in Hanken
  /// Grotesk, which `test/flutter_test_config.dart` now loads, "30. lis 2030"
  /// is narrower than "30 Nov 2030" despite being longer. The budget is
  /// two-sided for that reason.
  /// The one date on screen, as it READS — so a test can prove the language
  /// it rendered before it measures anything about the width.
  String dateText(WidgetTester tester) {
    final dates = find.byType(Text).evaluate().where((element) {
      final data = (element.widget as Text).data;
      return data != null && data.contains('30');
    }).toList();
    expect(dates, hasLength(1), reason: 'exactly one date should be on screen');
    return (dates.single.widget as Text).data!;
  }

  double dateWidth(WidgetTester tester) {
    final dates = find.byType(Text).evaluate().where((element) {
      final data = (element.widget as Text).data;
      return data != null && data.contains('30');
    }).toList();
    expect(dates, hasLength(1), reason: 'exactly one date should be on screen');
    return (dates.single.renderObject! as RenderParagraph).getMaxIntrinsicWidth(
      double.infinity,
    );
  }

  /// One character of the style the date is set in, with a little slack.
  double oneCharacter(double fontSize) => fontSize * 1.2;

  Future<void> pumpAt(
    WidgetTester tester,
    Widget child, {
    required double width,
    required String locale,
    List<Override> overrides = const [],
  }) async {
    tester.view
      ..physicalSize = Size(width, 1600)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      child,
      locale: Locale(locale),
      overrides: overrides,
    );
    await tester.pumpAndSettle();
  }

  // The dashboard header, laid out the way the dashboard lays it out: the same
  // list, the same side padding, so it gets the width it gets on the phone.
  Widget header() => ListView(
    padding: const EdgeInsets.all(16),
    children: [
      Builder(
        builder: (context) => HubHeader(
          code: 'BRA',
          nationName: 'Brazil',
          managerName: 'M. Urbanczyk',
          date: AppDate.dayMonthYear(context, day),
          rank: 12,
          movement: 21,
        ),
      ),
    ],
  );

  Widget headline() => Padding(
    padding: const EdgeInsets.all(16),
    child: MatchHeadline(
      homeCode: 'BRA',
      homeOverall: 82,
      awayCode: 'ARG',
      awayOverall: 84,
      date: day,
    ),
  );

  const careerId = 7;
  final nations = {
    for (var i = 1; i <= 3; i++)
      i: Nation(
        id: i,
        name: 'Nation $i',
        code: 'N$i',
        confederation: Confederation.europe,
        ranking: i,
      ),
  };
  // Four played group matches, all in November so every row carries the
  // longest Czech month abbreviation there is.
  final fixtures = [
    for (var i = 1; i <= 4; i++)
      Fixture(
        id: i,
        careerId: careerId,
        competitionId: 20,
        matchday: i,
        date: DateTime(2030, 11, 30 - i),
        homeNationId: 1,
        awayNationId: i.isEven ? 2 : 3,
        homeScore: 2,
        awayScore: 1,
        played: true,
        round: 'GROUP',
      ),
  ];

  for (final width in [360.0, 400.0]) {
    group('at ${width.toInt()}px', () {
      testWidgets('the results rows hold every date whole, in both languages', (
        tester,
      ) async {
        for (final locale in ['en', 'cs']) {
          await pumpAt(
            tester,
            const ResultsScreen(careerId: careerId),
            width: width,
            locale: locale,
            overrides: [
              resultsProvider(careerId).overrideWith(
                (ref) async => ResultsData(
                  fixtures: fixtures,
                  nations: nations,
                  playerNationId: 1,
                ),
              ),
            ],
          );
          // The date sits beside a stage name that is given the leftover
          // width, so this row can genuinely run out of room and say so.
          expectNothingCut(tester, 'the results screen in $locale');
        }
      });

      testWidgets('the dashboard date costs Czech no more than a character', (
        tester,
      ) async {
        await pumpAt(tester, header(), width: width, locale: 'en');
        final english = dateWidth(tester);
        final englishText = dateText(tester);
        expectNothingCut(tester, 'the dashboard header in en');

        await pumpAt(tester, header(), width: width, locale: 'cs');
        final czech = dateWidth(tester);
        expectNothingCut(tester, 'the dashboard header in cs');
        // Proof of which language was measured. Without it a harness that
        // quietly fell back to English would pass this whole test twice.
        expect(
          dateText(tester),
          isNot(englishText),
          reason: 'the dashboard date rendered in English while asked for cs',
        );

        expect(
          (czech - english).abs(),
          lessThanOrEqualTo(oneCharacter(13)), // bodySmall
          reason:
              'the Czech dashboard date differs from the English one by '
              '${(czech - english).abs().toStringAsFixed(0)}px, which is more '
              'than the ordinal full stop can account for',
        );
      });

      testWidgets('the match preview stamp asks for one more character', (
        tester,
      ) async {
        await pumpAt(tester, headline(), width: width, locale: 'en');
        final english = dateWidth(tester);
        expect(
          find.text('SAT 30 NOV'),
          findsOneWidget,
          reason: 'the English stamp reads as a label',
        );
        expectNothingCut(tester, 'the match headline in en');

        await pumpAt(tester, headline(), width: width, locale: 'cs');
        final czech = dateWidth(tester);
        expect(
          find.text('SO 30. LIS'),
          findsOneWidget,
          reason: 'the Czech stamp reads as a label, diacritics intact',
        );
        expectNothingCut(tester, 'the match headline in cs');

        expect(
          czech - english,
          lessThanOrEqualTo(oneCharacter(12)), // labelSmall, monospace
          reason:
              'the Czech kick-off stamp wants ${(czech - english).toStringAsFixed(0)}px '
              'more than the English one',
        );
      });
    });
  }
}
