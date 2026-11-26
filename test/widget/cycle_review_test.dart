import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/layout/form_factor.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/features/hub/cycle_review_providers.dart';
import 'package:fnm/features/hub/cycle_review_view.dart';
import 'package:fnm/features/hub/cycle_rollover_screen.dart';
import 'package:fnm/features/share/cycle_share_card.dart';
import 'package:fnm/features/share/share_capture.dart';
import 'package:fnm/features/share/share_card_kit.dart';
import 'package:fnm/features/share/share_sheet.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/shared/widgets/widgets.dart';

import '../helpers/expect_whole.dart';
import '../helpers/seeded_save.dart';

/// The end-of-cycle review: the step between the champion and the board,
/// read from the save, hiding what it has no data for, laid out on a small
/// phone in a long language and on the tablet, and shared as a card.
void main() {
  Future<void> continueOn(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(PrimaryButton, enL.hubContinue));
    await settle(tester);
  }

  Future<void> open(WidgetTester tester, SeededSave save, Size size) =>
      pumpRoute(
        tester,
        save,
        '${Routes.cycleRollover}?careerId=${save.careerId}',
        size: size,
      );

  Future<CycleReview> readReview(WidgetTester tester, SeededSave save) async {
    late CycleReview r;
    await tester.runAsync(() async {
      final sub = save.container.listen(
        cycleReviewProvider(save.careerId).future,
        (_, _) {},
      );
      try {
        r = (await sub.read())!;
      } finally {
        sub.close();
      }
    });
    return r;
  }

  /// Plays the first four of the seeded nation's fixtures: a 4-0 and a 1-0
  /// win, a 0-2 defeat and a 1-1 draw, with three of its men in each (and a fourth on a line with no nation).
  Future<List<int>> playFour(WidgetTester tester, SeededSave save) async {
    final squad = [
      for (final p in realPlayers)
        if (p.nationId == save.nationId) p.id,
    ].take(4).toList();
    await tester.runAsync(() async {
      final comp = save.container.read(competitionRepositoryProvider);
      final fixtures = (await comp.cycleFixturesForNation(
        save.careerId,
        save.nationId,
      )).take(4).toList();
      const scores = [(4, 0), (1, 0), (0, 2), (1, 1)];
      for (var i = 0; i < fixtures.length; i++) {
        final f = fixtures[i];
        final home = f.homeNationId == save.nationId;
        final (mine, theirs) = scores[i];
        await comp.recordResult(
          fixtureId: f.id,
          homeScore: home ? mine : theirs,
          awayScore: home ? theirs : mine,
        );
        await comp.recordPlayerMatchStats(save.careerId, f.id, [
          for (var j = 0; j < 3; j++)
            (
              playerId: squad[j],
              nationId: save.nationId,
              rating: 6.0 + j,
              // The first man scores every goal.
              goals: j == 0 ? mine : 0,
              assists: 0,
              cleanSheet: false,
              motm: false,
              yellows: 0,
              reds: 0,
            ),
          if (i == 0)
            // A line from before the rating table kept a nation: it cannot
            // say whose side he was on, so it counts for nobody.
            (
              playerId: squad[3],
              nationId: 0,
              rating: 9.5,
              goals: 9,
              assists: 0,
              cleanSheet: false,
              motm: false,
              yellows: 0,
              reds: 0,
            ),
        ]);
      }
    });
    return squad;
  }

  testWidgets('reads the four years from the save, and goes on to the board', (
    tester,
  ) async {
    final save = await seedSave(tester);
    final squad = await playFour(tester, save);
    final review = await readReview(tester, save);
    expect(review.fromYear, 2026);
    expect(review.toYear, 2030);
    expect(review.total, (
      played: 4,
      won: 2,
      drawn: 1,
      lost: 1,
      goalsFor: 6,
      goalsAgainst: 3,
    ));
    expect(review.friendlies, isNull, reason: 'all four were qualifiers');
    expect(review.bestWin?.goalsFor, 4);
    expect(review.bestWin?.goalsAgainst, 0);
    expect(review.worstDefeat?.goalsAgainst, 2);
    expect(review.topScorer?.playerId, squad[0]);
    expect(review.topScorer?.value, 6);
    expect(review.mostCaps?.value, 4);
    // Rated 6, 7 and 8 every match: the third man is the best.
    expect(review.bestRated?.playerId, squad[2]);
    expect(review.bestRated?.rating, 8.0);
    expect(
      review.debutants,
      isNull,
      reason: "a save's first cycle cannot tell",
    );
    expect(review.rankStart, isNotNull);
    expect(review.rankEnd, isNotNull);

    await open(tester, save, const Size(390, 2400));
    // The champion step is first, and unchanged.
    expect(find.text(enL.hubWorldChampionsYear(2026)), findsOneWidget);
    await continueOn(tester);
    expect(find.byKey(CycleReviewKeys.view), findsOneWidget);
    expect(find.text(enL.hubReviewTitle(2026, 2030)), findsOneWidget);
    for (final k in [
      CycleReviewKeys.record,
      CycleReviewKeys.results,
      CycleReviewKeys.bestWin,
      CycleReviewKeys.worstDefeat,
      CycleReviewKeys.players,
      CycleReviewKeys.ranking,
    ]) {
      expect(find.byKey(k), findsOneWidget, reason: '$k');
    }
    expect(find.byKey(CycleReviewKeys.empty), findsNothing);
    expect(find.text(review.topScorer!.name), findsWidgets);
    expect(find.text(enL.recordsGoalsCount(6)), findsOneWidget);
    expect(find.byKey(ShareKeys.button), findsOneWidget);
    expectNothingCut(tester, 'the review');

    // A player opens his page, and back again.
    await tester.tap(find.byKey(CycleReviewKeys.topScorer));
    await settle(tester);
    final router = save.container.read(routerProvider);
    expect(router.state.uri.path, Routes.player);
    expect(router.state.uri.queryParameters['playerId'], '${squad[0]}');
    router.pop();
    await settle(tester);
    expect(find.byKey(CycleReviewKeys.view), findsOneWidget);

    // The best win opens the meetings with that opponent.
    await tester.tap(find.byKey(CycleReviewKeys.bestWin));
    await settle(tester);
    expect(router.state.uri.path, Routes.h2hMeetings);
    expect(
      router.state.uri.queryParameters['b'],
      '${review.bestWin!.opponentId}',
    );
    router.pop();
    await settle(tester);

    // Then the board, then the money.
    await continueOn(tester);
    expect(find.text(enL.hubOffersOnTable), findsOneWidget);
    await tester.tap(find.byType(PrimaryButton).last);
    await settle(tester);
    expect(find.text(enL.hubFederationFinances), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('a cycle with no match hides every section but the headline', (
    tester,
  ) async {
    final save = await seedSave(tester);
    await open(tester, save, kPhoneSize);
    await continueOn(tester);
    expect(find.text(enL.hubReviewTitle(2026, 2030)), findsOneWidget);
    expect(find.byKey(CycleReviewKeys.empty), findsOneWidget);
    for (final k in [
      CycleReviewKeys.record,
      CycleReviewKeys.results,
      CycleReviewKeys.players,
    ]) {
      expect(find.byKey(k), findsNothing, reason: '$k');
    }
    expect(tester.takeException(), isNull);
    await continueOn(tester);
    expect(find.text(enL.hubOffersOnTable), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });

  /// A full review, every section filled, made up rather than played: the
  /// layout tests below need the longest it can be.
  CycleReview fullReview(SeededSave save, AppLocalizations l) {
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    final them = save.nations.firstWhere((n) => n.id != save.nationId);
    return CycleReview(
      nation: me,
      cycle: 1,
      fromYear: 2030,
      toYear: 2034,
      competitive: (
        played: 22,
        won: 14,
        drawn: 5,
        lost: 3,
        goalsFor: 41,
        goalsAgainst: 17,
      ),
      friendlies: (
        played: 8,
        won: 3,
        drawn: 3,
        lost: 2,
        goalsFor: 11,
        goalsAgainst: 9,
      ),
      total: (
        played: 30,
        won: 17,
        drawn: 8,
        lost: 5,
        goalsFor: 52,
        goalsAgainst: 26,
      ),
      tournaments: [
        (
          competition: l.objectiveWorldCup,
          result: l.finishQuarterFinals,
          won: false,
          trophyAsset: Trophies.worldCup,
        ),
        (
          competition: l.careerContinentalLabel,
          result: l.finishChampions,
          won: true,
          trophyAsset: Trophies.forConfederation(me.confederation),
        ),
        (
          competition: l.careerNationsCupLabel,
          result: l.finishRunnersUp,
          won: false,
          trophyAsset: Trophies.nationsCup,
        ),
      ],
      bestWin: (
        fixtureId: 1,
        opponentId: them.id,
        opponentName: them.name,
        opponentCode: them.code,
        goalsFor: 6,
        goalsAgainst: 0,
        competitive: true,
      ),
      worstDefeat: (
        fixtureId: 2,
        opponentId: them.id,
        opponentName: them.name,
        opponentCode: them.code,
        goalsFor: 0,
        goalsAgainst: 3,
        competitive: true,
      ),
      topScorer: (
        playerId: 1,
        name: 'Aldo Fenwickstraat-Merrin',
        value: 23,
        rating: null,
      ),
      mostCaps: (
        playerId: 2,
        name: 'Bram Tollisworth',
        value: 29,
        rating: null,
      ),
      bestRated: (playerId: 3, name: 'Cato Brevander', value: 21, rating: 7.84),
      debutants: 6,
      rankLine: [
        (date: DateTime(2030, 9), rank: 14),
        (date: DateTime(2031, 9), rank: 11),
        (date: DateTime(2032, 9), rank: 12),
        (date: DateTime(2034, 7), rank: 7),
      ],
      objectivesMet: 2,
      objectivesTotal: 3,
    );
  }

  for (final code in ['de', 'fi', 'hu', 'sr']) {
    testWidgets('$code: every section fits a 360 phone at 1.4', (tester) async {
      tester.platformDispatcher.textScaleFactorTestValue = 1.4;
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      final l = lookupAppLocalizations(Locale(code));
      late CycleReview review;
      final save = await seedSave(
        tester,
        overrides: [
          cycleReviewProvider.overrideWith((ref, id) async => review),
        ],
      );
      review = fullReview(save, l);
      await pumpRoute(
        tester,
        save,
        '${Routes.cycleRollover}?careerId=${save.careerId}',
        size: const Size(360, 3200),
        locale: Locale(code),
      );
      await tester.tap(find.widgetWithText(PrimaryButton, l.hubContinue));
      await settle(tester);
      expect(tester.takeException(), isNull);
      for (final k in [
        CycleReviewKeys.verdict,
        CycleReviewKeys.record,
        CycleReviewKeys.tournaments,
        CycleReviewKeys.results,
        CycleReviewKeys.players,
        CycleReviewKeys.ranking,
      ]) {
        expect(find.byKey(k), findsOneWidget, reason: '$k');
      }
      expect(find.text(l.hubReviewDebutants(6)), findsOneWidget);
      expect(find.text(l.hubReviewObjectives(2, 3)), findsOneWidget);
      expectNothingCut(tester, 'the review in $code');
      expectWhole(find.text(l.hubContinue), 'Continue');
      await tester.pumpWidget(const SizedBox());
    });
  }

  for (final size in kTabletSizes) {
    testWidgets(
      'the tablet: the review left, Share and Continue right, $size',
      (
        tester,
      ) async {
        late CycleReview review;
        final save = await seedSave(
          tester,
          formFactor: FormFactor.tablet,
          overrides: [
            cycleReviewProvider.overrideWith((ref, id) async => review),
          ],
        );
        review = fullReview(save, enL);
        await open(tester, save, size);
        expect(find.byKey(CycleRolloverScreen.tabletLayoutKey), findsOneWidget);
        await continueOn(tester);
        expect(tester.takeException(), isNull);
        final headline = find.text(enL.hubReviewTitle(2030, 2034));
        expect(headline, findsOneWidget);
        final players = find.byKey(CycleReviewKeys.players);
        expect(players, findsOneWidget);
        expect(
          tester.getRect(players).left,
          greaterThan(tester.getRect(headline).right),
        );
        expect(find.byKey(ShareKeys.button), findsOneWidget);
        expect(find.text(enL.hubBackToSaves), findsOneWidget);
        expectNothingCut(tester, 'the tablet review');
        await continueOn(tester);
        expect(find.text(enL.hubOffersOnTable), findsOneWidget);
        await tester.pumpWidget(const SizedBox());
      },
    );
  }

  testWidgets('Share opens the sheet and shares a story at 1080 x 1920', (
    tester,
  ) async {
    final shared = <(Uint8List, String)>[];
    late CycleReview review;
    final save = await seedSave(
      tester,
      overrides: [
        cycleReviewProvider.overrideWith((ref, id) async => review),
        shareImageSinkProvider.overrideWithValue(
          (png, name, origin) async => shared.add((png, name)),
        ),
      ],
    );
    review = fullReview(save, enL);
    await open(tester, save, kPhoneSize);
    await continueOn(tester);
    await tester.tap(find.byKey(ShareKeys.button));
    await tester.pump();
    // The sheet up, and its preview drawn (the art warmed).
    bool ready() =>
        find.byKey(ShareKeys.sheet).evaluate().isNotEmpty &&
        find
            .descendant(
              of: find.byKey(ShareKeys.sheet),
              matching: find.byType(CircularProgressIndicator),
            )
            .evaluate()
            .isEmpty;
    for (var i = 0; i < 100 && !ready(); i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byKey(ShareKeys.sheet), findsOneWidget);
    await tester.tap(find.byKey(ShareKeys.format(ShareFormat.story)));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(ShareKeys.action(ShareAction.share)));
    for (var i = 0; i < 100 && shared.isEmpty; i++) {
      await tester.runAsync(
        () => Future<void>.delayed(const Duration(milliseconds: 30)),
      );
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(shared, hasLength(1));
    final b = ByteData.sublistView(shared.single.$1);
    expect((b.getUint32(16), b.getUint32(20)), (1080, 1920));
    expect(shared.single.$2, 'fnm-${review.nation!.code}-2030-2034-story.png');
    await tester.pumpWidget(const SizedBox());
  });

  for (final format in ShareFormat.values) {
    testWidgets('the card renders at exactly ${format.size}, nothing cut', (
      tester,
    ) async {
      final save = await seedSave(tester);
      final data = cycleShareData(fullReview(save, enL));
      tester.view
        ..physicalSize = format.size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      late BuildContext context;
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (c) {
              context = c;
              return CycleShareCard(data: data, format: format);
            },
          ),
        ),
      );
      await tester.pump();
      expect(tester.takeException(), isNull);
      expect(tester.getSize(find.byType(CycleShareCard)), format.size);
      expect(find.text(enL.hubReviewTitle(2030, 2034)), findsOneWidget);
      expect(find.text(enL.finishChampions), findsOneWidget);
      expectNothingCut(tester, 'the ${format.name} card');
      final png = await tester.runAsync(
        () => renderShareCard(
          context,
          card: CycleShareCard(data: data, format: format),
          format: format,
          flagCodes: [data.code],
        ),
      );
      // Kept for a look, as the other cards' captures are.
      File('build/share_preview/cycle_review_${format.name}.png')
        ..createSync(recursive: true)
        ..writeAsBytesSync(png!);
      final b = ByteData.sublistView(png);
      expect(
        (b.getUint32(16), b.getUint32(20)),
        (format.size.width.toInt(), format.size.height.toInt()),
      );
    });
  }
}
