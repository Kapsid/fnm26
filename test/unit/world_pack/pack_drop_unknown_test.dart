import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/entities/player_ids.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';
import 'package:fnm/features/editor/editor_providers.dart';

const int _a = kPackAddedIdBase;

PackPlayer _p(int id, {List<String> unknown = const []}) => PackPlayer(
  id: id,
  name: 'P$id',
  age: 25,
  position: PlayerPosition.cm,
  attributes: const PlayerAttributes(physical: 60, technical: 60, stamina: 60),
  potential: 90,
  traits: const [PlayerTrait.leader],
  unknownTraits: unknown,
);

WorldPack _pack() => WorldPack(
  uuid: 'u',
  name: 'n',
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  squads: {
    1: [
      _p(7, unknown: ['flyingKick']),
    ],
  },
  pools: {
    1: [
      _p(kFirstFringeId, unknown: ['x']),
      _p(kFirstFringeId + 1),
    ],
  },
  addedClubs: const [
    PackClub(id: _a, name: 'A FC', country: 'cze'),
    PackClub(id: _a + 10, name: 'B FC', country: 'cze'),
  ],
  addedSponsors: const [
    PackSponsor(
      id: _a + 1,
      name: 'S',
      deal: PackSponsor.fallbackDeal,
      industry: 'acme',
      unknownDeal: 'barter',
    ),
  ],
  addedYAccounts: const [
    PackYAccount(
      id: _a + 2,
      name: 'Y',
      voice: PackYAccount.fallbackVoice,
      unknownVoice: 'oracle',
    ),
  ],
  localized: const {
    'addedClubs.$_a': {'cs': 'A klub'},
    'addedClubs.${_a + 10}': {'cs': 'B klub'},
    'addedSponsors.${_a + 1}': {'cs': 'S'},
    'addedSponsors.${_a + 1}.description': {'cs': 'Popis'},
    'addedYAccounts.${_a + 2}': {'cs': 'Y'},
    'clubs.Old FC': {'cs': 'Starý', 'xx': 'Old'},
  },
);

void main() {
  WorldPack drop(String path) => PackEditor.dropUnknown(_pack(), path);

  test('removing an added item removes all its names', () {
    final club = drop('addedClubs.$_a');
    expect(club.addedClubs.map((c) => c.id), [_a + 10]);
    expect(club.localized.keys, isNot(contains('addedClubs.$_a')));
    expect(club.localized.keys, contains('addedClubs.${_a + 10}'));

    final sponsor = drop('addedSponsors.${_a + 1}');
    expect(sponsor.addedSponsors, isEmpty);
    expect(
      sponsor.localized.keys.where((k) => k.startsWith('addedSponsors')),
      isEmpty,
    );

    final y = drop('addedYAccounts.${_a + 2}');
    expect(y.addedYAccounts, isEmpty);
    expect(y.localized.keys, isNot(contains('addedYAccounts.${_a + 2}')));
  });

  test('an unknown trait, deal or voice goes; the item stays', () {
    final squad = drop('squads.1.7.traits').squads[1]!.single;
    expect(squad.unknownTraits, isEmpty);
    expect(squad.traits, [PlayerTrait.leader]);

    final pool = drop('pools.1.$kFirstFringeId.traits').pools[1]!;
    expect(pool.map((p) => p.unknownTraits), [isEmpty, isEmpty]);
    expect(pool, hasLength(2));

    final s = drop('addedSponsors.${_a + 1}.deal').addedSponsors.single;
    expect((s.deal, s.unknownDeal), (PackSponsor.fallbackDeal, null));
    expect(s.toJson()['deal'], PackSponsor.fallbackDeal.name);

    final y = drop('addedYAccounts.${_a + 2}.voice').addedYAccounts.single;
    expect((y.voice, y.unknownVoice), (YVoice.neutral, null));
  });

  test('one unknown language goes; a path goes with its last one', () {
    final one = drop('localized.clubs.Old FC.xx');
    expect(one.localized['clubs.Old FC'], {'cs': 'Starý'});
    final last = PackEditor.dropUnknown(one, 'localized.clubs.Old FC.cs');
    expect(last.localized.containsKey('clubs.Old FC'), isFalse);
    expect(drop('localized.clubs.Old FC').localized, isNot(contains('x')));
  });

  test('a pool, or one player in it, goes', () {
    expect(drop('pools.1').pools, isEmpty);
    expect(
      drop('pools.1.${kFirstFringeId + 1}').pools[1]!.map((p) => p.id),
      [kFirstFringeId],
    );
  });

  test('a path naming nothing leaves the pack as it is', () {
    final p = _pack();
    for (final path in [
      'addedClubs.1',
      'addedSponsors.${_a + 1}.description',
      'addedYAccounts.$_a.voice',
      'pools.2',
      'pools.1.5',
      'squads.1.99.traits',
      'pools.1.${kFirstFringeId + 1}.traits',
      'localized.clubs.Nope',
      'localized.clubs.Old FC.de',
      'nonsense',
    ]) {
      expect(
        identical(PackEditor.dropUnknown(p, path), p),
        isTrue,
        reason: path,
      );
    }
  });
}
