import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/data/seed/seed_source.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/entitlement/entitlement.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/hub/hub_providers.dart';
import 'package:fnm/features/tactics/tactics_providers.dart';

import '../../helpers/test_database.dart';

/// Moving the manager to a new nation must leave them with a real squad.
///
/// Player ids are partitioned per nation, so the old nation's call-ups share no
/// ids with the new nation's pool. Call-ups/tactics are keyed by careerId alone,
/// so if they survive a switch they filter the new pool down to nothing: the
/// manager arrives at a new job with an empty team and no way to fix it.
void main() {
  test('switching nation gives the manager the new nation\'s squad', () async {
    final db = createTestDatabase();
    final nations = (jsonDecode(
      File('assets/data/nations.json').readAsStringSync(),
    ) as List<dynamic>)
        .map((e) => Nation.fromJson(e as Map<String, Object?>))
        .toList();

    // Real squads: this test is about which players a manager can pick, so an
    // empty player pool would make it pass vacuously.
    final base = (jsonDecode(
      File('assets/data/players.json').readAsStringSync(),
    ) as List<dynamic>)
        .map((e) => Player.fromJson(e as Map<String, Object?>))
        .toList();
    final namesRaw = jsonDecode(
      File('assets/data/country_names.json').readAsStringSync(),
    ) as Map<String, Object?>;
    final namesByNation = <int, ({List<String> first, List<String> sur})>{
      for (final e in namesRaw.entries)
        int.parse(e.key): (
          first: ((e.value! as Map)['first'] as List).cast<String>(),
          sur: ((e.value! as Map)['sur'] as List).cast<String>(),
        ),
    };
    final players = PoolGenerator.expand(base, namesByNation: namesByNation);

    final container = ProviderContainer(
      overrides: [
        appDatabaseProvider.overrideWithValue(db),
        premiumUnlockedProvider.overrideWith((ref) => true),
        seedSourceProvider.overrideWithValue(
          InMemorySeedSource(nationList: nations, playerList: players),
        ),
      ],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

    await container.read(seedLoaderProvider).ensureSeeded();
    final europeans = nations
        .where((n) => n.confederation == Confederation.europe)
        .toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));
    final from = europeans.first;
    final to = europeans[1];

    final career = (await container.read(careerServiceProvider).create(
          nationId: from.id,
          managerName: 'M',
        ))
        .valueOrNull!;

    final playerRepo = container.read(playerRepositoryProvider);
    final squadRepo = container.read(squadRepositoryProvider);

    // The manager curates a squad at their first job.
    final fromPool = await playerRepo.byNation(from.id, saveSeed: career.rngSeed);
    final fromIds = fromPool.take(23).map((p) => p.id).toSet();
    await squadRepo.setCallUps(career.id, fromIds);

    // Play out the cycle so the next one can begin.
    final season = container.read(seasonServiceProvider);
    var last = DateTime(1900);
    for (var i = 0; i < 400; i++) {
      await season.advance(career.id);
      final hub = await container.read(hubDataProvider(career.id).future);
      if (hub == null || hub.championNationId != null) break;
      if (!hub.career.inGameDate.isAfter(last)) break;
      last = hub.career.inGameDate;
    }
    expect(
      await container.read(competitionRepositoryProvider).worldChampion(
            career.id,
          ),
      isNotNull,
      reason: 'the cycle must finish before the manager can move',
    );

    // The manager takes a new job.
    await season.startNextCycle(career.id, switchToNationId: to.id);

    final moved =
        await container.read(careerRepositoryProvider).byId(career.id);
    expect(moved!.nationId, to.id);

    // The new nation's pool shares no ids with the old one.
    // minAge 15, matching what the call-up screen asks for: the squad screen
    // reaches down to the U-17s so a wonderkid can be named, and this set is
    // what its pool is checked against below.
    final toPool = await playerRepo.byNation(
      to.id,
      agingYears: CareerService.agingYears(moved),
      saveSeed: moved.rngSeed,
      minAge: 15,
    );
    final toIds = toPool.map((p) => p.id).toSet();
    expect(
      toIds.intersection(fromIds),
      isEmpty,
      reason: 'nations partition player ids — this is why stale call-ups kill',
    );

    // No call-up may still name a player the manager can no longer pick.
    final callUps = await squadRepo.callUps(career.id);
    expect(
      callUps.difference(toIds),
      isEmpty,
      reason: 'call-ups must not survive a move to a new nation',
    );

    // The call-up screen must offer the NEW nation's players.
    final squad = await container.read(squadDataProvider(career.id).future);
    expect(squad, isNotNull);
    expect(
      squad!.pool.map((p) => p.id).toSet().difference(toIds),
      isEmpty,
      reason: 'the squad screen must show the new nation, not the old one',
    );

    // And the manager must be able to field a team.
    final tactic = await container.read(tacticDataProvider(career.id).future);
    expect(tactic, isNotNull);
    expect(
      tactic!.pool,
      isNotEmpty,
      reason: 'a manager must never arrive at a new job with an empty squad',
    );
    final named = tactic.tactic.lineup.whereType<int>().toList();
    expect(named, isNotEmpty, reason: 'a starting XI must be picked');
    expect(
      named.toSet().difference(toIds),
      isEmpty,
      reason: 'the XI must name the new nation\'s players',
    );
  }, timeout: const Timeout(Duration(minutes: 6)));
}
