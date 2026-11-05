import 'package:flutter_test/flutter_test.dart';
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
);

List<String> _paths(List<PackIssue> issues) => [
  for (final i in issues) i.where,
];

List<PackIssue> _check(WorldPack p) => PackRules.compatibility(
  p,
  nationIds: {1, 2},
  competitionNames: {'World Championship'},
  trophyKeys: {'world'},
  sponsorBrands: {'acme'},
  yAccounts: {'FootyFan'},
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
    final keys = PackGameKeys.of(const [1]);
    expect(keys.competitionNames, contains('World Championship'));
    expect(keys.competitionNames, contains('Continental Clash'));
    expect(keys.competitionNames, contains('Intercontinental Play-off'));
    expect(keys.trophyKeys, containsAll(['world', 'nationscup']));
    expect(keys.sponsorBrands, {for (final b in SponsorBrand.values) b.name});
    expect(keys.yAccounts, YFeed.namedAccounts.toSet());
    expect(keys.nationIds, {1});
    final p = _pack(
      competitions: {for (final c in keys.competitionNames) c: 'X'},
      trophies: keys.trophyKeys,
      sponsors: {for (final s in keys.sponsorBrands) s: 'S'},
      yAccounts: {for (final y in keys.yAccounts) y: '$y 2'},
    );
    expect(keys.check(p), isEmpty);
    expect(keys.check(_pack(squads: {999: const []})), hasLength(1));
  });
}
