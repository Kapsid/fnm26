import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';

/// Turns the base 23-per-nation seed into a deeper, scoutable pool: it assigns
/// every player a club and pads each nation with procedurally-generated fringe
/// players (names recombined from the real squad, so they stay culturally
/// plausible; attributes scaled down from the squad average). Deterministic.
abstract final class PoolGenerator {
  /// Extra fringe players added per nation (23 real + this ≈ a 100+-man pool).
  static const extraPerNation = 80;

  /// Fictional-but-plausible club sides, shared across nations (national-team
  /// players from the same club is realistic).
  static const List<String> _clubs = [
    'FC Meridian', 'Athletic Rivera', 'Real Montaña', 'Sporting Delta',
    'Inter Valle', 'Olympic Larsson', 'Dynamo Kest', 'AC Borealis',
    'Union Sportif', 'Cassar City', 'Vardar United', 'Nord FK',
    'Racing Aledo', 'Kaiser SV', 'Atlético Ponte', 'Estrella FC',
    'Lokomotiv Ost', 'Wanderers AFC', 'Hansa Verein', 'CD Marino',
    'Górnik Wisła', 'Étoile Sud', 'Panthera SC', 'River Aterno',
    'Fortuna Vega', 'Slavia Brod', 'Kongens BK', 'Al-Nahda SC',
    'Toluca Norte', 'Selênio FC', 'Ironside United', 'Volta Roja',
    'Aurora Athletic', 'Kobalt SV', 'Deportivo Sol', 'Rangers Kilda',
    'FK Zenica', 'Corsair FC', 'Monteverde', 'Halden IL',
  ];

  static String _club(int seed) => _clubs[seed.abs() % _clubs.length];

  /// A depth chart of extra positions per nation, roughly realistic.
  static const List<PlayerPosition> _fringePositions = [
    PlayerPosition.gk, PlayerPosition.gk,
    PlayerPosition.rb, PlayerPosition.lb, PlayerPosition.cb,
    PlayerPosition.cb, PlayerPosition.cb, PlayerPosition.rb,
    PlayerPosition.dm, PlayerPosition.cm, PlayerPosition.cm,
    PlayerPosition.am, PlayerPosition.lm, PlayerPosition.rm,
    PlayerPosition.dm, PlayerPosition.cm, PlayerPosition.am,
    PlayerPosition.lw, PlayerPosition.rw, PlayerPosition.st,
    PlayerPosition.st, PlayerPosition.lw, PlayerPosition.rw,
    PlayerPosition.cb, PlayerPosition.cm, PlayerPosition.st,
    PlayerPosition.lb, PlayerPosition.rm, PlayerPosition.am,
    PlayerPosition.dm,
  ];

  /// Returns the players with clubs assigned, plus generated fringe players.
  static List<Player> expand(List<Player> real) {
    final byNation = <int, List<Player>>{};
    for (final p in real) {
      (byNation[p.nationId] ??= []).add(p);
    }

    final out = <Player>[];
    var nextId = 10000000;
    for (final entry in byNation.entries) {
      final nationId = entry.key;
      final squad = entry.value;

      // Clubs for the real squad.
      for (final p in squad) {
        out.add(p.copyWith(club: _club(p.id)));
      }

      final rng = SeededRng((nationId * 0x9E3779B1) ^ 0xF00DBEEF);
      final firsts = squad.map((p) => _firstName(p.name)).toList();
      final lasts = squad.map((p) => _lastName(p.name)).toList();
      final avg = _averageAttributes(squad);

      for (var i = 0; i < extraPerNation; i++) {
        final pos = _fringePositions[i % _fringePositions.length];
        // Depth-graded quality: the first fringe players are near the squad's
        // level (just below the weaker starters) and taper smoothly down the
        // depth chart, so there's no cliff between the top 23 and the rest.
        final depth = extraPerNation == 1 ? 0.0 : i / (extraPerNation - 1);
        final noise = (rng.nextInt(9) - 4) / 100;
        final scale = (0.96 - 0.34 * depth + noise).clamp(0.55, 0.98);
        out.add(
          Player(
            id: nextId,
            nationId: nationId,
            name: '${firsts[rng.nextInt(firsts.length)]} '
                '${lasts[rng.nextInt(lasts.length)]}',
            age: 18 + rng.nextInt(17), // 18 … 34
            position: pos,
            attributes: _scale(avg, scale, rng),
            club: _club(nextId),
          ),
        );
        nextId++;
      }
    }
    return out;
  }

  static String _firstName(String full) => full.trim().split(' ').first;

  static String _lastName(String full) {
    final parts = full.trim().split(' ');
    return parts.length > 1 ? parts.last : parts.first;
  }

  static PlayerAttributes _averageAttributes(List<Player> squad) {
    final n = squad.length;
    int mean(int Function(PlayerAttributes) pick) =>
        squad.fold<int>(0, (s, p) => s + pick(p.attributes)) ~/ n;
    return PlayerAttributes(
      passing: mean((a) => a.passing),
      shooting: mean((a) => a.shooting),
      dribbling: mean((a) => a.dribbling),
      tackling: mean((a) => a.tackling),
      positioning: mean((a) => a.positioning),
      composure: mean((a) => a.composure),
      decisions: mean((a) => a.decisions),
      pace: mean((a) => a.pace),
      stamina: mean((a) => a.stamina),
      strength: mean((a) => a.strength),
    );
  }

  static PlayerAttributes _scale(
    PlayerAttributes base,
    double scale,
    SeededRng rng,
  ) {
    int a(int v) => ((v * scale) + rng.nextInt(9) - 4).round().clamp(20, 92);
    return PlayerAttributes(
      passing: a(base.passing),
      shooting: a(base.shooting),
      dribbling: a(base.dribbling),
      tackling: a(base.tackling),
      positioning: a(base.positioning),
      composure: a(base.composure),
      decisions: a(base.decisions),
      pace: a(base.pace),
      stamina: a(base.stamina),
      strength: a(base.strength),
    );
  }
}
