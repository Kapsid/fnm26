import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/routing/app_router.dart';
import 'package:fnm/core/theme/app_colors.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/fixture.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/euro_playoffs.dart';
import 'package:fnm/features/tournaments/continental_detail_providers.dart';
import 'package:fnm/features/tournaments/euro_playoff_draw_screen.dart';
import 'package:fnm/features/tournaments/euro_playoff_providers.dart';

import '../helpers/competition_fixtures.dart';
import '../helpers/pump_app.dart';
import '../helpers/seeded_save.dart';

/// Europe's qualifying in the EURO 2028 shape (`Euro28`): the winners and
/// the eight best runners-up green, the other runners-up yellow and on the
/// ladder under the tables, a host on a held place green, a key that says
/// so; and the play-offs' two-legged ties as cards and finals placeholders.
void main() {
  Color? stripeOf(WidgetTester tester, String name) {
    final row = find
        .ancestor(of: find.text(name).first, matching: find.byType(Container))
        .evaluate()
        .map((e) => e.widget as Container)
        .firstWhere(
          (c) =>
              c.decoration is BoxDecoration &&
              (c.decoration! as BoxDecoration).border != null,
        );
    final border = (row.decoration! as BoxDecoration).border! as Border;
    return border.left.color;
  }

  testWidgets('the qualifying tables: winners and the best eight runners-up '
      'green, the rest of them yellow, the ladder and the hosts explained', (
    tester,
  ) async {
    final base = fakeContinentalData(seededNationId);
    final field = fieldOf(seededNationId, 54);
    // Six groups of five, then six of four, in pot order.
    final groups = <FinalsGroupTable>[];
    var next = 0;
    for (var g = 0; g < 12; g++) {
      final size = g < 6 ? 5 : 4;
      groups.add((
        name: String.fromCharCode(65 + g),
        standings: standingsOf([
          for (var p = 0; p < size; p++) field[next + p].id,
        ]),
      ));
      next += size;
    }
    // The host is fourth in group A: out, on a held place.
    final host = groups.first.standings[3].nationId;
    final data = ContinentalData(
      name: base.name,
      confederation: Confederation.europe,
      isPlayerRegion: true,
      hostCount: 1,
      hostIds: [host],
      qualifyingGroups: groups,
      groups: const [],
      knockout: const [],
      champion: null,
      scorers: const [],
      honours: const [],
      nations: base.nations,
      playerNationId: base.playerNationId,
      playerNames: const {},
      playoffRoute: true,
      euro28: true,
      playoffCourse: [
        (
          letter: 'A',
          seeds: [
            groups[11].standings[1].nationId,
            groups[0].standings[2].nationId,
          ],
          finalHostSemi: 0,
        ),
      ],
    );
    final save = await seedSave(
      tester,
      overrides: [
        continentalDetailProvider((
          careerId: kSeededCareerId,
          confederation: Confederation.europe,
        )).overrideWith((ref) async => data),
      ],
    );
    await pumpRoute(
      tester,
      save,
      '${Routes.continental}?careerId=${save.careerId}'
      '&conf=${Confederation.europe.name}',
      size: const Size(390, 9000),
    );
    expect(tester.takeException(), isNull);
    String name(int id) => base.nations[id]!.name;

    // The key: green, yellow, and the hosts' line.
    expect(find.text(enL.qualLegendDirect), findsOneWidget);
    expect(find.text(enL.euro28LegendPlayoff), findsOneWidget);
    expect(find.text(enL.euro28LegendHosts(name(host))), findsOneWidget);

    // Winners green; the groups of five's runners-up (more points, no
    // per-match records to discount here) and two of the fours' green, the
    // other four yellow.
    expect(
      stripeOf(tester, name(groups[6].standings[0].nationId)),
      AppColors.positive,
    );
    expect(
      stripeOf(tester, name(groups[0].standings[1].nationId)),
      AppColors.positive,
    );
    final yellow = [
      for (final g in groups)
        if (stripeOf(tester, name(g.standings[1].nationId)) ==
            AppColors.playoff)
          g.name,
    ];
    expect(yellow, hasLength(4));
    // A third is plain; the host fourth is green on its held place.
    expect(
      stripeOf(tester, name(groups[1].standings[2].nationId)),
      isNot(
        anyOf(AppColors.positive, AppColors.playoff),
      ),
    );
    expect(stripeOf(tester, name(host)), AppColors.positive);

    // The runners-up ladder under the tables, the play-offs beneath it.
    expect(find.text(enL.tourContBestRunnersUp), findsOneWidget);
    expect(
      find.text(enL.tourThirdsAdvance(8, enL.tourCupDestFinals)),
      findsOneWidget,
    );
    expect(
      find.text(enL.tourThirdsNextAdvance(4, enL.euro28DestPlayoffs)),
      findsOneWidget,
    );
    // The play-offs as they stand: the shape's own card.
    expect(find.text(enL.euro28CourseNote), findsOneWidget);
    expect(find.text(enL.euro28CourseFooter), findsOneWidget);
    expect(find.text(enL.euroPlayoffTie('A')), findsOneWidget);
    expect(find.text(enL.playoffCourseFooter), findsNothing);
    // Each side tagged with its way in: a runner-up, or the Nations Cup.
    Text tag(int id) => tester.widget<Text>(
      find.byKey(Key('continental.playoffCourse.tag.$id')),
    );
    expect(tag(groups[11].standings[1].nationId).data, enL.ncRouteTagRunnerUp);
    expect(tag(groups[0].standings[2].nationId).data, enL.compNationsCup);
  });

  final nations = {
    for (var i = 1; i <= 8; i++)
      i: Nation(
        id: i,
        name: 'Nation $i',
        code: 'N$i',
        confederation: Confederation.europe,
        ranking: i,
      ),
  };
  Fixture leg(int id, String round, int home, int away, {int? hs, int? as}) =>
      Fixture(
        id: id,
        careerId: 1,
        competitionId: 1,
        matchday: 99,
        date: DateTime(2028, 3, round == EuroPlayoffs.legOneRound ? 25 : 28),
        homeNationId: home,
        awayNationId: away,
        homeScore: hs,
        awayScore: as,
        played: hs != null,
        round: round,
      );

  testWidgets('a two-legged tie: both legs, the aggregate, the winner', (
    tester,
  ) async {
    const tieA = (letter: 'A', seeds: [1, 5], finalHostSemi: 0);
    const tieB = (letter: 'B', seeds: [2, 6], finalHostSemi: 0);
    final data = EuroPlayoffData(
      paths: const [tieA, tieB],
      fixtures: [
        // Tie A: 1-0 to the unseeded side, then 3-0 to the seeded: 3-1.
        leg(1, EuroPlayoffs.legOneRound, 5, 1, hs: 1, as: 0),
        leg(2, EuroPlayoffs.legTwoRound, 1, 5, hs: 3, as: 0),
        // Tie B: only the first leg played, 2-0 to the unseeded.
        leg(3, EuroPlayoffs.legOneRound, 6, 2, hs: 2, as: 0),
        leg(4, EuroPlayoffs.legTwoRound, 2, 6),
      ],
      finalsSlots: const [],
      nations: nations,
      playerNationId: 6,
      euro28: true,
    );
    expect(data.ties, isTrue);
    await tester.pumpApp(
      Scaffold(
        body: SingleChildScrollView(child: EuroPlayoffPaths(data: data)),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(enL.euroPlayoffTie('A')), findsOneWidget);
    expect(find.text(enL.euroPlayoffTie('B')), findsOneWidget);
    expect(find.text(enL.matchTinyFirstLeg), findsNWidgets(2));
    expect(find.text(enL.matchTinySecondLeg), findsNWidgets(2));
    // Tie A is decided on aggregate; B's first leg decides nothing.
    expect(find.text(enL.euroPlayoffAggregate('3-1')), findsOneWidget);
    expect(
      find.byKey(const Key('euroPlayoff.through.final.1')),
      findsOneWidget,
    );
    expect(find.byKey(const Key('euroPlayoff.through.semi.6')), findsNothing);
    expect(find.byKey(const Key('euroPlayoff.through.final.6')), findsNothing);
    // The manager's own tie, once.
    expect(
      find.descendant(
        of: find.byKey(const Key('euroPlayoff.tie.B')),
        matching: find.text(enL.euroPlayoffYourTie),
      ),
      findsOneWidget,
    );
  });

  testWidgets("the EURO's groups name each tie's winner", (tester) async {
    final stored = drawWithPlaceholders([
      (
        groupName: 'A',
        position: 0,
        nationId: 3,
        placeholderKey: null,
        resolvedNationId: null,
      ),
      (
        groupName: 'A',
        position: 1,
        nationId: null,
        placeholderKey: EuroPlayoffs.placeholderKey('B'),
        resolvedNationId: null,
      ),
    ]);
    await tester.pumpApp(
      Scaffold(
        body: EuroPendingGroups(
          draw: stored.draw,
          letters: stored.letters,
          playerNationId: 6,
          playerPathLetter: 'B',
          ties: true,
          code: (id) => nations[id]?.code ?? '??',
          name: (id) => nations[id]?.name ?? '?',
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(enL.euroPlayoffTieWinnerPlaceholder('B')), findsOneWidget);
    expect(find.text(enL.euroPlayoffWinnerPlaceholder('B')), findsNothing);
  });

  test('a stored tie keeps its two sides', () {
    const tie = (letter: 'C', seeds: [4, 8], finalHostSemi: 0);
    final back = EuroPlayoffs.fromSlots(EuroPlayoffs.toSlots(const [tie]));
    expect(back.single.seeds, [4, 8]);
    expect(EuroPlayoffs.isTie(back.single), isTrue);
  });
}
