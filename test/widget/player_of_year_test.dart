import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_dimens.dart';
import 'package:fnm/features/messages/message_sheet.dart';
import 'package:fnm/features/messages/poty_card.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/pump_app.dart';

/// The player of the year, announced properly.
///
/// The award used to pop up as one sentence with a name in it, which told the
/// manager nothing: not where the man plays, not what he did over the year,
/// not how good he actually is. The card carries his flag, his season and his
/// rating, and it has to carry all of that inside a POPUP — a box tighter than
/// a screen — in both languages and on the narrowest phone.
///
/// `expect(tester.takeException(), isNull)` is not a width test: it passes for
/// any amount of ellipsis. `expectNothingCut` reads every paragraph on screen
/// and asks whether it ran out of room, which is the only guard that catches a
/// label somebody forgot to bound.
void main() {
  /// Asserts that NOTHING anywhere on the screen ran out of room.
  void expectNothingCut(WidgetTester tester) {
    for (final element in find.byType(Text).evaluate()) {
      final paragraph = element.renderObject;
      if (paragraph is! RenderParagraph) continue;
      expect(
        paragraph.didExceedMaxLines,
        isFalse,
        reason:
            'something on the award card is cut off: '
            '"${(element.widget as Text).data}"',
      );
    }
  }

  /// The longest first-and-surname pair the shipped pools can generate — the
  /// worst name this card will ever have to print.
  const longName = 'Nomenjanahary Raheriniaina';

  /// A name a phone can hold whole, so the guard has something it must NOT
  /// shorten as well as something it may.
  const shortName = 'Jan Novák';

  PotyRow best({String name = longName}) => (
    young: false,
    name: name,
    nationCode: 'cze',
    nationName: 'Czech Republic',
    age: 27,
    overall: 88,
    apps: 14,
    goals: 9,
    assists: 5,
    meanRating: 7.84,
    motms: 4,
  );

  PotyRow young({String name = shortName}) => (
    young: true,
    name: name,
    nationCode: 'bra',
    nationName: 'Brazil',
    age: 19,
    overall: 79,
    apps: 11,
    goals: 6,
    assists: 3,
    meanRating: 7.41,
    motms: 2,
  );

  Future<AppLocalizations> pumpCard(
    WidgetTester tester, {
    required double width,
    required Locale locale,
    List<PotyRow>? rows,
  }) async {
    tester.view
      ..physicalSize = Size(width, 1200)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: PotyCard(rows: rows ?? [best(), young()]),
          ),
        ),
      ),
      locale: locale,
    );
    await tester.pumpAndSettle();
    return AppLocalizations.of(tester.element(find.byType(PotyCard)));
  }

  group('the card says who, from where, and how good', () {
    for (final width in [360.0, 400.0]) {
      for (final locale in [const Locale('en'), const Locale('cs')]) {
        final at = 'at ${width.toInt()}px in ${locale.languageCode}';

        testWidgets('the winner wears his flag, $at', (tester) async {
          await pumpCard(tester, width: width, locale: locale);
          // One flag per winner: the award is about a player of a COUNTRY, and
          // the announcement used to leave the country out altogether.
          expect(find.byType(FlagDisc), findsNWidgets(2));
          expect(find.text('Czech Republic'), findsOneWidget);
          expect(find.text('Brazil'), findsOneWidget);
          expectNothingCut(tester);
        });

        testWidgets('his season is on the card, $at', (tester) async {
          final l = await pumpCard(tester, width: width, locale: locale);
          expect(find.text(l.msgTallyCaps(14)), findsOneWidget);
          expect(find.text(l.msgTallyGoals(9)), findsOneWidget);
          expect(find.text(l.potyTallyAssists(5)), findsOneWidget);
          expect(find.text(l.statsMotmShort(4)), findsOneWidget);
          expectNothingCut(tester);
        });

        testWidgets('his rating is on the card, $at', (tester) async {
          final l = await pumpCard(tester, width: width, locale: locale);
          // BOTH ratings: how good he is, and how he was marked over the year.
          expect(find.text(l.potyOverallValue(88)), findsOneWidget);
          expect(find.text(l.potyOverallValue(79)), findsOneWidget);
          expect(find.text(l.potyRatingValue('7.84')), findsOneWidget);
          expectNothingCut(tester);
        });

        testWidgets('both awards are named, $at', (tester) async {
          final l = await pumpCard(tester, width: width, locale: locale);
          expect(find.text(l.potyLabelBest), findsOneWidget);
          expect(find.text(l.potyLabelYoung), findsOneWidget);
          expectNothingCut(tester);
        });

        testWidgets('a name a phone can hold is printed in full, $at', (
          tester,
        ) async {
          await pumpCard(
            tester,
            width: width,
            locale: locale,
            rows: [best(name: shortName)],
          );
          expect(find.text(shortName), findsOneWidget);
          expectNothingCut(tester);
        });

        testWidgets(
          'a name too long gives up its forename, never its end, $at',
          (tester) async {
            await pumpCard(
              tester,
              width: width,
              locale: locale,
              rows: [best()],
            );
            final whole = find.text(longName).evaluate().length;
            final initialled = find
                .text(initialledName(longName))
                .evaluate()
                .length;
            expect(
              whole + initialled,
              1,
              reason: 'the name on screen is neither the name nor its initial',
            );
            expectNothingCut(tester);
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  });

  group('the card survives the round trip through a message body', () {
    test('what is written is what is read back', () {
      final rows = [best(), young()];
      final decoded = decodePotyReport(encodePotyReport(rows));
      expect(decoded, rows);
    });

    test('a plain body is not an award card', () {
      expect(
        decodePotyReport('Somebody is the best player in the world.'),
        isNull,
      );
      expect(decodePotyReport(''), isNull);
    });

    test('a name with the separator in it does not break the row', () {
      final decoded = decodePotyReport(
        encodePotyReport([best(name: 'Odd|Name')]),
      );
      expect(decoded, hasLength(1));
      expect(decoded!.first.name, 'Odd Name');
    });
  });

  testWidgets('the message sheet renders the card, not the raw body', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(360, 1200)
      ..devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);
    final body = encodePotyReport([best(), young()]);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(
          child: MessageSheet(
            message: (
              id: 1,
              category: 'award',
              title: 'World Player of the Year 2026',
              body: body,
              year: 2026,
              read: false,
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PotyCard), findsOneWidget);
    // The encoded body is never shown as text.
    expect(find.textContaining('#poty'), findsNothing);
    expectNothingCut(tester);
  });
}
