import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/db/app_database.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/tactics.dart';
import 'package:fnm/domain/services/competition/rounds.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/domain/services/match/match_engine.dart';
import 'package:fnm/domain/services/match/venue.dart';
import 'package:fnm/domain/services/tactics/team_chemistry.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/match/match_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/test_database.dart';

/// Skipping is never the way to dodge a counter.
///
/// The AI counters what it has seen the manager play lately (the stored
/// drilling: familiarity, predictability and the last plan per shape). A
/// played match records itself there; a skipped one used to record nothing,
/// so a manager who skipped every match was never read at all. Now a skipped
/// manager match is recorded exactly as a played one, once each, and the
/// world's own matches record nothing.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues(<String, Object>{});

  late List<Nation> nations;
  late List<Player> players;

  setUpAll(() {
    nations =
        (jsonDecode(File('assets/data/nations.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Nation.fromJson(e as Map<String, Object?>))
            .toList();
    players =
        (jsonDecode(File('assets/data/players.json').readAsStringSync())
                as List<dynamic>)
            .map((e) => Player.fromJson(e as Map<String, Object?>))
            .toList();
  });

  ({AppDatabase db, ProviderContainer c}) open() {
    final db = createTestDatabase();
    final c = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(() async {
      c.dispose();
      await db.close();
    });
    return (db: db, c: c);
  }

  const shape = Formation.f4231;
  const plan = TacticalInstructions(pressing: 85, defensiveLine: 75);
  const czechia = 12;

  test(
    'skipping N manager matches drills the side as playing N would',
    () async {
      final w = open();
      await w.c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await w.c
                  .read(careerServiceProvider)
                  .create(nationId: czechia, managerName: 'M', rngSeed: 77))
              .valueOrNull!;
      await w.c.read(tacticServiceProvider).setFormation(career.id, shape);
      await w.c.read(tacticServiceProvider).setInstructions(career.id, plan);

      // The reference: what `playPlayerMatch` records per match, N times, in a
      // second save of the same world.
      final ref = open();
      await ref.c.read(seedLoaderProvider).ensureSeeded();
      final refCareer =
          (await ref.c
                  .read(careerServiceProvider)
                  .create(nationId: czechia, managerName: 'M', rngSeed: 77))
              .valueOrNull!;
      final refFam = ref.c.read(tacticFamiliarityRepositoryProvider);

      Future<({int ours, int world})> played() async {
        var ours = 0;
        var world = 0;
        for (final f in await w.db.select(w.db.fixtures).get()) {
          if (!f.played) continue;
          if (f.homeNationId == czechia || f.awayNationId == czechia) {
            ours++;
          } else {
            world++;
          }
        }
        return (ours: ours, world: world);
      }

      final fam = w.c.read(tacticFamiliarityRepositoryProvider);
      expect(await fam.forCareer(career.id), isEmpty);
      var recorded = 0;
      for (var step = 0; step < 6; step++) {
        await w.c.read(seasonServiceProvider).advance(career.id);
        final n = await played();
        for (; recorded < n.ours; recorded++) {
          await refFam.recordMatch(
            refCareer.id,
            shape,
            planKey: TeamChemistry.planKey(plan),
          );
        }
        expect(
          await fam.forCareer(career.id),
          await refFam.forCareer(refCareer.id),
          reason:
              'after ${n.ours} skipped manager matches (and ${n.world} of the '
              "world's), the drilling must be ${n.ours} recordings of his plan",
        );
      }
      final n = await played();
      expect(n.ours, greaterThanOrEqualTo(3), reason: 'too few of his matches');
      expect(n.world, greaterThan(n.ours), reason: 'the world must play too');
      final row = (await fam.forCareer(career.id))[shape]!;
      expect(row.lastPlanKey, TeamChemistry.planKey(plan));
      expect(row.predictability, greaterThan(0));
    },
  );

  test(
    'a played match records once; the world it catches up records nothing',
    () async {
      // Committing a played match also simulates the world up to it, with the
      // manager's own nation excluded: a background-only step. The drilling
      // must come out as exactly ONE recording of his plan, from the played
      // path, and none from the world's matches around it.
      final w = open();
      await w.c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await w.c
                  .read(careerServiceProvider)
                  .create(nationId: czechia, managerName: 'M', rngSeed: 78))
              .valueOrNull!;
      await w.c.read(tacticServiceProvider).setFormation(career.id, shape);
      await w.c.read(tacticServiceProvider).setInstructions(career.id, plan);
      final held = w.c.listen(matchPreviewProvider(career.id), (_, _) {});
      addTearDown(held.close);
      final preview = (await w.c.read(matchPreviewProvider(career.id).future))!;
      await w.c
          .read(seasonServiceProvider)
          .playPlayerMatch(career.id, preview.fixture, preview.result);

      final worldPlayed = (await w.db.select(w.db.fixtures).get()).where(
        (f) =>
            f.played && f.homeNationId != czechia && f.awayNationId != czechia,
      );
      expect(worldPlayed, isNotEmpty, reason: 'the world must have caught up');

      final ref = open();
      await ref.c.read(seedLoaderProvider).ensureSeeded();
      final refCareer =
          (await ref.c
                  .read(careerServiceProvider)
                  .create(nationId: czechia, managerName: 'M', rngSeed: 78))
              .valueOrNull!;
      final refFam = ref.c.read(tacticFamiliarityRepositoryProvider);
      await refFam.recordMatch(
        refCareer.id,
        shape,
        planKey: TeamChemistry.planKey(plan),
      );
      expect(
        await w.c
            .read(tacticFamiliarityRepositoryProvider)
            .forCareer(career.id),
        await refFam.forCareer(refCareer.id),
      );
    },
  );
  test(
    'skipped knockouts (extra time) and finals matches record once each',
    () async {
      // A finals match goes through the neutral-venue branch of the skip path
      // and a level knockout through extra time and maybe penalties
      // (`decideKnockout`); both are still ONE recording of his plan. Seed 80
      // reaches Czechia's first continental finals match at the 9th advance
      // and a round of 16 there settled after extra time at the 12th.
      final w = open();
      await w.c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await w.c
                  .read(careerServiceProvider)
                  .create(nationId: czechia, managerName: 'M', rngSeed: 80))
              .valueOrNull!;
      await w.c.read(tacticServiceProvider).setFormation(career.id, shape);
      await w.c.read(tacticServiceProvider).setInstructions(career.id, plan);

      final ref = open();
      await ref.c.read(seedLoaderProvider).ensureSeeded();
      final refCareer =
          (await ref.c
                  .read(careerServiceProvider)
                  .create(nationId: czechia, managerName: 'M', rngSeed: 80))
              .valueOrNull!;
      final refFam = ref.c.read(tacticFamiliarityRepositoryProvider);
      final fam = w.c.read(tacticFamiliarityRepositoryProvider);

      var recorded = 0;
      var finals = false;
      var extraTime = false;
      for (var step = 0; step < 20 && !(finals && extraTime); step++) {
        await w.c.read(seasonServiceProvider).advance(career.id);
        var ours = 0;
        for (final f in await w.db.select(w.db.fixtures).get()) {
          if (!f.played) continue;
          if (f.homeNationId != czechia && f.awayNationId != czechia) continue;
          ours++;
          if (isNeutralFinalsRound(f.round)) finals = true;
          if (Rounds.isKnockout(f.round) && f.afterExtraTime) extraTime = true;
        }
        for (; recorded < ours; recorded++) {
          await refFam.recordMatch(
            refCareer.id,
            shape,
            planKey: TeamChemistry.planKey(plan),
          );
        }
        expect(
          await fam.forCareer(career.id),
          await refFam.forCareer(refCareer.id),
          reason: 'after $ours of his matches (step $step)',
        );
      }
      expect(finals, isTrue, reason: 'no finals match was skipped');
      expect(extraTime, isTrue, reason: 'no knockout went to extra time');
    },
    timeout: const Timeout(Duration(minutes: 3)),
  );

  test(
    'a played match records the plan held longest, not the team sheet',
    () async {
      // The decoy: name one plan on the sheet, switch to another at 1'. The
      // opposition's video shows the plan played, so that is what's recorded.
      final w = open();
      await w.c.read(seedLoaderProvider).ensureSeeded();
      final career =
          (await w.c
                  .read(careerServiceProvider)
                  .create(nationId: czechia, managerName: 'M', rngSeed: 78))
              .valueOrNull!;
      await w.c.read(tacticServiceProvider).setFormation(career.id, shape);
      await w.c.read(tacticServiceProvider).setInstructions(career.id, plan);
      final held = w.c.listen(matchPreviewProvider(career.id), (_, _) {});
      addTearDown(held.close);
      final preview = (await w.c.read(matchPreviewProvider(career.id).future))!;
      final mine = preview.playerIsHome ? preview.homeTeam : preview.awayTeam;
      const live = TacticalInstructions(directness: 20, tempo: 40);
      final result = const MatchEngine().play(
        home: preview.homeTeam,
        away: preview.awayTeam,
        rng: SeededRng(1),
        changes: [
          TacticalChange(
            teamNationId: mine.nationId,
            minute: 1,
            formation: Formation.f442,
            instructions: live,
            xi: mine.xi,
          ),
        ],
      );
      await w.c
          .read(seasonServiceProvider)
          .playPlayerMatch(career.id, preview.fixture, result);

      final rows = await w.c
          .read(tacticFamiliarityRepositoryProvider)
          .forCareer(career.id);
      expect(rows.keys, [
        Formation.f442,
      ], reason: 'the sheet shape was a decoy');
      expect(rows[Formation.f442]!.lastPlanKey, TeamChemistry.planKey(live));
    },
  );
}
