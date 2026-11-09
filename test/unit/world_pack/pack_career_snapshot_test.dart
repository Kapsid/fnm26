import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

/// A career copies the database it started on (`copyToCareer`, read back by
/// `forCareer`), so what the editor does to that database afterwards, an
/// edit or a delete, must never reach a career already under way.
void main() {
  late ProviderContainer c;

  setUp(() async {
    final db = createTestDatabase();
    addTearDown(db.close);
    c = greenlandContainer(db);
    addTearDown(c.dispose);
    await c.read(seedLoaderProvider).ensureSeeded();
  });

  final png = Uint8List.fromList(List.generate(64, (i) => i));

  /// A career on a new copy of the default world with one renamed club, one
  /// renamed player and one trophy picture; returns the pack's id, the
  /// career's id and the pack as the career was started on it.
  Future<({int pack, int career, WorldPack started})> start() async {
    final repo = c.read(worldPackRepositoryProvider);
    final id = await c.read(worldPackServiceProvider).createFromDefault('Src');
    final base = (await repo.load(id))!;
    final nation = base.squads.keys.first;
    final squad = base.squads[nation]!;
    final edited = base.copyWith(
      clubs: {'Some FC': 'Renamed FC'},
      squads: {
        ...base.squads,
        nation: [
          for (final p in squad)
            if (p.id == squad.first.id)
              PackPlayer(
                id: p.id,
                name: 'Original Name',
                age: p.age,
                position: p.position,
                attributes: p.attributes,
                potential: p.potential,
                club: p.club,
                clubCountry: p.clubCountry,
              )
            else
              p,
        ],
      },
    );
    await repo.save(id, edited);
    await repo.setTrophy(
      id,
      'world',
      png,
      pack: edited.copyWith(trophies: {'world'}),
    );
    final started = (await repo.load(id))!;
    final career =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: 1,
                  managerName: 'M',
                  rngSeed: 7,
                  worldPackId: id,
                ))
            .valueOrNull!;
    return (pack: id, career: career.id, started: started);
  }

  Future<String> careerJson(int career) async {
    final world = await c.read(worldPackRepositoryProvider).forCareer(career);
    return jsonEncode(world!.pack.toJson());
  }

  test('the career holds the database as it was when it started', () async {
    final s = await start();
    final world = await c.read(worldPackRepositoryProvider).forCareer(s.career);
    expect(world, isNotNull);
    expect(jsonEncode(world!.pack.toJson()), jsonEncode(s.started.toJson()));
    expect(world.trophies['world'], png);
  });

  test('editing the database leaves a career already started on it as it '
      'was', () async {
    final s = await start();
    final repo = c.read(worldPackRepositoryProvider);
    final before = await careerJson(s.career);

    // Every kind of edit the editor makes: names, a player, the squad
    // itself, a picture.
    final nation = s.started.squads.keys.first;
    final edited = s.started.copyWith(
      name: 'Src, edited',
      clubs: {'Some FC': 'Another FC', 'Other FC': 'Third FC'},
      squads: {
        ...s.started.squads,
        nation: [
          for (final p in s.started.squads[nation]!.skip(1))
            PackPlayer(
              id: p.id,
              name: 'Edited ${p.id}',
              age: p.age,
              position: p.position,
              attributes: p.attributes,
              potential: p.potential,
              club: p.club,
              clubCountry: p.clubCountry,
            ),
        ],
      },
    );
    await repo.save(s.pack, edited);
    await repo.setTrophy(
      s.pack,
      'world',
      Uint8List.fromList([9, 9, 9]),
      pack: edited,
    );

    // The pack did change...
    final now = (await repo.load(s.pack))!;
    expect(now.name, 'Src, edited');
    expect(now.clubs, {'Some FC': 'Another FC', 'Other FC': 'Third FC'});
    expect((await repo.trophies(s.pack))['world'], [9, 9, 9]);
    // ...and the career did not.
    expect(await careerJson(s.career), before);
    final world = (await repo.forCareer(s.career))!;
    expect(world.pack.name, 'Src');
    expect(world.pack.clubs, {'Some FC': 'Renamed FC'});
    expect(world.trophies['world'], png);
  });

  test(
    'deleting the database leaves a career started on it as it was',
    () async {
      final s = await start();
      final repo = c.read(worldPackRepositoryProvider);
      final before = await careerJson(s.career);

      await repo.delete(s.pack);

      expect(await repo.load(s.pack), isNull);
      expect(await careerJson(s.career), before);
      final world = (await repo.forCareer(s.career))!;
      expect(world.trophies['world'], png);
    },
  );

  test('a second career on the edited database gets the edit, the first '
      'does not', () async {
    final s = await start();
    final repo = c.read(worldPackRepositoryProvider);
    final before = await careerJson(s.career);
    await repo.save(
      s.pack,
      s.started.copyWith(clubs: {'Some FC': 'Edited Later FC'}),
    );
    final second =
        (await c
                .read(careerServiceProvider)
                .create(
                  nationId: 1,
                  managerName: 'N',
                  rngSeed: 8,
                  worldPackId: s.pack,
                ))
            .valueOrNull!;

    expect(
      (await repo.forCareer(second.id))!.pack.clubs,
      {'Some FC': 'Edited Later FC'},
    );
    expect(await careerJson(s.career), before);
  });
}
