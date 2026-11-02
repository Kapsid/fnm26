import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/services/achievements/board_satisfaction.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/objective_providers.dart';
import 'package:fnm/l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// A weak side's GRADED qualifying brief (players' complaint, 1.0.9: the
/// board's objectives were too hard for Czechia). A side in the bottom third
/// of its confederation's places, or below them, is no longer told to
/// "qualify" as its base expectation: the pass mark is the top half of the
/// qualifying group, and qualifying beats the brief. New cycles only.
void main() {
  final nations =
      (jsonDecode(File('assets/data/nations.json').readAsStringSync())
              as List<dynamic>)
          .map((e) => Nation.fromJson(e as Map<String, Object?>))
          .toList();
  final byName = {for (final n in nations) n.name: n};

  group('who is weak for a competition', () {
    test('Europe: 17th and below of the 24 Euro places, 12th and below of '
        'the 16 World Championship places', () {
      expect(weakForPlaces(16, 24), isFalse);
      expect(weakForPlaces(17, 24), isTrue);
      expect(weakForPlaces(24, 24), isTrue);
      expect(weakForPlaces(11, 16), isFalse);
      expect(weakForPlaces(12, 16), isTrue);
      // Oceania's single World Championship place: nobody inside it is weak.
      expect(weakForPlaces(1, 1), isFalse);
    });

    test('only a "qualify" brief is graded', () {
      expect(
        gradedQualifyingTarget(2, confederationRank: 20, places: 24),
        (target: 1, graded: true),
      );
      // Inside the top two-thirds of the places: still "qualify".
      expect(
        gradedQualifyingTarget(2, confederationRank: 16, places: 24),
        (target: 2, graded: false),
      );
      // A knockout brief is no weak side's; a side outside the places keeps
      // its qualifying-campaign brief, or none.
      for (final usual in [0, 1, 3, 7]) {
        expect(
          gradedQualifyingTarget(usual, confederationRank: 30, places: 24),
          (target: usual, graded: false),
        );
      }
    });
  });

  group('a new career', () {
    late ProviderContainer c;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      final db = createTestDatabase();
      addTearDown(db.close);
      c = ProviderContainer(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          premiumUnlockedProvider.overrideWith((ref) => true),
          seedSourceProvider.overrideWithValue(
            InMemorySeedSource(nationList: nations, playerList: const []),
          ),
        ],
      );
      addTearDown(c.dispose);
      await c.read(seedLoaderProvider).ensureSeeded();
    });

    Future<int> start(String name) async =>
        (await c
                .read(careerServiceProvider)
                .create(nationId: byName[name]!.id, managerName: 'M'))
            .valueOrNull!
            .id;

    Future<Map<TournamentTier, ObjectiveOutcome>> briefs(int careerId) async {
      c.invalidate(cycleObjectiveOutcomesProvider);
      return {
        for (final o in await c.read(
          cycleObjectiveOutcomesProvider(careerId).future,
        ))
          o.tier: o,
      };
    }

    test('Czechia (Europe 24th of 24 Euro places) is asked to challenge for '
        'a Euro place, not to qualify', () async {
      final id = await start('Czechia');
      final b = await briefs(id);
      final euro = b[TournamentTier.continental]!;
      expect(euro.target, 1);
      expect(euro.graded, isTrue);
      // Outside Europe's sixteen World Championship places already: the
      // plain qualifying-campaign brief, as before.
      final world = b[TournamentTier.world]!;
      expect(world.target, 1);
      expect(world.graded, isFalse);

      final en = lookupAppLocalizations(const Locale('en'));
      final cs = lookupAppLocalizations(const Locale('cs'));
      expect(
        objectiveDemandText(en, TournamentTier.continental, 1, graded: true),
        en.objectiveQualifyingChallenge,
      );
      expect(
        objectiveDemandText(cs, TournamentTier.continental, 1, graded: true),
        cs.objectiveQualifyingChallenge,
      );
      expect(
        objectiveDemandText(en, TournamentTier.world, 1),
        en.objectiveQualifyingTopHalf,
      );

      // The nation preview states the same briefs.
      expect(openingObjectiveTargets(byName['Czechia']!, nations), (
        world: 1,
        continental: 1,
        worldGraded: false,
        continentalGraded: true,
      ));
    });

    test('Scotland (Europe 21st) gets the same graded Euro brief', () async {
      final euro = (await briefs(
        await start('Scotland'),
      ))[TournamentTier.continental]!;
      expect((euro.target, euro.graded), (1, true));
    });

    test('Spain and Austria are asked exactly what they were', () async {
      for (final (name, euroTarget, worldTarget) in [
        ('Spain', 7, 7),
        ('Austria', 3, 3),
      ]) {
        final b = await briefs(await start(name));
        expect(b[TournamentTier.continental]!.target, euroTarget, reason: name);
        expect(b[TournamentTier.world]!.target, worldTarget, reason: name);
        for (final o in b.values) {
          expect(o.graded, isFalse, reason: '$name ${o.tier}');
        }
      }
    });

    test('a cycle opened without the mark keeps "qualify"', () async {
      final id = await start('Czechia');
      final repo = c.read(careerRepositoryProvider);
      final comp = c.read(competitionRepositoryProvider);
      // Cycle 2, opened by 1.0.8: the 1.0.6 and 1.0.7 marks, not 1.0.9's.
      await repo.advanceCycle(id, 1, DateTime(2030, 9));
      await repo.recordStint(id, 1, byName['Czechia']!.id);
      await comp.markDrawWatched(id, 1, briefRulesV2Kind);
      await comp.markDrawWatched(id, 1, briefRulesV3Kind);
      final euro = (await briefs(id))[TournamentTier.continental]!;
      expect((euro.target, euro.graded), (2, false));

      // The same cycle opened by this version.
      await comp.markDrawWatched(id, 1, briefRulesV4Kind);
      final now = (await briefs(id))[TournamentTier.continental]!;
      expect((now.target, now.graded), (1, true));
    });
  });

  test('grading: qualifying beats the graded brief, the top half meets it, '
      'the bottom half misses it', () {
    int swing(int actual) => BoardSatisfaction.objectiveSwing((
      tier: TournamentTier.continental,
      target: 1,
      actual: actual,
    ));
    final qualified = swing(2);
    final topHalf = swing(1);
    final bottomHalf = swing(0);
    expect(topHalf, greaterThan(0));
    // Beaten, with the over-achievement surge on top.
    expect(qualified, greaterThan(topHalf));
    expect(bottomHalf, lessThan(0));
    // Reaching the finals is credited at once, as any finals brief reached.
    expect(
      BoardSatisfaction.lockedIn((
        tier: TournamentTier.continental,
        target: 1,
        actual: 2,
      )),
      isTrue,
    );
    // A graded miss costs less than missing a "qualify" brief did.
    final oldMiss = BoardSatisfaction.objectiveSwing((
      tier: TournamentTier.continental,
      target: 2,
      actual: 1,
    ));
    expect(bottomHalf, greaterThan(oldMiss));
  });
}
