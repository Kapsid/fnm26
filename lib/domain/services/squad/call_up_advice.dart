import 'package:fnm/core/rng/seeded_rng.dart';
import 'package:fnm/domain/entities/enums.dart';
import 'package:fnm/domain/entities/formation.dart';
import 'package:fnm/domain/entities/player.dart';
import 'package:fnm/domain/entities/player_absence.dart';
import 'package:fnm/domain/services/manager/staff.dart';
import 'package:fnm/domain/services/squad/condition.dart';
import 'package:fnm/domain/services/squad/squad_selection.dart';
import 'package:fnm/domain/services/tactics/position_fit.dart';

/// Why the assistant names a man, or leaves one out. The words live in the
/// copy (`call_up_advice_sheet.dart`); this is the fact.
enum CallUpReason {
  /// Among the best he reads in the pool.
  topPick,

  /// Named so his line has its cover, ahead of a better man elsewhere.
  lineCover,

  /// Playing well lately (only an elite assistant reads form).
  inForm,

  /// Rested, in the "fresher legs" squad.
  fresh,

  /// A youngster, in the "blood the youngsters" squad.
  young,

  /// An old head, in the "experience" squad.
  experienced,

  /// Left out: hurt.
  injured,

  /// Left out: suspended.
  banned,

  /// Left out: running on empty (a good or elite assistant reads fatigue).
  tired,

  /// Left out: out of form (only an elite assistant reads form).
  outOfForm,

  /// Left out: others are ahead of him.
  othersAhead,
}

/// Which squad a [CallUpProposal] is. [main] is his pick; the rest are the
/// alternatives, each leaning on a real difference in the pool.
enum CallUpVariant { main, inForm, fresherLegs, youth, experience }

/// One proposed squad, with the reason each man is in it.
class CallUpProposal {
  const CallUpProposal({
    required this.variant,
    required this.squad,
    required this.reasons,
  });

  final CallUpVariant variant;

  /// The ids he would name.
  final Set<int> squad;

  /// Why each man in [squad] is there.
  final Map<int, CallUpReason> reasons;

  bool sameSquad(Set<int> other) =>
      other.length == squad.length && other.containsAll(squad);
}

/// His proposal: his pick and one or two alternatives.
typedef CallUpAdviceSet = ({
  CallUpProposal main,
  List<CallUpProposal> alternatives,
});

/// The assistant manager's advice on the call-up: which players to name.
///
/// How good the advice is depends on how good the man is, and the difference
/// is in what he READS:
///
///  * [StaffTier.basic] reads ratings and positions only, with a rough eye (a
///    few points either way per player). On a bad day (about one in three)
///    the eye is far rougher and he goes on reputation, old names over
///    young ones, and the squad can be clearly off.
///  * [StaffTier.good] reads ratings and positions with a small margin of
///    error, plus each man's fatigue by its broad band.
///  * [StaffTier.elite] reads exactly what the match engine will use: each
///    man's condition (form, fatigue, morale, club sharpness). He also reads
///    the window's opponents, which decides the alternative he leads with.
///
/// Every rough eye is drawn from [SeededRng] keyed on the seed the caller
/// passes (the save seed and the in-game date), so asking twice on one day
/// gives one answer.
///
/// The rules the call-up screen works by hold for every proposal: never more
/// than `max`, every line covered as [SquadSelection.bestQuality] covers it
/// (three keepers, the shape's count plus one in each outfield line), and
/// never a man who misses the whole period. He goes further than the screen
/// does and leaves out anyone injured or banned right now; only when a line
/// would be short of its cover, or the squad short of `min`, does he name a
/// man who is back during the period, the shortest absence first.
abstract final class CallUpAdvice {
  /// The share of days a basic assistant reads the pool badly.
  static const double badDayRate = 0.35;

  /// His proposal, or null with nobody in the job.
  ///
  /// [condition] is each player's live condition (only a good or elite
  /// assistant reads it); [opponentsStronger] is whether the window's
  /// opponents are ranked above the side on the whole (null when unknown),
  /// read only by an elite assistant.
  static CallUpAdviceSet? propose({
    required StaffTier tier,
    required List<Player> pool,
    required Map<int, PlayerAbsence> absences,
    required int coverage,
    required Formation formation,
    required int seed,
    required int min,
    required int max,
    Map<int, PlayerCondition> condition = const {},
    bool? opponentsStronger,
  }) {
    if (tier == StaffTier.none) return null;
    final candidates = [
      for (final p in pool)
        if (absences[p.id]?.isAvailable ?? true) p,
    ];
    final returning = CallUpAdvice.returning(
      pool: pool,
      absences: absences,
      coverage: coverage,
    );
    final eye = _Eye(tier, seed, condition);
    final fielded = <PositionCategory, int>{};
    for (final pos in formation.positions) {
      fielded[pos.category] = (fielded[pos.category] ?? 0) + 1;
    }

    CallUpProposal build(CallUpVariant variant) {
      double value(Player p) => eye.value(p) + eye.lean(variant, p);
      final ranked = [...candidates]
        ..sort((a, b) {
          final byValue = value(b).compareTo(value(a));
          return byValue != 0 ? byValue : a.id.compareTo(b.id);
        });
      bool isGk(Player p) => p.position.category == PositionCategory.goalkeeper;
      final picked = <int>{
        ...ranked.where(isGk).take(SquadSelection.keepers).map((p) => p.id),
      };
      int floorOf(PositionCategory line) => line == PositionCategory.goalkeeper
          ? SquadSelection.keepers
          : (fielded[line] ?? 0) + 1;
      final floorPicks = <int>{};
      for (final line in PositionCategory.values) {
        if (line == PositionCategory.goalkeeper) continue;
        final floor = floorOf(line);
        var named = 0;
        for (final p in ranked) {
          if (named >= floor || picked.length >= max) break;
          if (p.position.category != line || picked.contains(p.id)) continue;
          picked.add(p.id);
          floorPicks.add(p.id);
          named++;
        }
      }
      // A line short of its cover takes the men back during the period,
      // shortest absence first. They are there to cover.
      final byId = {for (final p in pool) p.id: p};
      for (final line in PositionCategory.values) {
        var named = picked
            .where((id) => byId[id]?.position.category == line)
            .length;
        for (final p in returning) {
          if (named >= floorOf(line) || picked.length >= max) break;
          if (p.position.category != line || picked.contains(p.id)) continue;
          picked.add(p.id);
          floorPicks.add(p.id);
          named++;
        }
      }
      // The floors are a floor, not the squad: the rest go to the best
      // outfielders still unnamed, wherever they play.
      for (final p in ranked) {
        if (picked.length >= max) break;
        if (isGk(p) || picked.contains(p.id)) continue;
        picked.add(p.id);
      }
      // And so does a squad short of the minimum.
      for (final p in returning) {
        if (picked.length >= min || picked.length >= max) break;
        if (isGk(p) || picked.contains(p.id)) continue;
        picked.add(p.id);
        floorPicks.add(p.id);
      }
      // A floor pick who would not have made it on his own reading is there
      // for his line, and says so.
      final outfieldPlaces = max - SquadSelection.keepers;
      final onMerit = {
        ...ranked.where((p) => !isGk(p)).take(outfieldPlaces).map((p) => p.id),
      };
      final reasons = <int, CallUpReason>{
        for (final p in ranked)
          if (picked.contains(p.id))
            p.id: eye.reasonFor(
              variant,
              p,
              cover: floorPicks.contains(p.id) && !onMerit.contains(p.id),
            ),
        // A man back during the period is there for cover, whatever else.
        for (final p in returning)
          if (picked.contains(p.id)) p.id: CallUpReason.lineCover,
      };
      return CallUpProposal(variant: variant, squad: picked, reasons: reasons);
    }

    final main = build(CallUpVariant.main);

    /// His pick with up to [maxSwaps] men swapped for the kind the variant
    /// is about, each within his own line (so every floor still holds), and
    /// never for a man more than [maxDrop] points below the one he replaces
    /// by this assistant's own reading.
    ///
    /// A lean on the ratings alone rarely moves a youngster into a squad:
    /// a 17-year-old is ten or fifteen points behind the man he would
    /// replace. "Blood the youngsters" is the decision to take that drop, so
    /// it is made as one.
    CallUpProposal swapped(
      CallUpVariant variant, {
      required bool Function(Player) wants,
      required bool Function(Player) sheds,
      required CallUpReason reason,
    }) {
      const maxSwaps = 3;
      const maxDrop = 15.0;
      final squad = {...main.squad};
      final reasons = {...main.reasons};
      final incoming =
          [
            for (final p in candidates)
              if (!squad.contains(p.id) && wants(p)) p,
          ]..sort((a, b) {
            final byValue = eye.value(b).compareTo(eye.value(a));
            return byValue != 0 ? byValue : a.id.compareTo(b.id);
          });
      final byId = {for (final p in pool) p.id: p};
      var swaps = 0;
      for (final inc in incoming) {
        if (swaps >= maxSwaps) break;
        Player? out;
        for (final id in squad) {
          final p = byId[id];
          if (p == null ||
              p.position.category != inc.position.category ||
              !sheds(p) ||
              reasons[id] == reason) {
            continue;
          }
          if (out == null ||
              eye.value(p) < eye.value(out) ||
              (eye.value(p) == eye.value(out) && p.id < out.id)) {
            out = p;
          }
        }
        if (out == null || eye.value(inc) < eye.value(out) - maxDrop) continue;
        squad
          ..remove(out.id)
          ..add(inc.id);
        reasons
          ..remove(out.id)
          ..[inc.id] = reason;
        swaps++;
      }
      return CallUpProposal(variant: variant, squad: squad, reasons: reasons);
    }

    CallUpProposal variantOf(CallUpVariant variant) => switch (variant) {
      CallUpVariant.youth => swapped(
        variant,
        wants: (p) => p.age <= 21,
        sheds: (p) => p.age >= 27,
        reason: CallUpReason.young,
      ),
      CallUpVariant.experience => swapped(
        variant,
        wants: (p) => p.age >= 30,
        sheds: (p) => p.age <= 23,
        reason: CallUpReason.experienced,
      ),
      _ => build(variant),
    };
    final (order, most) = switch (tier) {
      StaffTier.none || StaffTier.basic => (
        const [CallUpVariant.youth, CallUpVariant.experience],
        1,
      ),
      StaffTier.good => (
        const [
          CallUpVariant.fresherLegs,
          CallUpVariant.youth,
          CallUpVariant.experience,
        ],
        2,
      ),
      // The opponents decide which way he leans first, when he knows them.
      StaffTier.elite => (
        switch (opponentsStronger) {
          true => const [
            CallUpVariant.experience,
            CallUpVariant.inForm,
            CallUpVariant.fresherLegs,
            CallUpVariant.youth,
          ],
          false => const [
            CallUpVariant.youth,
            CallUpVariant.inForm,
            CallUpVariant.fresherLegs,
            CallUpVariant.experience,
          ],
          null => const [
            CallUpVariant.inForm,
            CallUpVariant.fresherLegs,
            CallUpVariant.youth,
            CallUpVariant.experience,
          ],
        },
        2,
      ),
    };
    final alternatives = <CallUpProposal>[];
    for (final variant in order) {
      if (alternatives.length >= most) break;
      final alt = variantOf(variant);
      // Only a REAL alternative: a card naming the same squad is noise.
      if (alt.sameSquad(main.squad)) continue;
      if (alternatives.any((a) => a.sameSquad(alt.squad))) continue;
      alternatives.add(alt);
    }
    return (main: main, alternatives: alternatives);
  }

  /// The men injured or banned now who are back during the period of
  /// [coverage] matches, shortest absence first.
  static List<Player> returning({
    required List<Player> pool,
    required Map<int, PlayerAbsence> absences,
    required int coverage,
  }) =>
      [
        for (final p in pool)
          if (!(absences[p.id]?.isAvailable ?? true) &&
              SquadSelection.usableInPeriod(absences[p.id], coverage))
            p,
      ]..sort((a, b) {
        final byMissed = SquadSelection.matchesMissed(
          absences[a.id],
        ).compareTo(SquadSelection.matchesMissed(absences[b.id]));
        if (byMissed != 0) return byMissed;
        final byOverall = b.overall.compareTo(a.overall);
        return byOverall != 0 ? byOverall : a.id.compareTo(b.id);
      });

  /// Why he would leave [p] out, as far as he can see it.
  static CallUpReason leftOutReason(
    Player p, {
    required StaffTier tier,
    required Map<int, PlayerAbsence> absences,
    Map<int, PlayerCondition> condition = const {},
  }) {
    final a = absences[p.id];
    if (a != null && a.injuryMatches > 0) return CallUpReason.injured;
    if (a != null && a.banMatches > 0) return CallUpReason.banned;
    final c = condition[p.id];
    if (tier.index >= StaffTier.good.index &&
        (c?.fatigueState == FatigueState.tired ||
            c?.fatigueState == FatigueState.exhausted)) {
      return CallUpReason.tired;
    }
    if (tier == StaffTier.elite &&
        (c?.form == PlayerForm.poor || c?.form == PlayerForm.cold)) {
      return CallUpReason.outOfForm;
    }
    return CallUpReason.othersAhead;
  }

  /// The window's opponents against the side on the world ranking (lower is
  /// stronger): true when they are ranked above it on the whole, false below,
  /// null with nothing to read (no opponents, or dead level).
  static bool? opponentsStronger({
    required int ownRanking,
    required Iterable<int> opponentRankings,
  }) {
    final list = opponentRankings.toList();
    if (list.isEmpty) return null;
    final mean = list.reduce((a, b) => a + b) / list.length;
    if (mean == ownRanking) return null;
    return mean < ownRanking;
  }

  /// How strong a squad is as the match engine will see it: the best eleven
  /// it can field for [formation], each man's overall shifted by his
  /// condition and scaled by how well he fits the place
  /// (`MatchEngine._mean`, before the in-match energy and traits).
  static double squadStrength(
    Iterable<int> squad,
    Formation formation,
    Map<int, Player> byId,
    Map<int, int> conditionDelta,
  ) {
    final players = [
      for (final id in squad) ?byId[id],
    ]..sort((a, b) => a.id.compareTo(b.id));
    final places = formation.positions;
    double value(Player p, PlayerPosition place) =>
        (p.overall + (conditionDelta[p.id] ?? 0)).clamp(1, 99) *
        PositionFit.factor(p.position, place);
    final xi = _assign(places, players, value);
    var total = 0.0;
    for (var i = 0; i < xi.length; i++) {
      if (xi[i] case final idx?) total += value(players[idx], places[i]);
    }
    return total;
  }
}

/// A deterministic error of up to [amp] either way, per (seed, player).
double _noise(int seed, int id, double amp) {
  if (amp == 0) return 0;
  final rng = SeededRng((seed * 0x9E3779B1) ^ (id * 0x85EBCA77));
  return (rng.nextDouble() * 2 - 1) * amp;
}

/// What one assistant sees of a player.
class _Eye {
  _Eye(this.tier, this.seed, this.condition)
    : _badDay =
          tier == StaffTier.basic &&
          SeededRng(seed ^ 0x51ED27).nextDouble() < CallUpAdvice.badDayRate;

  final StaffTier tier;
  final int seed;
  final Map<int, PlayerCondition> condition;

  /// A basic assistant's bad day: he goes on reputation and gets it wrong.
  final bool _badDay;

  double get _noiseAmp => switch (tier) {
    StaffTier.basic => _badDay ? 12.0 : 4.0,
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

  double value(Player p) =>
      p.overall + _shift(p) + _noise(seed, p.id, _noiseAmp) + _reputation(p);

  /// A basic assistant's bad day: he goes on reputation, so the old names
  /// read bigger than they are and the boys smaller.
  double _reputation(Player p) {
    if (!_badDay) return 0;
    if (p.age >= 29) return 5;
    if (p.age <= 22) return -6;
    return 0;
  }

  /// What an alternative leans towards, on top of [value].
  double lean(CallUpVariant variant, Player p) {
    final c = condition[p.id];
    return switch (variant) {
      CallUpVariant.main => 0,
      // Strong enough to move names, not just to reorder them: an
      // alternative that names the same squad is never shown.
      CallUpVariant.inForm => switch (c?.form) {
        PlayerForm.onFire => 7,
        PlayerForm.good => 4,
        PlayerForm.poor => -4,
        PlayerForm.cold => -7,
        _ => 0,
      },
      CallUpVariant.fresherLegs => switch (c?.fatigueState) {
        FatigueState.ready => -2,
        FatigueState.tired => -7,
        FatigueState.exhausted => -12,
        _ => 0,
      },
      // The age squads swap names rather than lean (see `swapped`).
      CallUpVariant.youth || CallUpVariant.experience => 0,
    };
  }

  CallUpReason reasonFor(
    CallUpVariant variant,
    Player p, {
    required bool cover,
  }) {
    final c = condition[p.id];
    if (variant == CallUpVariant.fresherLegs &&
        c?.fatigueState == FatigueState.fresh) {
      return CallUpReason.fresh;
    }
    if (cover) return CallUpReason.lineCover;
    if (tier == StaffTier.elite &&
        (c?.form == PlayerForm.onFire || c?.form == PlayerForm.good)) {
      return CallUpReason.inForm;
    }
    return CallUpReason.topPick;
  }
}

/// The eleven that scores best by [value] for [places] from [squad], as squad
/// indexes per slot.
///
/// Greedy over every (place, player) pair, strongest first, then improved by
/// swapping any two places or any place with an unused man until nothing
/// gains.
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
  final at = List<int?>.filled(n, null);
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
  return at;
}
