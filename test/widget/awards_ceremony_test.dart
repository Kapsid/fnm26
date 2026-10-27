import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/features/awards/award_providers.dart';
import 'package:fnm/features/awards/awards_ceremony_screen.dart';
import 'package:fnm/features/messages/poty_card.dart';
import 'package:fnm/features/nations/career_nations_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/expect_whole.dart';
import '../helpers/pump_app.dart';

final Map<int, Nation> _nations = {
  for (final n
      in (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>)))
    n.id: n,
};

/// The worst name the pools can make, for the width guards.
const String _longName = 'Nomenjanahary Raheriniaina';

PotyPlace _place(
  int rank, {
  bool own = false,
  PlayerPosition position = PlayerPosition.st,
  String? name,
  int nationId = 18,
  int age = 26,
  int? id,
}) {
  final n = _nations[nationId]!;
  return (
    rank: rank,
    playerId: id ?? 100 + rank,
    nationId: nationId,
    own: own,
    name: name ?? 'Player Number$rank',
    nationCode: n.code.toLowerCase(),
    nationName: n.name,
    age: age,
    overall: 85,
    position: position,
    apps: 12,
    goals: 9,
    assists: 3,
    cleanSheets: 6,
    meanRating: 7.62,
    motms: 3,
    score: 80.0 - rank,
  );
}

PotyVote _vote() => (
  best: [
    _place(1, name: _longName, nationId: 59),
    _place(2, position: PlayerPosition.gk),
    _place(3, own: true, position: PlayerPosition.cb, nationId: 14),
    _place(4),
    _place(5, nationId: 58),
  ],
  young: [
    for (var i = 1; i <= 3; i++)
      _place(i, age: 19, nationId: 50, name: 'Young Talent$i', id: 200 + i),
  ],
);

Future<AppLocalizations> _pump(
  WidgetTester tester, {
  bool watch = true,
  bool reducedMotion = false,
  Locale locale = const Locale('en'),
  double width = 390,
  double textScale = 1,
}) async {
  tester.view
    ..physicalSize = Size(width, 844)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: reducedMotion,
          textScaler: TextScaler.linear(textScale),
        ),
        child: AwardsCeremonyScreen(careerId: 1, year: 2030, watch: watch),
      ),
    ),
    locale: locale,
    overrides: [
      potyVoteProvider.overrideWith((ref, arg) async => _vote()),
      careerNationsByIdProvider.overrideWith((ref, id) async => _nations),
    ],
  );
  await tester.pump();
  await tester.pump();
  return AppLocalizations.of(tester.element(find.byType(Scaffold).first));
}

void main() {
  testWidgets('the ceremony reveals fifth to first, then the young award', (
    tester,
  ) async {
    final l = await _pump(tester);
    expect(find.byKey(const Key('poty.ceremony')), findsOneWidget);
    expect(find.text(l.potyCeremonyIntro), findsOneWidget);
    final order = <int>[];
    for (var i = 0; i < 12 && order.length < 5; i++) {
      await tester.pump(const Duration(milliseconds: 700));
      for (var rank = 5; rank >= 1; rank--) {
        if (find.text(l.potyCeremonyPlace(rank)).evaluate().isNotEmpty &&
            !order.contains(rank)) {
          order.add(rank);
        }
      }
      // Hold back once the winner's pause is on screen, so it is seen.
      if (find.text(l.potyCeremonyWinnerIs).evaluate().isNotEmpty &&
          find.text(l.potyCeremonyPlace(1)).evaluate().isEmpty) {
        expect(order, [5, 4, 3, 2]);
      }
      await tester.pump(const Duration(milliseconds: 2000));
    }
    expect(order, [5, 4, 3, 2, 1]);
    // The winner, then the young award, then the list.
    var sawYoung = false;
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 500));
      if (find.text(l.potyLabelYoung).evaluate().isNotEmpty) sawYoung = true;
      if (find.byKey(const Key('poty.list')).evaluate().isNotEmpty) break;
    }
    expect(sawYoung, isTrue);
    expect(find.byKey(const Key('poty.list')), findsOneWidget);
  });

  testWidgets('skip is always there and jumps to the list', (tester) async {
    final l = await _pump(tester);
    expect(find.byKey(const Key('poty.skip')), findsOneWidget);
    await tester.pump(const Duration(seconds: 3));
    expect(find.byKey(const Key('poty.skip')), findsOneWidget);
    await tester.tap(find.byKey(const Key('poty.skip')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('poty.list')), findsOneWidget);
    expect(find.byKey(const Key('poty.skip')), findsNothing);
    expect(find.text(l.potyTop5Heading), findsOneWidget);
  });

  testWidgets('reduced motion goes straight to the list', (tester) async {
    await _pump(tester, reducedMotion: true);
    expect(find.byKey(const Key('poty.ceremony')), findsNothing);
    expect(find.byKey(const Key('poty.list')), findsOneWidget);
  });

  testWidgets('skip to the list opens the list', (tester) async {
    final l = await _pump(tester, watch: false);
    expect(find.byKey(const Key('poty.list')), findsOneWidget);
    for (final p in _vote().best.skip(1)) {
      expect(find.text(p.name), findsOneWidget);
    }
    await tester.scrollUntilVisible(
      find.text(l.potyYoungTop3Heading),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text(l.potyYoungTop3Heading), findsOneWidget);
  });

  testWidgets("the manager's own man is picked out", (tester) async {
    final l = await _pump(tester, watch: false);
    expect(find.byKey(const Key('poty.own')), findsOneWidget);
    expect(find.text(l.potyYourPlayer), findsOneWidget);
    final own = find.ancestor(
      of: find.byKey(const Key('poty.own')),
      matching: find.byKey(const ValueKey('poty.place.103')),
    );
    expect(own, findsOneWidget);
  });

  testWidgets("and during the ceremony, when his place comes", (tester) async {
    final l = await _pump(tester);
    // Intro, then fifth and fourth: third is the manager's man.
    await tester.pump(const Duration(milliseconds: 1800));
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pump(const Duration(milliseconds: 2600));
    await tester.pump(const Duration(milliseconds: 700));
    expect(find.text(l.potyCeremonyPlace(3)), findsOneWidget);
    expect(find.byKey(const Key('poty.own')), findsOneWidget);
  });

  testWidgets('a keeper and a defender show clean sheets, a striker goals', (
    tester,
  ) async {
    final l = await _pump(tester, watch: false);
    expect(find.text(l.potyTallyCleanSheets(6)), findsNWidgets(2));
    expect(find.text(l.msgTallyGoals(9)), findsWidgets);
  });

  for (final code in ['de', 'fi', 'hu', 'el', 'pt', 'cs', 'en']) {
    testWidgets('fits 360 wide at text scale 1.4 in $code', (tester) async {
      await _pump(
        tester,
        watch: false,
        locale: Locale(code),
        width: 360,
        textScale: 1.4,
      );
      expect(tester.takeException(), isNull);
      expectNothingCut(tester);
      await tester.drag(find.byType(Scrollable).first, const Offset(0, -2000));
      await tester.pumpAndSettle();
      expectNothingCut(tester);
    });

    testWidgets('the winner reveal fits 360 wide at 1.4 in $code', (
      tester,
    ) async {
      final l = await _pump(
        tester,
        locale: Locale(code),
        width: 360,
        textScale: 1.4,
      );
      // Intro, fifth to second, the pause: the winner.
      await tester.pump(const Duration(milliseconds: 1800));
      for (var i = 0; i < 4; i++) {
        await tester.pump(const Duration(milliseconds: 2600));
      }
      await tester.pump(const Duration(milliseconds: 2000));
      await tester.pump(const Duration(milliseconds: 1500));
      expect(find.text(l.potyCeremonyPlace(1)), findsOneWidget);
      expect(tester.takeException(), isNull);
      expectNothingCut(tester);
    });

    testWidgets('the choice sheet fits 360 wide at 1.4 in $code', (
      tester,
    ) async {
      tester.view
        ..physicalSize = const Size(360, 844)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      bool? chose;
      await tester.pumpApp(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(1.4)),
            child: Scaffold(
              body: Align(
                alignment: Alignment.bottomCenter,
                child: AwardsCeremonyChoiceSheet(
                  year: 2030,
                  onChoose: (w) => chose = w,
                ),
              ),
            ),
          ),
        ),
        locale: Locale(code),
      );
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expectNothingCut(tester);
      await tester.tap(find.byKey(const Key('poty.skipToList')));
      expect(chose, isFalse);
      await tester.tap(find.byKey(const Key('poty.watch')));
      expect(chose, isTrue);
    });
  }
}
