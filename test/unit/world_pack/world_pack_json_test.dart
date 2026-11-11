import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/pack_paths.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

const _v1Fixture = 'test/unit/world_pack/fixtures/v1_pack.json';

const _player = PackPlayer(
  id: kPackPlayerIdBase + 1,
  name: 'A. Test',
  age: 24,
  position: PlayerPosition.gk,
  attributes: PlayerAttributes(physical: 60, technical: 70, stamina: 65),
  potential: 80,
  club: 'FC X',
  clubCountry: 'Czechia',
);

WorldPack _pack() => const WorldPack(
  uuid: 'u-1',
  name: 'My World',
  author: 'Me',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  squads: {
    7: [_player],
  },
  nations: {7: (name: 'Testland', code: 'TST')},
  clubs: {'Old FC': 'New FC'},
  stadiums: {'7:Prague': 'Arena'},
  competitions: {'World Championship': 'Globe Cup'},
  yAccounts: {'Old': 'New'},
  reporters: {3: PackReporter(name: 'Bob', outlet: 'Daily')},
  nameLists: {
    7: PackNameLists(first: ['Al'], sur: ['Bo']),
  },
  sponsors: {'Brand': 'Brand2'},
  trophies: {'worldChampionship'},
);

PackPlayer _withTraits(List<PlayerTrait>? traits) => PackPlayer(
  id: kPackPlayerIdBase + 2,
  name: 'B. Test',
  age: 20,
  position: PlayerPosition.st,
  attributes: const PlayerAttributes(physical: 66, technical: 61, stamina: 70),
  potential: 75,
  traits: traits,
);

final PackPlayer _none = _withTraits(const []);

const _club = PackClub(
  id: kPackAddedIdBase + 1,
  name: 'Pin FC',
  country: 'cze',
);

const _sponsor = PackSponsor(
  id: kPackAddedIdBase + 2,
  name: 'Pin Beer',
  deal: SponsorDeal.crowdPleaser,
  industry: 'happyBurgers',
  description: 'Cold and cheap.',
);

const _yAll = PackYAccount(
  id: kPackAddedIdBase + 3,
  name: 'PinFan',
  voice: YVoice.fan,
);

const _yOne = PackYAccount(
  id: kPackAddedIdBase + 4,
  name: 'PinPundit',
  voice: YVoice.pundit,
  nationId: 7,
);

const _localized = {
  'clubs.Old FC': {'cs': 'Nový FC'},
  'addedSponsors.700000002.description': {'cs': 'Studené a levné.'},
};

WorldPack _v2Pack() => _pack().copyWith(
  pools: {
    7: [
      _withTraits(const [PlayerTrait.setPiece, PlayerTrait.leader]),
      _none,
    ],
  },
  addedClubs: const [_club],
  addedSponsors: const [_sponsor],
  addedYAccounts: const [_yAll, _yOne],
  localized: _localized,
);

void main() {
  test('round trip keeps every field', () {
    final p = _pack();
    expect(WorldPack.fromJson(p.toJson()), p);
  });

  test('wrong types throw FormatException', () {
    final good = _pack().toJson();
    for (final bad in <Map<String, Object?>>[
      {...good, 'squads': 'x'},
      {
        ...good,
        'nations': {'1': 5},
      },
      {
        ...good,
        'squads': {'abc': <Object?>[]},
      },
    ]) {
      expect(() => WorldPack.fromJson(bad), throwsFormatException);
    }
    final json = _pack().toJson();
    final squads = json['squads']! as Map<String, Object?>;
    final players = (squads['7']! as List).cast<Map<String, Object?>>();
    squads['7'] = [
      {...players.first, 'age': '20'},
    ];
    expect(() => WorldPack.fromJson(json), throwsFormatException);
  });

  test('only canonical integer keys read as ids', () {
    final good = _pack().toJson();
    for (final key in ['07', '+7', ' 7', '7 ', '0x7', '-0']) {
      expect(
        () => WorldPack.fromJson({
          ...good,
          'nations': {
            key: {'name': 'Testland', 'code': 'TST'},
          },
        }),
        throwsFormatException,
        reason: 'key "$key"',
      );
    }
    expect(
      WorldPack.fromJson({
        ...good,
        'nations': {
          '-3': {'name': 'Testland', 'code': 'TST'},
        },
      }).nations.keys,
      [-3],
    );
  });

  test('unknown top-level keys throw', () {
    final json = {..._pack().toJson(), 'script': 'x'};
    expect(() => WorldPack.fromJson(json), throwsFormatException);
  });

  test('v2 migrates to v4 with empty managers', () {
    final v2 = _v2Pack().toJson()
      ..['formatVersion'] = 2
      ..remove('clubStrengths')
      ..remove('managers')
      ..remove('sponsorIndustries')
      ..remove('yHandles');
    final migrated = WorldPack.migrate(v2);
    expect(migrated['formatVersion'], kPackFormatVersion);
    expect(migrated['managers'], <String, Object?>{});
    final p = WorldPack.fromJson(migrated);
    expect(p.managers, isEmpty);
    expect(p.pools, _v2Pack().pools);
    // The stored v2 JSON is never written.
    expect(v2['formatVersion'], 2);
    expect(v2.containsKey('managers'), isFalse);
    // A v2 file already holding format 4's key is not a v2 file.
    expect(
      () => WorldPack.migrate({...v2, 'managers': <String, Object?>{}}),
      throwsFormatException,
    );
  });

  test('v3 (clubs) migrates to v4 with empty managers', () {
    final v3 = _v2Pack().copyWith(clubStrengths: const {'Man Blue': 2}).toJson()
      ..['formatVersion'] = 3
      ..remove('managers')
      ..remove('sponsorIndustries')
      ..remove('yHandles');
    final migrated = WorldPack.migrate(v3);
    expect(migrated['formatVersion'], kPackFormatVersion);
    final p = WorldPack.fromJson(migrated);
    expect(p.managers, isEmpty);
    expect(p.clubStrengths, {'Man Blue': 2});
    expect(v3.containsKey('managers'), isFalse);
    // A v3 file already holding format 4's key is not a v3 file.
    expect(
      () => WorldPack.migrate({...v3, 'managers': <String, Object?>{}}),
      throwsFormatException,
    );
  });

  test('asWritten: format 3 without managers, 4 with', () {
    final plain = _v2Pack().asWritten;
    expect(plain.formatVersion, 3);
    expect(plain.toJson().containsKey('managers'), isFalse);
    expect(plain.toJson().containsKey('clubStrengths'), isTrue);
    final withM = _v2Pack()
        .copyWith(managers: {7: (name: 'Ota Brnak', nationality: 'CZE')})
        .asWritten;
    expect(withM.formatVersion, 4);
    expect(withM.toJson().containsKey('managers'), isTrue);
    // A format-3 written pack reads back here unchanged.
    expect(
      WorldPack.fromJson(
        WorldPack.migrate(
          jsonDecode(jsonEncode(plain.toJson())) as Map<String, Object?>,
        ),
      ),
      _v2Pack(),
    );
  });

  test('v4 round trip keeps managers', () {
    final p = _v2Pack().copyWith(
      managers: {
        7: (name: 'Ota Brnak', nationality: 'CZE'),
        9: (name: 'Lew Ward', nationality: 'ENG'),
      },
    );
    expect(p.toJson()['formatVersion'], kPackFormatVersion);
    final back = WorldPack.fromJson(
      WorldPack.migrate(
        jsonDecode(jsonEncode(p.toJson())) as Map<String, Object?>,
      ),
    );
    expect(back, p);
    expect(back.managers[7], (name: 'Ota Brnak', nationality: 'CZE'));
    expect(back.managers[9]!.nationality, 'ENG');
    // A manager entry is read strictly, as every other part.
    for (final bad in <Object?>[
      {'name': 'X'},
      {'name': 'X', 'nationality': 3},
      {'name': 'X', 'nationality': 'ENG', 'age': 50},
      'X',
    ]) {
      expect(
        () => WorldPack.fromJson({
          ...p.toJson(),
          'managers': {'7': bad},
        }),
        throwsFormatException,
        reason: '$bad',
      );
    }
  });

  test('migrate refuses format 6', () {
    final json = _pack().toJson();
    expect(kPackFormatVersion, 5);
    expect(
      () => WorldPack.migrate({...json, 'formatVersion': 6}),
      throwsFormatException,
    );
  });

  test('migrate is identity at v5 and rejects newer or missing versions', () {
    final json = _pack().toJson();
    expect(WorldPack.migrate(json), json);
    expect(
      () =>
          WorldPack.migrate({...json, 'formatVersion': kPackFormatVersion + 1}),
      throwsFormatException,
    );
    expect(() => WorldPack.migrate({'name': 'x'}), throwsFormatException);
  });

  test('a pack made before a club was renamed reads under the new name', () {
    // What a pack made before the rename holds: the game's old name as the
    // key of its rename, strength and Czech name, and on its players.
    final old = _v2Pack().toJson();
    final squads = old['squads']! as Map<String, Object?>;
    final player = (squads['7']! as List).first as Map<String, Object?>;
    final json =
        {
            ...old,
            'formatVersion': 3,
            'clubs': {'Old FC': 'New FC', 'Limburg Smurfs': 'Genk Mine'},
            'clubStrengths': {'Toluca Red Devils': 4},
            'localized': {
              ...old['localized']! as Map<String, Object?>,
              'clubs.Limburg Smurfs': {'cs': 'Limburští'},
            },
            'squads': {
              '7': [
                {...player, 'club': 'Toluca Red Devils', 'clubCountry': 'mex'},
              ],
            },
          }
          ..remove('managers')
          ..remove('sponsorIndustries')
          ..remove('yHandles');
    final p = WorldPack.fromJson(WorldPack.migrate(json));
    expect(p.clubs, {'Old FC': 'New FC', 'Limburg Blue-White': 'Genk Mine'});
    expect(p.clubStrengths, {'Toluca Volcanoes': 4});
    expect(p.localized['clubs.Limburg Blue-White'], {'cs': 'Limburští'});
    expect(p.localized.keys, isNot(contains('clubs.Limburg Smurfs')));
    expect(p.localized['clubs.Old FC'], {'cs': 'Nový FC'});
    expect(p.squads[7]!.single.club, 'Toluca Volcanoes');
    expect(p.pools[7]!.length, 2);
    for (final old in ClubService.retiredNames.keys) {
      expect(
        ClubService.allLeagues().expand((l) => l.clubs),
        isNot(contains(old)),
      );
    }
    for (final now in ClubService.retiredNames.values) {
      expect(ClubService.allLeagues().expand((l) => l.clubs), contains(now));
    }
  });

  test('v2 round trip keeps every new part', () {
    final p = _v2Pack();
    expect(p.toJson()['formatVersion'], kPackFormatVersion);
    final back = WorldPack.fromJson(
      jsonDecode(jsonEncode(p.toJson())) as Map<String, Object?>,
    );
    expect(back, p);
    expect(back.pools[7]!.first.traits, [
      PlayerTrait.setPiece,
      PlayerTrait.leader,
    ]);
    expect(back.pools[7]!.last.traits, isEmpty);
    expect(back.addedClubs.single, _club);
    expect(back.addedSponsors.single, _sponsor);
    expect(back.addedSponsors.single.key, 'pack${kPackAddedIdBase + 2}');
    expect(back.addedYAccounts, [_yAll, _yOne]);
    expect(back.localized, _localized);
  });

  test(
    'v1 fixture migrates to v4 with empty new parts and the same 1.1.0 maps',
    () {
      final raw =
          jsonDecode(File(_v1Fixture).readAsStringSync())
              as Map<String, Object?>;
      expect(raw['formatVersion'], 1);
      final migrated = WorldPack.migrate(raw);
      expect(migrated['formatVersion'], kPackFormatVersion);
      final p = WorldPack.fromJson(migrated);
      expect(p.formatVersion, kPackFormatVersion);
      expect(p.clubStrengths, isEmpty);
      expect(p.managers, isEmpty);
      expect(p.pools, isEmpty);
      expect(p.addedClubs, isEmpty);
      expect(p.addedSponsors, isEmpty);
      expect(p.addedYAccounts, isEmpty);
      expect(p.localized, isEmpty);
      // Every 1.1.0 part reads back exactly as the 1.1.0 file wrote it,
      // but for a club renamed since, which reads under its new name.
      final out = jsonDecode(jsonEncode(p.toJson())) as Map<String, Object?>;
      var renamed = jsonEncode(raw);
      ClubService.retiredNames.forEach(
        (from, to) => renamed = renamed.replaceAll('"$from"', '"$to"'),
      );
      final expected = jsonDecode(renamed) as Map<String, Object?>;
      expect(renamed, isNot(jsonEncode(raw)), reason: 'it names one');
      for (final k in raw.keys) {
        if (k == 'formatVersion') continue;
        expect(out[k], expected[k], reason: k);
      }
      // The fixture is a 1.1.0 file: migrating never rewrites it.
      expect(raw['formatVersion'], 1);
      expect(raw.containsKey('pools'), isFalse);
      // Migration is idempotent once current.
      expect(WorldPack.migrate(migrated), migrated);
    },
  );

  test('a v1 player without traits reads as Random (null), and toJson writes '
      'no traits key', () {
    final json = _player.toJson();
    expect(json.containsKey('traits'), isFalse);
    final back = PackPlayer.fromJson(json);
    expect(back.traits, isNull);
    expect(back.toJson().containsKey('traits'), isFalse);
    expect(back, _player);
    // None and Random are different choices.
    expect(_none.toJson()['traits'], <String>[]);
    expect(_none == _withTraits(null), isFalse);
  });

  test('a badly shaped trait, voice or deal, or a wrong type, throws '
      'FormatException; a well-formed unknown one is kept', () {
    expect(kPackYVoices, {
      YVoice.fan,
      YVoice.pundit,
      YVoice.meme,
      YVoice.stats,
      YVoice.rival,
      YVoice.expro,
      YVoice.neutral,
    });
    final good = _v2Pack().toJson();
    Map<String, Object?> pools(Object? traits) => {
      ...good,
      'pools': {
        '7': [
          {..._player.toJson(), 'traits': traits},
        ],
      },
    };
    Map<String, Object?> y(String voice) => {
      ...good,
      'addedYAccounts': [
        {..._yAll.toJson(), 'voice': voice},
      ],
    };
    for (final bad in <Map<String, Object?>>[
      pools(['flying kick']),
      pools(['x' * 41]),
      pools('setPiece'),
      pools([1]),
      y('ghost!'),
      y(''),
      {
        ...good,
        'addedSponsors': [
          {..._sponsor.toJson(), 'deal': 'char-ity'},
        ],
      },
      {
        ...good,
        'addedClubs': [
          {..._club.toJson(), 'extra': 1},
        ],
      },
      {
        ...good,
        'localized': {
          'clubs.Old FC': {'cs': 5},
        },
      },
    ]) {
      expect(() => WorldPack.fromJson(bad), throwsFormatException);
    }
    // Unknown to this build but well formed: kept as it is, read as no
    // trait, the fallback voice or deal, and written back unchanged.
    final kept = WorldPack.fromJson({
      ...pools(['flying']),
      'addedYAccounts': [
        {..._yAll.toJson(), 'voice': YVoice.player.name},
      ],
      'addedSponsors': [
        {..._sponsor.toJson(), 'deal': 'charity'},
      ],
    });
    final pl = kept.pools[7]!.single;
    expect(pl.traits, isNotNull);
    expect(pl.traits, isEmpty);
    expect(pl.unknownTraits, ['flying']);
    final ya = kept.addedYAccounts.single;
    expect((ya.voice, ya.unknownVoice), (YVoice.neutral, YVoice.player.name));
    final sp = kept.addedSponsors.single;
    expect((sp.deal, sp.unknownDeal), (PackSponsor.fallbackDeal, 'charity'));
    expect(WorldPack.fromJson(kept.toJson()), kept);
    expect(
      (kept.toJson()['addedSponsors']! as List).single,
      containsPair('deal', 'charity'),
    );
  });

  group('format 3: club strength', () {
    Map<String, Object?> v2Json() {
      final json = _v2Pack().toJson()
        ..['formatVersion'] = 2
        ..remove('clubStrengths')
        ..remove('managers')
        ..remove('sponsorIndustries')
        ..remove('yHandles');
      return json;
    }

    test('a format-2 pack reads as every club at its default strength', () {
      final p = WorldPack.fromJson(WorldPack.migrate(v2Json()));
      expect(p.formatVersion, kPackFormatVersion);
      expect(p.clubStrengths, isEmpty);
      expect(p.addedClubs.single.strength, isNull);
      expect(p.addedClubs.single, _club);
    });

    test('a format-2 pack carrying a format-3 part is no format-2 file', () {
      expect(
        () => WorldPack.migrate({
          ...v2Json(),
          'clubStrengths': {'Man Blue': 4},
        }),
        throwsFormatException,
      );
      expect(
        () => WorldPack.migrate({
          ...v2Json(),
          'addedClubs': [
            {..._club.toJson(), 'strength': 4},
          ],
        }),
        throwsFormatException,
      );
    });

    test('strengths round-trip; a club with none writes no key', () {
      final p = _v2Pack().copyWith(
        clubStrengths: const {'Man Blue': 2, 'FC Blšany': 5},
        addedClubs: [
          _club,
          PackClub(
            id: _club.id + 100,
            name: 'Strong FC',
            country: 'cze',
            strength: 4,
          ),
        ],
      );
      final json = jsonDecode(jsonEncode(p.toJson())) as Map<String, Object?>;
      expect(
        (json['addedClubs']! as List).first as Map,
        isNot(contains('strength')),
      );
      final back = WorldPack.fromJson(WorldPack.migrate(json));
      expect(back, p);
      expect(back.clubStrengths, {'Man Blue': 2, 'FC Blšany': 5});
      expect(back.addedClubs.last.strength, 4);
    });

    test('a strength that is no integer is refused by the reader', () {
      expect(
        () => WorldPack.fromJson({
          ..._v2Pack().toJson(),
          'clubStrengths': {'Man Blue': 'five'},
        }),
        throwsFormatException,
      );
    });

    test('PackClub.copyWith keeps or clears the strength', () {
      const c = PackClub(id: 1, name: 'A', country: 'cze', strength: 3);
      expect(c.copyWith(name: 'B').strength, 3);
      expect(c.copyWith(strength: const Some(null)).strength, isNull);
      expect(c.copyWith(strength: const Some(5)).strength, 5);
    });
  });

  test('PackPaths builds and parses localized paths', () {
    expect(PackPaths.club('Old FC'), 'clubs.Old FC');
    expect(PackPaths.stadium('7:Prague'), 'stadiums.7:Prague');
    expect(
      PackPaths.competition('World Championship'),
      'competitions.World Championship',
    );
    expect(PackPaths.sponsor('agrofart'), 'sponsors.agrofart');
    expect(PackPaths.yAccount('GaffersCorner'), 'yAccounts.GaffersCorner');
    expect(PackPaths.reporterName(3), 'reporters.3.name');
    expect(PackPaths.reporterOutlet(3), 'reporters.3.outlet');
    expect(PackPaths.addedClub(700000001), 'addedClubs.700000001');
    expect(PackPaths.addedSponsor(700000002), 'addedSponsors.700000002');
    expect(
      PackPaths.addedSponsorDescription(700000002),
      'addedSponsors.700000002.description',
    );
    expect(PackPaths.addedY(700000003), 'addedYAccounts.700000003');

    // A club name with a dot splits at the first dot only.
    expect(PackPaths.parse(PackPaths.club('St. Pauli.X')), (
      root: 'clubs',
      rest: 'St. Pauli.X',
    ));
    expect(PackPaths.parse('reporters.3.name'), (
      root: 'reporters',
      rest: '3.name',
    ));
    for (final bad in ['clubs', 'clubs.', 'nations.7', 'x.y', '']) {
      expect(PackPaths.parse(bad), isNull, reason: bad);
    }
    expect(PackPaths.roots, isNot(contains('nations')));
    expect(PackPaths.roots, hasLength(9));
  });
}
