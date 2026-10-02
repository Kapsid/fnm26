import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';

/// Picks the strongest starting XI for [formation] from a [pool] of players.
///
/// Each slot (in order) takes the unused player who scores best for it: his
/// overall, less a penalty for playing out of position. A natural fits free;
/// another position in the same line (a centre-back at right-back) costs
/// [sameLinePenalty]; another line costs [otherLinePenalty]; a keeper outfield
/// or an outfielder in goal costs [keeperPenalty], so it only happens when no
/// one else is left. Returns slot→playerId (length 11), with `null` only if
/// the pool is exhausted.
///
/// It used to take ANY natural before anyone else, whatever his rating, so a
/// side whose one right-back was a 32-rated boy started him over an 80-rated
/// centre-back on the bench, and strong nations lost points of strength in
/// about a third of their background matches.
List<int?> bestEleven(Formation formation, List<Player> pool) {
  final available = [...pool]..sort((a, b) => b.overall.compareTo(a.overall));
  final used = <int>{};
  final slots = List<int?>.filled(11, null);

  for (var i = 0; i < 11; i++) {
    final wanted = formation.positions[i];
    Player? pick;
    var best = double.negativeInfinity;
    for (final p in available) {
      if (used.contains(p.id)) continue;
      final score = p.overall - _misfit(wanted, p.position);
      // Sorted by overall, so a tie keeps the stronger man.
      if (score > best) {
        best = score;
        pick = p;
      }
    }
    if (pick != null) {
      slots[i] = pick.id;
      used.add(pick.id);
    }
  }
  return slots;
}

/// What playing a man away from his position costs, in rating points.
const double sameLinePenalty = 4;
const double otherLinePenalty = 15;
const double keeperPenalty = 60;

double _misfit(PlayerPosition slot, PlayerPosition own) {
  if (slot == own) return 0;
  final keeperInvolved = slot == PlayerPosition.gk || own == PlayerPosition.gk;
  if (keeperInvolved) return keeperPenalty;
  return slot.category == own.category ? sameLinePenalty : otherLinePenalty;
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
