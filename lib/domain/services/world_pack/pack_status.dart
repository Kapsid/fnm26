import '../../entities/nation.dart';
import 'pack_keys.dart';
import 'pack_rules.dart';
import 'world_pack.dart';

/// Where a database stands, as the list of databases shows it.
enum PackStatus {
  /// Complete: it can start a career.
  ready,

  /// Saved and shareable, but [PackRules.issues] still lists things to fix.
  missing,

  /// A game update made it incompatible: it refers to something the game no
  /// longer has ([PackRules.compatibility]). Shown before [missing]: it is
  /// what the manager must fix first.
  needsAttention,

  /// The stored pack could not be read at all. Only deleting it is offered.
  unreadable,
}

/// What a pack is checked against besides the nations, read from the seed
/// once: each nation's stored fringe ids (`PlayerRepository.fringeRanges`)
/// and each nation's cities, biggest first (`SeedSource.cities`), by id.
typedef PackFacts = ({
  Map<int, ({int first, int last})> fringeRanges,
  Map<int, List<String>> cities,
});

/// [cities] by the lower-case code of each nation of [world], as
/// [PackRules.issues] takes them.
Map<String, List<String>> packCountryCities(
  List<Nation> world,
  Map<int, List<String>> cities,
) => {
  for (final n in world)
    if (cities[n.id] case final c? when c.isNotEmpty) n.code.toLowerCase(): c,
};

/// Where [pack] stands against the game whose new-career nations are
/// [world]: its [PackStatus] and everything standing between it and a
/// career, what the game no longer has ([PackRules.compatibility]) first,
/// then what is missing ([PackRules.issues]). A null [pack] could not be
/// read. [facts] are the fringe ranges and cities ([PackFacts]).
({PackStatus status, List<PackIssue> issues}) assessPack(
  WorldPack? pack,
  List<Nation> world, {
  required PackFacts facts,
}) {
  if (pack == null) return (status: PackStatus.unreadable, issues: const []);
  final unknown = PackGameKeys.of(
    [for (final n in world) n.id],
    codes: {for (final n in world) n.id: n.code},
    fringeRanges: facts.fringeRanges,
  ).check(pack);
  final missing = PackRules.issues(
    pack,
    baseCodes: {for (final n in world) n.id: n.code},
    countryCities: packCountryCities(world, facts.cities),
  );
  return (
    status: unknown.isNotEmpty
        ? PackStatus.needsAttention
        : missing.isNotEmpty
        ? PackStatus.missing
        : PackStatus.ready,
    issues: [...unknown, ...missing],
  );
}
