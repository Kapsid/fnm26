import 'dart:convert';
import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/data_providers.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/competition/trophies.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/career/career_providers.dart';
import 'package:fnm/features/world_pack/world_pack_providers.dart';

import '../../helpers/test_database.dart';
import '../greenland/greenland_fixtures.dart';

/// The pin on old worlds, written from the 1.1.0 code before editor 2: a
/// default career and a career on a format-1 (1.1.0) database read exactly
/// these players, sponsor rounds and Y names for the same seed. Every later
/// change that touches a career read re-runs it.
///
/// Regenerate the golden only on purpose: `WRITE_GOLDEN=1`. The format-1
/// pack itself is written only with `WRITE_V1_PACK=1`, and only by a build
/// whose current format is 1: it stands for a 1.1.0 file and must never be
/// rewritten by a newer build.
const _seed = 42;
const _nations = [1, 23, 140];
const _agingYears = [0, 6];
const _packFile = 'test/unit/world_pack/fixtures/v1_pack.json';
const _goldenFile = 'test/unit/world_pack/fixtures/v1_world_pin.json';

bool _env(String k) => Platform.environment[k] == '1';

/// A seeded container over a fresh database.
Future<ProviderContainer> _world() async {
  final db = createTestDatabase();
  addTearDown(db.close);
  final c = greenlandContainer(db);
  addTearDown(c.dispose);
  await c.read(seedLoaderProvider).ensureSeeded();
  return c;
}

/// The default world as a 1.1.0 pack, with one entry in every override map
/// and a squad edit: a renamed core player and a pack-made player.
Future<WorldPack> _buildV1Pack(ProviderContainer c) async {
  final squads = await c.read(worldPackServiceProvider).defaultSquads();
  final first = squads[1]!.first;
  final squad23 = squads[23]!;
  final renamed = squad23.first;
  return WorldPack(
    uuid: 'v1-pin-0000-0000-0000-000000000001',
    name: 'Pin 1.1.0',
    author: 'Pin',
    formatVersion: 1,
    madeWithVersion: '1.1.0',
    squads: {
      ...squads,
      23: [
        for (final p in squad23)
          if (p.id == renamed.id)
            PackPlayer(
              id: p.id,
              name: 'Pinned Renamed',
              age: p.age,
              position: p.position,
              attributes: p.attributes,
              potential: p.potential,
              club: p.club,
              clubCountry: p.clubCountry,
            )
          else
            p,
        const PackPlayer(
          id: kPackPlayerIdBase + 1,
          name: 'Pinned Added',
          age: 22,
          position: PlayerPosition.st,
          attributes: PlayerAttributes(
            physical: 70,
            technical: 72,
            stamina: 68,
          ),
          potential: 80,
          club: 'Klokani Praha',
          clubCountry: 'cze',
        ),
      ],
    },
    nations: const {140: (name: 'Pinland', code: '')},
    clubs: {first.club!: 'Pinned FC'},
    stadiums: const {'23:Pin City': 'Pin Arena'},
    competitions: const {'World Championship': 'Pin Globe'},
    yAccounts: {YFeed.namedAccounts.first: 'PinAccount'},
    reporters: const {0: PackReporter(name: 'Pin Reporter', outlet: 'Pin')},
    nameLists: {
      140: PackNameLists(
        first: [for (var i = 0; i < 20; i++) 'Pinfirst$i'],
        sur: [for (var i = 0; i < 20; i++) 'Pinsur$i'],
      ),
    },
    sponsors: {SponsorBrand.values.first.name: 'Pin Brand'},
    trophies: {Trophies.cabinet.first.key},
  );
}

List<Object?> _row(Player p) => [
  p.name,
  p.overall,
  p.club,
  p.clubCountry,
  [for (final t in PlayerTraits.of(p, saveSeed: _seed)) t.name],
];

Future<Map<String, Object>> _players(ProviderContainer c, int career) async {
  final players = c.read(playerRepositoryProvider);
  final out = <String, Object>{};
  for (final n in _nations) {
    for (final years in _agingYears) {
      final pool = await players.byNation(
        n,
        agingYears: years,
        saveSeed: _seed,
        careerId: career,
        minAge: 15,
      );
      expect(pool, isNotEmpty, reason: 'nation $n, year $years');
      out['$n/$years'] = {for (final p in pool) '${p.id}': _row(p)};
    }
  }
  return out;
}

Map<String, Object> _sponsors() => {
  for (var s = 1; s <= 20; s++)
    for (var cycle = 0; cycle <= 3; cycle++)
      '$s/$cycle': [
        for (final b in Sponsors.brandsFor(
          seed: s,
          cycle: cycle,
          czech: false,
        ))
          b.name,
      ],
};

Map<String, Object> _y() => {
  for (final v in YVoice.values)
    for (var i = 0; i < 10; i++)
      '${v.name}/$i': YFeed.personaFor(v, 'Czechia', _seed, 'k$i').displayName,
};

void main() {
  test(
    'default and 1.1.0 worlds read exactly as pinned',
    timeout: const Timeout.factor(8),
    () async {
      final c = await _world();
      final careers = c.read(careerServiceProvider);

      final plain = (await careers.create(
        nationId: 1,
        managerName: 'M',
        rngSeed: _seed,
      )).valueOrNull!;
      final defaultReads = await _players(c, plain.id);

      final packFile = File(_packFile);
      if (_env('WRITE_V1_PACK')) {
        expect(
          kPackFormatVersion,
          1,
          reason: 'only a 1.1.0 build writes the format-1 pack',
        );
        packFile
          ..createSync(recursive: true)
          ..writeAsStringSync(jsonEncode((await _buildV1Pack(c)).toJson()));
      }
      final raw =
          jsonDecode(packFile.readAsStringSync()) as Map<String, Object?>;
      expect(raw['formatVersion'], 1, reason: 'the fixture is a 1.1.0 file');
      final pack = WorldPack.fromJson(WorldPack.migrate(raw));
      final packId = await c
          .read(worldPackRepositoryProvider)
          .insert(pack, const {});
      final onPack = (await careers.create(
        nationId: 1,
        managerName: 'M',
        rngSeed: _seed,
        worldPackId: packId,
      )).valueOrNull;
      expect(onPack, isNotNull, reason: 'the 1.1.0 pack starts a career');

      final packReads = await _players(c, onPack!.id);
      // The pack's edits show: the pin reads a 1.1.0 world, not the default.
      final day23 = jsonEncode(packReads['23/0']);
      expect(day23, contains('Pinned Renamed'));
      expect(day23, contains('Pinned Added'));
      expect(jsonEncode(packReads['1/0']), contains('Pinned FC'));

      // Round-trip through JSON so the comparison is like for like.
      final got = jsonDecode(
        jsonEncode({
          'default': defaultReads,
          'v1Pack': packReads,
          'sponsors': _sponsors(),
          'y': _y(),
        }),
      );
      final golden = File(_goldenFile);
      if (_env('WRITE_GOLDEN')) {
        golden
          ..createSync(recursive: true)
          ..writeAsStringSync(const JsonEncoder.withIndent(' ').convert(got));
      }
      expect(got, jsonDecode(golden.readAsStringSync()));
    },
  );
}
