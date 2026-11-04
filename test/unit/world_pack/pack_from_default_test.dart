import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/data/repositories/world_pack_repository.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/player/player_aging.dart';
import 'package:fnm/domain/services/player/player_lifecycle.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

/// The placeholder names `players.json` ships, by id.
final Map<int, String> _placeholders = {
  for (final p
      in jsonDecode(File('assets/data/players.json').readAsStringSync())
          as List)
    (p as Map)['id'] as int: p['name'] as String,
};

/// A seeded container plus a service whose repository runs on [clock].
Future<
  ({ProviderContainer c, WorldPackService service, WorldPackRepository repo})
>
_world(DateTime clock) async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  final repo = WorldPackRepository(db, clock: () => clock);
  final service = WorldPackService(
    players: c.read(playerRepositoryProvider),
    nations: c.read(nationRepositoryProvider),
    packs: repo,
  );
  return (c: c, service: service, repo: repo);
}

void main() {
  test(
    'the default pack is complete',
    timeout: const Timeout.factor(4),
    () async {
      final w = await _world(DateTime(2026, 11, 4));
      final id = await w.service.createFromDefault('My world');
      final pack = (await w.repo.load(id))!;

      final world = await w.c.read(nationRepositoryProvider).newCareerWorld();
      expect(pack.name, 'My world');
      expect(pack.formatVersion, kPackFormatVersion);
      expect(pack.squads.keys.toSet(), {for (final n in world) n.id});
      for (final squad in pack.squads.values) {
        expect(squad, hasLength(23));
        // Core players only: no generated fringe.
        expect(squad.every((p) => p.id < 10000000), isTrue);
        for (final p in squad) {
          final overall = OverallRating.forPosition(p.position, p.attributes);
          expect(p.potential, greaterThanOrEqualTo(overall));
          expect(p.club, isNotNull);
        }
      }
      expect(pack.nations, isEmpty);
      expect(pack.clubs, isEmpty);
      expect(pack.stadiums, isEmpty);
      expect(pack.competitions, isEmpty);
      expect(pack.yAccounts, isEmpty);
      expect(pack.reporters, isEmpty);
      expect(pack.nameLists, isEmpty);
      expect(pack.sponsors, isEmpty);
      expect(pack.trophies, isEmpty);
      expect(
        PackRules.isComplete(
          pack,
          baseCodes: {for (final n in world) n.id: n.code},
        ),
        isTrue,
        reason: PackRules.issues(pack).map((i) => i.where).join(', '),
      );
    },
  );

  test('two packs created a day apart have the same names', () async {
    final a = await _world(DateTime(2026, 11, 4));
    final b = await _world(DateTime(2026, 11, 5));
    final pa = (await a.repo.load(await a.service.createFromDefault('A')))!;
    final pb = (await b.repo.load(await b.service.createFromDefault('B')))!;
    expect(pa.uuid, isNot(pb.uuid));
    expect(pb.squads, pa.squads);
  });

  test('names are the drawn names, not players.json placeholders', () async {
    final w = await _world(DateTime(2026, 11, 4));
    final pack = (await w.repo.load(await w.service.createFromDefault('X')))!;

    final all = [for (final s in pack.squads.values) ...s];
    final same = all.where((p) => _placeholders[p.id] == p.name).length;
    expect(same, lessThan(all.length ~/ 20));

    // Exactly what a career created now on seed kPackDrawSeed is given: the
    // current (1.0.9) pools, not the oldest ones a career-less read gets.
    final career = await w.c
        .read(careerRepositoryProvider)
        .create(
          managerName: 'M',
          nationId: 1,
          rngSeed: kPackDrawSeed,
          startDate: DateTime(2026, 9),
        );
    final comp = w.c.read(competitionRepositoryProvider);
    for (final k in [
      namePoolsV2Kind,
      namePoolsV3Kind,
      namePoolsV4Kind,
      namePoolsV5Kind,
    ]) {
      await comp.markDrawWatched(career.id, 0, k);
    }
    final players = w.c.read(playerRepositoryProvider);
    // Germany, Croatia (the 1.0.9 guard), Brazil (1.0.9 mononyms), Belarus,
    // and Spain (50), whose 34-year-old 5017 retires on day one.
    for (final nationId in [20, 10, 58, 6, 50]) {
      final drawn = {
        for (final p in await players.byNation(
          nationId,
          saveSeed: kPackDrawSeed,
          careerId: career.id,
        ))
          p.id: p.name,
      };
      for (final p in pack.squads[nationId]!) {
        // A veteran retired on day one is read by identity.
        final want =
            drawn[p.id] ??
            (await players.byId(
              p.id,
              saveSeed: kPackDrawSeed,
              careerId: career.id,
            ))?.name;
        expect(p.name, want, reason: 'player ${p.id}');
      }
    }
    // Brazil really is on the 1.0.9 pools: someone goes by one name.
    expect(pack.squads[58]!.any((p) => !p.name.contains(' ')), isTrue);
  });

  group('peakOverall', () {
    const attrs = PlayerAttributes(physical: 60, technical: 62, stamina: 58);

    test('a player of 27 or older is already at his peak', () {
      final now = OverallRating.forPosition(PlayerPosition.cm, attrs);
      expect(
        PlayerLifecycle.peakOverall(101, PlayerPosition.cm, attrs, 27),
        now,
      );
      expect(
        PlayerLifecycle.peakOverall(101, PlayerPosition.cm, attrs, 33),
        now,
      );
    });

    test('a young player peaks above where he is, by the expected gain', () {
      // An id that is not a superstar.
      final id = [
        for (var i = 1; i < 500; i++) i,
      ].firstWhere((i) => !PlayerLifecycle.isSuperstar(i));
      final now = OverallRating.forPosition(PlayerPosition.cm, attrs);
      final peak = PlayerLifecycle.peakOverall(
        id,
        PlayerPosition.cm,
        attrs,
        19,
      );
      expect(peak, (now + PlayerAging.expectedGain(id, 19, 27)).round());
      expect(peak, greaterThan(now));
    });

    test('a young superstar peaks near his own level', () {
      var id = 1;
      while (!PlayerLifecycle.isSuperstar(id)) {
        id++;
      }
      final peak = PlayerLifecycle.peakOverall(
        id,
        PlayerPosition.st,
        attrs,
        19,
      );
      expect(peak, greaterThan(85));
      expect(peak, lessThanOrEqualTo(99));
    });
  });
}
