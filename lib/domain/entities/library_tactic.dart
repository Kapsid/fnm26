import 'dart:convert';

import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_role.dart';
import 'package:fnm/domain/entities/tactics.dart';

/// A tactic kept in the manager's library, outside any one career.
///
/// Only the TACTICAL decisions travel: the shape, the playing style, the six
/// dials, and which slot carries which role and takes which set piece. Never a
/// player. Player ids belong to one save (a newgen in one world is nobody in
/// the next), so roles and takers are stored against the formation's slots and
/// re-attached to whoever fills those slots when the tactic is loaded; see
/// [fit].
class LibraryTactic {
  const LibraryTactic({
    required this.name,
    required this.formation,
    required this.instructions,
    this.id,
    this.playstyle = Playstyle.custom,
    this.fullBacks = FullBackPushes.neutral,
    this.rolesBySlot = const {},
    this.penaltySlot,
    this.deadBallSlot,
  });

  /// Captures [tactic] as a library entry called [name], reading the roles and
  /// set-piece takers of whoever currently fills each slot.
  ///
  /// A taker who is not in the eleven has no slot to remember, so he is left
  /// as automatic, which is what the tactics screen does with him anyway.
  factory LibraryTactic.capture({
    required String name,
    required Tactic tactic,
    Map<int, PlayerRole> roles = const {},
    int? penaltyTaker,
    int? deadBallTaker,
  }) {
    int? slotOf(int? playerId) {
      if (playerId == null) return null;
      final i = tactic.lineup.indexOf(playerId);
      return i < 0 ? null : i;
    }

    return LibraryTactic(
      name: name,
      formation: tactic.formation,
      instructions: tactic.instructions,
      playstyle: tactic.playstyle,
      fullBacks: tactic.fullBacks,
      rolesBySlot: {
        for (var slot = 0; slot < tactic.lineup.length; slot++)
          if (roles[tactic.lineup[slot]] case final role?
              when role != PlayerRole.none)
            slot: role,
      },
      penaltySlot: slotOf(penaltyTaker),
      deadBallSlot: slotOf(deadBallTaker),
    );
  }

  /// Reads a stored document back. Unknown or damaged values fall back to the
  /// neutral choice rather than losing the entry: a library written by a later
  /// build (a formation this one does not know) still loads as something.
  factory LibraryTactic.fromData({
    required String name,
    required String data,
    int? id,
  }) {
    Map<String, dynamic> json;
    try {
      final decoded = jsonDecode(data);
      json = decoded is Map<String, dynamic> ? decoded : const {};
    } on FormatException {
      json = const {};
    }
    int dial(String key) {
      final v = json[key];
      return v is int ? v.clamp(0, 100) : 50;
    }

    int? slot(Object? v) => v is int && v >= 0 && v < 11 ? v : null;

    final formation = Formation.values.firstWhere(
      (f) => f.name == json['formation'],
      orElse: () => Formation.values.first,
    );
    final instructions = TacticalInstructions(
      mentality: dial('mentality'),
      pressing: dial('pressing'),
      tempo: dial('tempo'),
      width: dial('width'),
      defensiveLine: dial('defensiveLine'),
      directness: dial('directness'),
    );
    final stored = Playstyle.values.firstWhere(
      (s) => s.name == json['playstyle'],
      orElse: () => Playstyle.custom,
    );
    // The style is a description of the dials; it may only claim one it
    // still matches (see [Playstyle]).
    final playstyle = stored.instructions == instructions
        ? stored
        : PlaystyleX.matching(instructions);
    final rolesBySlot = <int, PlayerRole>{};
    if (json['roles'] case final Map<String, dynamic> raw) {
      for (final e in raw.entries) {
        final s = slot(int.tryParse(e.key));
        final role = PlayerRole.values
            .where((r) => r.name == '${e.value}')
            .firstOrNull;
        if (s != null && role != null && role != PlayerRole.none) {
          rolesBySlot[s] = role;
        }
      }
    }
    return LibraryTactic(
      id: id,
      name: name,
      formation: formation,
      instructions: instructions,
      playstyle: playstyle,
      fullBacks: FullBackPushes.fromJson(json['fullBacks']),
      rolesBySlot: rolesBySlot,
      penaltySlot: slot(json['penaltySlot']),
      deadBallSlot: slot(json['deadBallSlot']),
    );
  }

  /// The row id in the library, null before it is saved.
  final int? id;
  final String name;
  final Formation formation;
  final TacticalInstructions instructions;
  final Playstyle playstyle;

  /// The full-backs' arrows; neutral for an entry saved before they existed.
  final FullBackPushes fullBacks;

  /// Formation slot (0 to 10) to the role whoever plays there is given.
  final Map<int, PlayerRole> rolesBySlot;

  /// The slot whose player takes penalties; null leaves it automatic.
  final int? penaltySlot;

  /// The slot whose player takes corners and free kicks; null = automatic.
  final int? deadBallSlot;

  LibraryTactic copyWith({int? id, String? name}) => LibraryTactic(
    id: id ?? this.id,
    name: name ?? this.name,
    formation: formation,
    instructions: instructions,
    playstyle: playstyle,
    fullBacks: fullBacks,
    rolesBySlot: rolesBySlot,
    penaltySlot: penaltySlot,
    deadBallSlot: deadBallSlot,
  );

  /// The stored document: everything but the name and id, which have columns.
  String toData() => jsonEncode({
    'v': 1,
    'formation': formation.name,
    'playstyle': playstyle.name,
    'mentality': instructions.mentality,
    'pressing': instructions.pressing,
    'tempo': instructions.tempo,
    'width': instructions.width,
    'defensiveLine': instructions.defensiveLine,
    'directness': instructions.directness,
    if (!fullBacks.isNeutral) 'fullBacks': fullBacks.toJson(),
    'roles': {
      for (final e in rolesBySlot.entries) '${e.key}': e.value.name,
    },
    'penaltySlot': penaltySlot,
    'deadBallSlot': deadBallSlot,
  });

  /// Fits this tactic's per-slot choices onto [lineup] (the eleven the new
  /// save picked for [formation]), given who those players are.
  ///
  /// Roles go to whoever stands in each slot, but only a role that suits his
  /// position (the same rule as the role picker); every other starter's role
  /// is cleared, so the eleven ends up carrying exactly this tactic's roles.
  /// A taker's slot that is empty leaves that set piece automatic. Anything
  /// that could not be carried over is counted in [LibraryFit.skipped], so the
  /// screen can say so.
  LibraryFit fit(List<int?> lineup, Map<int, Player> playersById) {
    final roles = <int, PlayerRole>{};
    var skipped = 0;
    for (var slot = 0; slot < lineup.length; slot++) {
      final id = lineup[slot];
      final player = id == null ? null : playersById[id];
      final wanted = rolesBySlot[slot] ?? PlayerRole.none;
      if (player == null) {
        if (wanted != PlayerRole.none) skipped++;
        continue;
      }
      if (wanted == PlayerRole.none || suits(wanted, player.category)) {
        roles[player.id] = wanted;
      } else {
        roles[player.id] = PlayerRole.none;
        skipped++;
      }
    }
    for (final s in rolesBySlot.keys) {
      if (s >= lineup.length) skipped++;
    }
    int? taker(int? slot) {
      if (slot == null) return null;
      final id = slot < lineup.length ? lineup[slot] : null;
      if (id == null || !playersById.containsKey(id)) {
        skipped++;
        return null;
      }
      return id;
    }

    return LibraryFit(
      roles: roles,
      penaltyTaker: taker(penaltySlot),
      deadBallTaker: taker(deadBallSlot),
      skipped: skipped,
    );
  }

  /// Whether [role] may be given to a player of [category]; the role picker's
  /// rule, so a loaded tactic never hands out a role the picker would not.
  static bool suits(PlayerRole role, PositionCategory category) =>
      role == PlayerRole.none ||
      switch (category) {
        PositionCategory.forward => role.forForwards,
        PositionCategory.midfielder => role.forMidfielders,
        PositionCategory.defender => role.forDefenders,
        PositionCategory.goalkeeper => false,
      };
}

/// What loading a [LibraryTactic] does to one save's eleven.
class LibraryFit {
  const LibraryFit({
    required this.roles,
    required this.penaltyTaker,
    required this.deadBallTaker,
    required this.skipped,
  });

  /// Starter id to the role he now has ([PlayerRole.none] clears one).
  final Map<int, PlayerRole> roles;
  final int? penaltyTaker;
  final int? deadBallTaker;

  /// How many of the tactic's roles and takers did not fit this squad.
  final int skipped;
}
