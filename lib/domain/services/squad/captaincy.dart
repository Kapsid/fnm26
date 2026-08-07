import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/player/player_traits.dart';

/// Who wears the armband, and what it is worth.
///
/// The captaincy is a choice with no obviously right answer: the best player
/// is not always the best captain, and the effect is squad-wide rather than
/// individual. A natural leader steadies the group; a quiet 21-year-old star
/// does not, however good they are.
///
/// The effect is deliberately routed through MORALE rather than straight into
/// ratings. Morale is already a bounded, visible number that feeds the engine
/// through `Condition.moraleDelta`, so the armband can matter without adding
/// another hidden multiplier on top of the balance the match engine is tuned
/// to — and the manager can see it move.
abstract final class Captaincy {
  /// The most morale a captain can add.
  static const int maxMoraleBonus = 6;

  /// How much of a leader [p] is, on a 0–10 scale.
  ///
  /// Being a recognised leader is most of it; the rest is seniority and
  /// standing in the side. Someone has to have played a bit and be worth their
  /// place before a dressing room follows them.
  static int leadership(Player p, {int saveSeed = 0}) {
    final traits = PlayerTraits.of(p, saveSeed: saveSeed);
    var score = 0.0;
    if (traits.contains(PlayerTrait.leader)) score += 5;
    if (traits.contains(PlayerTrait.oldHead)) score += 1.5;
    if (traits.contains(PlayerTrait.bigGame)) score += 1;
    // Seniority: rising to 2 by thirty, because a dressing room listens to
    // someone who has been there.
    score += ((p.age - 22) / 8).clamp(0.0, 1.0) * 2;
    // Standing: a captain nobody rates is a captain nobody follows.
    score += ((p.overall - 65) / 20).clamp(0.0, 1.0) * 2;
    return score.round().clamp(0, 10);
  }

  /// The morale a captain adds to the squad, 0–[maxMoraleBonus].
  ///
  /// A poor choice is never a penalty — naming the wrong captain costs you the
  /// lift you could have had, which is punishment enough and keeps the feature
  /// from becoming a trap for a manager who has nobody suitable.
  static int moraleBonus(Player? captain, {int saveSeed = 0}) {
    if (captain == null) return 0;
    final l = leadership(captain, saveSeed: saveSeed);
    return (l * maxMoraleBonus / 10).round().clamp(0, maxMoraleBonus);
  }

  /// A short description of how well a player would wear the armband.
  static CaptainFit fit(Player p, {int saveSeed = 0}) {
    final l = leadership(p, saveSeed: saveSeed);
    if (l >= 8) return CaptainFit.born;
    if (l >= 6) return CaptainFit.natural;
    if (l >= 4) return CaptainFit.capable;
    return CaptainFit.unproven;
  }

  /// The squad's best candidates, strongest first — the shortlist the manager
  /// is offered rather than the whole squad in rating order.
  static List<Player> shortlist(
    Iterable<Player> squad, {
    int saveSeed = 0,
    int limit = 5,
  }) {
    final ranked = [...squad]
      ..sort((a, b) {
        final byLeader = leadership(b, saveSeed: saveSeed).compareTo(
          leadership(a, saveSeed: saveSeed),
        );
        return byLeader != 0 ? byLeader : b.overall.compareTo(a.overall);
      });
    return ranked.take(limit).toList();
  }
}

/// How well a player suits the captaincy.
enum CaptainFit { born, natural, capable, unproven }
