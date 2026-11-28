import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/services/player/secondary_positions.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/editor/players/squad_edits.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

const _albania = 1;

Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

void main() {
  group('the editor override of secondary positions', () {
    late WorldPack pack;
    late PackPlayer winger;

    setUp(() async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final id = await c.read(worldPackServiceProvider).createFromDefault('W');
      pack = (await packs.load(id))!;
      final squad = pack.squads[_albania]!;
      winger = squad.firstWhere((p) => p.position != PlayerPosition.gk);
    });

    test('Derived shows what the game derives; a pick replaces it', () {
      expect(winger.secondaries, isNull);
      expect(
        SquadEdits.secondariesOf(winger),
        SecondaryPositions.derive(
          winger.id,
          winger.position,
          winger.attributes,
        ),
      );
      final picked = SquadEdits.withSecondaries(winger, [
        PlayerPosition.st,
        PlayerPosition.am,
      ]);
      expect(picked.secondaries, [PlayerPosition.st, PlayerPosition.am]);
      expect(SquadEdits.secondariesOf(picked).map((s) => s.position), [
        PlayerPosition.st,
        PlayerPosition.am,
      ]);
      final none = SquadEdits.withSecondaries(winger, const []);
      expect(SquadEdits.secondariesOf(none), isEmpty);
      expect(SquadEdits.withSecondaries(picked, null).secondaries, isNull);
    });

    test('a pick keeps to two, never his own place nor a keeper', () {
      final p = SquadEdits.withSecondaries(winger, [
        winger.position,
        PlayerPosition.gk,
        PlayerPosition.st,
        PlayerPosition.st,
        PlayerPosition.am,
        PlayerPosition.cb,
      ]);
      expect(p.secondaries, hasLength(2));
      expect(p.secondaries, isNot(contains(winger.position)));
      expect(p.secondaries, isNot(contains(PlayerPosition.gk)));
      // Moved to a pick's position, he loses it from the pick.
      final moved = SquadEdits.copy(p, position: p.secondaries!.first);
      expect(moved.secondaries, isNot(contains(moved.position)));
    });

    test('a pick is stored in the pack (format 10) and read back', () {
      final p = SquadEdits.withSecondaries(winger, [PlayerPosition.am]);
      final edited = SquadEdits.replace(pack, _albania, p);
      expect(pack.asWritten.formatVersion, lessThan(10));
      expect(edited.asWritten.formatVersion, 10);
      final back = WorldPack.fromJson(
        jsonDecode(jsonEncode(edited.asWritten.toJson()))
            as Map<String, Object?>,
      );
      expect(
        back.squads[_albania]!.firstWhere((x) => x.id == p.id).secondaries,
        [PlayerPosition.am],
      );
      // A pack with no pick writes no key at all.
      final plain = jsonEncode(pack.asWritten.toJson());
      expect(plain.contains('secondaries'), isFalse);
    });

    test('an older format carrying a pick is refused', () {
      final p = SquadEdits.withSecondaries(winger, [PlayerPosition.am]);
      final json =
          jsonDecode(
                jsonEncode(SquadEdits.replace(pack, _albania, p).toJson()),
              )
              as Map<String, Object?>;
      json['formatVersion'] = 9;
      expect(() => WorldPack.migrate(json), throwsFormatException);
    });

    test('the rules flag a bad pick', () {
      final bad = PackPlayer(
        id: winger.id,
        name: winger.name,
        age: winger.age,
        position: winger.position,
        attributes: winger.attributes,
        potential: winger.potential,
        secondaries: const [
          PlayerPosition.gk,
          PlayerPosition.st,
          PlayerPosition.am,
        ],
      );
      final issues = PackRules.squadIssues(_albania, [bad]);
      expect(
        issues.whereType<BadField>().map((i) => i.path),
        contains(endsWith('${winger.id}.secondaries')),
      );
    });

    test('a career on the pack plays the pick', () async {
      final c = await _world();
      final packs = c.read(worldPackRepositoryProvider);
      final packId = await c
          .read(worldPackServiceProvider)
          .createFromDefault('W');
      var w = (await packs.load(packId))!;
      final him = w.squads[_albania]!.firstWhere(
        (p) => p.position != PlayerPosition.gk,
      );
      w = SquadEdits.replace(
        w,
        _albania,
        SquadEdits.withSecondaries(him, [PlayerPosition.am]),
      );
      await packs.save(packId, w);
      final career =
          (await c
                  .read(careerServiceProvider)
                  .create(
                    nationId: _albania,
                    managerName: 'M',
                    rngSeed: 7,
                    worldPackId: packId,
                  ))
              .valueOrNull!;
      final read = await c
          .read(playerRepositoryProvider)
          .byNation(_albania, careerId: career.id, saveSeed: career.rngSeed);
      final p = read.firstWhere((x) => x.id == him.id);
      expect(p.fixedSecondaries, [PlayerPosition.am]);
      expect(SecondaryPositions.of(p).single.position, PlayerPosition.am);
    });
  });
}
