// Generates the bundled seed data (`assets/data/nations.json` and
// `assets/data/players.json`) for every FIFA nation.
//
// Run with:  dart run tool/generate_seed.dart
//
// For each nation in nations_data.dart we derive a FIFA ranking (nations sorted
// by strength) and generate a 23-player squad with fictional, culture-matched
// names (name_pools.dart). Player overalls scale with the nation's strength and
// squad role; attributes are then expanded from the overall via per-position
// profiles. Everything is deterministic (a fixed RNG seed per nation).
import 'dart:convert';
import 'dart:io';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';

import 'seed/name_pools.dart';
import 'seed/nations_data.dart';

void main() {
  // FIFA ranking: sort by strength (desc), tie-break by name for stability.
  final ranked = [...fifaNations]..sort((a, b) {
      final byStrength = b.strength.compareTo(a.strength);
      return byStrength != 0 ? byStrength : a.name.compareTo(b.name);
    });
  final rankByCode = {
    for (var i = 0; i < ranked.length; i++) ranked[i].code: i + 1,
  };

  final nations = <Map<String, Object?>>[];
  final players = <Map<String, Object?>>[];

  for (var n = 0; n < fifaNations.length; n++) {
    final nation = fifaNations[n];
    final nationId = n + 1;

    nations.add({
      'id': nationId,
      'name': nation.name,
      'code': nation.code,
      'confederation': nation.confederation.name,
      'ranking': rankByCode[nation.code],
      'isFreeDemo': nation.isFreeDemo,
    });

    final rng = SeededRng(nationId * 7919);
    final pool = namePools[nation.culture]!;
    final usedNames = <String>{};
    final base = 45 + 0.45 * nation.strength;

    for (var slot = 0; slot < _squad.length; slot++) {
      final role = _squad[slot];
      final delta = role.isStarter
          ? 2 - role.order * 0.4 // starters: +2 … -2
          : -4 - role.order * 0.7; // bench: -4 … -12
      final target =
          (base + delta + rng.rangeInt(-2, 2)).round().clamp(28, 94);

      players.add(
        _player(
          id: nationId * 100 + slot + 1,
          nationId: nationId,
          name: _uniqueName(pool, rng, usedNames),
          age: rng.rangeInt(18, 34),
          position: role.position,
          target: target,
          rng: rng,
        ),
      );
    }
  }

  const encoder = JsonEncoder.withIndent('  ');
  File('assets/data/nations.json').writeAsStringSync(encoder.convert(nations));
  File('assets/data/players.json').writeAsStringSync(encoder.convert(players));

  stdout.writeln(
    'Wrote ${nations.length} nations and ${players.length} players '
    '(${_squad.length} per nation).',
  );
}

String _uniqueName(NamePool pool, SeededRng rng, Set<String> used) {
  for (var attempt = 0; attempt < 40; attempt++) {
    final name = '${rng.pick(pool.first)} ${rng.pick(pool.last)}';
    if (used.add(name)) return name;
  }
  // Extremely unlikely fallback: disambiguate with a middle initial.
  final name = '${rng.pick(pool.first)} ${rng.pick(pool.last)}';
  var unique = name;
  var i = 2;
  while (!used.add(unique)) {
    unique = '$name $i';
    i++;
  }
  return unique;
}

Map<String, Object?> _player({
  required int id,
  required int nationId,
  required String name,
  required int age,
  required PlayerPosition position,
  required int target,
  required SeededRng rng,
}) {
  final profile = _profiles[position]!;
  int attr(double bias) =>
      (target + bias + rng.rangeInt(-3, 3)).clamp(25, 99).toInt();

  return {
    'id': id,
    'nationId': nationId,
    'name': name,
    'age': age,
    'position': position.name,
    'attributes': {
      'passing': attr(profile.passing),
      'shooting': attr(profile.shooting),
      'dribbling': attr(profile.dribbling),
      'tackling': attr(profile.tackling),
      'positioning': attr(profile.positioning),
      'composure': attr(profile.composure),
      'decisions': attr(profile.decisions),
      'pace': attr(profile.pace),
      'stamina': attr(profile.stamina),
      'strength': attr(profile.strength),
    },
  };
}

/// A squad slot: a position plus whether it is a first-choice starter and its
/// ordinal within that group (used to taper overall ratings).
class _Role {
  const _Role(this.position, {required this.isStarter, required this.order});

  final PlayerPosition position;
  final bool isStarter;
  final int order;
}

const _startingXi = <PlayerPosition>[
  PlayerPosition.gk,
  PlayerPosition.rb,
  PlayerPosition.cb,
  PlayerPosition.cb,
  PlayerPosition.lb,
  PlayerPosition.dm,
  PlayerPosition.cm,
  PlayerPosition.am,
  PlayerPosition.rw,
  PlayerPosition.st,
  PlayerPosition.lw,
];

const _bench = <PlayerPosition>[
  PlayerPosition.gk,
  PlayerPosition.gk,
  PlayerPosition.rb,
  PlayerPosition.lb,
  PlayerPosition.cb,
  PlayerPosition.cm,
  PlayerPosition.dm,
  PlayerPosition.lm,
  PlayerPosition.rm,
  PlayerPosition.st,
  PlayerPosition.rw,
  PlayerPosition.am,
];

final List<_Role> _squad = [
  for (var i = 0; i < _startingXi.length; i++)
    _Role(_startingXi[i], isStarter: true, order: i),
  for (var i = 0; i < _bench.length; i++)
    _Role(_bench[i], isStarter: false, order: i),
];

/// Per-position attribute biases (added to the player's overall). Unspecified
/// attributes use the overall directly.
class _Profile {
  const _Profile({
    this.passing = 0,
    this.shooting = 0,
    this.dribbling = 0,
    this.tackling = 0,
    this.positioning = 0,
    this.composure = 0,
    this.decisions = 0,
    this.pace = 0,
    this.stamina = 0,
    this.strength = 0,
  });

  final double passing;
  final double shooting;
  final double dribbling;
  final double tackling;
  final double positioning;
  final double composure;
  final double decisions;
  final double pace;
  final double stamina;
  final double strength;
}

const _profiles = <PlayerPosition, _Profile>{
  PlayerPosition.gk: _Profile(
    shooting: -40,
    dribbling: -35,
    tackling: -20,
    positioning: 6,
    composure: 4,
    decisions: 4,
    pace: -15,
    stamina: -10,
    strength: 2,
  ),
  PlayerPosition.lb: _Profile(
    tackling: 4,
    positioning: 3,
    pace: 8,
    stamina: 6,
    dribbling: 2,
    passing: 2,
    shooting: -18,
  ),
  PlayerPosition.cb: _Profile(
    tackling: 8,
    positioning: 6,
    strength: 8,
    decisions: 2,
    composure: 2,
    passing: -2,
    dribbling: -10,
    shooting: -25,
    pace: -2,
  ),
  PlayerPosition.rb: _Profile(
    tackling: 4,
    positioning: 3,
    pace: 8,
    stamina: 6,
    dribbling: 2,
    passing: 2,
    shooting: -18,
  ),
  PlayerPosition.dm: _Profile(
    passing: 4,
    tackling: 8,
    decisions: 6,
    positioning: 6,
    stamina: 6,
    strength: 4,
    composure: 2,
    shooting: -8,
  ),
  PlayerPosition.cm: _Profile(
    passing: 8,
    decisions: 6,
    dribbling: 4,
    stamina: 6,
    composure: 4,
    positioning: 2,
    shooting: -2,
  ),
  PlayerPosition.am: _Profile(
    passing: 8,
    dribbling: 8,
    decisions: 6,
    composure: 6,
    shooting: 4,
    pace: 4,
    positioning: 2,
    tackling: -8,
    strength: -4,
  ),
  PlayerPosition.lm: _Profile(
    passing: 4,
    dribbling: 8,
    pace: 10,
    stamina: 6,
    composure: 2,
    decisions: 2,
    tackling: -4,
    strength: -4,
  ),
  PlayerPosition.rm: _Profile(
    passing: 4,
    dribbling: 8,
    pace: 10,
    stamina: 6,
    composure: 2,
    decisions: 2,
    tackling: -4,
    strength: -4,
  ),
  PlayerPosition.lw: _Profile(
    shooting: 6,
    pace: 12,
    dribbling: 12,
    composure: 6,
    positioning: 4,
    decisions: 2,
    passing: 2,
    tackling: -15,
    strength: -8,
  ),
  PlayerPosition.rw: _Profile(
    shooting: 6,
    pace: 12,
    dribbling: 12,
    composure: 6,
    positioning: 4,
    decisions: 2,
    passing: 2,
    tackling: -15,
    strength: -8,
  ),
  PlayerPosition.st: _Profile(
    shooting: 14,
    pace: 8,
    dribbling: 6,
    composure: 8,
    positioning: 8,
    strength: 4,
    decisions: 2,
    passing: -2,
    tackling: -20,
  ),
};
