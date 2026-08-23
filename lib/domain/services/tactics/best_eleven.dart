import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';

/// Picks the strongest starting XI for [formation] from a [pool] of players.
///
/// For each slot (in order) it takes the best unused player whose position
/// matches exactly; failing that, the best in the same positional category;
/// failing that, the best player left. Returns slot→playerId (length 11), with
/// `null` only if the pool is exhausted.
List<int?> bestEleven(Formation formation, List<Player> pool) {
  final available = [...pool]..sort((a, b) => b.overall.compareTo(a.overall));
  final used = <int>{};
  final slots = List<int?>.filled(11, null);

  for (var i = 0; i < 11; i++) {
    final wanted = formation.positions[i];
    final pick =
        _pickExact(wanted, available, used) ??
        _pickCategory(wanted, available, used) ??
        _pickAny(available, used);
    if (pick != null) {
      slots[i] = pick.id;
      used.add(pick.id);
    }
  }
  return slots;
}

Player? _pickExact(
  PlayerPosition position,
  List<Player> sorted,
  Set<int> used,
) {
  for (final p in sorted) {
    if (!used.contains(p.id) && p.position == position) return p;
  }
  return null;
}

Player? _pickCategory(
  PlayerPosition position,
  List<Player> sorted,
  Set<int> used,
) {
  for (final p in sorted) {
    if (!used.contains(p.id) && p.position.category == position.category) {
      return p;
    }
  }
  return null;
}

Player? _pickAny(List<Player> sorted, Set<int> used) {
  for (final p in sorted) {
    if (!used.contains(p.id)) return p;
  }
  return null;
}

/// Who a SHAPE CHANGE may draw on: exactly the players already on the pitch.
///
/// A reshape rearranges the men out there. It never brings anybody on —
/// putting a fresh player on is a substitution, and has to cost one.
///
/// This existed inline in the in-match editor and topped the pool up from the
/// bench whenever fewer than eleven were on the pitch. That is precisely the
/// state after a sending-off, so changing shape with ten men quietly restored
/// the eleventh from the bench, spent no substitution, and undid the red card.
/// Passing a short pool to [bestEleven] leaves the spare slots empty, which is
/// what playing a man down looks like.
List<Player> reshapePool(List<Player> eligible, Set<int> onPitch) => [
  for (final p in eligible)
    if (onPitch.contains(p.id)) p,
];
