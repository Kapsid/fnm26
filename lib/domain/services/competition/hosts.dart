import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/nation.dart';

/// Decides World Cup hosts. The hosting confederation rotates each edition and
/// a strong member is chosen deterministically, so the host of any year is
/// reproducible and the decision can be "revealed" after the previous final.
abstract final class WorldCupHosts {
  /// Confederation rotation order across editions.
  static const List<Confederation> _rotation = [
    Confederation.europe,
    Confederation.southAmerica,
    Confederation.northAmerica,
    Confederation.asia,
    Confederation.africa,
    Confederation.europe,
    Confederation.oceania,
  ];

  /// The host nation id for the World Cup in [year].
  static int hostFor({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) {
    final conf = _rotation[(year ~/ 4) % _rotation.length];
    final pool = nations.where((n) => n.confederation == conf).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));
    if (pool.isEmpty) {
      final all = [...nations]..sort((a, b) => a.ranking.compareTo(b.ranking));
      return all.first.id;
    }
    final shortlist = pool.take(12).toList();
    final rng = SeededRng(seed ^ (year * 0x51ED));
    return shortlist[rng.nextInt(shortlist.length)].id;
  }
}
