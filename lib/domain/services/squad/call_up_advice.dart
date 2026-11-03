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

  /// Named only to bring the squad up to its minimum.
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

  /// The cover at one of the shape's positions
  /// ([CallUpProposal.positions] names it).
  backup,

  /// Plays two or more of the shape's positions, naturally or nearly
  /// ([CallUpProposal.positions] lists them).
  covers,

  /// Named for a position of the other shape on a "change of tactics" card
  /// ([CallUpProposal.positions] names it, [CallUpProposal.formation] the
  /// shape).
  forChange,
}

/// Which squad a [CallUpProposal] is. [main] is his pick; the rest are the
/// alternatives, each leaning on a real difference in the pool.
enum CallUpVariant {
  main,
  inForm,
  fresherLegs,
  youth,
  experience,

  /// His pick, with a few men in for another shape the manager may turn to.
  tacticsChange,
}

/// A shape the side could line up in: the formation and the position each
/// slot plays (slot switches applied).
typedef CallUpShape = ({Formation formation, List<PlayerPosition> positions});

/// One proposed squad, with the reason each man is in it.
class CallUpProposal {
  const CallUpProposal({
    required this.variant,
    required this.squad,
    required this.reasons,
    this.positions = const {},
    this.formation,
  });

  final CallUpVariant variant;

  /// The ids he would name.
  final Set<int> squad;

  /// Why each man in [squad] is there.
  final Map<int, CallUpReason> reasons;

  /// The positions a reason is about, for the reasons that name some
  /// ([CallUpReason.backup], [CallUpReason.covers],
  /// [CallUpReason.forChange]).
  final Map<int, List<PlayerPosition>> positions;

  /// The shape a [CallUpVariant.tacticsChange] card is for.
  final Formation? formation;

  bool sameSquad(Set<int> other) =>
      other.length == squad.length && other.containsAll(squad);
}

/// His proposal: his pick and one or two alternatives.
typedef CallUpAdviceSet = ({
  CallUpProposal main,
  List<CallUpProposal> alternatives,
});

/// What a man was named for in the main squad: the position he covers, and
/// whether he is the first choice there. Absent for the men named on top of
/// the cover.
typedef _Role = ({PlayerPosition at, bool starter});

/// A built squad and what each man was named for.
typedef _Built = ({CallUpProposal proposal, Map<int, _Role> roles});

/// The assistant manager's advice on the call-up: which players to name.
///
/// He builds the squad around the manager's CURRENT tactic: its formation and
/// every slot switch (`Tactic.positions`). Every position the eleven plays
/// gets a first choice and a natural backup, a position played two or more
/// times gets one man more than it plays, and three keepers travel
/// ([coverNeeds]). A man counts for a position when it is his own; when the
/// pool has too few of those, one who plays it nearly ([playsNearly]), then
/// anyone from the same line (the pitch's "same line" fit), takes the place.
/// Only then does he fill the rest of the squad, and there he values a man
/// who can play several of the shape's positions above one who plays just
/// one ([covers]).
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
/// Whatever his eye, every proposal meets the cover: the eye decides WHO, not
/// whether a position is covered.
///
/// Every rough eye is drawn from [SeededRng] keyed on the seed the caller
/// passes (the save seed and the in-game date), so asking twice on one day
/// gives one answer.
///
/// The rules the call-up screen works by hold for every proposal: never more
/// than `max`, and never a man who misses the whole period. He goes further
/// than the screen does and leaves out anyone injured or banned right now;
/// only when a position would be short of its cover, or the squad short of
/// `min`, does he name a man who is back during the period, the shortest
/// absence first.
abstract final class CallUpAdvice {
  /// The share of days a basic assistant reads the pool badly.
  static const double badDayRate = 0.35;

  /// The most men a "change of tactics" card brings in.
  static const int maxChangeSwaps = 3;

  /// What a place in the squad beyond the cover is worth, in rating points,
  /// for each extra position of the shape a man can play.
  static const double versatilityBonus = 3;

  /// What it costs a man, in rating points, to play none of the shape's
  /// positions naturally or nearly.
  static const double offShapePenalty = 4;

  /// The positions a man plays NEARLY: within his own line, and the next
  /// place along. A full-back plays either flank, a central midfielder sits
  /// deeper or further on, a wide man switches wings.
  static const Map<PlayerPosition, Set<PlayerPosition>> _near = {
    PlayerPosition.gk: {},
    PlayerPosition.lb: {PlayerPosition.rb},
    PlayerPosition.rb: {PlayerPosition.lb},
    PlayerPosition.cb: {},
    PlayerPosition.dm: {PlayerPosition.cm},
    PlayerPosition.cm: {PlayerPosition.dm, PlayerPosition.am},
    PlayerPosition.am: {PlayerPosition.cm},
    PlayerPosition.lm: {PlayerPosition.rm},
    PlayerPosition.rm: {PlayerPosition.lm},
    PlayerPosition.lw: {PlayerPosition.rw},
    PlayerPosition.rw: {PlayerPosition.lw},
    PlayerPosition.st: {},
  };

  /// Whether [p] plays [place] nearly (not his own position, but the next
  /// place along in his line).
  static bool playsNearly(Player p, PlayerPosition place) =>
      _near[p.position]?.contains(place) ?? false;

  /// The shape's positions [p] plays naturally or nearly, each once, his own
  /// first and then in slot order.
  static List<PlayerPosition> covers(
    Player p,
    List<PlayerPosition> positions,
  ) => [
    if (positions.contains(p.position)) p.position,
    for (final place in {...positions})
      if (place != p.position && playsNearly(p, place)) place,
  ];

  /// How many men each position of [positions] needs in the squad, in slot
  /// order: three keepers; two (a first choice and a backup) for a position
  /// played once; one more than it is played for a position played twice or
  /// more.
  static Map<PlayerPosition, int> coverNeeds(List<PlayerPosition> positions) {
    final played = <PlayerPosition, int>{};
    for (final place in positions) {
      played[place] = (played[place] ?? 0) + 1;
    }
    return {
      for (final e in played.entries)
        e.key: e.key == PlayerPosition.gk
            ? SquadSelection.keepers
            : (e.value == 1 ? 2 : e.value + 1),
    };
  }

  /// The shapes a manager playing [current] is likely to turn to, likeliest
  /// first: those he has saved (presets and his tactics library, in the order
  /// given), then the shapes his side is drilled in (most familiar first),
  /// then the natural neighbours of [current]. Never [current] itself, and
  /// each formation once.
  static List<CallUpShape> otherShapes({
    required Formation current,
    List<CallUpShape> saved = const [],
    Map<Formation, double> familiarity = const {},
  }) {
    final seen = <Formation>{current};
    final out = <CallUpShape>[];
    for (final s in saved) {
      if (seen.add(s.formation)) out.add(s);
    }
    final drilled =
        [
          for (final e in familiarity.entries)
            if (e.value > 0 && !seen.contains(e.key)) e,
        ]..sort((a, b) {
          final byValue = b.value.compareTo(a.value);
          return byValue != 0 ? byValue : a.key.index.compareTo(b.key.index);
        });
    for (final e in drilled) {
      seen.add(e.key);
      out.add((formation: e.key, positions: e.key.positions));
    }
    for (final f in _neighbours(current)) {
      if (seen.add(f)) out.add((formation: f, positions: f.positions));
    }
    return out;
  }

  /// The shapes nearest [f]: one change of a line or two away.
  static List<Formation> _neighbours(Formation f) => switch (f) {
    Formation.f433 => const [Formation.f4231, Formation.f4141],
    Formation.f4231 => const [Formation.f433, Formation.f4411],
    Formation.f442 => const [Formation.f4411, Formation.f41212],
    Formation.f4411 => const [Formation.f442, Formation.f4231],
    Formation.f352 => const [Formation.f532, Formation.f3412],
    Formation.f532 => const [Formation.f352, Formation.f541],
    Formation.f4141 => const [Formation.f433, Formation.f451],
    Formation.f343 => const [Formation.f3421, Formation.f352],
    Formation.f4222 => const [Formation.f4231, Formation.f41212],
    Formation.f424 => const [Formation.f442, Formation.f433],
    Formation.f41212 => const [Formation.f4312, Formation.f442],
    Formation.f4312 => const [Formation.f41212, Formation.f433],
    Formation.f451 => const [Formation.f4141, Formation.f4231],
    Formation.f541 => const [Formation.f532, Formation.f451],
    Formation.f3421 => const [Formation.f343, Formation.f3412],
    Formation.f3412 => const [Formation.f352, Formation.f3421],
    Formation.f5212 => const [Formation.f532, Formation.f352],
    Formation.f4321 => const [Formation.f433, Formation.f4231],
    Formation.f3511 => const [Formation.f352, Formation.f3421],
  };

  /// His proposal, or null with nobody in the job.
  ///
  /// [positions] is the place each slot of the current tactic plays (the
  /// formation with its slot switches; [formation]'s own positions when not
  /// given). [otherShapes] are the shapes he may suggest a change to,
  /// likeliest first (see [CallUpAdvice.otherShapes]; the neighbours of
  /// [formation] when not given). [condition] is each player's live
  /// condition (only a good or elite assistant reads it);
  /// [opponentsStronger] is whether the window's opponents are ranked above
  /// the side on the whole (null when unknown), read only by an elite
  /// assistant.
  static CallUpAdviceSet? propose({
    required StaffTier tier,
    required List<Player> pool,
    required Map<int, PlayerAbsence> absences,
    required int coverage,
    required Formation formation,
    required int seed,
    required int min,
    required int max,
    List<PlayerPosition>? positions,
    List<CallUpShape>? otherShapes,
    Map<int, PlayerCondition> condition = const {},
    bool? opponentsStronger,
  }) {
    if (tier == StaffTier.none) return null;
    final places = positions ?? formation.positions;
    final needs = coverNeeds(places);
    final played = <PlayerPosition, int>{};
    for (final place in places) {
      played[place] = (played[place] ?? 0) + 1;
    }
    final byId = {for (final p in pool) p.id: p};
    final candidates = [
      for (final p in pool)
        if (absences[p.id]?.isAvailable ?? true) p,
    ];
    final returning = CallUpAdvice.returning(
      pool: pool,
      absences: absences,
      coverage: coverage,
    );
    final returningIds = {for (final p in returning) p.id};
    final eye = _Eye(tier, seed, condition);
    bool isGk(Player p) => p.position.category == PositionCategory.goalkeeper;

    // How a man fits a place, best first: his own position, nearly, the
    // same line.
    final fits = <bool Function(Player, PlayerPosition)>[
      (p, place) => p.position == place,
      playsNearly,
      (p, place) =>
          PositionFit.fitRank(p, place) == 1 && !playsNearly(p, place),
    ];

    _Built build(CallUpVariant variant) {
      double value(Player p) => eye.value(p) + eye.lean(variant, p);
      final ranked = [...candidates]
        ..sort((a, b) {
          final byValue = value(b).compareTo(value(a));
          return byValue != 0 ? byValue : a.id.compareTo(b.id);
        });
      final picked = <int>{};
      final roles = <int, _Role>{};
      final have = {for (final place in needs.keys) place: 0};

      void name(Player p, PlayerPosition place) {
        picked.add(p.id);
        roles[p.id] = (
          at: place,
          starter: p.position == place && have[place]! < played[place]!,
        );
        have[place] = have[place]! + 1;
      }

      // The cover, from the men fit now and then, for a position still
      // short, from the men back during the period (shortest absence first).
      for (final from in [ranked, returning]) {
        for (final fit in fits) {
          for (final place in needs.keys) {
            for (final p in from) {
              if (have[place]! >= needs[place]! || picked.length >= max) break;
              if (picked.contains(p.id) || !fit(p, place)) continue;
              name(p, place);
            }
          }
        }
      }

      // The cover is a floor, not the squad: the rest go to the best
      // outfielders still unnamed, a man who plays more of the shape worth
      // more than one who plays less of it.
      double fillValue(Player p) {
        final n = covers(p, places).length;
        return value(p) +
            (n == 0 ? -offShapePenalty : versatilityBonus * (n - 1));
      }

      final rest =
          [
            for (final p in ranked)
              if (!isGk(p) && !picked.contains(p.id)) p,
          ]..sort((a, b) {
            final byValue = fillValue(b).compareTo(fillValue(a));
            return byValue != 0 ? byValue : a.id.compareTo(b.id);
          });
      for (final p in rest) {
        if (picked.length >= max) break;
        picked.add(p.id);
      }
      // A squad short of the minimum takes men back during the period.
      final toppedUp = <int>{};
      for (final p in returning) {
        if (picked.length >= min || picked.length >= max) break;
        if (isGk(p) || picked.contains(p.id)) continue;
        picked.add(p.id);
        toppedUp.add(p.id);
      }

      final reasons = <int, CallUpReason>{};
      final named = <int, List<PlayerPosition>>{};
      for (final id in picked) {
        final p = byId[id]!;
        final role = roles[id];
        final plays = covers(p, places);
        if (toppedUp.contains(id)) {
          reasons[id] = CallUpReason.lineCover;
        } else if (role != null && role.starter && !returningIds.contains(id)) {
          reasons[id] = eye.reasonFor(variant, p);
        } else if (role != null) {
          // A backup who plays more than the place he covers says so.
          if (p.position == role.at &&
              plays.length >= 2 &&
              !returningIds.contains(id)) {
            reasons[id] = CallUpReason.covers;
            named[id] = plays;
          } else {
            reasons[id] = CallUpReason.backup;
            named[id] = [role.at];
          }
        } else if (plays.length >= 2) {
          reasons[id] = CallUpReason.covers;
          named[id] = plays;
        } else {
          reasons[id] = eye.reasonFor(variant, p);
        }
      }
      return (
        proposal: CallUpProposal(
          variant: variant,
          squad: picked,
          reasons: reasons,
          positions: named,
        ),
        roles: roles,
      );
    }

    final built = build(CallUpVariant.main);
    final main = built.proposal;

    /// His pick with up to [maxSwaps] men swapped for the kind the variant
    /// is about, and never for a man more than [maxDrop] points below the one
    /// he replaces by this assistant's own reading.
    ///
    /// The cover holds: a man named to cover a position is only ever
    /// replaced by another whose own position it is, and a man named on top
    /// of the cover by another from his line.
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
      final named = {...main.positions};
      final roles = {...built.roles};
      final incoming =
          [
            for (final p in candidates)
              if (!squad.contains(p.id) && wants(p)) p,
          ]..sort((a, b) {
            final byValue = eye.value(b).compareTo(eye.value(a));
            return byValue != 0 ? byValue : a.id.compareTo(b.id);
          });
      var swaps = 0;
      for (final inc in incoming) {
        if (swaps >= maxSwaps) break;
        Player? out;
        for (final id in squad) {
          final p = byId[id];
          if (p == null || !sheds(p) || reasons[id] == reason) continue;
          final fits = roles[id] != null
              ? p.position == inc.position
              : p.position.category == inc.position.category;
          if (!fits) continue;
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
        named.remove(out.id);
        if (roles.remove(out.id) case final role?) roles[inc.id] = role;
        swaps++;
      }
      return CallUpProposal(
        variant: variant,
        squad: squad,
        reasons: reasons,
        positions: named,
      );
    }

    /// His pick with up to [maxChangeSwaps] men in who play the positions of
    /// [shape] the squad is short of, most pressing first (a position with
    /// nobody for it before one short of its backup). Room is made, while the
    /// squad is full, only from the men named on top of the cover: the
    /// current tactic keeps every place it has.
    CallUpProposal changeTo(CallUpShape shape) {
      final altNeeds = coverNeeds(shape.positions)..remove(PlayerPosition.gk);
      final altPlayed = <PlayerPosition, int>{};
      for (final place in shape.positions) {
        altPlayed[place] = (altPlayed[place] ?? 0) + 1;
      }
      final squad = {...main.squad};
      final reasons = {...main.reasons};
      final named = {...main.positions};
      int haveAt(PlayerPosition place) =>
          squad.where((id) => byId[id]?.position == place).length;
      final exhausted = <PlayerPosition>{};
      var swaps = 0;
      while (swaps < maxChangeSwaps) {
        PlayerPosition? target;
        var worst = 0;
        for (final place in altNeeds.keys) {
          if (exhausted.contains(place)) continue;
          final have = haveAt(place);
          if (have >= altNeeds[place]!) continue;
          final severity = have - altPlayed[place]!;
          if (target == null || severity < worst) {
            target = place;
            worst = severity;
          }
        }
        if (target == null) break;
        Player? inc;
        for (final p in candidates) {
          if (p.position != target || squad.contains(p.id)) continue;
          if (inc == null ||
              eye.value(p) > eye.value(inc) ||
              (eye.value(p) == eye.value(inc) && p.id < inc.id)) {
            inc = p;
          }
        }
        if (inc == null) {
          exhausted.add(target);
          continue;
        }
        if (squad.length >= max) {
          // How readily the other shape lets a man go: one it does not
          // play at all first, then one where it has more than it needs,
          // then one whose place would still be less short than the target
          // is now. Null: it cannot spare him.
          int? spare(Player p) {
            final played = altPlayed[p.position];
            if (played == null) return 1 << 20;
            final have = haveAt(p.position);
            if (have > altNeeds[p.position]!) return (1 << 10) + have;
            final after = have - 1 - played;
            return after > worst ? after : null;
          }

          Player? out;
          int? outSpare;
          for (final id in squad) {
            final p = byId[id];
            if (p == null ||
                isGk(p) ||
                built.roles.containsKey(id) ||
                reasons[id] == CallUpReason.forChange) {
              continue;
            }
            final s = spare(p);
            if (s == null) continue;
            if (out == null ||
                s > outSpare! ||
                (s == outSpare &&
                    (eye.value(p) < eye.value(out) ||
                        (eye.value(p) == eye.value(out) && p.id < out.id)))) {
              out = p;
              outSpare = s;
            }
          }
          if (out == null) break;
          squad.remove(out.id);
          reasons.remove(out.id);
          named.remove(out.id);
        }
        squad.add(inc.id);
        reasons[inc.id] = CallUpReason.forChange;
        named[inc.id] = [target];
        swaps++;
      }
      return CallUpProposal(
        variant: CallUpVariant.tacticsChange,
        squad: squad,
        reasons: reasons,
        positions: named,
        formation: shape.formation,
      );
    }

    // Only a REAL alternative: a card naming the same squad is noise.
    final alternatives = <CallUpProposal>[];
    bool fresh(CallUpProposal alt) =>
        !alt.sameSquad(main.squad) &&
        !alternatives.any((a) => a.sameSquad(alt.squad));

    // The likeliest other shape the pool gives him something to say about.
    CallUpProposal? change;
    for (final shape
        in otherShapes ??
            CallUpAdvice.otherShapes(
              current: formation,
            )) {
      if (shape.formation == formation) continue;
      final alt = changeTo(shape);
      if (!alt.sameSquad(main.squad)) {
        change = alt;
        break;
      }
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
      _ => build(variant).proposal,
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
    // A basic man has one idea beyond his pick, and the change of tactics is
    // the one the manager most wants; the better men lead with their own
    // read of the pool and keep the change of tactics as the second card.
    final ideas = <CallUpProposal? Function()>[
      if (tier != StaffTier.basic)
        for (final v in order.take(1)) () => variantOf(v),
      () => change,
      for (final v in order.skip(tier == StaffTier.basic ? 0 : 1))
        () => variantOf(v),
    ];
    for (final idea in ideas) {
      if (alternatives.length >= most) break;
      final alt = idea();
      if (alt != null && fresh(alt)) alternatives.add(alt);
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
      // The age squads swap names rather than lean (see `swapped`), and so
      // does the change of tactics (see `changeTo`).
      CallUpVariant.youth ||
      CallUpVariant.experience ||
      CallUpVariant.tacticsChange => 0,
    };
  }

  CallUpReason reasonFor(CallUpVariant variant, Player p) {
    final c = condition[p.id];
    if (variant == CallUpVariant.fresherLegs &&
        c?.fatigueState == FatigueState.fresh) {
      return CallUpReason.fresh;
    }
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
