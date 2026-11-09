import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/core/util/text_variety.dart';
import 'package:fnm/domain/entities/nation.dart';
import 'package:fnm/domain/entities/world_manager.dart';
import 'package:fnm/domain/repositories/player_repository.dart';
import 'package:fnm/domain/services/nation/nation_identity.dart';
import 'package:fnm/domain/services/world_managers/manager_seeder.dart';

/// A former international who could come into management: his stored name
/// and birth year, and the country he played for.
typedef ExInternational = ({
  int playerId,
  String name,
  int birthYear,
  String nationality,
});

/// The new faces of a rollover (spec section 2, rule 7): enough to top the
/// free pool back up to [poolSize], [exPlayerShare] of them former
/// internationals and the rest fresh names. Pure and deterministic from the
/// career's seed and the cycle, on a stream of its own.
abstract final class ManagerEntrants {
  /// The size the free pool is topped back up to.
  static const int poolSize = ManagerSeeder.freeCount;

  /// The share of the entrants who are former internationals.
  static const double exPlayerShare = 0.40;

  /// How old a former international is, in the rollover's year, to enter.
  static const int exPlayerMinAge = 36;
  static const int exPlayerMaxAge = 45;

  /// How old a fresh entrant is.
  static const int freshMinAge = 38;
  static const int freshMaxAge = 52;

  /// How many of [count] entrants are former internationals.
  static int exPlayersOf(int count) => (count * exPlayerShare).round();

  /// [count] entrants on [date], numbered from [firstId]: every one of
  /// [exPlayers] (the caller takes at most [exPlayersOf] of them), the rest
  /// fresh. A fresh entrant's country is drawn weighted `(6 − pedigree)^2`
  /// among the [nations] [pools] can name, and his name is drawn as a
  /// seeded manager's is, never one in [realNames] and, while it can be
  /// helped, none in [usedNames].
  static List<WorldManager> build({
    required int rngSeed,
    required int cycle,
    required DateTime date,
    required int count,
    required int firstId,
    required List<Nation> nations,
    required Map<String, NamePoolLists> pools,
    required List<ExInternational> exPlayers,
    Map<String, NamePoolLists> defaultPools = const {},
    Set<String> realNames = const {},
    Set<String> usedNames = const {},
  }) {
    if (count <= 0) return const [];
    final rng = SeededRng(varietySeed('mgr:entrants:$rngSeed:$cycle'));
    final used = {...usedNames};
    final out = <WorldManager>[];
    var id = firstId;

    for (final p in exPlayers.take(count)) {
      out.add(
        WorldManager(
          managerId: id++,
          name: p.name,
          nationality: p.nationality.toUpperCase(),
          birthYear: p.birthYear,
          style: ManagerSeeder.drawStyle(
            p.nationality,
            p.nationality,
            rng,
          ).name,
          origin: ManagerOrigin.exPlayer,
          enteredAt: date,
          sourceId: p.playerId,
        ),
      );
    }

    final ordered = [...nations]..sort((a, b) => a.id.compareTo(b.id));
    final named = [
      for (final n in ordered)
        if (pools[n.code.toUpperCase()] case final p?
            when p.first.isNotEmpty && p.sur.isNotEmpty)
          n,
    ];
    final origins = named.isEmpty ? ordered : named;
    if (origins.isEmpty) return out;
    int weight(Nation n) =>
        ManagerSeeder.weight(NationIdentity.of(n.code).pedigree);
    final total = origins.fold(0, (a, n) => a + weight(n));

    while (out.length < count) {
      var at = rng.nextInt(total);
      var from = origins.last;
      for (final n in origins) {
        at -= weight(n);
        if (at < 0) {
          from = n;
          break;
        }
      }
      final nationality = from.code.toUpperCase();
      final name = ManagerSeeder.drawName(
        nationality,
        rng,
        pools: pools,
        defaultPools: defaultPools,
        realNames: realNames,
        used: used,
      );
      final age = rng.rangeInt(freshMinAge, freshMaxAge);
      out.add(
        WorldManager(
          managerId: id++,
          name: name,
          nationality: nationality,
          birthYear: date.year - age,
          style: ManagerSeeder.drawStyle('', nationality, rng).name,
          origin: ManagerOrigin.fresh,
          enteredAt: date,
        ),
      );
    }
    return out;
  }
}
