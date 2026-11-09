import 'dart:math' as math;

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/player/player_traits.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/player_build.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// The edits the players section makes to a pack, as plain functions of it.
abstract final class SquadEdits {
  /// The id a new player gets: one past the highest pack-made id in any
  /// nation's squad or pool ([kPackPlayerIdBase] + 1 in a pack that has
  /// none), so ids stay unique across the whole pack.
  static int nextPlayerId(WorldPack pack) {
    var top = 0;
    for (final players in [...pack.squads.values, ...pack.pools.values]) {
      for (final p in players) {
        if (p.id >= kPackPlayerIdBase) {
          top = math.max(top, p.id - kPackPlayerIdBase);
        }
      }
    }
    return kPackPlayerIdBase + top + 1;
  }

  /// The least each position group needs ([PackRules]).
  static const Map<PositionCategory, int> minimums = {
    PositionCategory.goalkeeper: PackRules.gkMin,
    PositionCategory.defender: PackRules.defMin,
    PositionCategory.midfielder: PackRules.midMin,
    PositionCategory.forward: PackRules.fwdMin,
  };

  /// How many of [squad] play in each position group.
  static Map<PositionCategory, int> counts(List<PackPlayer> squad) {
    final out = {for (final c in PositionCategory.values) c: 0};
    for (final p in squad) {
      out[p.position.category] = out[p.position.category]! + 1;
    }
    return out;
  }

  /// The position a new player of [squad] takes: the group furthest below
  /// its minimum, or, with every minimum met, the group thinnest against it.
  static PlayerPosition neededPosition(List<PackPlayer> squad) {
    final have = counts(squad);
    PositionCategory? best;
    var bestScore = double.infinity;
    for (final c in PositionCategory.values) {
      final need = minimums[c]!;
      // Below the minimum, the shortfall decides (negative, so first);
      // above it, the cover per required man does.
      final short = need - have[c]!;
      final score = short > 0 ? -short.toDouble() : have[c]! / need;
      if (score < bestScore) {
        best = c;
        bestScore = score;
      }
    }
    return switch (best!) {
      PositionCategory.goalkeeper => PlayerPosition.gk,
      PositionCategory.defender => PlayerPosition.cb,
      PositionCategory.midfielder => PlayerPosition.cm,
      PositionCategory.forward => PlayerPosition.st,
    };
  }

  /// The overall a new player of [squad] starts at: the squad's median, 60
  /// for an empty one.
  static int startingOverall(List<PackPlayer> squad) {
    if (squad.isEmpty) return 60;
    final rated = [for (final p in squad) overallOf(p)]..sort();
    return rated[rated.length ~/ 2];
  }

  /// [p]'s overall, the game's own position-weighted one.
  static int overallOf(PackPlayer p) =>
      OverallRating.forPosition(p.position, p.attributes);

  /// A new player for [squad] with id [id]: the position the squad most
  /// lacks, 24 years old, a balanced build at [startingOverall], potential
  /// equal to it, no club of his own (the game places him), and no name: the
  /// editor asks for one, and the pack is not ready until he has it.
  static PackPlayer newPlayer(List<PackPlayer> squad, int id) {
    final position = neededPosition(squad);
    final attributes = PlayerBuild.attributesFor(
      position,
      PlayerType.balanced,
      startingOverall(squad),
    );
    return PackPlayer(
      id: id,
      name: '',
      age: 24,
      position: position,
      attributes: attributes,
      potential: OverallRating.forPosition(position, attributes),
    );
  }

  /// [pack] with a new player added to nation [nationId], or null when the
  /// squad is already at [PackRules.squadMax].
  static ({WorldPack pack, PackPlayer player})? add(
    WorldPack pack,
    int nationId,
  ) {
    final squad = pack.squads[nationId] ?? const <PackPlayer>[];
    if (squad.length >= PackRules.squadMax) return null;
    final player = newPlayer(squad, nextPlayerId(pack));
    return (
      pack: _withSquad(pack, nationId, [...squad, player]),
      player: player,
    );
  }

  /// [pack] without player [playerId] of nation [nationId].
  static WorldPack remove(WorldPack pack, int nationId, int playerId) {
    final squad = pack.squads[nationId];
    if (squad == null || !squad.any((p) => p.id == playerId)) return pack;
    return _withSquad(pack, nationId, [
      for (final p in squad)
        if (p.id != playerId) p,
    ]);
  }

  /// [pack] with [player] (matched by id) replaced in nation [nationId].
  static WorldPack replace(WorldPack pack, int nationId, PackPlayer player) {
    final squad = pack.squads[nationId];
    if (squad == null) return pack;
    if (!squad.any((p) => p.id == player.id)) return pack;
    return _withSquad(pack, nationId, [
      for (final p in squad)
        if (p.id == player.id) player else p,
    ]);
  }

  /// [pack] with nation [nationId]'s pool changed by [change]: the pack's
  /// own pool when it has one, else [shown], the generated pool the editor
  /// shows, so the first edit fixes the whole pool exactly as it was shown.
  /// A [change] that gives back the very list it got changes nothing (and
  /// fixes nothing). Every pool edit goes through here in one
  /// [PackEditor.update], so one undo of the first gives the untouched pool
  /// back.
  static WorldPack poolEdit(
    WorldPack pack,
    int nationId,
    List<PackPlayer> shown,
    List<PackPlayer> Function(List<PackPlayer>) change,
  ) {
    final base = pack.pools[nationId] ?? shown;
    final next = change(base);
    if (identical(next, base)) return pack;
    return pack.copyWith(pools: {...pack.pools, nationId: next});
  }

  /// [pack] with a new player added to nation [nationId]'s pool ([shown]
  /// while it is untouched), or null when the pool is at [PackRules.poolMax].
  /// He gets a pack-made id ([nextPlayerId]).
  static ({WorldPack pack, PackPlayer player})? poolAdd(
    WorldPack pack,
    int nationId,
    List<PackPlayer> shown,
  ) {
    final pool = pack.pools[nationId] ?? shown;
    if (pool.length >= PackRules.poolMax) return null;
    final player = newPlayer(pool, nextPlayerId(pack));
    return (
      pack: poolEdit(pack, nationId, shown, (list) => [...list, player]),
      player: player,
    );
  }

  /// [pack] without player [playerId] of nation [nationId]'s pool.
  static WorldPack poolRemove(
    WorldPack pack,
    int nationId,
    List<PackPlayer> shown,
    int playerId,
  ) => poolEdit(
    pack,
    nationId,
    shown,
    (list) => list.any((p) => p.id == playerId)
        ? [
            for (final p in list)
              if (p.id != playerId) p,
          ]
        : list,
  );

  /// [pack] with [player] (matched by id) replaced in nation [nationId]'s
  /// pool.
  static WorldPack poolReplace(
    WorldPack pack,
    int nationId,
    List<PackPlayer> shown,
    PackPlayer player,
  ) => poolEdit(
    pack,
    nationId,
    shown,
    (list) => list.any((p) => p.id == player.id)
        ? [
            for (final p in list)
              if (p.id == player.id) player else p,
          ]
        : list,
  );

  /// [pack] with player [playerId] moved from nation [nationId]'s pool
  /// ([shown] while it is untouched) into its squad, or null when he cannot
  /// go: he is not in the pool, or the squad is at [PackRules.squadMax] and
  /// no [swapOutId] (a squad player who goes back to the pool in his place)
  /// is given.
  ///
  /// Both players get a pack-made id ([nextPlayerId]): a fringe id belongs
  /// to the pool and a core id to the squad, and a squad may not hold the
  /// first nor a pool the second. One edit, so one undo moves them back.
  static WorldPack? promote(
    WorldPack pack,
    int nationId,
    List<PackPlayer> shown,
    int playerId, {
    int? swapOutId,
  }) {
    final pool = pack.pools[nationId] ?? shown;
    final squad = pack.squads[nationId] ?? const <PackPlayer>[];
    final him = pool.where((p) => p.id == playerId).firstOrNull;
    if (him == null) return null;
    final out = swapOutId == null
        ? null
        : squad.where((p) => p.id == swapOutId).firstOrNull;
    if (swapOutId != null && out == null) return null;
    if (out == null && squad.length >= PackRules.squadMax) return null;
    final id = nextPlayerId(pack);
    return pack.copyWith(
      squads: {
        ...pack.squads,
        nationId: [
          for (final p in squad)
            if (p.id != swapOutId) p,
          _withId(him, id),
        ],
      },
      pools: {
        ...pack.pools,
        nationId: [
          for (final p in pool)
            if (p.id != playerId) p,
          if (out != null) _withId(out, id + 1),
        ],
      },
    );
  }

  static PackPlayer _withId(PackPlayer p, int id) => PackPlayer(
    id: id,
    name: p.name,
    age: p.age,
    position: p.position,
    attributes: p.attributes,
    potential: p.potential,
    club: p.club,
    clubCountry: p.clubCountry,
    traits: p.traits,
    unknownTraits: p.unknownTraits,
  );

  static WorldPack _withSquad(
    WorldPack pack,
    int nationId,
    List<PackPlayer> squad,
  ) => pack.copyWith(squads: {...pack.squads, nationId: squad});

  /// [p] re-rated at [overall] with the build of [type]; a potential below
  /// the new overall is raised to it.
  static PackPlayer rated(PackPlayer p, int overall, PlayerType type) {
    final a = PlayerBuild.attributesFor(p.position, type, overall);
    final now = OverallRating.forPosition(p.position, a);
    return copy(p, attributes: a, potential: math.max(p.potential, now));
  }

  /// [p] at [position], keeping his overall and build.
  static PackPlayer moved(
    PackPlayer p,
    PlayerPosition position,
    PlayerType type,
  ) {
    if (position == p.position) return p;
    final a = PlayerBuild.attributesFor(position, type, overallOf(p));
    final now = OverallRating.forPosition(position, a);
    return copy(
      p,
      position: position,
      attributes: a,
      potential: math.max(p.potential, now),
    );
  }

  /// [p] with the stored qualities [a] as they are (each kept to 1..99);
  /// a potential below the overall they give is raised to it.
  static PackPlayer withAttributes(PackPlayer p, PlayerAttributes a) {
    final kept = PlayerAttributes(
      physical: a.physical.clamp(1, 99),
      technical: a.technical.clamp(1, 99),
      stamina: a.stamina.clamp(1, 99),
    );
    final now = OverallRating.forPosition(p.position, kept);
    return copy(p, attributes: kept, potential: math.max(p.potential, now));
  }

  /// [p] with his traits picked: null is Random (each career rolls them,
  /// and a pick's unknown traits go with it), an empty list "no traits".
  /// A pick keeps the traits this game does not know ([PackPlayer
  /// .unknownTraits]) until they are removed on their own.
  static PackPlayer withTraits(PackPlayer p, List<PlayerTrait>? traits) =>
      PackPlayer(
        id: p.id,
        name: p.name,
        age: p.age,
        position: p.position,
        attributes: p.attributes,
        potential: p.potential,
        club: p.club,
        clubCountry: p.clubCountry,
        traits: traits == null ? null : List.unmodifiable(traits),
        unknownTraits: traits == null ? const [] : p.unknownTraits,
      );

  /// [p] with potential [value], never below his overall nor above 99.
  static PackPlayer withPotential(PackPlayer p, int value) =>
      copy(p, potential: value.clamp(overallOf(p), 99));

  /// [p] at [club] in [country]'s league (a FIFA code); a null [club] lets
  /// the game place him on day one, [ClubService.freeAgent] has him at none
  /// (stored with no club country).
  static PackPlayer withClub(PackPlayer p, String? club, String? country) =>
      PackPlayer(
        id: p.id,
        name: p.name,
        age: p.age,
        position: p.position,
        attributes: p.attributes,
        potential: p.potential,
        club: club,
        clubCountry: club == null || club == ClubService.freeAgent
            ? null
            : country,
        traits: p.traits,
        unknownTraits: p.unknownTraits,
      );

  /// [p] with some fields changed (his club stays: see [withClub]).
  static PackPlayer copy(
    PackPlayer p, {
    String? name,
    int? age,
    PlayerPosition? position,
    PlayerAttributes? attributes,
    int? potential,
  }) => PackPlayer(
    id: p.id,
    name: name ?? p.name,
    age: age ?? p.age,
    position: position ?? p.position,
    attributes: attributes ?? p.attributes,
    potential: potential ?? p.potential,
    club: p.club,
    clubCountry: p.clubCountry,
    traits: p.traits,
    unknownTraits: p.unknownTraits,
  );

  /// [squad] as the editor lists it: by position (keepers first), then the
  /// strongest first, then by name.
  static List<PackPlayer> sorted(List<PackPlayer> squad) =>
      [...squad]..sort((a, b) {
        final pos = a.position.index.compareTo(b.position.index);
        if (pos != 0) return pos;
        final ovr = overallOf(b).compareTo(overallOf(a));
        if (ovr != 0) return ovr;
        return a.name.compareTo(b.name);
      });

  /// The name key two players clash on: trimmed, case folded.
  static String nameKey(String name) => name.trim().toLowerCase();

  /// The names (as [nameKey]) more than one player of [squad] has. A
  /// warning, never a block: two players may share a name.
  static Set<String> duplicateNames(List<PackPlayer> squad) {
    final seen = <String>{};
    final twice = <String>{};
    for (final p in squad) {
      final k = nameKey(p.name);
      if (k.isEmpty) continue;
      if (!seen.add(k)) twice.add(k);
    }
    return twice;
  }
}
