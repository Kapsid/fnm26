import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/theme/app_theme.dart';
import 'package:fnm/core/theme/text_size.dart';
import 'package:fnm/core/util/match_stage.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/tactics/call_up_match_tiles.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/app_card.dart';
import 'package:fnm/shared/widgets/flag_disc.dart';

import '../helpers/expect_whole.dart';

/// The matches a call-up covers, as tiles three to a phone's width.
///
/// They were one full-width row each, and six of them pushed the pool a screen
/// down. A tile has a third of the width, so every word in it is checked: in
/// the long languages, at the narrowest phone, at the largest text size.
void main() {
  const me = 1;
  // Real codes, so each flag is drawn rather than the code standing in for it.
  const codes = ['CZE', 'ALB', 'MKD', 'BIH', 'SUI', 'BUL', 'NED'];
  final nations = {
    for (var i = 1; i <= codes.length; i++)
      i: Nation(
        id: i,
        name: 'Nation $i',
        code: codes[i - 1],
        confederation: Confederation.europe,
        ranking: 10,
      ),
  };
  // The widest mix a window carries: qualifiers home and away, a friendly, a
  // continental qualifier, a Nations Cup final and an intercontinental
  // play-off semi.
  final rounds = <String?>[null, null, 'FRIENDLY', 'CQ', 'NFINAL', 'POSF'];
  final matches = [
    for (var i = 0; i < rounds.length; i++)
      Fixture(
        id: 100 + i,
        careerId: 1,
        competitionId: 1,
        matchday: 10 + i,
        date: DateTime(2030, 11, 20 + i),
        homeNationId: i.isEven ? me : i + 2,
        awayNationId: i.isEven ? i + 2 : me,
        round: rounds[i],
      ),
  ];

  Future<void> pumpTiles(
    WidgetTester tester, {
    required double width,
    String code = 'en',
    double textScale = 1,
  }) async {
    tester.view
      ..devicePixelRatio = 1
      ..physicalSize = Size(width, 800);
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.theme,
        locale: Locale(code),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: child!,
        ),
        // As the call-up screen's banner sets them: the phone margin, then a
        // card with its own padding.
        home: Scaffold(
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: AppCard(
              child: CallUpMatchTiles(
                matches: matches,
                nations: nations,
                playerNationId: me,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Finder tile(Fixture f) => find.byKey(CallUpMatchTileKeys.tile(f.id));

  /// Every word in every tile is drawn whole, inside its tile: no ellipsis, no
  /// line cut, and no unbreakable word wider than the room it was given.
  void expectTilesWhole(WidgetTester tester, String where) {
    expect(tester.takeException(), isNull);
    for (final f in matches) {
      final box = tester.getRect(tile(f));
      final texts = find.descendant(of: tile(f), matching: find.byType(Text));
      expect(texts, findsWidgets);
      for (final element in texts.evaluate()) {
        final paragraph = element.renderObject! as RenderParagraph;
        final text = paragraph.text.toPlainText();
        expect(
          paragraph.didExceedMaxLines,
          isFalse,
          reason: '"$text" is cut on $where',
        );
        expect(
          paragraph.getMinIntrinsicWidth(double.infinity),
          lessThanOrEqualTo(paragraph.size.width + 0.5),
          reason: '"$text" runs out of its box on $where',
        );
        final rect = tester.getRect(
          find.byElementPredicate((e) => identical(e, element)),
        );
        expect(
          box.inflate(0.5).contains(rect.topLeft) &&
              box.inflate(0.5).contains(rect.bottomRight),
          isTrue,
          reason: '"$text" spills out of its tile on $where',
        );
      }
    }
    expectNothingCut(tester, where);
  }

  testWidgets('a tile says when, where, who and what', (tester) async {
    await pumpTiles(tester, width: 360);
    final l = await AppLocalizations.delegate.load(const Locale('en'));
    for (final f in matches) {
      final home = f.homeNationId == me;
      final opp = nations[home ? f.awayNationId : f.homeNationId]!;
      final tag = MatchStage.tinyParts(l, f, Confederation.europe);
      Finder inTile(Finder m) => find.descendant(of: tile(f), matching: m);
      expect(
        inTile(
          find.byWidgetPredicate((w) => w is FlagDisc && w.code == opp.code),
        ),
        findsOneWidget,
        reason: 'the flag',
      );
      expect(inTile(find.text(opp.code)), findsOneWidget, reason: 'the code');
      expect(
        inTile(find.text('${f.date.day}/${f.date.month}')),
        findsOneWidget,
        reason: 'the date',
      );
      expect(
        inTile(find.text(home ? l.callUpHomeShort : l.callUpAwayShort)),
        findsOneWidget,
        reason: 'home or away',
      );
      expect(
        inTile(find.text(tag.competition)),
        findsOneWidget,
        reason: 'the competition',
      );
      if (tag.stage case final stage?) {
        expect(
          inTile(find.text(stage)),
          findsOneWidget,
          reason: 'the round',
        );
      }
    }
    // The qualifier's matchday is on its tile, and the knock-outs' rounds.
    expect(
      find.descendant(of: tile(matches[0]), matching: find.text('WC Q')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: tile(matches[0]), matching: find.text('MD 10')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: tile(matches[4]), matching: find.text('NC')),
      findsOneWidget,
    );
    expect(
      find.descendant(of: tile(matches[4]), matching: find.text('Final')),
      findsOneWidget,
    );
    // A screen reader hears the word, not the letter.
    expect(find.bySemanticsLabel(l.callUpHome), findsWidgets);
    expect(find.bySemanticsLabel(l.callUpAway), findsWidgets);
  });

  testWidgets('three to a row on a 360 phone, all six in two rows', (
    tester,
  ) async {
    await pumpTiles(tester, width: 360);
    double top(int i) => tester.getTopLeft(tile(matches[i])).dy;
    double left(int i) => tester.getTopLeft(tile(matches[i])).dx;
    expect(top(1), top(0));
    expect(top(2), top(0));
    expect(top(3), greaterThan(top(0)));
    expect(top(4), top(3));
    expect(top(5), top(3));
    expect(left(1), greaterThan(left(0)));
    expect(left(2), greaterThan(left(1)));
    expect(left(3), left(0));
    // A row's tiles are one height, whatever each has to say.
    expect(
      tester.getSize(tile(matches[1])).height,
      tester.getSize(tile(matches[0])).height,
    );
  });

  testWidgets('more to a row on a tablet', (tester) async {
    await pumpTiles(tester, width: 900);
    final y = tester.getTopLeft(tile(matches[0])).dy;
    for (final f in matches) {
      expect(tester.getTopLeft(tile(f)).dy, y);
    }
  });

  for (final code in const ['fi', 'de', 'cs', 'hu', 'en']) {
    for (final width in const [320.0, 360.0]) {
      for (final scale in const [1.0, kMaxAppTextScale]) {
        testWidgets('$code at ${width.toInt()}, text x$scale: nothing cut', (
          tester,
        ) async {
          await pumpTiles(tester, width: width, code: code, textScale: scale);
          expectLocale(tester, find.byType(CallUpMatchTiles), code);
          expectTilesWhole(tester, '$code at ${width.toInt()} x$scale');
          // Still three to a row at the narrowest phone and largest text.
          expect(
            tester.getTopLeft(tile(matches[2])).dy,
            tester.getTopLeft(tile(matches[0])).dy,
          );
        });
      }
    }
  }

  // The rest of the languages, at the hardest case only.
  for (final locale in AppLocalizations.supportedLocales) {
    final code = locale.languageCode;
    if (const ['fi', 'de', 'cs', 'hu', 'en'].contains(code)) continue;
    testWidgets('$code at 320, largest text: nothing cut', (tester) async {
      await pumpTiles(
        tester,
        width: 320,
        code: code,
        textScale: kMaxAppTextScale,
      );
      expectLocale(tester, find.byType(CallUpMatchTiles), code);
      expectTilesWhole(tester, '$code at 320 x$kMaxAppTextScale');
    });
  }
}
