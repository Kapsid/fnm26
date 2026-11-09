import 'dart:math';

import 'package:fnm/domain/repositories/competition_repository.dart';
import 'package:fnm/domain/services/competition/real_history.dart';

/// A nation's World Championship pedigree: the small edge, in background
/// strength points, that a side with a recent record of going deep at the
/// finals carries into a finals knockout tie.
///
/// Without it the world had no memory. A giant that went out in the round of
/// 32 was exactly as likely to go out early again next time as any side of its
/// strength, and with the elite band only a few points wide the podium spread
/// across thirty nations a save; a real World Championship podium goes to a
/// dozen traditional powers about nine times in ten. The pedigree is that
/// tradition: medals and semi-finals, real (the seeded roll of honour) and
/// earned in the save alike, each worth less every cycle that passes.
///
/// Read only by the background simulator, and only for World Championship
/// finals knockout rounds: groups, qualifiers, friendlies and the continental
/// cups never see it, and neither does the manager's own match. Nothing is
/// stored; it is derived from the honour rows every save already has, so old
/// saves pick it up with no migration.
abstract final class WorldPedigree {
  /// The most a pedigree is ever worth, in strength points.
  static const double cap = 2.5;

  /// What a result is still worth one cycle (four years) later.
  static const double decayPerCycle = 0.85;

  static const double _gold = 3;
  static const double _silver = 2;
  static const double _bronze = 1;
  static const double _fourth = 0.75;

  /// The real fourth-placed sides (beaten semi-finalists who lost the
  /// third-place match), which the roll of honour does not hold. Older
  /// editions have decayed to nothing by the time a save starts, and 2026 is
  /// the save's own backstory, so the list starts at 1990 and stops at 2022.
  static const realFourthPlaces = <int, String>{
    1990: 'England',
    1994: 'Bulgaria',
    1998: 'Netherlands',
    2002: 'South Korea',
    2006: 'Portugal',
    2010: 'Uruguay',
    2014: 'Brazil',
    2018: 'England',
    2022: 'Morocco',
  };

  /// Each nation's pedigree edge for the finals of [year], from every World
  /// Championship honour before it (later ones are ignored) and the real
  /// fourth places, resolved through [idByEnglishName]. Nations with no
  /// record are absent (an edge of 0).
  static Map<int, double> edges({
    required Iterable<Honour> honours,
    required int year,
    Map<String, int> idByEnglishName = const {},
  }) {
    final raw = <int, double>{};
    void credit(int? id, double weight, int at) {
      if (id == null || at >= year) return;
      final cycles = (year - at) / 4;
      raw[id] = (raw[id] ?? 0) + weight * pow(decayPerCycle, cycles);
    }

    for (final h in honours) {
      if (h.competition != RealHistory.worldChampionship) continue;
      for (final c in h.champions) {
        credit(c, _gold, h.year);
      }
      credit(h.runnerUpId, _silver, h.year);
      credit(h.thirdId, _bronze, h.year);
      credit(h.thirdId2, _bronze, h.year);
    }
    realFourthPlaces.forEach((at, name) {
      final id =
          idByEnglishName[name] ??
          idByEnglishName[RealHistory.aliases[name] ?? name];
      credit(id, _fourth, at);
    });
    return {
      for (final e in raw.entries) e.key: cap * (1 - exp(-e.value / cap)),
    };
  }
}
