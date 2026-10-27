import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/competition/group_advancement.dart';
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
    expect(await _yellow(t, _data(Confederation.oceania, 2, 5)), 1);
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
  // seven winners go and none is safe: the table must stop painting them green,
  // or a winner it called qualified is the one left out (the Palestine report).
  testWidgets('an Asian host leaves no Asian group winner painted safe', (
    t,
  ) async {
    final asia = _data(Confederation.asia, 8, 5);
    expect(await _green(t, asia), greaterThan(0));
    expect(await _green(t, _withHosts(asia, {Confederation.asia: 1})), 0);
    // A host from elsewhere costs Asia nothing.
    expect(
      await _green(t, _withHosts(asia, {Confederation.europe: 1})),
      greaterThan(0),
    );
  });
}
