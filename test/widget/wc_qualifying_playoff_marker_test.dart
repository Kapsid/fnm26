import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
import 'package:fnm/domain/services/competition/wc_playoffs.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tournaments/cup_detail_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/seeded_save.dart';

/// Two qualifying tables for [conf], [perGroup] real nations each.
CupData _data(Confederation conf, int groups, int perGroup) {
  final ids = [
    for (final n in realNations)
      if (n.confederation == conf) n.id,
  ];
  final me = ids.first;
  return CupData(
    groups: [
      for (var g = 0; g < groups; g++)
        (
          confederation: conf,
          groupName: String.fromCharCode(65 + g),
          standings: standingsOf([
            for (var p = 0; p < perGroup; p++) ids[p * groups + g],
          ]),
        ),
    ],
    nations: realNationsById,
    playerNationId: me,
    playerConfederation: conf,
    finalsGroups: const [],
    knockout: const [],
    champion: null,
    hostId: null,
    scorersQualifying: const [],
    scorersFinals: const [],
    honours: const [],
    playerNames: const {},
  );
}

int _greenRows(WidgetTester tester) =>
    tester.widgetList<Container>(find.byType(Container)).where((c) {
      final d = c.decoration;
      return d is BoxDecoration &&
          d.border is Border &&
          (d.border! as Border).left.color == AppColors.positive;
    }).length;

int _yellowRows(WidgetTester tester) =>
    tester.widgetList<Container>(find.byType(Container)).where((c) {
      final d = c.decoration;
      return d is BoxDecoration &&
          d.border is Border &&
          (d.border! as Border).left.color == AppColors.playoff;
    }).length;

/// [data] with this edition's World Cup hosts set aside per confederation.
CupData _withHosts(CupData d, Map<Confederation, int> hosts) => CupData(
  groups: d.groups,
  nations: d.nations,
  playerNationId: d.playerNationId,
  playerConfederation: d.playerConfederation,
  finalsGroups: d.finalsGroups,
  knockout: d.knockout,
  champion: d.champion,
  hostId: d.hostId,
  scorersQualifying: d.scorersQualifying,
  scorersFinals: d.scorersFinals,
  honours: d.honours,
  playerNames: d.playerNames,
  wcHostBerths: hosts,
);

Future<int> _green(WidgetTester tester, CupData data) async {
  final save = await seedSave(
    tester,
    overrides: [
      cupDetailProvider(kSeededCareerId).overrideWith((ref) async => data),
    ],
  );
  await pumpRoute(tester, save, '${Routes.cup}?careerId=${save.careerId}');
  final n = _greenRows(tester);
  await tester.pumpWidget(const SizedBox());
  return n;
}

Future<int> _yellow(WidgetTester tester, CupData data) async {
  final save = await seedSave(
    tester,
    overrides: [
      cupDetailProvider(kSeededCareerId).overrideWith((ref) async => data),
    ],
  );
  await pumpRoute(tester, save, '${Routes.cup}?careerId=${save.careerId}');
  final n = _yellowRows(tester);
  await tester.pumpWidget(const SizedBox());
  return n;
}

void main() {
  test('the play-off places come from the format', () {
    final oc = _data(Confederation.oceania, 2, 5);
    final pool = GroupAdvancement.worldCupPlayoffNations(
      Confederation.oceania,
      [
        for (final g in oc.groups) g.standings,
      ],
      hosts: 0,
    );
    expect(pool, hasLength(1));
    final eu = _data(Confederation.europe, 2, 5);
    expect(
      GroupAdvancement.worldCupPlayoffNations(Confederation.europe, [
        for (final g in eu.groups) g.standings,
      ], hosts: 0),
      isEmpty,
    );
  });

  testWidgets('an Oceania table marks its play-off place yellow', (t) async {
    // Once in its group table, and once on the "best group winners" ladder
    // under it, where the better winner goes to the finals and this one to
    // the play-off (the New Zealand report).
    expect(await _yellow(t, _data(Confederation.oceania, 2, 5)), 2);
  });

  testWidgets('a European table has no yellow', (t) async {
    expect(await _yellow(t, _data(Confederation.europe, 2, 5)), 0);
  });

  testWidgets('the hub mini-table marks the Oceania play-off nation', (
    t,
  ) async {
    final oc = _data(Confederation.oceania, 2, 5);
    final tables = [for (final g in oc.groups) g.standings];
    final playoff = GroupAdvancement.worldCupPlayoffNations(
      Confederation.oceania,
      tables,
      hosts: 0,
    );
    final save = await seedSave(
      t,
      overrides: [
        hubDataProvider.overrideWith((ref, id) async {
          final career = await ref.watch(careerRepositoryProvider).byId(id);
          return HubData(
            career: career!,
            group: (
              groupId: 1,
              name: 'A',
              competition: 'Oceania Qualifiers',
              kind: CompetitionKind.worldCupQualifying,
              groupCount: 2,
              standings: tables.first,
            ),
            next: null,
            fixtures: const [],
            nations: realNationsById,
            squadSize: 23,
            squadRating: 70,
            championNationId: null,
            hasFinals: false,
            groupPlayoffNations: playoff,
          );
        }),
      ],
    );
    await pumpRoute(t, save, Routes.hub);
    final inGroupA = tables.first.any((s) => playoff.contains(s.nationId));
    expect(_yellowRows(t), inGroupA ? 1 : 0);
    expect(
      inGroupA || tables.last.any((s) => playoff.contains(s.nationId)),
      isTrue,
    );
    await t.pumpWidget(const SizedBox());
  });

  // Asia: eight places over eight groups, so every winner is green. An Asian
  // World Cup host takes one of those places (it sits qualifying out), so only
  // seven winners go: the weakest winner on the cross-group ladder must not be
  // painted green, or a winner the table called qualified is the one left out
  // (the Palestine report). The other seven are green as things stand, as the
  // ladder under the tables paints them.
  testWidgets('an Asian host leaves its weakest group winner unpainted', (
    t,
  ) async {
    final asia = _data(Confederation.asia, 8, 5);
    final hosted = _withHosts(asia, {Confederation.asia: 1});
    final tables = [for (final g in asia.groups) g.standings];
    final out = GroupAdvancement.worldCupPlayoffNations(
      Confederation.asia,
      tables,
      hosts: 1,
    );
    final direct = GroupAdvancement.worldCupDirectNations(
      Confederation.asia,
      tables,
      hosts: 1,
    );
    expect(direct, hasLength(7));
    expect(out.where(direct.contains), isEmpty);
    expect(
      [for (final t in tables) t.first.nationId].where(out.contains),
      hasLength(1),
    );
    // The tables paint exactly that ladder (only the first groups are in
    // view): a winner is green when it is among the seven.
    final shown = await _green(t, hosted);
    expect(shown, greaterThan(0));
    // A host from elsewhere costs Asia nothing.
    expect(
      await _green(t, _withHosts(asia, {Confederation.europe: 1})),
      greaterThan(0),
    );
  });

  // The real UEFA shape (1.1.2): 1st green, EVERY 2nd yellow, a runners-up
  // table under the groups (all twelve yellow), and the Nations Cup route
  // panel, or in a European host's cycle a note that there is none.
  CupData realShape({
    required int hosts,
    List<NcRouteEntry> route = const [],
  }) {
    final d = _data(Confederation.europe, 12, 4);
    return CupData(
      groups: d.groups,
      nations: d.nations,
      playerNationId: d.playerNationId,
      playerConfederation: d.playerConfederation,
      finalsGroups: d.finalsGroups,
      knockout: d.knockout,
      champion: d.champion,
      hostId: d.hostId,
      scorersQualifying: d.scorersQualifying,
      scorersFinals: d.scorersFinals,
      honours: d.honours,
      playerNames: d.playerNames,
      wcHostBerths: {Confederation.europe: hosts},
      europePlayoffPaths: 4 - hosts,
      europeAllRunnersUp: true,
      europeNationsCupRoute: route,
    );
  }

  Future<void> pumpCup(WidgetTester t, CupData data) async {
    final save = await seedSave(
      t,
      overrides: [
        cupDetailProvider(kSeededCareerId).overrideWith((ref) async => data),
      ],
    );
    await pumpRoute(
      t,
      save,
      '${Routes.cup}?careerId=${save.careerId}',
      size: const Size(390, 12000),
    );
  }

  testWidgets('the real shape: winners green, every runner-up yellow in the '
      'groups and in their own table, the Nations Cup route below', (t) async {
    final ids = [
      for (final n in realNations)
        if (n.confederation == Confederation.europe) n.id,
    ];
    final route = <NcRouteEntry>[
      (nationId: ids[48], status: NcRouteStatus.holds, groupWinner: true),
      (nationId: ids[0], status: NcRouteStatus.qualified, groupWinner: true),
      (nationId: ids[49], status: NcRouteStatus.waiting, groupWinner: false),
    ];
    await pumpCup(t, realShape(hosts: 0, route: route));
    expect(t.takeException(), isNull);
    // Twelve winners, and the route's "through" tag (row and legend).
    expect(_greenRows(t), 14);
    // Twelve in the groups, twelve in the runners-up table, and the route's
    // "holds a place" tag (row and legend).
    expect(_yellowRows(t), 26);
    expect(find.text(enL.playoffCourseLegendAll), findsOneWidget);
    expect(find.text(enL.wcRunnersUpTableTitle), findsOneWidget);
    expect(find.text(enL.ncRouteTagHolds), findsNWidgets(2));
    expect(find.text(enL.ncRouteLegendQualified), findsOneWidget);
    expect(find.text(enL.ncRouteLegendRunnerUp), findsNothing);
    expect(find.byKey(ValueKey('ncRoute${ids[48]}')), findsOneWidget);
  });

  testWidgets('the real shape with a European host: all twelve runners-up, '
      'three paths, no Nations Cup route', (t) async {
    await pumpCup(t, realShape(hosts: 1));
    expect(t.takeException(), isNull);
    expect(_yellowRows(t), 24);
    expect(find.text(enL.ncRouteHostCycle(3, 12)), findsOneWidget);
    expect(find.text(enL.ncRouteTagHolds), findsNothing);
  });

  testWidgets('the real shape fits a tablet', (t) async {
    final save = await seedSave(
      t,
      overrides: [
        cupDetailProvider(
          kSeededCareerId,
        ).overrideWith((ref) async => realShape(hosts: 0)),
      ],
    );
    await pumpRoute(
      t,
      save,
      '${Routes.cup}?careerId=${save.careerId}',
      size: const Size(1280, 4000),
    );
    expect(t.takeException(), isNull);
    expect(find.text(enL.wcRunnersUpTableTitle), findsOneWidget);
  });
}
