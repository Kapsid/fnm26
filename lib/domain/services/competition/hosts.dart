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

  /// The confederation hosting the World Cup in [year].
  static Confederation confederationFor(int year) =>
      _rotation[(year ~/ 4) % _rotation.length];

  /// The shortlist of realistic host candidates for [confederation] (its
  /// strongest members), shown in the host-draw ceremony before the winner is
  /// revealed.
  static List<int> hostCandidates({
    required Confederation confederation,
    required List<Nation> nations,
    int count = 6,
  }) {
    final pool = nations.where((n) => n.confederation == confederation).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));
    return pool.take(count).map((n) => n.id).toList();
  }

  /// The host nation id for the World Cup in [year].
  static int hostFor({
    required int year,
    required List<Nation> nations,
    required int seed,
  }) {
    final conf = _rotation[(year ~/ 4) % _rotation.length];
    return hostFromConfederation(
      confederation: conf,
      nations: nations,
      seed: seed ^ (year * 0x51ED),
    );
  }

  /// The host of a continental championship for a confederation in a given
  /// [cycle], derived deterministically (like the World Cup host) so it can be
  /// re-computed anywhere without being stored. Biased toward strong members.
  static int continentalHostFor({
    required Confederation confederation,
    required int cycle,
    required int seed,
    required List<Nation> nations,
  }) =>
      hostFromConfederation(
        confederation: confederation,
        nations: nations,
        seed: seed ^ (cycle * 0x2C9F) ^ (confederation.index * 0x51ED) ^ 0xC047,
      );

  /// Picks a host from [confederation], biased toward its strongest members: a
  /// weighted draw over the top of the confederation's ranking so a heavyweight
  /// usually hosts, but not always. Falls back to the strongest nation overall
  /// if the confederation has no members. Deterministic for a given [seed].
  static int hostFromConfederation({
    required Confederation confederation,
    required List<Nation> nations,
    required int seed,
  }) {
    final pool = nations.where((n) => n.confederation == confederation).toList()
      ..sort((a, b) => a.ranking.compareTo(b.ranking));
    if (pool.isEmpty) {
      final all = [...nations]..sort((a, b) => a.ranking.compareTo(b.ranking));
      return all.isEmpty ? 0 : all.first.id;
    }
    final shortlist = pool.take(12).toList();
    final rng = SeededRng(seed);
    // Triangular weights: the strongest candidate is weighted `n`, the next
    // `n-1`, … so stronger nations are far likelier to host.
    final n = shortlist.length;
    final total = n * (n + 1) / 2;
    var roll = rng.nextDouble() * total;
    for (var i = 0; i < n; i++) {
      roll -= n - i;
      if (roll <= 0) return shortlist[i].id;
    }
    return shortlist.first.id;
  }
}
