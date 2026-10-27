import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';

import '../../helpers/test_database.dart';

/// The board's patience with the weakest sides in the world (owner, 1.0.7:
/// "be more tolerant with board goals for the really lowest teams, so it's
/// not impossible to keep the job there"). A minnow gets a softer Nations Cup
/// brief, a softer form window and a smaller bill for a missed brief; every
/// other side is judged exactly as before.
void main() {
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final byName = {for (final n in nations) n.name: n};
  final baseline = {for (final n in nations) n.id: n.ranking};
  double minnowOf(String name) =>
      boardMinnowFactor(baseline, nations, byName[name]!.id);

  group('who is a minnow', () {
    test('the bottom sides of the world are full minnows', () {
      for (final name in [
        'San Marino',
        'Liechtenstein',
        'Gibraltar',
        'Anguilla',
        'British Virgin Islands',
        'American Samoa',
        'US Virgin Islands',
      ]) {
        expect(minnowOf(name), greaterThan(0.9), reason: name);
      }
      expect(minnowOf('Andorra'), greaterThan(0.8));
    });

    test('nobody ranked 120th or better is one, nor any side high in its '
        'confederation', () {
      for (final n in nations) {
        final m = boardMinnowFactor(baseline, nations, n.id);
        if (n.ranking <= BoardSatisfaction.minnowWorldFrom) {
          expect(m, 0, reason: n.name);
        }
      }
      // Oceania's sides are all ranked low, but its strong ones are no
      // minnows there.
      final oceania = [
        for (final n in nations)
          if (n.confederation.name == 'oceania') n,
      ]..sort((a, b) => a.ranking.compareTo(b.ranking));
      for (final n in oceania.take(oceania.length * 2 ~/ 3)) {
        expect(
          boardMinnowFactor(baseline, nations, n.id),
          0,
          reason: n.name,
        );
      }
    });

    test('the factor rises smoothly down a confederation', () {
      var last = 0.0;
      for (var rank = 30; rank <= 55; rank++) {
        final m = BoardSatisfaction.minnowFactor(
          worldRank: 200,
          confederationRank: rank,
          confederationSize: 55,
        );
        expect(m, greaterThanOrEqualTo(last));
        expect(m - last, lessThan(0.25));
        last = m;
      }
      expect(last, 1);
    });
  });

  group('mid and top nations are judged exactly as before', () {
    final outcomes = MatchOutcome.values;
    test('form, briefs, carry-over and the whole gauge are unchanged at 0', () {
      for (final a in outcomes) {
        for (final b in outcomes) {
          for (final under in [true, false]) {
            final recent = [a, b, a, a, b, b, a, b, a, b];
            final flags = [under, !under, under, under, false, true];
            final humiliated = [true, false, true, true, false, true];
            expect(
              BoardSatisfaction.formPoints(
                recent,
                asUnderdog: flags,
                humiliations: humiliated,
              ),
              BoardSatisfaction.formPoints(recent, asUnderdog: flags),
            );
          }
        }
      }
      for (final tier in TournamentTier.values) {
        for (var target = 0; target <= 7; target++) {
          for (var actual = 0; actual <= 7; actual++) {
            final o = (tier: tier, target: target, actual: actual);
            expect(
              BoardSatisfaction.objectiveSwing(o, minnow: 0),
              BoardSatisfaction.objectiveSwing(o),
            );
          }
        }
      }
      for (var prev = 0; prev <= 100; prev++) {
        expect(
          BoardSatisfaction.openingFrom(prev, minnow: 0),
          (50 + (prev - 50) * BoardSatisfaction.carryOver).round(),
        );
      }
      final full = BoardSatisfaction.compute(
        recent: const [
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.draw,
          MatchOutcome.loss,
        ],
        recentHumiliations: const [true, true, false, true],
        honours: const [],
        worldRank: 60,
        objectives: const [
          (tier: TournamentTier.world, target: 2, actual: 0),
          (tier: TournamentTier.nationsCup, target: 3, actual: 1),
        ],
        previousCycle: 30,
      );
      expect(
        full,
        BoardSatisfaction.compute(
          recent: const [
            MatchOutcome.loss,
            MatchOutcome.loss,
            MatchOutcome.draw,
            MatchOutcome.loss,
          ],
          honours: const [],
          worldRank: 60,
          objectives: const [
            (tier: TournamentTier.world, target: 2, actual: 0),
            (tier: TournamentTier.nationsCup, target: 3, actual: 1),
          ],
          previousCycle: 30,
        ),
      );
    });

    test('the Nations Cup brief is unchanged below the minnow mark', () {
      for (var usual = 1; usual <= 7; usual++) {
        for (final m in [0.0, 0.2, 0.49]) {
          expect(minnowNationsCupTarget(usual, minnow: m), usual);
        }
      }
    });
  });

  group('a minnow is judged on what it can do', () {
    test('its Nations Cup brief is a rung lower, never below off the '
        'bottom', () {
      expect(minnowNationsCupTarget(3, minnow: 1), 2);
      expect(minnowNationsCupTarget(4, minnow: 0.6), 3);
      expect(minnowNationsCupTarget(2, minnow: 1), 2);
    });

    test('a missed brief costs less, a met one is worth the same', () {
      const missed = (tier: TournamentTier.nationsCup, target: 2, actual: 1);
      const met = (tier: TournamentTier.nationsCup, target: 2, actual: 2);
      expect(
        BoardSatisfaction.objectiveSwing(missed, minnow: 1),
        greaterThan(BoardSatisfaction.objectiveSwing(missed)),
      );
      expect(BoardSatisfaction.objectiveSwing(missed, minnow: 1), lessThan(0));
      expect(
        BoardSatisfaction.objectiveSwing(met, minnow: 1),
        BoardSatisfaction.objectiveSwing(met),
      );
    });

    test(
      'plain defeats cost less, but a humiliation costs the full weight',
      () {
        const tenLosses = [
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
        ];
        final plain = BoardSatisfaction.formPoints(
          tenLosses,
          minnow: 1,
          humiliations: List.filled(10, false),
        );
        final humiliated = BoardSatisfaction.formPoints(
          tenLosses,
          minnow: 1,
          humiliations: List.filled(10, true),
        );
        final byGiants = BoardSatisfaction.formPoints(
          tenLosses,
          minnow: 1,
          asUnderdog: List.filled(10, true),
          humiliations: List.filled(10, true),
        );
        expect(plain, 10 * BoardSatisfaction.minnowLoss);
        expect(humiliated, 10 * BoardSatisfaction.loss);
        expect(byGiants, 0);
        expect(
          BoardSatisfaction.formPoints(const [MatchOutcome.draw], minnow: 1),
          BoardSatisfaction.minnowDraw,
        );
      },
    );

    test('only a heavy defeat by a fellow minnow is a humiliation', () {
      bool h(int margin, int opp) => BoardSatisfaction.isHumiliation(
        margin: margin,
        ownRank: 209,
        opponentRank: opp,
      );
      expect(h(5, 205), isTrue);
      expect(h(4, 180), isTrue);
      expect(h(5, 150), isFalse);
      expect(h(3, 205), isFalse);
    });

    test('an average minnow cycle keeps the job, a terrible one still '
        'loses it', () {
      // The sacking bar for a manager without a reputation (nationOffers).
      const sackBar = 15;
      // A typical San Marino cycle: beaten in nine of ten, a draw, three of
      // the defeats heavy ones by giants, and the brief missed.
      final average = BoardSatisfaction.compute(
        recent: const [
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.draw,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
          MatchOutcome.loss,
        ],
        recentAsUnderdog: const [
          true,
          true,
          false,
          false,
          false,
          true,
          false,
          false,
          false,
          false,
        ],
        recentHumiliations: List.filled(10, false),
        honours: const [],
        worldRank: 203,
        objectives: const [
          (tier: TournamentTier.nationsCup, target: 2, actual: 1),
        ],
        minnow: 1,
      );
      expect(average, greaterThanOrEqualTo(sackBar));
      // The same cycle was a sacking before.
      expect(
        BoardSatisfaction.compute(
          recent: [...List.filled(9, MatchOutcome.loss)]
            ..insert(2, MatchOutcome.draw),
          recentAsUnderdog: const [
            true,
            true,
            false,
            false,
            false,
            true,
            false,
            false,
            false,
            false,
          ],
          honours: const [],
          worldRank: 203,
          objectives: const [
            (tier: TournamentTier.nationsCup, target: 3, actual: 1),
          ],
        ),
        lessThan(sackBar),
      );

      // Every game lost, most of them humiliations by fellow minnows, the
      // brief missed, and a bad last cycle behind him.
      final terrible = BoardSatisfaction.compute(
        recent: List.filled(10, MatchOutcome.loss),
        recentHumiliations: const [
          true,
          true,
          true,
          true,
          false,
          true,
          true,
          false,
          true,
          true,
        ],
        honours: const [],
        worldRank: 203,
        objectives: const [
          (tier: TournamentTier.nationsCup, target: 2, actual: 1),
        ],
        minnow: 1,
        previousCycle: 30,
      );
      expect(terrible, lessThan(sackBar));
    });
  });

  test('a minnow gets the softer Nations Cup brief; a mid-table side the '
      'same one as before', () async {
    Future<List<ObjectiveOutcome>> briefsOf(String name) async {
      final db = createTestDatabase();
      final c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: const []),
          ),
        ],
      );
      addTearDown(c.dispose);
      addTearDown(db.close);
      await c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: byName[name]!.id,
                    managerName: 'M',
                    rngSeed: 4242,
                  ))
              .valueOrNull!;
      expect(await c.read(boardMinnowProvider(career.id).future), isNotNull);
      return c.read(cycleObjectiveOutcomesProvider(career.id).future);
    }

    final sm = (await briefsOf(
      'San Marino',
    )).where((o) => o.tier == TournamentTier.nationsCup).single;
    expect(sm.target, 2);
    expect(sm.offTheBottom, isTrue);

    // Scotland is nowhere near a minnow: its briefs carry no minnow wording
    // and its Nations Cup brief is the one the ladder sets.
    for (final o in await briefsOf('Scotland')) {
      expect(o.offTheBottom, isFalse);
    }
  });
}
