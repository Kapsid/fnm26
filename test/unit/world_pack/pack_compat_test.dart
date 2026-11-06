import 'package:flutter_test/flutter_test.dart';
import 'package:fnm/data/seed/pool_generator.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/federation/sponsors.dart';
import 'package:fnm/domain/services/press/y_feed.dart';
import 'package:fnm/domain/services/world_pack/pack_keys.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

WorldPack _pack({
  Map<int, List<PackPlayer>> squads = const {},
  Map<int, ({String name, String code})> nations = const {},
  Map<String, String> stadiums = const {},
  Map<String, String> competitions = const {},
  Map<String, String> yAccounts = const {},
  Map<int, PackNameLists> nameLists = const {},
  Map<String, String> sponsors = const {},
  Set<String> trophies = const {},
  Map<int, List<PackPlayer>> pools = const {},
  List<PackClub> addedClubs = const [],
  List<PackSponsor> addedSponsors = const [],
  List<PackYAccount> addedYAccounts = const [],
  Map<String, Map<String, String>> localized = const {},
}) => WorldPack(
  uuid: 'u',
  name: 'P',
  author: '',
  formatVersion: kPackFormatVersion,
  madeWithVersion: '1.1.0',
  squads: squads,
  nations: nations,
  stadiums: stadiums,
  competitions: competitions,
  yAccounts: yAccounts,
  nameLists: nameLists,
  sponsors: sponsors,
  trophies: trophies,
  pools: pools,
  addedClubs: addedClubs,
  addedSponsors: addedSponsors,
  addedYAccounts: addedYAccounts,
  localized: localized,
);

PackPlayer _pl(int id) => PackPlayer(
  id: id,
  name: 'P$id',
  age: 25,
  position: PlayerPosition.cm,
  attributes: const PlayerAttributes(physical: 60, technical: 60, stamina: 60),
  potential: 90,
);

const _f = PoolGenerator.firstFringeId;
const _ranges = {
  1: (first: _f, last: _f + 79),
  2: (first: _f + 80, last: _f + 159),
  23: (first: _f + 1760, last: _f + 1839),
};

List<String> _paths(List<PackIssue> issues) => [
  for (final i in issues) i.where,
];

List<PackIssue> _check(WorldPack p) => PackRules.compatibility(
  p,
  nationIds: {1, 2, 23},
  competitionNames: {'World Championship'},
  trophyKeys: {'world'},
  sponsorBrands: {'acme'},
  yAccounts: {'FootyFan'},
  countryCodes: {'cze', 'svk'},
  fringeRanges: _ranges,
);

void main() {
  test('a pack naming only what the game has is compatible', () {
    final p = _pack(
      squads: {1: const []},
      nations: {2: (name: 'Two', code: 'TWO')},
      stadiums: {'1:Prague': 'Arena'},
      competitions: {'World Championship': 'Big Cup'},
      yAccounts: {'FootyFan': 'Fan'},
      nameLists: {2: const PackNameLists(first: [], sur: [])},
      sponsors: {'acme': 'Acme'},
      trophies: {'world'},
    );
    expect(_check(p), isEmpty);
  });

  test('a pack naming nation 999 is incompatible wherever it names it', () {
    final p = _pack(
      squads: {999: const []},
      nations: {999: (name: 'Gone', code: 'GON')},
      stadiums: {'999:Nowhere': 'Ground'},
      nameLists: {999: const PackNameLists(first: [], sur: [])},
    );
    final issues = _check(p);
    expect(issues, everyElement(isA<UnknownId>()));
    expect(_paths(issues), [
      'squads.999',
      'nations.999',
      'stadiums.999:Nowhere',
      'nameLists.999',
    ]);
  });

  test('unknown competitions, trophies, sponsors and Y accounts are each '
      'reported', () {
    final p = _pack(
      competitions: {'Old Cup': 'X'},
      trophies: {'oldcup'},
      sponsors: {'gone': 'Y'},
      yAccounts: {'Vanished': 'Z'},
    );
    expect(_paths(_check(p)), [
      'competitions.Old Cup',
      'yAccounts.Vanished',
      'sponsors.gone',
      'trophies.oldcup',
    ]);
  });

  test('content problems are not compatibility issues', () {
    // A blank rename and a too-small squad are for PackRules.issues.
    final p = _pack(
      squads: {1: const []},
      competitions: {'World Championship': ''},
    );
    expect(_check(p), isEmpty);
    expect(PackRules.issues(p), isNotEmpty);
  });

  test("the game's own keys cover every section the editor offers", () {
    final keys = PackGameKeys.of(
      const [1],
      codes: const {1: 'CZE'},
      fringeRanges: const {1: (first: _f, last: _f + 79)},
    );
    expect(keys.competitionNames, contains('World Championship'));
    expect(keys.competitionNames, contains('Continental Clash'));
    expect(keys.competitionNames, contains('Intercontinental Play-off'));
    expect(keys.trophyKeys, containsAll(['world', 'nationscup']));
    expect(keys.sponsorBrands, {for (final b in SponsorBrand.values) b.name});
    expect(keys.yAccounts, YFeed.namedAccounts.toSet());
    expect(keys.nationIds, {1});
    expect(keys.countryCodes, {'cze'});
    expect(keys.fringeRanges, {1: (first: _f, last: _f + 79)});
    final p = _pack(
      competitions: {for (final c in keys.competitionNames) c: 'X'},
      trophies: keys.trophyKeys,
      sponsors: {for (final s in keys.sponsorBrands) s: 'S'},
      yAccounts: {for (final y in keys.yAccounts) y: '$y 2'},
    );
    expect(keys.check(p), isEmpty);
    expect(keys.check(_pack(squads: {999: const []})), hasLength(1));
  });

  test("a pool holding nation 23's fringe id under nation 1 is UnknownId", () {
    final p = _pack(
      pools: {
        1: [_pl(_f), _pl(_f + 1760), _pl(kPackPlayerIdBase + 1)],
        23: [_pl(_f + 1760)],
      },
    );
    expect(_paths(_check(p)), ['pools.1.${_f + 1760}']);
    expect(_check(p).single, isA<UnknownId>());
  });

  test('a pool keyed by an unknown nation, or a fringe id no nation has, is '
      'UnknownId', () {
    final p = _pack(
      pools: {
        2: [_pl(_f + 500000)],
        999: [_pl(kPackPlayerIdBase + 1)],
      },
    );
    expect(_paths(_check(p)), ['pools.2.${_f + 500000}', 'pools.999']);
  });

  test("an added club in country 'zzz' is UnknownId", () {
    final p = _pack(
      addedClubs: const [
        PackClub(id: kPackAddedIdBase, name: 'Z FC', country: 'zzz'),
        PackClub(id: kPackAddedIdBase + 1, name: 'C FC', country: 'cze'),
      ],
    );
    expect(_paths(_check(p)), ['addedClubs.$kPackAddedIdBase']);
  });

  test('an added sponsor of an unknown industry and a Y account bound to an '
      'unknown nation are UnknownId', () {
    final p = _pack(
      addedSponsors: const [
        PackSponsor(
          id: kPackAddedIdBase,
          name: 'S',
          deal: SponsorDeal.risky,
          industry: 'nothing',
        ),
        PackSponsor(
          id: kPackAddedIdBase + 1,
          name: 'T',
          deal: SponsorDeal.risky,
          industry: 'acme',
        ),
      ],
      addedYAccounts: const [
        PackYAccount(
          id: kPackAddedIdBase + 2,
          name: 'A',
          voice: YVoice.fan,
          nationId: 999,
        ),
        PackYAccount(
          id: kPackAddedIdBase + 3,
          name: 'B',
          voice: YVoice.fan,
          nationId: 2,
        ),
        PackYAccount(id: kPackAddedIdBase + 4, name: 'C', voice: YVoice.fan),
      ],
    );
    expect(_paths(_check(p)), [
      'addedSponsors.$kPackAddedIdBase',
      'addedYAccounts.${kPackAddedIdBase + 2}',
    ]);
  });

  test('localized competitions.Old Cup is UnknownId', () {
    final p = _pack(
      localized: {
        'competitions.Old Cup': {'cs': 'Starý pohár'},
        'competitions.World Championship': {'cs': 'MS'},
        'sponsors.gone': {'cs': 'X'},
        'sponsors.acme': {'cs': 'X'},
        'yAccounts.Vanished': {'cs': 'X'},
        'stadiums.999:Nowhere': {'cs': 'X'},
        'stadiums.1:Prague': {'cs': 'X'},
        'clubs.Any FC': {'cs': 'X'},
      },
    );
    final issues = _check(p);
    expect(issues, everyElement(isA<UnknownId>()));
    expect(_paths(issues), [
      'localized.competitions.Old Cup',
      'localized.sponsors.gone',
      'localized.stadiums.999:Nowhere',
      'localized.yAccounts.Vanished',
    ]);
  });

  test('a well-formed language this build does not speak is a note, '
      'never a compat issue', () {
    final p = _pack(
      localized: {
        'clubs.Old FC': {'xx': 'X', 'cs': 'Y'},
        'competitions.Old Cup': {'xx': 'Z'},
      },
    );
    // A path the game no longer has is flagged whole, not per language.
    expect(_paths(_check(p)), ['localized.competitions.Old Cup']);
    // The language is kept and listed, and blocks nothing.
    expect(
      [for (final n in PackRules.unknownLanguages(p)) (n.path, n.language)],
      [
        ('localized.clubs.Old FC.xx', 'xx'),
        ('localized.competitions.Old Cup.xx', 'xx'),
      ],
    );
  });

  test('unknown traits, deals and voices are UnknownId', () {
    final pl = PackPlayer(
      id: 7,
      name: 'P',
      age: 25,
      position: PlayerPosition.cm,
      attributes: const PlayerAttributes(
        physical: 60,
        technical: 60,
        stamina: 60,
      ),
      potential: 90,
      traits: const [],
      unknownTraits: const ['flyingKick'],
    );
    final p = _pack(
      squads: {
        1: [pl],
      },
      pools: {
        2: [
          PackPlayer(
            id: _f + 80,
            name: 'Q',
            age: 25,
            position: PlayerPosition.cm,
            attributes: pl.attributes,
            potential: 90,
            traits: const [],
            unknownTraits: const ['x'],
          ),
        ],
      },
      addedSponsors: const [
        PackSponsor(
          id: kPackAddedIdBase,
          name: 'S',
          deal: PackSponsor.fallbackDeal,
          industry: 'acme',
          unknownDeal: 'barter',
        ),
      ],
      addedYAccounts: const [
        PackYAccount(
          id: kPackAddedIdBase + 1,
          name: 'Y',
          voice: PackYAccount.fallbackVoice,
          unknownVoice: 'oracle',
        ),
      ],
    );
    expect(_paths(_check(p)), [
      'squads.1.7.traits',
      'pools.2.${_f + 80}.traits',
      'addedSponsors.$kPackAddedIdBase.deal',
      'addedYAccounts.${kPackAddedIdBase + 1}.voice',
    ]);
  });
}
