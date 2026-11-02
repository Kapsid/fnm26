import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';

/// Why the assistant put a man where he did, or why he wants him off. The
/// words live in the copy (`assistant_advice_sheet.dart`); this is the fact.
enum AdviceReason {
  /// The strongest man for the place, in his own position.
  bestFit,

  /// Playing well lately (only an elite assistant reads form).
  inForm,

  /// Rested, in the "fresher legs" proposal.
  fresh,

  /// Picked for a place that is not his own.
  covering,

  /// The first defender off the bench.
  coverDefence,

  /// The first midfielder off the bench.
  coverMidfield,

  /// The first attacker off the bench.
  coverAttack,

  /// In-match: running out of legs.
  tired,

  /// In-match: on a yellow card, one tackle from a red.
  booked,

  /// In-match: hurt.
  injured,

  /// In-match: playing a place that is not his, with a better fit on the bench.
  outOfPosition,

  /// In-match: behind late on, fresh attacking legs.
  chasing,
}

/// Which proposal a [LineupAdvice] is. [main] is his pick; the rest are the
/// alternatives, each built from a real difference in the squad.
enum AdviceVariant { main, fresherLegs, inForm, attacking, solid }

/// One proposed eleven for the current shape, with a reason per slot and up
/// to three men he would have first off the bench.
class LineupAdvice {
  const LineupAdvice({
    required this.variant,
    required this.lineup,
    required this.reasons,
    required this.bench,
  });

  final AdviceVariant variant;

  /// Slot → player id, the same shape as `Tactic.lineup`.
  final List<int?> lineup;

  /// Slot → why he is there (null for an empty slot).
  final List<AdviceReason?> reasons;

  /// The men he would bring on first, with the line each one covers.
  final List<({int playerId, AdviceReason reason})> bench;

  /// How many men in this eleven are not in [current] (positional swaps of
  /// men already in it do not count: nobody new is coming in).
  int newMenAgainst(List<int?> current) {
    final now = current.whereType<int>().toSet();
    return lineup.whereType<int>().where((id) => !now.contains(id)).length;
  }

  bool sameEleven(List<int?> other) {
    if (other.length != lineup.length) return false;
    for (var i = 0; i < lineup.length; i++) {
      if (lineup[i] != other[i]) return false;
    }
    return true;
  }
}

/// His proposal before a match: his pick and one or two alternatives.
typedef PreMatchAdvice = ({LineupAdvice main, List<LineupAdvice> alternatives});

/// One change he would make during a match.
typedef SubAdvice = ({int offId, int onId, AdviceReason reason});

/// The assistant manager's advice: who should start in each place, and during
/// a match, who should come off for whom.
///
/// How good the advice is depends on how good the man is, and the difference
/// is in what he READS, not in a dice roll on the answer:
///
///  * [StaffTier.basic] reads ratings and positions and nothing else. His eye
///    is rough (a few points either way per player) and some days he treats a
///    same-line player as a natural fit. He never reads fitness or form.
///  * [StaffTier.good] reads ratings, positions and fatigue, with a small
///    margin of error.
///  * [StaffTier.elite] reads exactly what the match engine will use: each
///    man's condition (form, fatigue, morale, club sharpness) and the fit
///    penalty, plus the opponent when the briefing is open, which decides the
///    alternative he leads with. In a match he also minds bookings and the
///    scoreline.
///
/// Every "rough eye" is drawn from [SeededRng] keyed on the seed the caller
/// passes (save seed and date before a match, the fixture and minute during
/// one), so asking twice gives the same answer.
///
/// Nothing here picks a player the caller did not offer: the pool is the
/// called-up squad who can play, and anybody in the `unavailableIds` given to
/// [lineup] is dropped again on the way in.
abstract final class AssistantAdvice {
  /// The most changes he proposes in one go during a match.
  static const int maxSubs = 3;

  /// The side's strength as the match engine rates it before kick-off: each
  /// man's overall shifted by his condition, times how well he fits the place
  /// he plays (`MatchEngine._mean`, without the in-match energy and traits).
  static double strength(
    List<int?> lineup,
    List<PlayerPosition> places,
    Map<int, Player> byId,
    Map<int, int> conditionDelta,
  ) {
    var total = 0.0;
    for (var i = 0; i < lineup.length && i < places.length; i++) {
      final p = byId[lineup[i]];
      if (p == null) continue;
      total +=
          (p.overall + (conditionDelta[p.id] ?? 0)).clamp(1, 99) *
          PositionFit.factor(p.position, places[i]);
    }
    return total;
  }

  /// His proposal for [places] (the formation's slots with any switches
  /// applied) from [pool], or null with nobody in the job.
  ///
  /// [condition] is each player's live condition; [opponentStronger] is
  /// whether the next opponent is ranked above the side (null when it is not
  /// known yet), and only an elite assistant uses either fully.
  static PreMatchAdvice? lineup({
    required StaffTier tier,
    required List<PlayerPosition> places,
    required List<Player> pool,
    required int seed,
    Map<int, PlayerCondition> condition = const {},
    Set<int> unavailableIds = const {},
    bool? opponentStronger,
  }) {
    if (tier == StaffTier.none) return null;
    final squad = [
      for (final p in pool)
        if (!unavailableIds.contains(p.id)) p,
    ]..sort((a, b) => a.id.compareTo(b.id));
    final eye = _Eye(tier, seed, condition);

    LineupAdvice build(AdviceVariant variant) {
      double value(Player p, PlayerPosition place) =>
          eye.value(p, place) + eye.lean(variant, p, place);
      final xi = _assign(places, squad, value);
      final used = xi.whereType<int>().toSet();
      final byId = {for (final p in squad) p.id: p};
      final reasons = List<AdviceReason?>.generate(
        xi.length,
        (i) => switch (byId[xi[i]]) {
          final p? => eye.reasonFor(variant, p, places[i]),
          null => null,
        },
      );
      final bench = <({int playerId, AdviceReason reason})>[];
      for (final (category, reason) in const [
        (PositionCategory.forward, AdviceReason.coverAttack),
        (PositionCategory.midfielder, AdviceReason.coverMidfield),
        (PositionCategory.defender, AdviceReason.coverDefence),
      ]) {
        final place = places.where((p) => p.category == category).firstOrNull;
        if (place == null) continue;
        Player? best;
        var bestValue = double.negativeInfinity;
        for (final p in squad) {
          if (used.contains(p.id) || p.position == PlayerPosition.gk) continue;
          final v = value(p, place);
          if (v > bestValue) {
            bestValue = v;
            best = p;
          }
        }
        if (best == null) continue;
        used.add(best.id);
        bench.add((playerId: best.id, reason: reason));
      }
      return LineupAdvice(
        variant: variant,
        lineup: xi,
        reasons: reasons,
        bench: bench,
      );
    }

    final main = build(AdviceVariant.main);
    final alternatives = <LineupAdvice>[];
    final (candidates, most) = switch (tier) {
      StaffTier.none || StaffTier.basic => (
        const [AdviceVariant.attacking, AdviceVariant.solid],
        1,
      ),
      StaffTier.good => (
        const [
          AdviceVariant.fresherLegs,
          AdviceVariant.attacking,
          AdviceVariant.solid,
        ],
        2,
      ),
      // The opponent decides which way he leans first, when it is known.
      StaffTier.elite => (
        switch (opponentStronger) {
          true => const [
            AdviceVariant.solid,
            AdviceVariant.fresherLegs,
            AdviceVariant.inForm,
            AdviceVariant.attacking,
          ],
          false => const [
            AdviceVariant.attacking,
            AdviceVariant.fresherLegs,
            AdviceVariant.inForm,
            AdviceVariant.solid,
          ],
          null => const [
            AdviceVariant.fresherLegs,
            AdviceVariant.inForm,
            AdviceVariant.attacking,
            AdviceVariant.solid,
          ],
        },
        2,
      ),
    };
    for (final variant in candidates) {
      if (alternatives.length >= most) break;
      final alt = build(variant);
      // Only a REAL alternative: a card that names the same eleven is noise.
      if (alt.sameEleven(main.lineup)) continue;
      if (alternatives.any((a) => a.sameEleven(alt.lineup))) continue;
      alternatives.add(alt);
    }
    return (main: main, alternatives: alternatives);
  }

  /// The changes he would make right now, best first: never more than
  /// [maxSubs], and never more than [subsLeft].
  ///
  /// [lineup] is slot → id as it stands (an empty slot is a hole a red card
  /// left, which nobody fills); [bench] is everyone who may still come on.
  /// [energy] is 0–100 per player, [booked] the men on a yellow, [scoreDiff]
  /// the side's goals minus the opponent's.
  static List<SubAdvice> substitutions({
    required StaffTier tier,
    required List<int?> lineup,
    required List<PlayerPosition> places,
    required Map<int, Player> byId,
    required List<Player> bench,
    required int subsLeft,
    required int minute,
    required int seed,
    Map<int, int> energy = const {},
    Set<int> booked = const {},
    Set<int> injured = const {},
    int scoreDiff = 0,
    Map<int, int> conditionDelta = const {},
  }) {
    final limit = subsLeft < maxSubs ? subsLeft : maxSubs;
    if (tier == StaffTier.none || limit <= 0 || bench.isEmpty) return const [];
    final rng = SeededRng(seed ^ (tier.index * 0x2545F491));
    // A basic assistant's bad day: he matches a body to a hole and forgets
    // the shirt says something else. One in three.
    final ignoresFit = tier == StaffTier.basic && rng.nextDouble() < 0.35;
    final noiseAmp = switch (tier) {
      StaffTier.basic => 4.0,
      StaffTier.good => 1.5,
      _ => 0.0,
    };

    double rating(Player p) {
      final base = tier == StaffTier.elite
          ? p.overall + (conditionDelta[p.id] ?? 0)
          : p.overall.toDouble();
      return (base + _noise(seed, p.id, noiseAmp)).clamp(1, 99).toDouble();
    }

    double fit(Player p, PlayerPosition place) {
      if (ignoresFit &&
          p.position != PlayerPosition.gk &&
          place != PlayerPosition.gk) {
        return 1;
      }
      return PositionFit.factor(p.position, place);
    }

    double legs(int id) {
      final e = (energy[id] ?? 100).toDouble();
      // He sees a man blowing hard and nothing finer than that.
      if (tier == StaffTier.basic) return e < 55 ? 0.85 : 1.0;
      return energyFactor(e);
    }

    final late = minute >= 60;
    final candidates =
        <({int slot, int offId, int onId, double gain, AdviceReason reason})>[];
    for (var slot = 0; slot < lineup.length && slot < places.length; slot++) {
      final off = byId[lineup[slot]];
      if (off == null) continue;
      final place = places[slot];
      final r = rating(off);
      final current = r * fit(off, place) * legs(off.id);
      final energyLoss = r * fit(off, place) * (1 - legs(off.id));
      final fitLoss = tier == StaffTier.basic
          ? 0.0
          : r * (1 - PositionFit.factor(off.position, place));
      final hurt = injured.contains(off.id);
      // A second yellow is a red: an elite assistant takes the risk off once
      // the game is old enough for it to matter.
      final bookedRisk =
          tier == StaffTier.elite && booked.contains(off.id) && minute >= 45
          ? 2.5
          : 0.0;
      for (final on in bench) {
        final next = rating(on) * fit(on, place) * legs(on.id);
        var gain = next - current;
        final chase =
            tier == StaffTier.elite &&
                scoreDiff < 0 &&
                late &&
                place.category != PositionCategory.goalkeeper &&
                place.category != PositionCategory.defender &&
                _attacking(on.position)
            ? 3.0
            : 0.0;
        gain += bookedRisk + chase + (hurt ? 50 : 0);
        // Not worth a change for a point or two.
        if (gain < 2) continue;
        final AdviceReason reason;
        if (hurt) {
          reason = AdviceReason.injured;
        } else {
          final parts = {
            AdviceReason.tired: energyLoss,
            AdviceReason.outOfPosition:
                PositionFit.factor(on.position, place) >
                    PositionFit.factor(off.position, place)
                ? fitLoss
                : 0.0,
            AdviceReason.booked: bookedRisk,
            AdviceReason.chasing: chase,
          };
          reason = parts.entries
              .reduce((a, b) => b.value > a.value ? b : a)
              .key;
        }
        candidates.add((
          slot: slot,
          offId: off.id,
          onId: on.id,
          gain: gain,
          reason: reason,
        ));
      }
    }
    candidates.sort((a, b) {
      final byGain = b.gain.compareTo(a.gain);
      if (byGain != 0) return byGain;
      final bySlot = a.slot.compareTo(b.slot);
      return bySlot != 0 ? bySlot : a.onId.compareTo(b.onId);
    });
    final out = <SubAdvice>[];
    final usedOff = <int>{};
    final usedOn = <int>{};
    for (final c in candidates) {
      if (out.length >= limit) break;
      if (usedOff.contains(c.offId) || usedOn.contains(c.onId)) continue;
      usedOff.add(c.offId);
      usedOn.add(c.onId);
      out.add((offId: c.offId, onId: c.onId, reason: c.reason));
    }
    return out;
  }

  /// How energy scales a player's effective rating: the match engine's own
  /// kinked curve (`MatchEngine._energyFactor`), restated so the advice
  /// weighs tiredness exactly as the match will.
  static double energyFactor(double energy) {
    final e = (energy / 100).clamp(0.0, 1.0);
    if (e >= 0.72) return 1.0 - (1.0 - e) * 0.18;
    return 0.95 - (0.72 - e) * 0.62;
  }
}

bool _attacking(PlayerPosition p) =>
    p == PlayerPosition.am ||
    p == PlayerPosition.lw ||
    p == PlayerPosition.rw ||
    p == PlayerPosition.st;

bool _defensive(PlayerPosition p) =>
    p == PlayerPosition.cb ||
    p == PlayerPosition.dm ||
    p == PlayerPosition.lb ||
    p == PlayerPosition.rb;

/// A deterministic error of up to [amp] either way, per (seed, player).
double _noise(int seed, int id, double amp) {
  if (amp == 0) return 0;
  final rng = SeededRng((seed * 0x9E3779B1) ^ (id * 0x85EBCA77));
  return (rng.nextDouble() * 2 - 1) * amp;
}

/// What one assistant sees of a player, before a match.
class _Eye {
  _Eye(this.tier, this.seed, this.condition)
    : _misjudgesFit =
          tier == StaffTier.basic &&
          SeededRng(seed ^ 0x51ED27).nextDouble() < 0.35;

  final StaffTier tier;
  final int seed;
  final Map<int, PlayerCondition> condition;

  /// A basic assistant's bad day: a same-line player reads to him as a
  /// natural (a centre-back is a full-back is a centre-back).
  final bool _misjudgesFit;

  double get _noiseAmp => switch (tier) {
    StaffTier.basic => 4.0,
    StaffTier.good => 1.5,
    _ => 0.0,
  };

  /// The rating shift he reads into a man's condition.
  double _shift(Player p) {
    final c = condition[p.id];
    if (c == null) return 0;
    return switch (tier) {
      StaffTier.elite => c.overallDelta.toDouble(),
      // Fatigue only, and only by its broad band.
      StaffTier.good => switch (c.fatigueState) {
        FatigueState.fresh => 0,
        FatigueState.ready => -1,
        FatigueState.tired => -3,
        FatigueState.exhausted => -6,
      },
      _ => 0,
    };
  }

  double value(Player p, PlayerPosition place) {
    final rating = (p.overall + _shift(p) + _noise(seed, p.id, _noiseAmp))
        .clamp(1, 99)
        .toDouble();
    final sameLine =
        p.position.category == place.category &&
        place != PlayerPosition.gk &&
        p.position != PlayerPosition.gk;
    final f = _misjudgesFit && sameLine
        ? 1.0
        : PositionFit.factor(p.position, place);
    return rating * f;
  }

  /// What an alternative leans towards, on top of [value].
  double lean(AdviceVariant variant, Player p, PlayerPosition place) {
    final c = condition[p.id];
    final outfield = place != PlayerPosition.gk;
    return switch (variant) {
      AdviceVariant.main => 0,
      AdviceVariant.fresherLegs => switch (c?.fatigueState) {
        FatigueState.ready => -1,
        FatigueState.tired => -4,
        FatigueState.exhausted => -8,
        _ => 0,
      },
      AdviceVariant.inForm => switch (c?.form) {
        PlayerForm.onFire => 4,
        PlayerForm.good => 2,
        PlayerForm.poor => -2,
        PlayerForm.cold => -4,
        _ => 0,
      },
      AdviceVariant.attacking when !outfield => 0,
      AdviceVariant.attacking =>
        _attacking(p.position)
            ? 3
            : (_defensive(p.position) &&
                      place.category != PositionCategory.defender
                  ? -2
                  : 0),
      AdviceVariant.solid when !outfield => 0,
      AdviceVariant.solid =>
        _defensive(p.position)
            ? 3
            : (_attacking(p.position) &&
                      place.category != PositionCategory.forward
                  ? -2
                  : 0),
    };
  }

  AdviceReason reasonFor(AdviceVariant variant, Player p, PlayerPosition at) {
    final c = condition[p.id];
    if (variant == AdviceVariant.fresherLegs &&
        c?.fatigueState == FatigueState.fresh) {
      return AdviceReason.fresh;
    }
    if (tier == StaffTier.elite &&
        (c?.form == PlayerForm.onFire || c?.form == PlayerForm.good)) {
      return AdviceReason.inForm;
    }
    return p.position == at ? AdviceReason.bestFit : AdviceReason.covering;
  }
}

/// The eleven that scores best by [value] for [places] from [squad].
///
/// Greedy over every (place, player) pair, strongest first, then improved by
/// swapping any two places or any place with an unused man until nothing
/// gains. Slot-by-slot greedy (as `bestEleven` does) lets an early slot take a
/// man a later one needed far more; the swaps undo that.
List<int?> _assign(
  List<PlayerPosition> places,
  List<Player> squad,
  double Function(Player, PlayerPosition) value,
) {
  final n = places.length;
  final scores = [
    for (final p in squad) [for (final place in places) value(p, place)],
  ];
  final pairs =
      <({int player, int slot, double v})>[
        for (var i = 0; i < squad.length; i++)
          for (var s = 0; s < n; s++) (player: i, slot: s, v: scores[i][s]),
      ]..sort((a, b) {
        final byV = b.v.compareTo(a.v);
        if (byV != 0) return byV;
        final byPlayer = a.player.compareTo(b.player);
        return byPlayer != 0 ? byPlayer : a.slot.compareTo(b.slot);
      });
  final at = List<int?>.filled(n, null); // slot → squad index
  final placed = <int>{};
  for (final pair in pairs) {
    if (at[pair.slot] != null || placed.contains(pair.player)) continue;
    at[pair.slot] = pair.player;
    placed.add(pair.player);
  }

  const eps = 1e-9;
  for (var pass = 0; pass < 50; pass++) {
    var improved = false;
    for (var a = 0; a < n; a++) {
      for (var b = a + 1; b < n; b++) {
        final pa = at[a];
        final pb = at[b];
        if (pa == null || pb == null) continue;
        if (scores[pa][b] + scores[pb][a] >
            scores[pa][a] + scores[pb][b] + eps) {
          at[a] = pb;
          at[b] = pa;
          improved = true;
        }
      }
    }
    for (var s = 0; s < n; s++) {
      final cur = at[s];
      if (cur == null) continue;
      for (var q = 0; q < squad.length; q++) {
        if (placed.contains(q)) continue;
        if (scores[q][s] > scores[at[s]!][s] + eps) {
          placed
            ..remove(at[s])
            ..add(q);
          at[s] = q;
          improved = true;
        }
      }
    }
    if (!improved) break;
  }
  return List<int?>.generate(
    n,
    (s) => switch (at[s]) {
      final i? => squad[i].id,
      null => null,
    },
  );
}
