import '../competition/continental_cups.dart';
import '../competition/nations_cups.dart';
import '../competition/trophies.dart';
import '../federation/sponsors.dart';
import '../press/y_feed.dart';
import 'pack_rules.dart';
import 'world_pack.dart';

/// The stored names of the competitions a database can rename that are not
/// a continent's own: the World Championship first, the two inter-continental
/// ties after the continents' (the editor lists them in that order).
const List<String> kPackWorldCompetitions = [
  'World Championship',
  'Continental Clash',
  'Intercontinental Play-off',
];

/// Every stored competition name a database can rename, in the editor's
/// order: the World Championship, each continental championship, each
/// Nations Cup, then the two inter-continental ties.
List<String> get packCompetitionNames => [
  kPackWorldCompetitions.first,
  for (final cup in ContinentalCups.byConfederation.values) cup.name,
  ...NationsCups.allNames,
  ...kPackWorldCompetitions.skip(1),
];

/// What the current game has for a database's overrides to refer to: the
/// sets [PackRules.compatibility] checks a pack against.
class PackGameKeys {
  const PackGameKeys._({
    required this.nationIds,
    required this.competitionNames,
    required this.trophyKeys,
    required this.sponsorBrands,
    required this.yAccounts,
  });

  /// The game's keys, with [nationIds] the nations a career created now
  /// starts with (`NationRepository.newCareerWorld`).
  factory PackGameKeys.of(Iterable<int> nationIds) => PackGameKeys._(
    nationIds: nationIds.toSet(),
    competitionNames: packCompetitionNames.toSet(),
    trophyKeys: {for (final t in Trophies.cabinet) t.key},
    sponsorBrands: {for (final b in SponsorBrand.values) b.name},
    yAccounts: YFeed.namedAccounts.toSet(),
  );

  final Set<int> nationIds;
  final Set<String> competitionNames;
  final Set<String> trophyKeys;
  final Set<String> sponsorBrands;
  final Set<String> yAccounts;

  /// [PackRules.compatibility] of [p] against these keys.
  List<PackIssue> check(WorldPack p) => PackRules.compatibility(
    p,
    nationIds: nationIds,
    competitionNames: competitionNames,
    trophyKeys: trophyKeys,
    sponsorBrands: sponsorBrands,
    yAccounts: yAccounts,
  );
}
