import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/services/squad/legends.dart';
import 'package:fnm/features/player/player_detail_screen.dart';
import 'package:fnm/features/records/legends_providers.dart';
import 'package:fnm/features/records/legends_screen.dart';
import 'package:fnm/features/tactics/pitch_plan.dart';
import 'package:fnm/features/tactics/tactics_pitch.dart';
import 'package:fnm/l10n/app_localizations.dart';

import '../helpers/history_fixtures.dart';
import '../helpers/seeded_save.dart';

/// The phone legends: the all-time XI on the full-time line-ups' read-only
/// pitch, each disc a rating and a surname, and the hall of fame as a grid
/// of cards below it.
void main() {
  Future<SeededSave> open(
    WidgetTester tester, {
    Size size = kPhoneSize,
    Locale locale = const Locale('en'),
    LegendsView? view,
  }) async {
    final save = await seedSave(
      tester,
      overrides: [
        if (view == null)
          fakeLegendsOverride()
        else
          legendsProvider(kSeededCareerId).overrideWith((ref) async => view),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.legends}?careerId=${save.careerId}',
      size: size,
      locale: locale,
    );
    return save;
  }

  testWidgets('the header: LEGENDS, All-time XI and the shape', (
    tester,
  ) async {
    await open(tester);
    expect(tester.takeException(), isNull);
    final bar = find.byType(AppBar);
    for (final text in [enL.recordsLegends, enL.recordsAllTimeXiSubtitle]) {
      expect(
        find.descendant(of: bar, matching: find.text(text)),
        findsOneWidget,
      );
    }
    final pill = find.byKey(LegendsScreen.formationKey);
    expect(
      find.descendant(of: pill, matching: find.text('4-3-3')),
      findsOneWidget,
    );
    expect(
      tester.getCenter(pill).dx,
      greaterThan(tester.getCenter(find.text(enL.recordsLegends)).dx),
    );
  });

  testWidgets('the XI: eleven discs, a rating and a surname each', (
    tester,
  ) async {
    await open(tester);
    expect(tester.takeException(), isNull);
    expect(xiDiscs(), findsNWidgets(11));
    expectReadOnlyDiscs();
    final pitch = tester.widget<TacticsPitch>(find.byType(TacticsPitch));
    final view = fakeLegends();
    expect(pitch.formation, view.formation);
    expect(pitch.lineup, legendsXiLineup(view.formation, view.allTimeXi));
    expect(pitch.lineup.whereType<int>().toSet(), {
      for (final l in view.allTimeXi) l.playerId,
    });
    for (final l in view.allTimeXi) {
      expect(
        pitch.discLabelByPlayer[l.playerId],
        l.avgRating.toStringAsFixed(1),
      );
    }
    // Each disc prints its legend's rating, and nothing else is worn on it:
    // no rating badge, no goals.
    final keeper = pitch.lineup[0]!;
    final legend = view.allTimeXi.firstWhere((l) => l.playerId == keeper);
    expect(
      find.descendant(
        of: find.byKey(const ValueKey('pitchDisc0')),
        matching: find.text(legend.avgRating.toStringAsFixed(1)),
      ),
      findsOneWidget,
    );
    expect(pitch.ratingByPlayer, isEmpty);
    expect(pitch.goalsByPlayer, isEmpty);
    expect(pitch.assistsByPlayer, isEmpty);
    // About 330 tall, the width of the screen.
    final rect = tester.getRect(find.byKey(LegendsScreen.xiPitchKey));
    expect(rect.height, closeTo(LegendsScreen.phonePitchHeight, 0.5));
    expect(rect.width, closeTo(LegendsScreen.phonePitchHeight * 10 / 11, 0.5));
  });

  testWidgets('a disc opens its legend', (tester) async {
    await open(tester);
    final pitch = tester.widget<TacticsPitch>(find.byType(TacticsPitch));
    final id = pitch.lineup[9]!;
    await tester.tap(
      find.byKey(const ValueKey('pitchDisc9')),
      warnIfMissed: false,
    );
    await settle(tester);
    expect(tester.widget<PlayerView>(find.byType(PlayerView)).playerId, id);
  });

  testWidgets('the hall of fame: every legend a card, two abreast', (
    tester,
  ) async {
    await open(tester, size: const Size(390, 2600));
    expect(tester.takeException(), isNull);
    final view = fakeLegends();
    final hall = view.hallOfFame;
    final label = tester.getRect(find.text(enL.recordsHallOfFame));
    expect(
      label.top,
      greaterThan(tester.getRect(find.byKey(LegendsScreen.xiPitchKey)).bottom),
    );
    for (final l in hall) {
      expect(find.byKey(LegendsScreen.cardKey(l.playerId)), findsOneWidget);
    }
    Rect card(int i) =>
        tester.getRect(find.byKey(LegendsScreen.cardKey(hall[i].playerId)));
    expect(card(0).top, card(1).top);
    expect(card(0).height, card(1).height);
    expect(card(1).left, greaterThan(card(0).right));
    expect(card(2).top, greaterThan(card(0).bottom));
    expect(card(0).top, greaterThan(label.bottom));

    // The first card: initials, name, position and years, caps, goals and
    // titles.
    final first = hall.first;
    final c = view.careers[first.playerId]!;
    Finder inCard(Finder f) => find.descendant(
      of: find.byKey(LegendsScreen.cardKey(first.playerId)),
      matching: f,
    );
    final words = first.name.split(' ');
    expect(
      inCard(find.text('${words.first[0]}${words.last[0]}'.toUpperCase())),
      findsOneWidget,
    );
    expect(inCard(find.text(first.name)), findsOneWidget);
    expect(
      inCard(find.text('${first.position.label} · ${c.from}–${c.to}')),
      findsOneWidget,
    );
    expect(inCard(find.text('${first.caps}')), findsOneWidget);
    expect(inCard(find.text('${first.goals}')), findsOneWidget);
    expect(inCard(find.byIcon(Icons.star_rounded)), findsOneWidget);
    expect(inCard(find.text('×${c.titles}')), findsOneWidget);

    await tester.tap(find.byKey(LegendsScreen.cardKey(first.playerId)));
    await settle(tester);
    expect(
      tester.widget<PlayerView>(find.byType(PlayerView)).playerId,
      first.playerId,
    );
  });

  testWidgets('the whole hall of fame scrolls into view', (tester) async {
    await open(tester);
    final last = fakeLegends().hallOfFame.last;
    await tester.scrollUntilVisible(
      find.byKey(LegendsScreen.cardKey(last.playerId)),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(tester.takeException(), isNull);
    expect(find.byKey(LegendsScreen.cardKey(last.playerId)), findsOneWidget);
  });

  // Long names, long copy and the system font turned up: nothing overflows.
  for (final code in ['de', 'fi']) {
    for (final scale in [1.0, 1.3]) {
      testWidgets('long names in $code at text scale $scale', (tester) async {
        tester.platformDispatcher.textScaleFactorTestValue = scale;
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
        final view = longNamedLegends(code);
        await open(
          tester,
          size: const Size(390, 3200),
          locale: Locale(code),
          view: view,
        );
        expect(tester.takeException(), isNull);
        expect(xiDiscs(), findsNWidgets(11));
        final l = lookupAppLocalizations(Locale(code));
        expect(find.text(l.recordsAllTimeXiSubtitle), findsOneWidget);
        for (final legend in view.hallOfFame) {
          expect(
            find.byKey(LegendsScreen.cardKey(legend.playerId)),
            findsOneWidget,
          );
        }
      });
    }
  }

  testWidgets('a fresh save has no legends yet', (tester) async {
    final save = await seedSave(tester);
    await pumpRoute(
      tester,
      save,
      '${Routes.legends}?careerId=${save.careerId}',
    );
    final me = save.nations.firstWhere((n) => n.id == save.nationId);
    expect(find.text(enL.recordsNoLegends(me.name)), findsOneWidget);
    expect(find.byKey(LegendsScreen.xiPitchKey), findsNothing);
    expect(find.byKey(LegendsScreen.formationKey), findsNothing);
  });

  test('the lineup puts each legend in his own place first', () {
    final view = fakeLegends();
    final lineup = legendsXiLineup(view.formation, view.allTimeXi);
    final positions = view.formation.positions;
    final byId = {for (final l in view.allTimeXi) l.playerId: l};
    for (var slot = 0; slot < lineup.length; slot++) {
      expect(byId[lineup[slot]]!.position.category, positions[slot].category);
    }
    // No slot is held out of position by a man while another legend who
    // plays exactly that place sits out of his own.
    for (var slot = 0; slot < lineup.length; slot++) {
      if (byId[lineup[slot]]!.position == positions[slot]) continue;
      for (var other = 0; other < lineup.length; other++) {
        final there = byId[lineup[other]]!;
        expect(
          there.position == positions[slot] &&
              there.position != positions[other],
          isFalse,
        );
      }
    }
  });
}

/// The discs on the legends' pitch.
Finder xiDiscs() => find.descendant(
  of: find.byKey(LegendsScreen.xiPitchKey),
  matching: find.byWidgetPredicate(
    (w) =>
        w.key is ValueKey<String> &&
        (w.key! as ValueKey<String>).value.startsWith('pitchDisc'),
  ),
);

/// The legends' discs carry no position, role, run, arrow or rating badge.
void expectReadOnlyDiscs() {
  expect(find.byKey(PitchPlanKeys.roleRuns), findsNothing);
  expect(find.byKey(PitchPlanKeys.arrows), findsNothing);
  for (var slot = 0; slot < 11; slot++) {
    expect(find.byKey(ValueKey('pitchPos$slot')), findsNothing);
    expect(find.byKey(PitchPlanKeys.badge(slot)), findsNothing);
    expect(find.byKey(PitchPlanKeys.tag(slot)), findsNothing);
    expect(find.byKey(PitchPlanKeys.runMark(slot)), findsNothing);
    expect(find.byKey(ValueKey('pitchFullBack$slot')), findsNothing);
    expect(find.byKey(ValueKey('pitchRating$slot')), findsNothing);
    expect(find.byKey(ValueKey('pitchGoals$slot')), findsNothing);
  }
}

/// The fake legends with the longest names the language's football throws
/// up, on the discs and in the hall of fame alike, and records in three
/// figures.
LegendsView longNamedLegends(String code) {
  final base = fakeLegends();
  const longDe = [
    'Maximilian Schweinsteiger-Hummelsberger',
    'Friedrich-Wilhelm Oberschleißheimer',
    'Konstantin Kleinschmidtbauer',
  ];
  const longFi = [
    'Aleksanteri Jääskeläinen-Väänänen',
    'Kristian Hämäläinen-Kivimäki',
    'Juho-Pekka Kärkkäinen-Siltanen',
  ];
  final names = code == 'fi' ? longFi : longDe;
  final order = {for (final (i, l) in base.hallOfFame.indexed) l.playerId: i};
  String nameOf(int id) => names[(order[id] ?? 0) % names.length];
  RankedLegend renamed(RankedLegend l) => (
    playerId: l.playerId,
    name: nameOf(l.playerId),
    position: l.position,
    caps: l.caps + 100,
    goals: l.goals + 100,
    assists: l.assists,
    motm: l.motm,
    avgRating: l.avgRating,
    score: l.score,
  );
  return (
    nationName: base.nationName,
    allTimeXi: [for (final l in base.allTimeXi) renamed(l)],
    hallOfFame: [for (final l in base.hallOfFame) renamed(l)],
    formation: base.formation,
    players: {
      for (final e in base.players.entries)
        e.key: e.value.copyWith(name: nameOf(e.key)),
    },
    careers: {
      for (final e in base.careers.entries)
        e.key: (from: e.value.from, to: e.value.to, titles: 12),
    },
    kit: base.kit,
  );
}
