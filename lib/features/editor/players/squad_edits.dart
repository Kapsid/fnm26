import 'dart:math' as math;

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/club/clubs.dart';
import 'package:fnm/domain/services/rating/overall_rating.dart';
import 'package:fnm/domain/services/world_pack/pack_rules.dart';
import 'package:fnm/domain/services/world_pack/player_build.dart';
import 'package:fnm/domain/services/world_pack/world_pack.dart';

/// The edits the players section makes to a pack, as plain functions of it.
abstract final class SquadEdits {
  /// The id a new player gets: one past the highest pack-made id in any
  /// nation ([kPackPlayerIdBase] + 1 in a pack that has none), so ids stay
  /// unique across the whole pack.
  static int nextPlayerId(WorldPack pack) {
    var top = 0;
    for (final squad in pack.squads.values) {
      for (final p in squad) {
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
