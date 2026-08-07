import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_attributes.dart';
import 'package:fnm/domain/services/player/depth_chart.dart';

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

  /// Returns the players with clubs assigned, plus generated fringe players.
  ///
  /// [namesByNation] supplies culturally-authentic first/surname pools per
  /// nation id (from `assets/data/country_names.json`); when absent for a
  /// nation the fringe names are recombined from that squad's real names.
  static List<Player> expand(
    List<Player> real, {
    Map<int, ({List<String> first, List<String> sur})>? namesByNation,
  }) {
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
      final pool = namesByNation?[nationId];
      final firsts = pool != null && pool.first.isNotEmpty
          ? pool.first
          : squad.map((p) => _firstName(p.name)).toList();
      final lasts = pool != null && pool.sur.isNotEmpty
          ? pool.sur
          : squad.map((p) => _lastName(p.name)).toList();
      // Anchor on the nation's stronger players (top half by overall), not the
      // whole-squad mean — stars pull the mean down, so a mean-anchored fringe
      // sat well below the real starters and left a cliff right after the 23.
      final ranked = [...squad]..sort((a, b) => b.overall.compareTo(a.overall));
      final avg = _averageAttributes(
        ranked.take((squad.length / 2).ceil().clamp(1, squad.length)).toList(),
      );

      // The nation's own depth chart, not one shared list — see [DepthChart].
      // Every country used to pad its pool from the same fixed cycle of
      // positions, so every nation in the world had an identical fringe.
      final fringePositions = DepthChart.forNation(
        nationId: nationId,
        count: extraPerNation,
      );

      for (var i = 0; i < extraPerNation; i++) {
        final pos = fringePositions[i];
        // Depth-graded quality anchored on the stronger players so the best
        // fringe overlap the first-choice XI (a continuous curve, no cliff at
        // the top-23 boundary) and taper gently down the depth chart to a
        // clear-reserve floor. The slope is deliberately shallow near the top
        // so the next tier of talent stays competitive.
        final depth = extraPerNation == 1 ? 0.0 : i / (extraPerNation - 1);
        final noise = (rng.nextInt(9) - 4) / 100;
        // Shallow slope + a high floor: the next tier stays close to the XI and
        // even the deepest reserve is a credible squad player, not a minnow.
        final scale = (1.04 - 0.26 * depth + noise).clamp(0.74, 1.06);
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
      physical: mean((a) => a.physical),
      technical: mean((a) => a.technical),
      stamina: mean((a) => a.stamina),
    );
  }

  static PlayerAttributes _scale(
    PlayerAttributes base,
    double scale,
    SeededRng rng,
  ) {
    int a(int v) => ((v * scale) + rng.nextInt(9) - 4).round().clamp(20, 92);
    return PlayerAttributes(
      physical: a(base.physical),
      technical: a(base.technical),
      stamina: a(base.stamina),
    );
  }
}
