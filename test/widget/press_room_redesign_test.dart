import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/services/press/conference.dart';
import 'package:fnm/domain/services/press/statement.dart';
import 'package:fnm/features/press/press_providers.dart';
import 'package:fnm/features/press/press_sheet.dart';
import 'package:fnm/features/press/press_ticker.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:fnm/l10n/app_localizations_en.dart';

import '../helpers/press_room.dart';
import '../helpers/pump_app.dart';

/// The 1.1.2 press room: variant F for the questions (ticker, drawn
/// microphone, the question large, answers as wide buttons with their
/// on-the-record line) and variant C for the end (the paper, three signed
/// tiles and what he promised, tied to its fixture).
void main() {
  final l = AppLocalizationsEn();

  PressContext contextFor(PendingConference c, {bool played = true}) =>
      pressContextFor(
        l,
        conference: c,
        nationId: PressRoom.england,
        fixtures: played ? PressRoom.afterTwo : PressRoom.beforeAny,
        nations: PressRoom.nations,
        group: PressRoom.group,
        groupNames: PressRoom.groupNames,
        dateLabel: PressRoom.dateLabel,
      );

  group('what the ticker shows', () {
    test('after a match: the group, his results so far and the table', () {
      final room = contextFor(PressRoom.postMatch);
      final t = room.ticker!;
      expect(t.label, contains('GROUP C'));
      expect(t.items, ['ENG 0–3 NED', 'SEN 1–1 ENG']);
      expect(t.standing, 'ENG 1 PT · 3RD');
      // A promise after the match is judged on the next one.
      expect(room.next!.title, 'England – Japan');
      expect(room.next!.meta, 'WED 17/6 · GROUP C');
      expect(room.opener, isNull);
    });

    test('a preview: the fixture to come and its day, no table', () {
      final room = contextFor(PressRoom.preview, played: false);
      final t = room.ticker!;
      expect(t.label, contains('GROUP C'));
      expect(t.items, ['ENG – NED', 'WED 10/6']);
      expect(t.standing, isNull);
      expect(room.opener!.title, 'England – Netherlands');
      expect(room.next, isNull);
    });

    test('a match outside the fixtures he holds leaves the strip out', () {
      final room = pressContextFor(
        l,
        conference: PressRoom.postMatch,
        nationId: PressRoom.england,
        fixtures: const [],
        nations: PressRoom.nations,
        dateLabel: PressRoom.dateLabel,
      );
      expect(room.ticker, isNull);
    });
  });

  Future<FakePressService> pumpSheet(
    WidgetTester tester,
    PendingConference c, {
    bool played = true,
  }) async {
    final fake = FakePressService();
    final room = contextFor(c, played: played);
    // Tall enough that every answer is on screen: the sheet takes 85% of
    // the view's height.
    tester.view
      ..physicalSize = const Size(390, 1600)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpApp(
      Scaffold(
        body: PressSheet(
          careerId: 1,
          conference: c,
          playerNames: const {9: 'Svoboda'},
          opponentName: 'Senegal',
          competitionName: 'World Championship',
          rivalName: 'Netherlands',
          ticker: room.ticker,
          opener: room.opener,
          next: room.next,
        ),
      ),
      overrides: [conferenceServiceProvider.overrideWithValue(fake)],
    );
    await tester.pumpAndSettle();
    return fake;
  }

  testWidgets('a post-match room: results ticker, a promise and its fixture', (
    tester,
  ) async {
    final fake = await pumpSheet(tester, PressRoom.postMatch);
    expect(find.byKey(PressTickerStrip.stripKey), findsOneWidget);
    expect(find.text('ENG 0–3 NED'), findsOneWidget);
    expect(find.text('SEN 1–1 ENG'), findsOneWidget);
    expect(find.text('ENG 1 PT · 3RD'), findsOneWidget);
    expect(find.byKey(PressMicrophone.micKey), findsOneWidget);
    expect(find.text(l.pressFloor(1, 2)), findsOneWidget);

    // The answers keep what they put on the record, under the answer.
    expect(find.text(l.pressOnRecordWinNext), findsOneWidget);
    // takeResponsibility, demandMore, promiseWinNext, deflect.
    await tester.tap(find.byType(AnswerTile).at(2));
    await tester.pumpAndSettle();
    expect(fake.answers.single.$2, AnswerKind.promiseWinNext);
    expect(find.text(l.pressFloor(2, 2)), findsOneWidget);
    // jobOnTheLine, takeResponsibility, deflect.
    expect(find.text(l.pressOnRecordJob), findsOneWidget);
    await tester.tap(find.byType(AnswerTile).at(2));
    await tester.pumpAndSettle();
    expect(fake.answers.last.$2, AnswerKind.deflect);

    // The end: the paper, three tiles, the promise on the Japan match.
    expect(find.text(l.pressAfterTitle), findsOneWidget);
    expect(find.byKey(PressTickerStrip.stripKey), findsNothing);
    expect(find.byKey(PressPaper.paperKey), findsOneWidget);
    final tiles = tester
        .widgetList<PressEffectTile>(find.byType(PressEffectTile))
        .toList();
    expect(tiles.map((t) => t.label), [
      l.pressTileMorale,
      l.pressBoard,
      l.pressTilePress,
    ]);
    final win = ConferenceBuilder.effectOf(AnswerKind.promiseWinNext, 50);
    final deflect = ConferenceBuilder.effectOf(AnswerKind.deflect, 50);
    expect(tiles[0].value, win.morale + deflect.morale);
    expect(tiles[1].value, win.board + deflect.board);
    expect(tiles[2].value, Credibility.deflectStep);
    expect(
      find.text(PressEffectTile.signed(Credibility.deflectStep)),
      findsOneWidget,
    );
    expect(find.byKey(PressPromiseCard.cardKey), findsOneWidget);
    expect(find.text(l.pressPromiseHeading), findsOneWidget);
    expect(find.text(l.pressPromiseWinNext), findsOneWidget);
    expect(find.text('England – Japan'), findsOneWidget);
    expect(find.text('WED 17/6 · GROUP C'), findsOneWidget);

    await tester.tap(find.text(l.hubContinue));
    await tester.pumpAndSettle();
    expect(fake.finished, [50]);
  });

  testWidgets('a preview room: the fixture ticker and the stated target', (
    tester,
  ) async {
    final fake = await pumpSheet(tester, PressRoom.preview, played: false);
    expect(find.text('ENG – NED'), findsOneWidget);
    expect(find.text('WED 10/6'), findsOneWidget);
    expect(find.text(l.pressFloor(1, 3)), findsOneWidget);
    // The aim answers keep their target line.
    expect(
      find.text(l.pressOnRecordTarget(l.objectiveReachSemis)),
      findsOneWidget,
    );
    expect(find.text(l.pressOnRecordPlayDown), findsOneWidget);
    // aimHigher, matchBrief, playDown...: aim higher, then anything.
    final aim = tester
        .widgetList<AnswerTile>(find.byType(AnswerTile))
        .toList()
        .indexWhere(
          (t) => t.note == l.pressOnRecordTarget(l.objectiveReachSemis),
        );
    await tester.tap(find.byType(AnswerTile).at(aim));
    await tester.pumpAndSettle();
    expect(fake.answers.single.$2, AnswerKind.aimHigher);
    for (var i = 0; i < 2; i++) {
      await tester.tap(find.byType(AnswerTile).first);
      await tester.pumpAndSettle();
    }
    expect(find.byKey(PressPaper.paperKey), findsOneWidget);
    expect(find.byType(PressEffectTile), findsNWidgets(3));
    expect(find.byKey(PressPromiseCard.cardKey), findsOneWidget);
    expect(find.text(l.objectiveReachSemis), findsOneWidget);
    expect(find.text(l.pressPromiseJudgedCampaign), findsOneWidget);
    expect(find.text('England – Netherlands'), findsOneWidget);
  });

  testWidgets('no promise, no card; the effects stay hidden until the end', (
    tester,
  ) async {
    await pumpSheet(tester, PressRoom.postMatch);
    expect(find.byType(PressEffectTile), findsNothing);
    // takeResponsibility, then the reaction's first answer.
    await tester.tap(find.byType(AnswerTile).first);
    await tester.pumpAndSettle();
    expect(find.byType(PressEffectTile), findsNothing);
    final note = tester
        .widgetList<AnswerTile>(find.byType(AnswerTile))
        .toList()
        .indexWhere((t) => t.note == null);
    await tester.tap(find.byType(AnswerTile).at(note));
    await tester.pumpAndSettle();
    expect(find.byType(PressEffectTile), findsNWidgets(3));
    expect(find.byKey(PressPromiseCard.cardKey), findsNothing);
  });

  for (final code in const ['en', 'cs', 'de', 'fr', 'pl', 'hu', 'bg']) {
    testWidgets('$code: both screens fit a 320 phone', (tester) async {
      tester.view
        ..physicalSize = const Size(320, 800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final lang = lookupAppLocalizations(Locale(code));
      final room = pressContextFor(
        lang,
        conference: PressRoom.postMatch,
        nationId: PressRoom.england,
        fixtures: PressRoom.afterTwo,
        nations: PressRoom.nations,
        group: PressRoom.group,
        groupNames: PressRoom.groupNames,
        dateLabel: PressRoom.dateLabel,
      );
      await tester.pumpApp(
        Scaffold(
          body: PressSheet(
            careerId: 1,
            conference: PressRoom.postMatch,
            playerNames: const {},
            opponentName: 'Bosnia and Herzegovina',
            ticker: room.ticker,
            next: room.next,
          ),
        ),
        locale: Locale(code),
        overrides: [
          conferenceServiceProvider.overrideWithValue(FakePressService()),
        ],
      );
      await tester.pumpAndSettle();
      for (var i = 0; i < 2; i++) {
        expect(tester.takeException(), isNull);
        final tile = find.byType(AnswerTile).at(2);
        await tester.ensureVisible(tile);
        await tester.pumpAndSettle();
        await tester.tap(tile);
        await tester.pumpAndSettle();
      }
      expect(tester.takeException(), isNull);
      expect(find.byKey(PressPromiseCard.cardKey), findsOneWidget);
    });
  }

  test('signed figures use a true minus sign', () {
    expect(PressEffectTile.signed(3), '+3');
    expect(PressEffectTile.signed(0), '0');
    expect(PressEffectTile.signed(-1), '−1');
  });
}
