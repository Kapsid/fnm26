// Generates the bundled seed data (`assets/data/nations.json` and
// `assets/data/players.json`) from the concise rosters defined below.
//
// Run with:  dart run tool/generate_seed.dart
//
// Authoring stays compact — each player is just (name, position, age, overall).
// This script deterministically expands that into a full ten-attribute block
// using per-position profiles, so attribute spreads are realistic and
// reproducible (a fixed RNG seed per player id).
//
// 8 nations × 14 players. The four strongest demo nations are free; the rest
// are gated behind the premium unlock.
import 'dart:convert';
import 'dart:io';

import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';

void main() {
  final nations = _nations.map((n) => n.toJson()).toList();

  final players = <Map<String, Object?>>[];
  _rosters.forEach((nationId, roster) {
    for (var i = 0; i < roster.length; i++) {
      final p = roster[i];
      final id = nationId * 100 + (i + 1);
      players.add(_expand(id: id, nationId: nationId, entry: p));
    }
  });

  const encoder = JsonEncoder.withIndent('  ');
  File('assets/data/nations.json').writeAsStringSync(encoder.convert(nations));
  File('assets/data/players.json').writeAsStringSync(encoder.convert(players));

  stdout.writeln(
    'Wrote ${nations.length} nations and ${players.length} players.',
  );
}

/// Expands a concise roster entry into the full seed JSON for one player.
Map<String, Object?> _expand({
  required int id,
  required int nationId,
  required _RosterEntry entry,
}) {
  final rng = SeededRng(id);
  final base = entry.overall;
  final profile = _profiles[entry.position]!;

  int attr(double bias) =>
      (base + bias + rng.rangeInt(-3, 3)).clamp(25, 99).toInt();

  return {
    'id': id,
    'nationId': nationId,
    'name': entry.name,
    'age': entry.age,
    'position': entry.position.name,
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

class _NationSeed {
  const _NationSeed(
    this.id,
    this.name,
    this.code,
    this.confederation,
    this.ranking, {
    this.isFreeDemo = false,
  });

  final int id;
  final String name;
  final String code;
  final Confederation confederation;
  final int ranking;
  final bool isFreeDemo;

  Map<String, Object?> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'confederation': confederation.name,
        'ranking': ranking,
        'isFreeDemo': isFreeDemo,
      };
}

typedef _RosterEntry = ({
  String name,
  PlayerPosition position,
  int age,
  int overall,
});

_RosterEntry _p(String name, PlayerPosition position, int age, int overall) =>
    (name: name, position: position, age: age, overall: overall);

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

const _nations = <_NationSeed>[
  _NationSeed(
    1,
    'Brazil',
    'BRA',
    Confederation.southAmerica,
    5,
    isFreeDemo: true,
  ),
  _NationSeed(2, 'France', 'FRA', Confederation.europe, 2, isFreeDemo: true),
  _NationSeed(3, 'Spain', 'ESP', Confederation.europe, 8, isFreeDemo: true),
  _NationSeed(4, 'England', 'ENG', Confederation.europe, 4, isFreeDemo: true),
  _NationSeed(5, 'Germany', 'GER', Confederation.europe, 10),
  _NationSeed(6, 'Argentina', 'ARG', Confederation.southAmerica, 1),
  _NationSeed(7, 'Portugal', 'POR', Confederation.europe, 6),
  _NationSeed(8, 'Netherlands', 'NED', Confederation.europe, 7),
];

// 14 per nation: gk, gk, lb, cb, cb, rb, dm, cm, cm, am, lw, rw, st, st.
final _rosters = <int, List<_RosterEntry>>{
  1: [
    _p('Alisson', PlayerPosition.gk, 33, 87),
    _p('Ederson', PlayerPosition.gk, 32, 85),
    _p('Wendell', PlayerPosition.lb, 32, 79),
    _p('Marquinhos', PlayerPosition.cb, 31, 86),
    _p('Gabriel Magalhães', PlayerPosition.cb, 28, 85),
    _p('Danilo', PlayerPosition.rb, 34, 80),
    _p('Bruno Guimarães', PlayerPosition.dm, 28, 85),
    _p('Lucas Paquetá', PlayerPosition.cm, 28, 83),
    _p('André', PlayerPosition.cm, 24, 80),
    _p('Rodrygo', PlayerPosition.am, 25, 85),
    _p('Vinícius Júnior', PlayerPosition.lw, 25, 89),
    _p('Raphinha', PlayerPosition.rw, 29, 86),
    _p('Endrick', PlayerPosition.st, 19, 80),
    _p('Matheus Cunha', PlayerPosition.st, 26, 82),
  ],
  2: [
    _p('Mike Maignan', PlayerPosition.gk, 30, 87),
    _p('Brice Samba', PlayerPosition.gk, 31, 81),
    _p('Théo Hernández', PlayerPosition.lb, 28, 85),
    _p('Dayot Upamecano', PlayerPosition.cb, 27, 84),
    _p('William Saliba', PlayerPosition.cb, 24, 86),
    _p('Jules Koundé', PlayerPosition.rb, 27, 84),
    _p('Aurélien Tchouaméni', PlayerPosition.dm, 25, 85),
    _p('Eduardo Camavinga', PlayerPosition.cm, 22, 84),
    _p('Adrien Rabiot', PlayerPosition.cm, 30, 82),
    _p('Antoine Griezmann', PlayerPosition.am, 35, 85),
    _p('Kylian Mbappé', PlayerPosition.lw, 27, 91),
    _p('Ousmane Dembélé', PlayerPosition.rw, 28, 86),
    _p('Marcus Thuram', PlayerPosition.st, 28, 83),
    _p('Randal Kolo Muani', PlayerPosition.st, 27, 81),
  ],
  3: [
    _p('Unai Simón', PlayerPosition.gk, 28, 84),
    _p('David Raya', PlayerPosition.gk, 30, 84),
    _p('Marc Cucurella', PlayerPosition.lb, 27, 83),
    _p('Robin Le Normand', PlayerPosition.cb, 29, 83),
    _p('Pau Cubarsí', PlayerPosition.cb, 19, 82),
    _p('Dani Carvajal', PlayerPosition.rb, 34, 84),
    _p('Rodri', PlayerPosition.dm, 29, 90),
    _p('Pedri', PlayerPosition.cm, 23, 87),
    _p('Fabián Ruiz', PlayerPosition.cm, 30, 83),
    _p('Dani Olmo', PlayerPosition.am, 27, 84),
    _p('Nico Williams', PlayerPosition.lw, 23, 85),
    _p('Lamine Yamal', PlayerPosition.rw, 18, 87),
    _p('Álvaro Morata', PlayerPosition.st, 33, 81),
    _p('Mikel Oyarzabal', PlayerPosition.st, 29, 83),
  ],
  4: [
    _p('Jordan Pickford', PlayerPosition.gk, 32, 84),
    _p('Dean Henderson', PlayerPosition.gk, 29, 80),
    _p('Myles Lewis-Skelly', PlayerPosition.lb, 19, 80),
    _p('John Stones', PlayerPosition.cb, 31, 84),
    _p('Marc Guéhi', PlayerPosition.cb, 25, 83),
    _p('Trent Alexander-Arnold', PlayerPosition.rb, 27, 85),
    _p('Declan Rice', PlayerPosition.dm, 27, 87),
    _p('Jude Bellingham', PlayerPosition.cm, 22, 89),
    _p('Cole Palmer', PlayerPosition.cm, 23, 86),
    _p('Phil Foden', PlayerPosition.am, 25, 86),
    _p('Bukayo Saka', PlayerPosition.lw, 24, 87),
    _p('Anthony Gordon', PlayerPosition.rw, 25, 82),
    _p('Harry Kane', PlayerPosition.st, 32, 90),
    _p('Ollie Watkins', PlayerPosition.st, 30, 82),
  ],
  5: [
    _p('Marc-André ter Stegen', PlayerPosition.gk, 34, 85),
    _p('Oliver Baumann', PlayerPosition.gk, 35, 79),
    _p('David Raum', PlayerPosition.lb, 28, 81),
    _p('Antonio Rüdiger', PlayerPosition.cb, 33, 85),
    _p('Jonathan Tah', PlayerPosition.cb, 30, 83),
    _p('Joshua Kimmich', PlayerPosition.rb, 31, 86),
    _p('Robert Andrich', PlayerPosition.dm, 31, 80),
    _p('Florian Wirtz', PlayerPosition.cm, 23, 88),
    _p('Leon Goretzka', PlayerPosition.cm, 31, 82),
    _p('Jamal Musiala', PlayerPosition.am, 23, 88),
    _p('Leroy Sané', PlayerPosition.lw, 30, 84),
    _p('Serge Gnabry', PlayerPosition.rw, 30, 83),
    _p('Kai Havertz', PlayerPosition.st, 27, 84),
    _p('Niclas Füllkrug', PlayerPosition.st, 33, 80),
  ],
  6: [
    _p('Emiliano Martínez', PlayerPosition.gk, 33, 86),
    _p('Gerónimo Rulli', PlayerPosition.gk, 33, 80),
    _p('Nicolás Tagliafico', PlayerPosition.lb, 33, 81),
    _p('Cristian Romero', PlayerPosition.cb, 27, 86),
    _p('Lisandro Martínez', PlayerPosition.cb, 28, 84),
    _p('Nahuel Molina', PlayerPosition.rb, 27, 81),
    _p('Enzo Fernández', PlayerPosition.dm, 25, 85),
    _p('Alexis Mac Allister', PlayerPosition.cm, 27, 86),
    _p('Rodrigo De Paul', PlayerPosition.cm, 31, 83),
    _p('Lionel Messi', PlayerPosition.am, 38, 88),
    _p('Nicolás González', PlayerPosition.lw, 27, 82),
    _p('Ángel Di María', PlayerPosition.rw, 37, 82),
    _p('Lautaro Martínez', PlayerPosition.st, 28, 88),
    _p('Julián Álvarez', PlayerPosition.st, 25, 87),
  ],
  7: [
    _p('Diogo Costa', PlayerPosition.gk, 26, 85),
    _p('José Sá', PlayerPosition.gk, 33, 80),
    _p('Nuno Mendes', PlayerPosition.lb, 23, 85),
    _p('Rúben Dias', PlayerPosition.cb, 28, 87),
    _p('Gonçalo Inácio', PlayerPosition.cb, 24, 82),
    _p('João Cancelo', PlayerPosition.rb, 31, 84),
    _p('João Palhinha', PlayerPosition.dm, 30, 84),
    _p('Vitinha', PlayerPosition.cm, 26, 86),
    _p('Bruno Fernandes', PlayerPosition.cm, 31, 87),
    _p('Bernardo Silva', PlayerPosition.am, 31, 86),
    _p('Rafael Leão', PlayerPosition.lw, 26, 85),
    _p('Pedro Neto', PlayerPosition.rw, 25, 82),
    _p('Cristiano Ronaldo', PlayerPosition.st, 41, 84),
    _p('Gonçalo Ramos', PlayerPosition.st, 24, 82),
  ],
  8: [
    _p('Bart Verbruggen', PlayerPosition.gk, 23, 82),
    _p('Mark Flekken', PlayerPosition.gk, 32, 80),
    _p('Nathan Aké', PlayerPosition.lb, 31, 83),
    _p('Virgil van Dijk', PlayerPosition.cb, 34, 87),
    _p('Jurriën Timber', PlayerPosition.cb, 24, 83),
    _p('Denzel Dumfries', PlayerPosition.rb, 29, 82),
    _p('Frenkie de Jong', PlayerPosition.dm, 28, 86),
    _p('Tijjani Reijnders', PlayerPosition.cm, 27, 84),
    _p('Ryan Gravenberch', PlayerPosition.cm, 23, 84),
    _p('Cody Gakpo', PlayerPosition.am, 26, 84),
    _p('Xavi Simons', PlayerPosition.lw, 22, 85),
    _p('Noa Lang', PlayerPosition.rw, 26, 80),
    _p('Memphis Depay', PlayerPosition.st, 32, 83),
    _p('Brian Brobbey', PlayerPosition.st, 23, 80),
  ],
};
