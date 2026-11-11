import 'package:fnm/domain/services/profanity/profanity_filter.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// [p] as the game plays it: every name [PackRules.notAllowed] lists shown
/// masked ([ProfanityFilter.mask]: "F*** United"), so a shared database can
/// never put a slur on screen. A refused entry of a name list is left out
/// (a newgen is never named by it), unless that would empty the list, when
/// it is masked instead.
///
/// Display-time only: the stored pack, and every career's stored copy of
/// it, keep the names as they were, and a pack the filter has nothing
/// against comes back identical. Masking one string is the same wherever it
/// stands, so a player's club still names the club it masks to. Remembered
/// per pack, as a career reads its world on every screen.
WorldPack maskedForPlay(WorldPack p) {
  final kept = _masked[p];
  if (kept != null) return kept;
  final result = PackRules.notAllowed(p).isEmpty ? p : _mask(p);
  _masked[p] = result;
  return result;
}

final Expando<WorldPack> _masked = Expando('masked world packs');

WorldPack _mask(WorldPack p) {
  String m(String s) => ProfanityFilter.mask(s);
  Map<K, String> values<K>(Map<K, String> map) => {
    for (final e in map.entries) e.key: m(e.value),
  };
  List<PackPlayer> players(List<PackPlayer> list) => [
    for (final pl in list)
      if (ProfanityFilter.isClean(pl.name) &&
          (pl.club == null || ProfanityFilter.isClean(pl.club!)))
        pl
      else
        PackPlayer(
          id: pl.id,
          name: m(pl.name),
          age: pl.age,
          position: pl.position,
          attributes: pl.attributes,
          potential: pl.potential,
          club: pl.club == null ? null : m(pl.club!),
          clubCountry: pl.clubCountry,
          traits: pl.traits,
          unknownTraits: pl.unknownTraits,
        ),
  ];
  List<String> names(List<String> list) {
    final clean = list.where(ProfanityFilter.isClean).toList();
    return clean.isEmpty ? list.map(m).toList() : clean;
  }

  return p.copyWith(
    name: m(p.name),
    author: m(p.author),
    squads: {for (final e in p.squads.entries) e.key: players(e.value)},
    pools: {for (final e in p.pools.entries) e.key: players(e.value)},
    nations: {
      for (final e in p.nations.entries)
        e.key: (name: m(e.value.name), code: e.value.code),
    },
    clubs: values(p.clubs),
    stadiums: values(p.stadiums),
    competitions: values(p.competitions),
    sponsors: values(p.sponsors),
    yAccounts: values(p.yAccounts),
    yHandles: values(p.yHandles),
    reporters: {
      for (final e in p.reporters.entries)
        e.key: PackReporter(name: m(e.value.name), outlet: m(e.value.outlet)),
    },
    nameLists: {
      for (final e in p.nameLists.entries)
        e.key: PackNameLists(
          first: names(e.value.first),
          sur: names(e.value.sur),
        ),
    },
    managers: {
      for (final e in p.managers.entries)
        e.key: (name: m(e.value.name), nationality: e.value.nationality),
    },
    addedClubs: [for (final c in p.addedClubs) c.copyWith(name: m(c.name))],
    addedSponsors: [
      for (final s in p.addedSponsors)
        PackSponsor(
          id: s.id,
          name: m(s.name),
          deal: s.deal,
          industry: s.industry,
          description: m(s.description),
          unknownDeal: s.unknownDeal,
        ),
    ],
    addedYAccounts: [
      for (final y in p.addedYAccounts)
        PackYAccount(
          id: y.id,
          name: m(y.name),
          voice: y.voice,
          nationId: y.nationId,
          unknownVoice: y.unknownVoice,
          handle: y.handle == null ? null : m(y.handle!),
        ),
    ],
    addedReporters: [
      for (final r in p.addedReporters)
        PackAddedReporter(id: r.id, name: m(r.name), outlet: m(r.outlet)),
    ],
    addedStadiums: [
      for (final g in p.addedStadiums)
        PackStadium(
          id: g.id,
          nationId: g.nationId,
          name: m(g.name),
          city: m(g.city),
          capacity: g.capacity,
        ),
    ],
    localized: {
      for (final e in p.localized.entries) e.key: values(e.value),
    },
  );
}
